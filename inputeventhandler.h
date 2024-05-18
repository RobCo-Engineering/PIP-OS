#ifndef INPUTEVENTHANDLER_H
#define INPUTEVENTHANDLER_H

#include <QObject>
#include <QKeyEvent>

class InputEventHandler : public QObject
{
    Q_OBJECT

public:
    explicit InputEventHandler(QObject *parent = nullptr) : QObject(parent) {}

protected:
    bool eventFilter(QObject *obj, QEvent *event) override;

signals:
    void statPressed();
    void itemPressed();
    void dataPressed();
    void mapPressed();
    void radioPressed();

    void scrollUp();
    void scrollDown();
    void scrollPress();

    // Extra buttons some PipBoy models may have
    void button1Press();
    void button2Press();
    void button3Press();
    void button4Press();
};

#endif // INPUTEVENTHANDLER_H
