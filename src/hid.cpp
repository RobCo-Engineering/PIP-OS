#include "hid.h"
#include <QKeyEvent>

namespace PipOS {
bool HumanInterfaceDevice::eventFilter(QObject *object, QEvent *event)
{
    switch (event->type()) {
    case QEvent::KeyPress: {
        // Handle key press events
        QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);

        Qt::Key qtKey = Qt::Key(keyEvent->key());
        if (keymap.contains(qtKey)) {
            // qInfo() << qtKey << keymap.value(qtKey);
            emit userActivity(keymap.value(qtKey));
            return true;
        } else {
            // qInfo() << qtKey << "not mapped";
            return QObject::eventFilter(object, event);
        }
    }

    default:
        // standard event processing for non key press
        return QObject::eventFilter(object, event);
    }
}

void HumanInterfaceDevice::setKeyMap(Qt::Key key, QString activity)
{
    keymap.insert(key, activity);
}
} // namespace PipOS
