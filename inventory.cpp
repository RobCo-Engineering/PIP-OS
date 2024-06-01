#include <QFile>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include "inventory.h"
#include "inventoryitem.h"


void Inventory::addItem(InventoryItem &&item)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_items.append(std::move(item)); // Move the item into the list
    endInsertRows();
}

// Implement other required functions for QAbstractListModel
int Inventory::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_items.count();
}

QVariant Inventory::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_items.size())
        return QVariant();

    const InventoryItem &item = m_items[index.row()];
    if (role == Qt::DisplayRole)
    {
        return item.name(); // Adjust according to the role
    }
    // Add other roles as needed
    return QVariant();
}
