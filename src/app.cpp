#include <QDirIterator>
#include <QFile>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QJsonArray>
#include <QJsonDocument>
#include <QKeyEvent>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QStandardPaths>

#include "PipOS/app.h"
#include "PipOS/bootscreen.h"
#include "PipOS/hardwareinput.h"
#include "PipOS/inventory.h"

QJsonArray loadJsonArray(const QString &filePath) {
  QFile file(filePath);
  if (!file.open(QIODevice::ReadOnly)) {
    qWarning() << "Couldn't open file:" << filePath;
    return QJsonArray();
  }

  QByteArray jsonData = file.readAll();
  file.close();

  QJsonDocument document = QJsonDocument::fromJson(jsonData);
  if (!document.isArray()) {
    qWarning() << "JSON is not an array";
    return QJsonArray();
  }

  return document.array();
}

namespace PipOS {
App::App() : QObject(nullptr) {
  QGuiApplication::setOrganizationName("RobCo-Industries");
  QGuiApplication::setOrganizationDomain("robco-industries.org");
  QGuiApplication::setApplicationName("PipOS");

  QSettings::setDefaultFormat(QSettings::IniFormat);
}

void App::init() {
  qInfo() << "Init PipOS";

  QDirIterator it(":", {"*.ttf", "*.otf"}, QDir::Files,
                  QDirIterator::Subdirectories);
  while (it.hasNext()) {
    QString font = it.next();
    qDebug() << "Loading font" << font;
    QFontDatabase::addApplicationFont(font);
  }

  using std::make_shared, std::make_unique;

  m_settings = make_shared<Settings>();
  m_inputHandler = make_shared<InputEventHandler>();
  m_dweller = make_shared<Dweller>();

  m_mainWindowEngine = make_unique<QQmlApplicationEngine>();

  qmlRegisterType<BootScreen>("BootScreen", 1, 0, "BootScreen");

  auto *guiAppInst =
      dynamic_cast<QGuiApplication *>(QGuiApplication::instance());

  qmlRegisterSingletonInstance("PipOS", 1, 0, "App", this);
  m_mainWindowEngine->addImportPath(guiAppInst->applicationDirPath() + "/qml");
  guiAppInst->addLibraryPath(guiAppInst->applicationDirPath() + "/qml");

  // Keyboard input handler
  guiAppInst->installEventFilter(m_inputHandler.get());

  // gpioMonitor = new GPIOMonitor(this);
  // connect(gpioMonitor, &GPIOMonitor::pinStateChanged, this,
  // &App::handlePinStateChange); gpioMonitor->startMonitoring(18);

  // Load the inventory from JSON
  QJsonArray jsonArray = loadJsonArray(
      QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) +
      ".inventory.json");
  m_dweller->inventory()->addItems(jsonArray);

  // TODO: What does this do actually
  // QObject::connect(
  //     &m_mainWindowEngine,
  //     &QQmlApplicationEngine::objectCreationFailed,
  //     this,
  //     []() { QCoreApplication::exit(-1); },
  //     Qt::QueuedConnection);

  m_mainWindowEngine->load(QUrl(QStringLiteral("qrc:/qml/PipOSApp/main.qml")));
}

void App::setMainWindowEngine(QQmlApplicationEngine *mainWindowEngine) {
  if (m_mainWindowEngine.get() == mainWindowEngine)
    return;

  m_mainWindowEngine.reset(mainWindowEngine);
  emit mainWindowEngineChanged(m_mainWindowEngine.get());
}

void App::setSettings(Settings *settings) {
  if (m_settings.get() == settings)
    return;

  m_settings.reset(settings);
  emit settingsChanged(m_settings.get());
}

void App::setInputHandler(InputEventHandler *inputHandler) {
  if (m_inputHandler.get() == inputHandler)
    return;

  m_inputHandler.reset(inputHandler);
  emit inputHandlerChanged(m_inputHandler.get());
}

void App::setDweller(Dweller *dweller) {
  if (m_dweller.get() == dweller)
    return;

  m_dweller.reset(dweller);
  emit dwellerChanged(m_dweller.get());
}

} // namespace PipOS
