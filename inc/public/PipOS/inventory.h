#ifndef INVENTORY_H
#define INVENTORY_H

#include <QAbstractListModel>
#include <QList>

#include "inventoryitem.h"

namespace PipOS {

class InventoryModel : public QAbstractListModel
{
    Q_OBJECT

public:
    InventoryModel(QObject *parent = nullptr);

    void addItems(const QJsonArray &jsonArray);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    std::vector<InventoryItem> m_items;
};

// class Inventory : public QAbstractListModel {
//     Q_OBJECT

// public:
//     void addItem(InventoryItem&& item);

//     // Required overrides for QAbstractListModel
//     int rowCount(const QModelIndex &parent = QModelIndex()) const override;
//     QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

//     // Qt::ItemFlags flags(const QModelIndex &index) const override;

// private:
//     QList<InventoryItem> m_items;
// };

} // namespace PipOS

#endif // INVENTORY_H
