#ifndef HARDWAREINPUT_H
#define HARDWAREINPUT_H

#include <QObject>
#include <QThread>

namespace PipOS {
class InputWatcher : public QObject
{
    Q_OBJECT

public:
    explicit InputWatcher(QObject *parent = nullptr);

public slots:
    void watchForEvents();

signals:
    void inputEvent();
};

class HardwareInput : public QObject
{
    Q_OBJECT
    QThread inputThread;

public:
    explicit HardwareInput(QObject *parent = nullptr);

public slots:
    void handleEvents();

signals:
    void operate();
};
} // namespace PipOS

#endif // HARDWAREINPUT_H
