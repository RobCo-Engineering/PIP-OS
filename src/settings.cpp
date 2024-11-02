#include "PipOS/settings.h"
#include <QDir>

namespace PipOS {
Settings::Settings(QObject *parent)
    : QObject(parent)
{
    qInfo() << "Interface settings being loaded from" << m_settings.fileName();
}

QString Settings::interfaceColor() const
{
    return m_settings.value("Interface/color", "#00ff66").toString();
}

void Settings::setInterfaceColor(const QString &newInterfaceColor)
{
    m_settings.setValue("Interface/color", newInterfaceColor);
    emit interfaceColorChanged();
}

bool Settings::skipBoot() const
{
    return m_settings.value("Interface/skipBoot", false).toBool();
}

void Settings::setSkipBoot(bool newSkipBoot)
{
    m_settings.setValue("Interface/skipBoot", newSkipBoot);
    emit skipBootChanged();
}

bool Settings::scanLines() const
{
    return m_settings.value("Interface/scanlines", true).toBool();
}

void Settings::setScanLines(bool newScanLines)
{
    m_settings.setValue("Interface/scanlines", newScanLines);
    emit scanLinesChanged();
}

QString Settings::radioStationLocation() const
{
    return m_settings.value("Radio/directory", QDir::currentPath()).toString();
}

QString Settings::inventoryFileLocation() const
{
    return m_settings.value("Inventory/directory", QDir::currentPath()).toString();
}

float Settings::scale() const
{
    return m_settings.value("Interface/scale", 1.0).toFloat();
}
void Settings::setScale(float newScale)
{
    m_settings.setValue("Interface/scale", newScale);
    emit scaleChanged();
}
int Settings::xOffset() const
{
    return m_settings.value("Interface/xOffset", 0).toInt();
}
void Settings::setXOffset(int newOffset)
{
    m_settings.setValue("Interface/xOffset", newOffset);
    emit xOffsetChanged();
}
int Settings::yOffset() const
{
    return m_settings.value("Interface/yOffset", 0).toInt();
}
void Settings::setYOffset(int newOffset)
{
    m_settings.setValue("Interface/yOffset", newOffset);
    emit yOffsetChanged();
}

} // namespace PipOS
