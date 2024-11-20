#include "PipOS/settings.h"
#include <QDir>

namespace PipOS {
Settings::Settings(QObject *parent)
    : QObject(parent), defaultSettings(createDefaultSettings()) {
    qInfo() << "Interface settings being loaded from" << m_settings.fileName();
    initializeDefaults();
}

QMap<QString, QVariant> Settings::createDefaultSettings() {
    return QMap<QString, QVariant>{
        {"Interface/color", "#00ff66"},
        {"Interface/scale", 1.0},
        {"Interface/xOffset", 0},
        {"Interface/yOffset", 0},
        {"Interface/skipBoot", false},
        {"Interface/scanlines", true},
        {"Radio/directory", QDir::currentPath()},
        {"Inventory/directory", QDir::currentPath()},
        {"Map/apiKey", ""},
        {"Map/positionSource", ""},
    };
}

void Settings::initializeDefaults() {
  m_settings.beginGroup(""); // Ensure we're at the root
  QStringList existingKeys = getAllKeys(m_settings);

  // Iterate through all default settings
  for (auto it = defaultSettings.constBegin(); it != defaultSettings.constEnd();
       ++it) {
    if (!existingKeys.contains(it.key())) {
      m_settings.setValue(it.key(), it.value());
    }
  }

  m_settings.sync(); // Ensure all changes are written to disk
}

QStringList Settings::getAllKeys(QSettings &settings)
{
    QStringList allKeys;
    QStringList groups = settings.childGroups();

    // Get keys in current group
    allKeys.append(settings.childKeys());

    // Recursively get keys from all groups
    for (const QString &group : groups) {
        settings.beginGroup(group);
        QStringList groupKeys = getAllKeys(settings);

        // Prepend group name to keys
        for (const QString &key : groupKeys) {
            allKeys.append(group + "/" + key);
        }
        settings.endGroup();
    }

    return allKeys;
}

QString Settings::interfaceColor() const {
  return m_settings.value("Interface/color").toString();
}

void Settings::setInterfaceColor(const QString &newInterfaceColor) {
  m_settings.setValue("Interface/color", newInterfaceColor);
  emit interfaceColorChanged();
}

bool Settings::skipBoot() const {
  return m_settings.value("Interface/skipBoot").toBool();
}

void Settings::setSkipBoot(bool newSkipBoot) {
  m_settings.setValue("Interface/skipBoot", newSkipBoot);
  emit skipBootChanged();
}

bool Settings::scanLines() const {
    return m_settings.value("Interface/scanlines").toBool();
}

void Settings::setScanLines(bool newScanLines) {
  m_settings.setValue("Interface/scanlines", newScanLines);
  emit scanLinesChanged();
}

QString Settings::radioStationLocation() const {
  return m_settings.value("Radio/directory").toString();
}

QString Settings::inventoryFileLocation() const {
  return m_settings.value("Inventory/directory").toString();
}

float Settings::scale() const {
  return m_settings.value("Interface/scale").toFloat();
}
void Settings::setScale(float newScale) {
  m_settings.setValue("Interface/scale", newScale);
  emit scaleChanged();
}
int Settings::xOffset() const {
  return m_settings.value("Interface/xOffset").toInt();
}
void Settings::setXOffset(int newOffset) {
  m_settings.setValue("Interface/xOffset", newOffset);
  emit xOffsetChanged();
}
int Settings::yOffset() const {
  return m_settings.value("Interface/yOffset").toInt();
}
void Settings::setYOffset(int newOffset) {
  m_settings.setValue("Interface/yOffset", newOffset);
  emit yOffsetChanged();
}

QString Settings::mapApiKey() const {
  return m_settings.value("Map/apiKey").toString();
}

QString Settings::mapPositionSource() const
{
    return m_settings.value("Map/positionSource").toString();
}

} // namespace PipOS
