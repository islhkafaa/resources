#include "netreader.h"

#include <QFile>
#include <QTextStream>

static const QStringList kSkip = {"lo"};

QList<NetSnapshot> NetReader::readSnapshots() {
  QFile file("/proc/net/dev");
  if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    return {};

  QTextStream in(&file);
  in.readLine();
  in.readLine();

  QList<NetSnapshot> snaps;

  while (!in.atEnd()) {
    QString line = in.readLine().trimmed();
    int colonIdx = line.indexOf(':');
    if (colonIdx < 0)
      continue;

    QString iface = line.left(colonIdx).trimmed();
    if (kSkip.contains(iface))
      continue;

    QStringList parts = line.mid(colonIdx + 1).split(' ', Qt::SkipEmptyParts);
    if (parts.size() < 9)
      continue;

    NetSnapshot s;
    s.iface = iface;
    s.rxBytes = parts[0].toULongLong();
    s.txBytes = parts[8].toULongLong();
    snaps.append(s);
  }

  return snaps;
}

QList<NetInfo> NetReader::read() {
  QList<NetSnapshot> curr = readSnapshots();
  QList<NetInfo> result;

  for (const NetSnapshot &c : curr) {
    NetInfo info;
    info.iface = c.iface;

    for (const NetSnapshot &p : m_prev) {
      if (p.iface != c.iface)
        continue;
      info.rxBytesPerSec = static_cast<double>(c.rxBytes - p.rxBytes);
      info.txBytesPerSec = static_cast<double>(c.txBytes - p.txBytes);
      break;
    }

    result.append(info);
  }

  m_prev = curr;
  return result;
}
