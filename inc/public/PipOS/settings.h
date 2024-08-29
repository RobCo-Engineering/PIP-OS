#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QSettings>

namespace PipOS {
class ActiveProfile;

class Settings : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("")
    Q_CLASSINFO("RegisterEnumClassesUnscoped", "false")

    Q_PROPERTY(QString interfaceColor READ interfaceColor WRITE setInterfaceColor NOTIFY
                   interfaceColorChanged FINAL)
    Q_PROPERTY(bool skipBoot READ skipBoot WRITE setSkipBoot NOTIFY skipBootChanged FINAL)
    Q_PROPERTY(bool scanLines READ scanLines WRITE setScanLines NOTIFY scanLinesChanged FINAL)
    Q_PROPERTY(QString radioStationLocation READ radioStationLocation CONSTANT FINAL)

public:
    explicit Settings(QObject *parent = nullptr);

    QString interfaceColor() const;
    bool skipBoot() const;
    bool scanLines() const;

    QString radioStationLocation() const;

signals:
    void interfaceColorChanged();
    void skipBootChanged();
    void scanLinesChanged();

public slots:
    void setInterfaceColor(const QString &newInterfaceColor);
    void setSkipBoot(bool newSkipBoot);
    void setScanLines(bool newScanLines);

private:
    QSettings m_settings;
};
}
