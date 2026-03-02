#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#include "systemmonitor.h"

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  app.setApplicationName("Resources");
  app.setApplicationVersion("0.1.0");
  app.setOrganizationName("Resources");

  QQuickStyle::setStyle("Basic");

  SystemMonitor monitor;

  QQmlApplicationEngine engine;
  engine.rootContext()->setContextProperty("Monitor", &monitor);

  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
      []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);

  engine.loadFromModule("Resources", "App");

  return app.exec();
}
