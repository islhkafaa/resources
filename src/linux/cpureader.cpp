#include "cpureader.h"

#include <QFile>
#include <QRegularExpression>
#include <QStringList>
#include <QTextStream>

CpuReader::CpuReader() = default;

QList<CpuSnapshot> CpuReader::readSnapshots() {
  QFile file("/proc/stat");
  if (!file.open(QIODevice::ReadOnly))
    return {};

  QList<CpuSnapshot> snaps;
  QByteArray data = file.readAll();
  QList<QByteArray> lines = data.split('\n');

  for (const QByteArray &line : lines) {
    if (!line.startsWith("cpu"))
      continue;

    QList<QByteArray> parts = line.split(' ');
    QList<QByteArray> cleanParts;
    for (const QByteArray &p : parts) {
      if (!p.isEmpty())
        cleanParts.append(p);
    }

    if (cleanParts.size() < 9)
      continue;

    if (cleanParts[0] == "cpu")
      continue;

    CpuSnapshot s;
    s.user = cleanParts[1].toULongLong();
    s.nice = cleanParts[2].toULongLong();
    s.system = cleanParts[3].toULongLong();
    s.idle = cleanParts[4].toULongLong();
    s.iowait = cleanParts[5].toULongLong();
    s.irq = cleanParts[6].toULongLong();
    s.softirq = cleanParts[7].toULongLong();
    s.steal = cleanParts[8].toULongLong();
    snaps.append(s);
  }

  return snaps;
}

QString CpuReader::readModelName() {
  QFile file("/proc/cpuinfo");
  if (!file.open(QIODevice::ReadOnly))
    return {};

  QByteArray data = file.readAll();
  QList<QByteArray> lines = data.split('\n');
  for (const QByteArray &line : lines) {
    if (line.contains("model name")) {
      QList<QByteArray> parts = line.split(':');
      if (parts.size() > 1) {
        return QString::fromUtf8(parts[1].trimmed());
      }
    }
  }
  return {};
}

CpuInfo CpuReader::read() {
  if (!m_modelRead) {
    m_modelName = readModelName();
    m_modelRead = true;
  }

  QList<CpuSnapshot> curr = readSnapshots();

  CpuInfo info;
  info.modelName = m_modelName;
  info.coreCount = curr.size();

  if (m_prev.size() == curr.size() && !curr.isEmpty()) {
    uint64_t totalActive = 0;
    uint64_t totalAll = 0;

    for (int i = 0; i < curr.size(); ++i) {
      uint64_t dActive = curr[i].active() - m_prev[i].active();
      uint64_t dTotal = curr[i].total() - m_prev[i].total();

      double usage = (dTotal > 0) ? (100.0 * dActive / dTotal) : 0.0;
      info.perCoreUsage.append(usage);

      totalActive += dActive;
      totalAll += dTotal;
    }

    info.usagePercent = (totalAll > 0) ? (100.0 * totalActive / totalAll) : 0.0;
  }

  m_prev = curr;
  return info;
}
