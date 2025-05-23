#ifndef BOOTSCREEN_H
#define BOOTSCREEN_H

#include <QObject>
#include <QQmlEngine>

namespace PipOS {
class BootScreen : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QString bootingText READ bootingText CONSTANT FINAL)
    Q_PROPERTY(QString systemText READ systemText CONSTANT FINAL)
    QML_ELEMENT

public:
    explicit BootScreen(QObject *parent = nullptr);

    QString bootingText() const;
    QString systemText() const;

signals:

private:
    QString m_bootingText;
    QString m_systemText;
};
} // namespace PipOS

#endif // BOOTSCREEN_H
