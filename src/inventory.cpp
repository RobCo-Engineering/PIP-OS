#include "inventory.h"
#include <QDebug>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>

namespace PipOS {

enum InventoryRoles { NameRole = Qt::UserRole + 1, QuantityRole };

InventoryModel::InventoryModel(QObject *parent)
    : QAbstractListModel(parent)
{}

void InventoryModel::addItems(const QJsonArray &jsonArray)
{
    beginResetModel();
    m_items.clear();
    for (const QJsonValue &value : jsonArray) {
        QJsonObject obj = value.toObject();
        auto &ref = m_items.emplace_back(obj["text"].toString());
        ref.setQuantity(obj["count"].toInt());
        ref.setEquippedState(obj["equipState"].toInt() == 1);
    }
    endResetModel();
}

int InventoryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return static_cast<int>(m_items.size());
}

QVariant InventoryModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= static_cast<int>(m_items.size()))
        return QVariant();

    const InventoryItem &item = m_items[static_cast<size_t>(index.row())];
    if (role == NameRole)
        return item.name();
    else if (role == QuantityRole)
        return item.quantity();

    return QVariant();
}

QHash<int, QByteArray> InventoryModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[QuantityRole] = "quantity";
    return roles;
}

// void Inventory::addItem(InventoryItem &&item)
// {
//     beginInsertRows(QModelIndex(), rowCount(), rowCount());
//     m_items.append(std::move(item)); // Move the item into the list
//     endInsertRows();
// }

// // Implement other required functions for QAbstractListModel
// int Inventory::rowCount(const QModelIndex &parent) const
// {
//     Q_UNUSED(parent);
//     return m_items.count();
// }

// QVariant Inventory::data(const QModelIndex &index, int role) const
// {
//     if (!index.isValid() || index.row() >= m_items.size())
//         return QVariant();

//     const InventoryItem &item = m_items[index.row()];
//     if (role == Qt::DisplayRole)
//     {
//         return item.name(); // Adjust according to the role
//     }
//     // Add other roles as needed
//     return QVariant();
// }
} // namespace PipOS
