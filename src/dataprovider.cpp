#include "dataprovider.h"
namespace PipOS {

DataProvider::DataProvider(QObject *parent)
    : QObject(parent)
{}

bool DataProvider::loadData(const QString &filename)
{
    qInfo() << "Loading app data from" << filename;

    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Could not open app data:" << file.errorString();
        return false;
    }

    QByteArray jsonData = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(jsonData);

    if (doc.isNull()) {
        qWarning() << "Failed to parse JSON data";
        return false;
    }

    m_data = doc.object();
    return true;
}
} // namespace PipOS
