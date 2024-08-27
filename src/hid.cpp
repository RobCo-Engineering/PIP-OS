#include "hid.h"
#include <QKeyEvent>

bool EventFilter::eventFilter(QObject *object, QEvent *event) {
    // standard event processing for non key press

    switch (event->type()) {
    case QEvent::KeyPress: {
        // Handle key press events
        QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);

        switch (keyEvent->key()) {
        default:
            qInfo() << "Key pressed" << keyEvent->text();
            return true;
            // return QObject::eventFilter(object, event);
        }

        return true;
    }

        // Reduce noise
    case QEvent::MetaCall:
    case QEvent::Expose:
    case QEvent::Timer:
    case QEvent::UpdateRequest:
    case QEvent::MouseMove:
    case QEvent::DynamicPropertyChange:
        return QObject::eventFilter(object, event);

    default:
        qInfo() << "Unknown event" << event->type();
        return QObject::eventFilter(object, event);
    }

    return true;
}
