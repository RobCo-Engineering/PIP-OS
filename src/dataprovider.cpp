#include <QJsonDocument>
#include <QQmlContext>
#include <jsoncons/json.hpp>
#include <jsoncons_ext/jsonpath/jsonpath.hpp>
#include <jsoncons_ext/jsonpath/jsonpath_error.hpp>

#include "app.h"
#include "dataprovider.h"

namespace PipOS {

DataProvider::DataProvider(QObject *parent)
    : QObject(parent)
    , m_query("$")
{
    connect(this, &DataProvider::queryChanged, &DataProvider::doQuery);
}

void DataProvider::doQuery()
{
    if (m_query == "") { return; }

    qDebug() << "DataProvider doing query:" << m_query.toStdString();
    
    m_queryInProgress = true;
    emit queryInProgressChanged();

    try {
        // Get data from the root context
        QVariant appV = qmlEngine(this)->rootContext()->contextProperty("app");
        App *app = qobject_cast<App *>(qvariant_cast<QObject *>(appV));

        // Query the internal data structure
        jsoncons::json result = jsoncons::jsonpath::json_query(app->externalData(),
                                                               m_query.toStdString());

        // Convert the result to a string, then a byte array and then parse it again using Qt parser
        std::string jsonString = result.to_string();
        QByteArray ba(jsonString.c_str(), static_cast<int>(jsonString.length()));
        // m_data = QJsonDocument::fromJson( ba );

        //emit dataChanged();
    } catch (const jsoncons::jsonpath::jsonpath_error &e) {
        qWarning() << "DataProvider query error:" << m_query << e.what();
    }

    m_queryInProgress = false;
    emit queryInProgressChanged();
}

void DataProvider::setQuery(const QString &newQuery)
{
    if (m_query == newQuery)
        return;
    m_query = newQuery;
    emit queryChanged();
}

} // namespace PipOS
