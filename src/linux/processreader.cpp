#include "processreader.h"
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <algorithm>
#include <pwd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

static unsigned long long getTotalCpuTime() {
  QFile file("/proc/stat");
  if (!file.open(QIODevice::ReadOnly))
    return 0;
  QByteArray line = file.readLine();
  if (!line.startsWith("cpu "))
    return 0;
  QList<QByteArray> parts = line.split(' ');
  unsigned long long total = 0;
  for (int i = 1; i < parts.size(); ++i) {
    if (!parts[i].isEmpty()) {
      total += parts[i].toULongLong();
    }
  }
  return total;
}

static QString getUsernameFromUid(uid_t uid) {
  struct passwd *pw = getpwuid(uid);
  if (pw) {
    return QString(pw->pw_name);
  }
  return QString::number(uid);
}

QList<ProcessInfo> ProcessReader::read() {
  QList<ProcessInfo> result;
  QDir procDir("/proc");
  QStringList pids = procDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);

  unsigned long long currentTotalTime = getTotalCpuTime();
  unsigned long long totalTimeDiff = currentTotalTime - m_lastTotalTime;
  if (totalTimeDiff == 0)
    totalTimeDiff = 1;

  QMap<int, unsigned long long> newProcessTime;

  int pageSize = getpagesize();
  double pageSizeMb = pageSize / (1024.0 * 1024.0);
  int numCores = sysconf(_SC_NPROCESSORS_ONLN);

  for (const QString &pidStr : pids) {
    bool ok;
    int pid = pidStr.toInt(&ok);
    if (!ok)
      continue;

    ProcessInfo info;
    info.pid = pid;

    QString statPath = procDir.absoluteFilePath(pidStr + "/stat");
    QFile statFile(statPath);
    if (!statFile.open(QIODevice::ReadOnly))
      continue;
    QByteArray statData = statFile.readAll();

    int nameStart = statData.indexOf('(');
    int nameEnd = statData.lastIndexOf(')');
    if (nameStart == -1 || nameEnd == -1)
      continue;

    info.name = statData.mid(nameStart + 1, nameEnd - nameStart - 1);

    QList<QByteArray> fields = statData.mid(nameEnd + 2).split(' ');
    if (fields.size() < 22)
      continue;

    unsigned long long utime = fields[11].toULongLong();
    unsigned long long stime = fields[12].toULongLong();
    long long rssPages = fields[21].toLongLong();

    info.memUsageMb = rssPages * pageSizeMb;
    if (info.memUsageMb < 0)
      info.memUsageMb = 0;

    unsigned long long totalProcTime = utime + stime;
    newProcessTime[pid] = totalProcTime;

    if (m_lastTotalTime > 0 && m_lastProcessTime.contains(pid)) {
      unsigned long long procTimeDiff = totalProcTime - m_lastProcessTime[pid];
      info.cpuUsage = (double)procTimeDiff / totalTimeDiff * 100.0 * numCores;
    } else {
      info.cpuUsage = 0.0;
    }

    struct stat fileStat;
    if (stat(statPath.toUtf8().constData(), &fileStat) == 0) {
      info.user = getUsernameFromUid(fileStat.st_uid);
    } else {
      info.user = "unknown";
    }

    result.append(info);
  }

  m_lastTotalTime = currentTotalTime;
  m_lastProcessTime = newProcessTime;

  std::sort(result.begin(), result.end(),
            [](const ProcessInfo &a, const ProcessInfo &b) {
              if (a.cpuUsage != b.cpuUsage) {
                return a.cpuUsage > b.cpuUsage;
              }
              return a.memUsageMb > b.memUsageMb;
            });

  if (result.size() > 100) {
    result = result.mid(0, 100);
  }

  return result;
}
