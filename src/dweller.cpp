#include "dweller.h"
namespace PipOS {

Dweller::Dweller(QObject *parent)
    : QObject{parent}
    , m_name("Albert")
    , m_level(1)
    , m_levelProgress(0.0)
    , m_currentAP(10)
    , m_maxAP(10)
    , m_maxHealth(10)
    , m_currentHealth(10)
    , m_healthHead(1.0)
    , m_healthBody(1.0)
    , m_healthLeftArm(1.0)
    , m_healthRightArm(1.0)
    , m_healthLeftLeg(1.0)
    , m_healthRightLeg(1.0)
{
    m_inventory = std::make_shared<InventoryModel>(new InventoryModel());
}

int Dweller::level() const
{
    return m_level;
}

void Dweller::setLevel(int newLevel)
{
    if (m_level == newLevel)
        return;
    m_level = newLevel;
    emit levelChanged();
}

float Dweller::levelProgress() const
{
    return m_levelProgress;
}

void Dweller::setLevelProgress(float newLevelProgress)
{
    if (qFuzzyCompare(m_levelProgress, newLevelProgress))
        return;
    m_levelProgress = newLevelProgress;
    emit levelProgressChanged();
}

int Dweller::maxHealth() const
{
    return m_maxHealth;
}

void Dweller::setMaxHealth(int newMaxHealth)
{
    if (m_maxHealth == newMaxHealth)
        return;
    m_maxHealth = newMaxHealth;
    emit maxHealthChanged();
}

int Dweller::currentHealth() const
{
    return m_currentHealth;
}

void Dweller::setCurrentHealth(int newCurrentHealth)
{
    if (m_currentHealth == newCurrentHealth)
        return;
    m_currentHealth = newCurrentHealth;
    emit currentHealthChanged();
}

int Dweller::maxAP() const
{
    return m_maxAP;
}

void Dweller::setMaxAP(int newMapAP)
{
    if (m_maxAP == newMapAP)
        return;
    m_maxAP = newMapAP;
    emit maxAPChanged();
}

int Dweller::currentAP() const
{
    return m_currentAP;
}

void Dweller::setCurrentAP(int newCurrentAP)
{
    if (m_currentAP == newCurrentAP)
        return;
    m_currentAP = newCurrentAP;
    emit currentAPChanged();
}

QString Dweller::name() const
{
    return m_name;
}

void Dweller::setName(const QString &newName)
{
    if (m_name == newName)
        return;
    m_name = newName;
    emit nameChanged();
}

float Dweller::healthHead() const
{
    return m_healthHead;
}

void Dweller::setHealthHead(float newHealthHead)
{
    if (qFuzzyCompare(m_healthHead, newHealthHead))
        return;
    m_healthHead = newHealthHead;
    emit healthHeadChanged();
}

float Dweller::healthBody() const
{
    return m_healthBody;
}

void Dweller::setHealthBody(float newHealthBody)
{
    if (qFuzzyCompare(m_healthBody, newHealthBody))
        return;
    m_healthBody = newHealthBody;
    emit healthBodyChanged();
}

float Dweller::healthLeftArm() const
{
    return m_healthLeftArm;
}

void Dweller::setHealthLeftArm(float newHealthLeftArm)
{
    if (qFuzzyCompare(m_healthLeftArm, newHealthLeftArm))
        return;
    m_healthLeftArm = newHealthLeftArm;
    emit healthLeftArmChanged();
}

float Dweller::healthRightArm() const
{
    return m_healthRightArm;
}

void Dweller::setHealthRightArm(float newHealthRightArm)
{
    if (qFuzzyCompare(m_healthRightArm, newHealthRightArm))
        return;
    m_healthRightArm = newHealthRightArm;
    emit healthRightArmChanged();
}

float Dweller::healthLeftLeg() const
{
    return m_healthLeftLeg;
}

void Dweller::setHealthLeftLeg(float newHealthLeftLeg)
{
    if (qFuzzyCompare(m_healthLeftLeg, newHealthLeftLeg))
        return;
    m_healthLeftLeg = newHealthLeftLeg;
    emit healthLeftLegChanged();
}

float Dweller::healthRightLeg() const
{
    return m_healthRightLeg;
}

void Dweller::setHealthRightLeg(float newHealthRightLeg)
{
    if (qFuzzyCompare(m_healthRightLeg, newHealthRightLeg))
        return;
    m_healthRightLeg = newHealthRightLeg;
    emit healthRightLegChanged();
}

void Dweller::setInventory(InventoryModel *newInventory)
{
    if (m_inventory.get() == newInventory)
        return;

    m_inventory.reset(newInventory);
    emit inventoryChanged(m_inventory.get());
}
} // namespace PipOS
