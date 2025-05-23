#include "itemstats.h"

namespace PipOS {

ItemStats::ItemStats(QObject *parent)
    : QObject{parent}
{}

QVariant ItemStats::data() const
{
    return m_data;
}

void ItemStats::setData(const QVariant &newData)
{
    qDebug() << newData;

    if (m_data == newData)
        return;
    m_data = newData;
    emit dataChanged();
}

} // namespace PipOS
