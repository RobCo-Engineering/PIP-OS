#include "inventoryitem.h"

void InventoryItem::setQuantity(int newQuantity)
{
    m_quantity = newQuantity;
}

void InventoryItem::setEquippedState(bool equipped)
{
    m_equipped = equipped;
}

void InventoryItem::toggleEquippedState()
{
    m_equipped = !m_equipped;
}
