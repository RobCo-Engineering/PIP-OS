#ifndef EVENTS_H
#define EVENTS_H

#include <QEvent>
#include <QObject>
#include <QQmlEngine>

namespace PipOS {

class Events : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit Events(QObject *parent = nullptr);

    enum UserEvent {
        TAB_STAT,
        TAB_ITEM,
        TAB_DATA,
        TAB_MAP,
        TAB_RADIO,
        SUB_TAB_NEXT,
        SUB_TAB_PREVIOUS,
        SCROLL_UP,
        SCROLL_DOWN,

        SCROLL_UP_NEW,
        SCROLL_DOWN_NEW,

        BUTTON_SELECT,
        APP_QUIT
    };
    Q_ENUM(UserEvent)
};

} // namespace PipOS
#endif // EVENTS_H
