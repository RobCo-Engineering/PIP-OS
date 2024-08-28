#include "PipOS/settings.h"

namespace PipOS {
Settings::Settings(QObject *parent)
    : QObject(parent)
{}

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

} // namespace PipOS
