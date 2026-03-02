#include "diskreader.h"

#include <QDir>
#include <QFile>
#include <QRegularExpression>
#include <QTextStream>

static bool isRealDisk(const QString &dev) {
  static const QRegularExpression re(
      "^(sd[a-z]|nvme\\d+n\\d+|vd[a-z]|hd[a-z])$");
  return re.match(dev).hasMatch();
}

uint64_t DiskReader::sectorSize(const QString &device) {
  QFile f(QString("/sys/block/%1/queue/physical_block_size").arg(device));
  if (f.open(QIODevice::ReadOnly | QIODevice::Text)) {
    QTextStream in(&f);
    return in.readLine().trimmed().toULongLong();
  }
  return 512;
}

QList<DiskSnapshot> DiskReader::readSnapshots() {
  QFile file("/proc/diskstats");
  if (!file.open(QIODevice::ReadOnly))
    return {};

  QList<DiskSnapshot> snaps;
  QByteArray data = file.readAll();
  QList<QByteArray> lines = data.split('\n');

  for (const QByteArray &line : lines) {
    QList<QByteArray> p = line.split(' ');
    QList<QByteArray> cleanParts;
    for (const QByteArray &part : p) {
      if (!part.isEmpty())
        cleanParts.append(part);
    }

    if (cleanParts.size() < 14)
      continue;

    QString dev = QString::fromUtf8(cleanParts[2]);

    if (!isRealDisk(dev))
      continue;

    if (dev.size() > 3 && dev.at(dev.length() - 1).isDigit() &&
        !dev.contains("nvme"))
      continue;

    DiskSnapshot s;
    s.device = dev;
    s.readSectors = cleanParts[5].toULongLong();
    s.writeSectors = cleanParts[9].toULongLong();
    s.sectorSize = sectorSize(dev);
    snaps.append(s);
  }

  return snaps;
}

QList<DiskInfo> DiskReader::read() {
  QList<DiskSnapshot> curr = readSnapshots();
  QList<DiskInfo> result;

  for (const DiskSnapshot &c : curr) {
    DiskInfo info;
    info.device = c.device;

    for (const DiskSnapshot &p : m_prev) {
      if (p.device != c.device)
        continue;

      uint64_t dRead = c.readSectors - p.readSectors;
      uint64_t dWrite = c.writeSectors - p.writeSectors;
      info.readBytesPerSec = static_cast<double>(dRead) * c.sectorSize;
      info.writeBytesPerSec = static_cast<double>(dWrite) * c.sectorSize;
      break;
    }

    QFile statFile(QString("/sys/block/%1/stat").arg(c.device));
    QFile sizeFile(QString("/sys/block/%1/size").arg(c.device));

    result.append(info);
  }

  m_prev = curr;
  return result;
}
