#pragma once

#include "systeminfo.h"
#include <QList>

class DiskReader {
public:
  QList<DiskInfo> read();

private:
  QList<DiskSnapshot> readSnapshots();
  uint64_t sectorSize(const QString &device);

  QList<DiskSnapshot> m_prev;
};
