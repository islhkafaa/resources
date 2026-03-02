#pragma once

#include "systeminfo.h"
#include <QList>

class CpuReader {
public:
  CpuReader();

  CpuInfo read();

private:
  QString readModelName();
  QList<CpuSnapshot> readSnapshots();

  QList<CpuSnapshot> m_prev;
  QString m_modelName;
  bool m_modelRead = false;
};
