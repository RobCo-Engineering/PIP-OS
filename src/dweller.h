#ifndef DWELLER_H
#define DWELLER_H

#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QSettings>

namespace PipOS {

class CollectionItem : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QString name READ name CONSTANT FINAL)
    Q_PROPERTY(int quantity READ quantity WRITE setQuantity NOTIFY quantityChanged FINAL)

public:
    explicit CollectionItem(QObject *parent = nullptr, QString name = "-", int quantity = 0);
    QString name() const;
    int quantity() const;
    void setQuantity(int newQuantity);

signals:
    void quantityChanged();

private:
    QString m_name;
    int m_quantity;
};

class Dweller : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    QML_UNCREATABLE("")

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)

    // Levels
    Q_PROPERTY(int level READ level WRITE setLevel NOTIFY levelChanged FINAL)
    Q_PROPERTY(float levelProgress READ levelProgress WRITE setLevelProgress NOTIFY levelProgressChanged FINAL)

    // SPECIAL
    Q_PROPERTY(int specialStrength READ specialStrength WRITE setSpecialStrength NOTIFY
                   specialStrengthChanged FINAL)
    Q_PROPERTY(int specialPerception READ specialPerception WRITE setSpecialPerception NOTIFY
                   specialPerceptionChanged FINAL)
    Q_PROPERTY(int specialEndurance READ specialEndurance WRITE setSpecialEndurance NOTIFY
                   specialEnduranceChanged FINAL)
    Q_PROPERTY(int specialCharisma READ specialCharisma WRITE setSpecialCharisma NOTIFY
                   specialCharismaChanged FINAL)
    Q_PROPERTY(int specialIntelligence READ specialIntelligence WRITE setSpecialIntelligence NOTIFY
                   specialIntelligenceChanged FINAL)
    Q_PROPERTY(int specialAgility READ specialAgility WRITE setSpecialAgility NOTIFY
                   specialAgilityChanged FINAL)
    Q_PROPERTY(int specialLuck READ specialLuck WRITE setSpecialLuck NOTIFY specialLuckChanged FINAL)

    // Attributes
    Q_PROPERTY(int currentHealth READ currentHealth WRITE setCurrentHealth NOTIFY
                   currentHealthChanged FINAL)
    Q_PROPERTY(int maxHealth READ maxHealth WRITE setMaxHealth NOTIFY maxHealthChanged FINAL)
    Q_PROPERTY(int maxAP READ maxAP WRITE setMaxAP NOTIFY maxAPChanged FINAL)
    Q_PROPERTY(int currentAP READ currentAP WRITE setCurrentAP NOTIFY currentAPChanged FINAL)

    // Limb health
    Q_PROPERTY(float healthHead READ healthHead WRITE setHealthHead NOTIFY healthHeadChanged FINAL)
    Q_PROPERTY(float healthBody READ healthBody WRITE setHealthBody NOTIFY healthBodyChanged FINAL)
    Q_PROPERTY(float healthLeftArm READ healthLeftArm WRITE setHealthLeftArm NOTIFY healthLeftArmChanged FINAL)
    Q_PROPERTY(float healthRightArm READ healthRightArm WRITE setHealthRightArm NOTIFY healthRightArmChanged FINAL)
    Q_PROPERTY(float healthLeftLeg READ healthLeftLeg WRITE setHealthLeftLeg NOTIFY healthLeftLegChanged FINAL)
    Q_PROPERTY(float healthRightLeg READ healthRightLeg WRITE setHealthRightLeg NOTIFY healthRightLegChanged FINAL)

    // Collections inventory
    Q_PROPERTY(QVariantList collections READ collections CONSTANT FINAL)

public:
    explicit Dweller(QObject *parent = nullptr);

    QString name() const;
    int level() const;
    float levelProgress() const;

    int specialStrength() const;
    int specialPerception() const;
    int specialEndurance() const;
    int specialCharisma() const;
    int specialIntelligence() const;
    int specialAgility() const;
    int specialLuck() const;

    int maxHealth() const;
    int currentHealth() const;
    int maxAP() const;
    int currentAP() const;

    float healthHead() const;
    float healthBody() const;
    float healthLeftArm() const;
    float healthRightArm() const;
    float healthLeftLeg() const;
    float healthRightLeg() const;

    QVariantList collections();

public slots:
    void setName(const QString &newName);
    void setLevel(int newLevel);
    void setLevelProgress(float newLevelProgress);
    void setSpecialIntelligence(int newSpecialIntelligence);
    void setSpecialAgility(int newSpecialAgility);
    void setSpecialLuck(int newSpecialLuck);
    void setSpecialCharisma(int newSpecialCharisma);
    void setSpecialEndurance(int newSpecialEndurance);
    void setSpecialPerception(int newSpecialPerception);
    void setSpecialStrength(int newSpecialStrength);
    void setHealthHead(float newHealthHead);
    void setHealthBody(float newHealthBody);
    void setHealthLeftArm(float newHealthLeftArm);
    void setHealthRightArm(float newHealthRightArm);
    void setHealthLeftLeg(float newHealthLeftLeg);
    void setHealthRightLeg(float newHealthRightLeg);
    void setMaxHealth(int newMaxHealth);
    void setCurrentHealth(int newCurrentHealth);
    void setMaxAP(int newMapAP);
    void setCurrentAP(int newCurrentAP);

signals:
    void nameChanged();
    void levelChanged();
    void levelProgressChanged();
    void specialStrengthChanged();
    void specialPerceptionChanged();
    void specialEnduranceChanged();
    void specialCharismaChanged();
    void specialIntelligenceChanged();
    void specialAgilityChanged();
    void specialLuckChanged();
    void maxHealthChanged();
    void currentHealthChanged();
    void maxAPChanged();
    void currentAPChanged();
    void healthHeadChanged();
    void healthBodyChanged();
    void healthLeftArmChanged();
    void healthRightArmChanged();
    void healthLeftLegChanged();
    void healthRightLegChanged();

private:
    QSettings m_settings;
};
} // namespace PipOS

Q_DECLARE_METATYPE(PipOS::CollectionItem *);

#endif // DWELLER_H
