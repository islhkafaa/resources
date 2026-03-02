#include "systemmonitor.h"

static constexpr double kKbToGb = 1.0 / (1024.0 * 1024.0);

SystemMonitor::SystemMonitor(QObject *parent) : QObject(parent) {
  connect(&m_timer, &QTimer::timeout, this, &SystemMonitor::poll);
  m_timer.setInterval(1000);
  poll();
  m_timer.start();
}

void SystemMonitor::poll() {
  {
    CpuInfo info = m_cpuReader.read();
    m_cpuUsage = info.usagePercent;
    m_cpuModel = info.modelName;
    m_cpuCores = info.coreCount;
    m_perCoreUsage = info.perCoreUsage;

    m_cpuHistory.append(m_cpuUsage);
    if (m_cpuHistory.size() > 60) {
      m_cpuHistory.pop_front();
    }

    emit cpuChanged();
    emit cpuHistoryChanged();
  }

  {
    MemInfo info = m_memReader.read();
    m_memTotal = info.totalKb * kKbToGb;
    m_memUsed = info.usedKb * kKbToGb;
    m_memAvailable = info.availableKb * kKbToGb;
    m_memUsagePercent =
        (info.totalKb > 0) ? (100.0 * info.usedKb / info.totalKb) : 0.0;
    m_swapTotal = info.swapTotalKb * kKbToGb;
    m_swapUsed = info.swapUsedKb * kKbToGb;
    m_swapUsagePercent = (info.swapTotalKb > 0)
                             ? (100.0 * info.swapUsedKb / info.swapTotalKb)
                             : 0.0;
    emit memChanged();
  }

  {
    QList<DiskInfo> disks = m_diskReader.read();
    m_disks.clear();
    for (const DiskInfo &d : disks) {
      QVariantMap map;
      map["device"] = d.device;
      map["readBytesPerSec"] = d.readBytesPerSec;
      map["writeBytesPerSec"] = d.writeBytesPerSec;
      map["usagePercent"] = d.usagePercent;
      m_disks.append(map);
    }
    emit diskChanged();
  }

  {
    QList<NetInfo> nets = m_netReader.read();
    m_networks.clear();
    for (const NetInfo &n : nets) {
      QVariantMap map;
      map["iface"] = n.iface;
      map["rxBytesPerSec"] = n.rxBytesPerSec;
      map["txBytesPerSec"] = n.txBytesPerSec;
      m_networks.append(map);
    }
    emit netChanged();
  }
}
