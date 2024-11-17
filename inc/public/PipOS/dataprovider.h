#ifndef DATAPROVIDER_H
#define DATAPROVIDER_H

#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QObject>

namespace PipOS {
class DataProvider : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QJsonObject data READ data CONSTANT)

public:
    explicit DataProvider(QObject *parent = nullptr);

    // Method to load JSON from file
    bool loadData(const QString &filename);

    // Getter for the JSON data
    QJsonObject data() const { return m_data; }

private:
    QJsonObject m_data;
};
} // namespace PipOS
#endif // DATAPROVIDER_H
