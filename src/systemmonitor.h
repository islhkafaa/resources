#pragma once

#include <QList>
#include <QObject>
#include <QString>
#include <QTimer>
#include <QVariantList>

#include "linux/cpureader.h"
#include "linux/diskreader.h"
#include "linux/memreader.h"
#include "linux/netreader.h"

class SystemMonitor : public QObject {
  Q_OBJECT

  Q_PROPERTY(double cpuUsage READ cpuUsage NOTIFY cpuChanged)
  Q_PROPERTY(QString cpuModel READ cpuModel NOTIFY cpuChanged)
  Q_PROPERTY(int cpuCores READ cpuCores NOTIFY cpuChanged)
  Q_PROPERTY(QList<double> perCoreUsage READ perCoreUsage NOTIFY cpuChanged)
  Q_PROPERTY(QList<double> cpuHistory READ cpuHistory NOTIFY cpuHistoryChanged)

  Q_PROPERTY(double memTotal READ memTotal NOTIFY memChanged)
  Q_PROPERTY(double memUsed READ memUsed NOTIFY memChanged)
  Q_PROPERTY(double memAvailable READ memAvailable NOTIFY memChanged)
  Q_PROPERTY(double memUsagePercent READ memUsagePercent NOTIFY memChanged)
  Q_PROPERTY(double swapTotal READ swapTotal NOTIFY memChanged)
  Q_PROPERTY(double swapUsed READ swapUsed NOTIFY memChanged)
  Q_PROPERTY(double swapUsagePercent READ swapUsagePercent NOTIFY memChanged)

  Q_PROPERTY(QList<double> memHistory READ memHistory NOTIFY memHistoryChanged)
  Q_PROPERTY(
      QList<double> swapHistory READ swapHistory NOTIFY swapHistoryChanged)

  Q_PROPERTY(QVariantList disks READ disks NOTIFY diskChanged)
  Q_PROPERTY(QVariantList networks READ networks NOTIFY netChanged)

public:
  explicit SystemMonitor(QObject *parent = nullptr);

  double cpuUsage() const { return m_cpuUsage; }
  QString cpuModel() const { return m_cpuModel; }
  int cpuCores() const { return m_cpuCores; }
  QList<double> perCoreUsage() const { return m_perCoreUsage; }
  QList<double> cpuHistory() const { return m_cpuHistory; }

  double memTotal() const { return m_memTotal; }
  double memUsed() const { return m_memUsed; }
  double memAvailable() const { return m_memAvailable; }
  double memUsagePercent() const { return m_memUsagePercent; }
  double swapTotal() const { return m_swapTotal; }
  double swapUsed() const { return m_swapUsed; }
  double swapUsagePercent() const { return m_swapUsagePercent; }

  QList<double> memHistory() const { return m_memHistory; }
  QList<double> swapHistory() const { return m_swapHistory; }

  QVariantList disks() const { return m_disks; }
  QVariantList networks() const { return m_networks; }

signals:
  void cpuChanged();
  void cpuHistoryChanged();
  void memChanged();
  void memHistoryChanged();
  void swapHistoryChanged();
  void diskChanged();
  void netChanged();

private slots:
  void poll();

private:
  QTimer m_timer;
  CpuReader m_cpuReader;
  MemReader m_memReader;
  DiskReader m_diskReader;
  NetReader m_netReader;

  double m_cpuUsage = 0.0;
  QString m_cpuModel;
  int m_cpuCores = 0;
  QList<double> m_perCoreUsage;
  QList<double> m_cpuHistory;

  double m_memTotal = 0.0;
  double m_memUsed = 0.0;
  double m_memAvailable = 0.0;
  double m_memUsagePercent = 0.0;
  double m_swapTotal = 0.0;
  double m_swapUsed = 0.0;
  double m_swapUsagePercent = 0.0;

  QList<double> m_memHistory;
  QList<double> m_swapHistory;

  QMap<QString, QList<double>> m_diskReadHistory;
  QMap<QString, QList<double>> m_diskWriteHistory;

  QVariantList m_disks;

  QMap<QString, QList<double>> m_netRxHistory;
  QMap<QString, QList<double>> m_netTxHistory;

  QVariantList m_networks;
};
