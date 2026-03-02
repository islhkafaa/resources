#include "memreader.h"

#include <QFile>
#include <QRegularExpression>
#include <QTextStream>
#include <qregularexpression.h>

MemInfo MemReader::read() {
  QFile file("/proc/meminfo");
  if (!file.open(QIODevice::ReadOnly))
    return {};

  MemInfo info;
  uint64_t swapFree = 0;
  QByteArray data = file.readAll();
  QList<QByteArray> lines = data.split('\n');

  for (const QByteArray &line : lines) {
    QList<QByteArray> parts = line.split(':');
    if (parts.size() < 2)
      continue;

    QByteArray key = parts[0].trimmed();
    uint64_t val = parts[1].trimmed().split(' ').first().toULongLong();

    if (key == "MemTotal")
      info.totalKb = val;
    else if (key == "MemAvailable")
      info.availableKb = val;
    else if (key == "SwapTotal")
      info.swapTotalKb = val;
    else if (key == "SwapFree")
      swapFree = val;
  }

  info.usedKb = info.totalKb - info.availableKb;
  info.swapUsedKb = info.swapTotalKb - swapFree;

  return info;
}
