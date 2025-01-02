#include <QDebug>
#include <QDirIterator>
#include <QEvent>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QUrl>

#include "PipOS/app.h"

namespace PipOS {

void App::init() {
  qInfo() << "Init PipOS";

  QDirIterator it(":", {"*.ttf", "*.otf"}, QDir::Files,
                  QDirIterator::Subdirectories);
  while (it.hasNext()) {
    QString font = it.next();
    qDebug() << "Loading font" << font;
    QFontDatabase::addApplicationFont(font);
  }

  // List all contents of QRC
  QDirIterator its(":", QDirIterator::Subdirectories);
  while (its.hasNext()) {
    qDebug() << its.next();
  }

  auto *guiAppInst =
      dynamic_cast<QGuiApplication *>(QGuiApplication::instance());

  // Set a default app wide font
  QFont defaultFont = QFont("Roboto Condensed", 20);
  guiAppInst->setFont(defaultFont);

  // Where's all the QML
  m_mainWindowEngine->addImportPath(guiAppInst->applicationDirPath() + "/qml");
  guiAppInst->addLibraryPath(guiAppInst->applicationDirPath() + "/qml");

  // Load the main QML entrypoint
  qInfo() << "Loading main.qml";
  m_mainWindowEngine->load(
      QUrl(QStringLiteral("qrc:/robco-industries.org/PipOS/main.qml")));

  if (m_mainWindowEngine->rootObjects().isEmpty()) {
    qFatal("Failed to load main.qml");
  }
}

} // namespace PipOS
