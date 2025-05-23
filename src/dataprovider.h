#ifndef DATAPROVIDER_H
#define DATAPROVIDER_H

#include <QAbstractItemModel>
#include <QFile>
#include <QObject>
#include <QQmlEngine>
#include <jsoncons/json.hpp>

namespace PipOS {
class DataProvider : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString query READ query WRITE setQuery NOTIFY queryChanged FINAL)
    // Q_PROPERTY( QAbstractItemModel data READ data NOTIFY dataChanged FINAL )
    Q_PROPERTY(bool queryInProgress READ queryInProgress NOTIFY queryInProgressChanged FINAL)
    QML_ELEMENT

public:
    explicit DataProvider(QObject *parent = nullptr);

    QString query() const { return m_query; };
    void setQuery( const QString& newQuery );
    // QAbstractItemModel data() const
    // {
    //     return m_data;
    // };
    bool queryInProgress() const { return m_queryInProgress; };

signals:
    void queryChanged();
    void dataChanged();
    void queryInProgressChanged();

private:
    // QAbstractItemModel m_data;
    QString m_query;
    bool m_queryInProgress;

private slots:
    void doQuery();
};
} // namespace PipOS
#endif // DATAPROVIDER_H
