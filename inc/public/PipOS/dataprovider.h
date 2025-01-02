#ifndef DATAPROVIDER_H
#define DATAPROVIDER_H

#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QObject>
#include <QQmlEngine>

namespace PipOS {
class DataProvider : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QJsonObject data READ data WRITE setData NOTIFY dataChanged FINAL)

public:
    explicit DataProvider(QObject *parent = nullptr);

    // Method to load JSON from file
    Q_INVOKABLE bool loadData(const QString &filename);

    // Getter/setter for the JSON data
    QJsonObject data() const { return m_data; }
    void setData(const QJsonObject &newData);

signals:
    void dataChanged();

private:
    QJsonObject m_data;
};
} // namespace PipOS
#endif // DATAPROVIDER_H
