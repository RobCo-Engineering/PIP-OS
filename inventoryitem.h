#pragma once

#include <QString>

class InventoryItem
{
public:
    InventoryItem(const QString &name)
        : m_name(name), m_quantity(1), m_equipped(false) {}

    QString name() const { return m_name; }
    int quantity() const { return m_quantity; }
    bool equipped() const { return m_equipped; }

public slots:
    void setQuantity(int newQuantity);
    void setEquippedState(bool equipped);
    void toggleEquippedState();

private:
    QString m_name;
    int m_quantity;
    bool m_equipped;
};
