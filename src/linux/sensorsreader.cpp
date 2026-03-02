#include "sensorsreader.h"

#include <QDir>
#include <QFile>
#include <QTextStream>

QList<SensorInfo> SensorsReader::read() {
  QList<SensorInfo> sensors;
  QDir hwmonDir("/sys/class/hwmon");

  if (hwmonDir.exists()) {
    hwmonDir.setFilter(QDir::Dirs | QDir::NoDotAndDotDot);
    for (const QFileInfo &hwFolder :
         hwmonDir.entryInfoList(QStringList{"hwmon*"})) {
      QString path = hwFolder.absoluteFilePath();

      QString driverName;
      QFile nameFile(path + "/name");
      if (nameFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        driverName = QTextStream(&nameFile).readLine().trimmed();
      }

      QDir subDir(path);
      for (const QFileInfo &tempFile :
           subDir.entryInfoList(QStringList{"temp*_input"})) {
        QString tempPath = tempFile.absoluteFilePath();
        QString base = tempFile.baseName();
        QString num = base.split('_').first();

        QString label;
        QFile labelFile(path + "/" + num + "_label");
        if (labelFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
          label = QTextStream(&labelFile).readLine().trimmed();
        }

        QFile valFile(tempPath);
        if (valFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
          QString valStr = QTextStream(&valFile).readLine().trimmed();
          bool ok;
          long long mC = valStr.toLongLong(&ok);
          if (ok) {
            double temp = static_cast<double>(mC) / 1000.0;
            if (temp > -50.0 && temp < 150.0 && temp != 0.0) {
              SensorInfo info;
              QString prettyDriver = driverName;
              if (prettyDriver == "k10temp")
                prettyDriver = "CPU";
              else if (prettyDriver == "amdgpu")
                prettyDriver = "GPU";
              else if (prettyDriver.length() > 3) {
                prettyDriver[0] = prettyDriver[0].toUpper();
              }

              info.name = prettyDriver;
              if (!label.isEmpty())
                info.name += " (" + label + ")";
              else
                info.name += " " + num;

              info.temperature = temp;
              sensors.append(info);
            }
          }
        }
      }
    }
  }

  if (sensors.isEmpty()) {
    QDir thermalDir("/sys/class/thermal");
    if (thermalDir.exists()) {
      for (const QFileInfo &zoneInfo :
           thermalDir.entryInfoList(QStringList{"thermal_zone*"})) {
        QString basePath = zoneInfo.absoluteFilePath();
        QFile typeFile(basePath + "/type");
        QFile tempFile(basePath + "/temp");
        if (typeFile.open(QIODevice::ReadOnly | QIODevice::Text) &&
            tempFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
          QString name = QTextStream(&typeFile).readLine().trimmed();
          QString valStr = QTextStream(&tempFile).readLine().trimmed();
          bool ok;
          long long mC = valStr.toLongLong(&ok);
          if (ok) {
            double temp = static_cast<double>(mC) / 1000.0;
            if (temp > -50.0 && temp < 150.0 && temp != 0.0) {
              SensorInfo info;
              info.name = name;
              info.temperature = temp;
              sensors.append(info);
            }
          }
        }
      }
    }
  }

  return sensors;
}
