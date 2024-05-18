#include "inputeventhandler.h"

bool InputEventHandler::eventFilter(QObject *obj, QEvent *event)
{
    // standard event processing for non key press
    if (event->type() != QEvent::KeyPress) {
        return QObject::eventFilter(obj, event);
    }

    // Handle key press events
    QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);
    switch (keyEvent->key()) {

    // TODO: Load keymaps from settings
    case Qt::Key_1:
        emit this->statPressed();
        break;

    case Qt::Key_2:
        emit this->itemPressed();
        break;

    case Qt::Key_3:
        emit this->dataPressed();
        break;

    case Qt::Key_4:
        emit this->mapPressed();
        break;

    case Qt::Key_5:
        emit this->radioPressed();
        break;

    case Qt::Key_Up:
        emit this->scrollUp();
        break;

    case Qt::Key_Down:
        emit this->scrollDown();
        break;

    case Qt::Key_Left:
        emit this->scrollPress();
        break;

    default:
        return QObject::eventFilter(obj, event);
    }

    // qDebug()<<"Key press handled"<<QKeySequence(keyEvent->key()).toString();
    return true;
}
