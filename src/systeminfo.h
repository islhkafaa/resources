#pragma once

#include <QList>
#include <QString>
#include <cstdint>

struct CpuSnapshot {
  uint64_t user = 0;
  uint64_t nice = 0;
  uint64_t system = 0;
  uint64_t idle = 0;
  uint64_t iowait = 0;
  uint64_t irq = 0;
  uint64_t softirq = 0;
  uint64_t steal = 0;

  uint64_t total() const {
    return user + nice + system + idle + iowait + irq + softirq + steal;
  }
  uint64_t active() const {
    return user + nice + system + irq + softirq + steal;
  }
};

struct CpuInfo {
  double usagePercent = 0.0;
  int coreCount = 0;
  QString modelName;
  QList<double> perCoreUsage;
};

struct MemInfo {
  uint64_t totalKb = 0;
  uint64_t usedKb = 0;
  uint64_t availableKb = 0;
  uint64_t swapTotalKb = 0;
  uint64_t swapUsedKb = 0;
};

struct DiskSnapshot {
  QString device;
  uint64_t readSectors = 0;
  uint64_t writeSectors = 0;
  uint64_t sectorSize = 512;
};

struct DiskInfo {
  QString device;
  double readBytesPerSec = 0.0;
  double writeBytesPerSec = 0.0;
  double usagePercent = 0.0;
};

struct NetSnapshot {
  QString iface;
  uint64_t rxBytes = 0;
  uint64_t txBytes = 0;
};

struct NetInfo {
  QString iface;
  double rxBytesPerSec = 0.0;
  double txBytesPerSec = 0.0;
};
