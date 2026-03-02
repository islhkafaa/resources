#pragma once

#include "systeminfo.h"
#include <QList>

class NetReader {
public:
  QList<NetInfo> read();

private:
  QList<NetSnapshot> readSnapshots();
  QList<NetSnapshot> m_prev;
};
