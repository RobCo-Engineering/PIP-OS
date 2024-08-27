#pragma once

#include <QDebug>
#include <QEvent>
#include <QMap>
#include <QObject>

namespace PipOS {

class HumanInterfaceDevice : public QObject
{
    Q_OBJECT

public:
    HumanInterfaceDevice(QObject *parent = nullptr)
        : QObject(parent)
    {}

    void setKeyMap(Qt::Key key, QString activity);

protected:
    bool eventFilter(QObject *obj, QEvent *event) override;

private:
    QMap<Qt::Key, QString> keymap{
        {Qt::Key_F1, "TAB_STAT"},
        {Qt::Key_F2, "TAB_ITEM"},
        {Qt::Key_F3, "TAB_DATA"},
        {Qt::Key_F4, "TAB_MAP"},
        {Qt::Key_F5, "TAB_RADIO"},
        {Qt::Key_Up, "SCROLL_UP"},
        {Qt::Key_Down, "SCROLL_DOWN"},
        {Qt::Key_Space, "BUTTON_SELECT"},
    };

signals:
    void userActivity(QString activity);
};
}; // namespace PipOS
