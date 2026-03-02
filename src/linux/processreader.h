#pragma once

#include <QList>
#include <QMap>
#include <QString>

struct ProcessInfo {
  int pid;
  QString name;
  QString user;
  double cpuUsage;
  double memUsageMb;
};

class ProcessReader {
public:
  QList<ProcessInfo> read();

private:
  QMap<int, unsigned long long> m_lastProcessTime;
  unsigned long long m_lastTotalTime = 0;
};
