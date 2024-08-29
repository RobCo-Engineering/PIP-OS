#include "dweller.h"
namespace PipOS {

Dweller::Dweller(QObject *parent)
    : QObject{parent}
{
    qInfo() << "Dweller attributes being loaded from" << m_settings.fileName();
    m_inventory = std::make_shared<InventoryModel>(new InventoryModel());
}

QString Dweller::name() const
{
    return m_settings.value("Dweller/name", "Albert").toString();
}
void Dweller::setName(const QString &newName)
{
    m_settings.setValue("Dweller/name", newName);
    emit nameChanged();
}

int Dweller::level() const
{
    if (m_settings.value("Dweller/useBirthdayAsLevel", false).toBool()) {
        if (!m_settings.contains("Dweller/birthday")) {
            qWarning() << "useBirthdayAsLevel was set but no 'birthday' value was set, defaulting "
                          "to using 'level'";
        } else {
            QDate dob = m_settings.value("Dweller/birthday").toDate();
            QDate now = QDate::currentDate();

            return dob.daysTo(now) / 365;
        }
    }
    return m_settings.value("Dweller/level", 1).toInt();
}

void Dweller::setLevel(int newLevel)
{
    m_settings.setValue("Dweller/level", newLevel);
    emit levelChanged();
}

float calculateProgressToNextBirthday(const QDate &birthDate)
{
    QDate currentDate = QDate::currentDate();
    QDate nextBirthday = QDate(currentDate.year(), birthDate.month(), birthDate.day());

    // If the next birthday is in the past, move it to the next year
    if (nextBirthday < currentDate) {
        nextBirthday = nextBirthday.addYears(1);
    }

    int daysInYear = birthDate.daysInYear();
    int daysSinceLastBirthday = birthDate.daysTo(currentDate) % daysInYear;
    int daysToNextBirthday = currentDate.daysTo(nextBirthday);

    float progress = static_cast<float>(daysSinceLastBirthday)
                     / (daysSinceLastBirthday + daysToNextBirthday);

    return progress;
}

float Dweller::levelProgress() const
{
    if (m_settings.value("Dweller/useBirthdayAsLevel", false).toBool()) {
        if (!m_settings.contains("Dweller/birthday")) {
            qWarning() << "useBirthdayAsLevel was set but no 'birthday' value was set, defaulting "
                          "to using 'level'";
        } else {
            QDate dob = m_settings.value("Dweller/birthday").toDate();

            return calculateProgressToNextBirthday(dob);
        }
    }
    return m_settings.value("Dweller/levelProgress", 0.0).toFloat();
}

void Dweller::setLevelProgress(float newLevelProgress)
{
    m_settings.setValue("Dweller/levelProgress", newLevelProgress);
    emit levelProgressChanged();
}

int Dweller::specialStrength() const
{
    return m_settings.value("Dweller/specialStrength", 1).toInt();
}

void Dweller::setSpecialStrength(int newSpecialStrength)
{
    m_settings.setValue("Dweller/specialStrength", newSpecialStrength);
    emit specialStrengthChanged();
}

int Dweller::specialPerception() const
{
    return m_settings.value("Dweller/specialPerception", 1).toInt();
}

void Dweller::setSpecialPerception(int newSpecialPerception)
{
    m_settings.setValue("Dweller/specialPerception", newSpecialPerception);
    emit specialPerceptionChanged();
}

int Dweller::specialEndurance() const
{
    return m_settings.value("Dweller/specialEndurance", 1).toInt();
}

void Dweller::setSpecialEndurance(int newSpecialEndurance)
{
    m_settings.setValue("Dweller/specialEndurance", newSpecialEndurance);
    emit specialEnduranceChanged();
}

int Dweller::specialCharisma() const
{
    return m_settings.value("Dweller/specialCharisma", 1).toInt();
}

void Dweller::setSpecialCharisma(int newSpecialCharisma)
{
    m_settings.setValue("Dweller/specialCharisma", newSpecialCharisma);
    emit specialCharismaChanged();
}

int Dweller::specialIntelligence() const
{
    return m_settings.value("Dweller/specialIntelligence", 1).toInt();
}

void Dweller::setSpecialIntelligence(int newSpecialIntelligence)
{
    m_settings.setValue("Dweller/specialIntelligence", newSpecialIntelligence);
    emit specialIntelligenceChanged();
}

int Dweller::specialAgility() const
{
    return m_settings.value("Dweller/specialAgility", 1).toInt();
}

void Dweller::setSpecialAgility(int newSpecialAgility)
{
    m_settings.setValue("Dweller/specialAgility", newSpecialAgility);
    emit specialAgilityChanged();
}

int Dweller::specialLuck() const
{
    return m_settings.value("Dweller/specialLuck", 1).toInt();
}

void Dweller::setSpecialLuck(int newSpecialLuck)
{
    m_settings.setValue("Dweller/specialLuck", newSpecialLuck);
    emit specialLuckChanged();
}

int Dweller::maxHealth() const
{
    return m_settings.value("Dweller/maxHP", 100).toInt();
}

void Dweller::setMaxHealth(int newMaxHealth)
{
    m_settings.setValue("Dweller/maxHP", newMaxHealth);
    emit maxHealthChanged();
}

int Dweller::currentHealth() const
{
    return m_settings.value("Dweller/currentHP", 100).toInt();
}

void Dweller::setCurrentHealth(int newCurrentHealth)
{
    m_settings.setValue("Dweller/currentHP", newCurrentHealth);
    emit currentHealthChanged();
}

int Dweller::maxAP() const
{
    return m_settings.value("Dweller/maxAP", 100).toInt();
}

void Dweller::setMaxAP(int newMaxAP)
{
    m_settings.setValue("Dweller/maxAP", newMaxAP);
    emit maxAPChanged();
}

int Dweller::currentAP() const
{
    return m_settings.value("Dweller/currentAP", 100).toInt();
}

void Dweller::setCurrentAP(int newCurrentAP)
{
    m_settings.setValue("Dweller/currentAP", newCurrentAP);
    emit currentAPChanged();
}

float Dweller::healthHead() const
{
    return m_settings.value("Dweller/healthHead", 1.0).toFloat();
}

void Dweller::setHealthHead(float newHealthHead)
{
    m_settings.setValue("Dweller/healthHead", newHealthHead);
    emit healthHeadChanged();
}

float Dweller::healthBody() const
{
    return m_settings.value("Dweller/healthBody", 1.0).toFloat();
}

void Dweller::setHealthBody(float newHealthBody)
{
    m_settings.setValue("Dweller/healthBody", newHealthBody);
    emit healthBodyChanged();
}

float Dweller::healthLeftArm() const
{
    return m_settings.value("Dweller/healthHead", 1.0).toFloat();
}

void Dweller::setHealthLeftArm(float newHealthLeftArm)
{
    m_settings.setValue("Dweller/healthLeftArm", newHealthLeftArm);
    emit healthLeftArmChanged();
}

float Dweller::healthRightArm() const
{
    return m_settings.value("Dweller/healthRightArm", 1.0).toFloat();
}

void Dweller::setHealthRightArm(float newHealthRightArm)
{
    m_settings.setValue("Dweller/healthRightArm", newHealthRightArm);
    emit healthRightArmChanged();
}

float Dweller::healthLeftLeg() const
{
    return m_settings.value("Dweller/healthLeftLeg", 1.0).toFloat();
}

void Dweller::setHealthLeftLeg(float newHealthLeftLeg)
{
    m_settings.setValue("Dweller/healthLeftLeg", newHealthLeftLeg);
    emit healthLeftLegChanged();
}

float Dweller::healthRightLeg() const
{
    return m_settings.value("Dweller/healthRightLeg", 1.0).toFloat();
}

void Dweller::setHealthRightLeg(float newHealthRightLeg)
{
    m_settings.setValue("Dweller/healthRightLeg", newHealthRightLeg);
    emit healthRightLegChanged();
}

void Dweller::setInventory(InventoryModel *newInventory)
{
    if (m_inventory.get() == newInventory)
        return;

    m_inventory.reset(newInventory);
    emit inventoryChanged(m_inventory.get());
}

QVariantList Dweller::collections()
{
    QVariantList c;

    m_settings.beginGroup("Collections");

    QStringList keys = m_settings.childKeys();
    for (const QString &key : keys) {
        CollectionItem *ci = new CollectionItem(this, key);
        ci->setQuantity(m_settings.value(key).toInt());
        c.append(QVariant::fromValue(ci));
    }

    m_settings.endGroup();
    return c;
}

CollectionItem::CollectionItem(QObject *parent, QString name, int quantity)
{
    m_name = name;
    m_quantity = quantity;
}

QString CollectionItem::name() const
{
    return m_name;
}

int CollectionItem::quantity() const
{
    return m_quantity;
}

void CollectionItem::setQuantity(int newQuantity)
{
    if (m_quantity == newQuantity)
        return;
    m_quantity = newQuantity;
    emit quantityChanged();
}

} // namespace PipOS
