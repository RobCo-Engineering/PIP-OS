#include <QDebug>
#include <QDirIterator>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QUrl>

#include "PipOS/app.h"
#include "PipOS/bootscreen.h"

namespace PipOS {

void App::init() {
  qInfo() << "Init PipOS";

  qRegisterMetaType<CollectionItem *>("CollectionItem*");

  QDirIterator it(":", {"*.ttf", "*.otf"}, QDir::Files, QDirIterator::Subdirectories);
  while (it.hasNext()) {
    QString font = it.next();
    qDebug() << "Loading font" << font;
    QFontDatabase::addApplicationFont(font);
  }

  // Load the JSON data file
  m_dataProvider->loadData(m_settings->inventoryFileLocation());

  QQmlContext *context = m_mainWindowEngine->rootContext();

  context->setContextProperty("hid", m_hid);
  context->setContextProperty("dataProvider", m_dataProvider);
  context->setContextProperty("settings", m_settings);
  context->setContextProperty("dweller", m_dweller);
  context->setContextProperty("radio", m_radio);

  // auto *context = static_cast<QQmlEngine *>(m_mainWindowEngine)->rootContext();
  // context->setContextProperty("app", this);

  // List all contents of QRC
  // QDirIterator its(":", QDirIterator::Subdirectories);
  // while (its.hasNext()) {
  //     qDebug() << its.next();
  // }

  // qmlRegisterSingletonInstance("PipOS", 1, 0, "App", this);
  qmlRegisterType<BootScreen>("BootScreen", 1, 0, "BootScreen");

  auto *guiAppInst = dynamic_cast<QGuiApplication *>(QGuiApplication::instance());

  // Set a default app wide font
  QFont defaultFont = QFont("Roboto Condensed", 20);
  guiAppInst->setFont(defaultFont);

  // Where's all the QML
  m_mainWindowEngine->addImportPath(guiAppInst->applicationDirPath() + "/qml");
  guiAppInst->addLibraryPath(guiAppInst->applicationDirPath() + "/qml");

  // Human interface device filter for capturing user events
  guiAppInst->installEventFilter(m_hid);

  // Load the main QML entrypoint
  qInfo() << "Loading main.qml";
  m_mainWindowEngine->load(QUrl(QStringLiteral("qrc:/qml/PipOSApp/main.qml")));

  if (m_mainWindowEngine->rootObjects().isEmpty()) {
      qFatal("Failed to load main.qml");
  }
}

} // namespace PipOS
