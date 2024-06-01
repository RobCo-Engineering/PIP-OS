#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QQmlContext>
#include <QSettings>
#include <QKeyEvent>
#include <QFile>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonArray>

#include "bootscreen.h"
#include "inputeventhandler.h"
#include "dweller.h"
#include "inventorymodel.h"

QJsonArray loadJsonArray(const QString &filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly))
    {
        qWarning() << "Couldn't open file:" << filePath;
        return QJsonArray();
    }

    QByteArray jsonData = file.readAll();
    file.close();

    QJsonDocument document = QJsonDocument::fromJson(jsonData);
    if (!document.isArray())
    {
        qWarning() << "JSON is not an array";
        return QJsonArray();
    }

    return document.array();
}


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName("RobCo");
    app.setOrganizationDomain("example.com");
    app.setApplicationName("PipOS");

    QSettings::setDefaultFormat(QSettings::IniFormat);

    QFontDatabase::addApplicationFont(":/fonts/Share-TechMono.ttf");
    QFontDatabase::addApplicationFont(":/fonts/RobotoCondensedFallout.ttf");
    QFontDatabase::addApplicationFont(":/fonts/RobotoCondensedLightFallout.ttf");
    QFontDatabase::addApplicationFont(":/fonts/RobotoCondensedBoldFallout.ttf");

    qmlRegisterType<BootScreen>("BootScreen", 1, 0, "BootScreen");

    QQmlApplicationEngine engine;

    // Access root context
    QQmlContext* context = engine.rootContext();

    // Input handler
    InputEventHandler* inputHandler = new InputEventHandler();
    app.installEventFilter(inputHandler);

    // Start thread for listening to external hardware events?
    // inputHandler->

    context->setContextProperty("inputHandler", inputHandler);

    // Dweller
    Dweller* dweller = new Dweller();
    context->setContextProperty("dweller", dweller);

    // Load the inventory from JSON

    QJsonArray jsonArray = loadJsonArray(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)+".inventory.json");
    InventoryModel *inventory = new InventoryModel();
    inventory->addItems(jsonArray);

    context->setContextProperty("inventory", inventory);

    const QUrl url(QStringLiteral("qrc:/RobCo/PipOS/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
