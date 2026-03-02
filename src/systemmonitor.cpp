#include "systemmonitor.h"

static constexpr double kKbToGb = 1.0 / (1024.0 * 1024.0);

SystemMonitor::SystemMonitor(QObject *parent) : QObject(parent) {
  connect(&m_timer, &QTimer::timeout, this, &SystemMonitor::poll);
  m_timer.setInterval(m_updateInterval);
  poll();
  m_timer.start();
}

void SystemMonitor::setUpdateInterval(int interval) {
  if (m_updateInterval == interval)
    return;

  m_updateInterval = interval;
  m_timer.setInterval(m_updateInterval);
  emit updateIntervalChanged();
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

    m_memHistory.append(m_memUsagePercent);
    if (m_memHistory.size() > 60)
      m_memHistory.pop_front();

    m_swapHistory.append(m_swapUsagePercent);
    if (m_swapHistory.size() > 60)
      m_swapHistory.pop_front();

    emit memChanged();
    emit memHistoryChanged();
    emit swapHistoryChanged();
  }

  {
    QList<DiskInfo> disks = m_diskReader.read();
    m_disks.clear();
    for (const DiskInfo &d : disks) {
      double rMB = d.readBytesPerSec / (1024.0 * 1024.0);
      double wMB = d.writeBytesPerSec / (1024.0 * 1024.0);

      m_diskReadHistory[d.device].append(rMB);
      if (m_diskReadHistory[d.device].size() > 60)
        m_diskReadHistory[d.device].pop_front();

      m_diskWriteHistory[d.device].append(wMB);
      if (m_diskWriteHistory[d.device].size() > 60)
        m_diskWriteHistory[d.device].pop_front();

      QVariantMap map;
      map["device"] = d.device;
      map["readBytesPerSec"] = QVariant::fromValue(d.readBytesPerSec);
      map["writeBytesPerSec"] = QVariant::fromValue(d.writeBytesPerSec);
      map["usagePercent"] = d.usagePercent;

      QVariantList rHist, wHist;
      for (double v : m_diskReadHistory[d.device])
        rHist.append(v);
      for (double v : m_diskWriteHistory[d.device])
        wHist.append(v);

      map["readHistory"] = rHist;
      map["writeHistory"] = wHist;

      m_disks.append(map);
    }
    emit diskChanged();
  }

  {
    QList<NetInfo> nets = m_netReader.read();
    m_networks.clear();
    for (const NetInfo &n : nets) {
      double rxMbps = (n.rxBytesPerSec * 8.0) / 1000000.0;
      double txMbps = (n.txBytesPerSec * 8.0) / 1000000.0;

      m_netRxHistory[n.iface].append(rxMbps);
      if (m_netRxHistory[n.iface].size() > 60)
        m_netRxHistory[n.iface].pop_front();

      m_netTxHistory[n.iface].append(txMbps);
      if (m_netTxHistory[n.iface].size() > 60)
        m_netTxHistory[n.iface].pop_front();

      QVariantMap map;
      map["iface"] = n.iface;
      map["rxBytesPerSec"] = QVariant::fromValue(n.rxBytesPerSec);
      map["txBytesPerSec"] = QVariant::fromValue(n.txBytesPerSec);

      QVariantList rxHist, txHist;
      for (double v : m_netRxHistory[n.iface])
        rxHist.append(v);
      for (double v : m_netTxHistory[n.iface])
        txHist.append(v);

      map["rxHistory"] = rxHist;
      map["txHistory"] = txHist;

      m_networks.append(map);
    }
    emit netChanged();
  }

  {
    QList<SensorInfo> sensorsRaw = m_sensorsReader.read();
    m_sensors.clear();
    for (const SensorInfo &s : sensorsRaw) {
      QVariantMap map;
      map["name"] = s.name;
      map["temperature"] = s.temperature;
      m_sensors.append(map);
    }
    emit sensorsChanged();
  }

  {
    QList<ProcessInfo> procs = m_processReader.read();
    QVariantList newProcs;
    for (const auto &p : procs) {
      QVariantMap map;
      map["pid"] = p.pid;
      map["name"] = p.name;
      map["user"] = p.user;
      map["cpuUsage"] = p.cpuUsage;
      map["memUsageMb"] = p.memUsageMb;
      newProcs.append(map);
    }
    m_processes = newProcs;
    emit processesChanged();
  }
}
