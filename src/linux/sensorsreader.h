#pragma once

#include <QList>
#include <QString>

#include "../systeminfo.h"

class SensorsReader {
public:
  SensorsReader() = default;
  QList<SensorInfo> read();
};
