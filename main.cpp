#include <QGuiApplication>

#include "PipOS/app.h"


int main(int argc, char *argv[])
{
    QGuiApplication::setOrganizationName("RobCo-Industries");
    QGuiApplication::setOrganizationDomain("robco-industries.org");
    QGuiApplication::setApplicationName("PipOS");
    QSettings::setDefaultFormat(QSettings::IniFormat);

    QGuiApplication qtGuiApp(argc, argv);
    PipOS::App app;

    app.init();
    const int status = qtGuiApp.exec();

    return status;
}
