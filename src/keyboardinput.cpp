#include "hardwareinput.h"

bool KeyboardEventHandler::eventFilter(QObject *obj, QEvent *event) {
  // standard event processing for non key press
  if (event->type() != QEvent::KeyPress) {
    return QObject::eventFilter(obj, event);
  }

  // Handle key press events
  QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);
  switch (keyEvent->key()) {

  // TODO: Load keymaps from settings
  case Qt::Key_1:
    emit statPressed();
    break;

  case Qt::Key_2:
    emit itemPressed();
    break;

  case Qt::Key_3:
    emit dataPressed();
    break;

  case Qt::Key_4:
    emit mapPressed();
    break;

  case Qt::Key_5:
    emit radioPressed();
    break;

  case Qt::Key_Up:
    emit scrollDown();
    break;

  case Qt::Key_Down:
    emit scrollUp();
    break;

  case Qt::Key_Left:
    emit scrollPress();
    break;

  default:
    return QObject::eventFilter(obj, event);
  }

  // qDebug()<<"Key press handled"<<QKeySequence(keyEvent->key()).toString();
  return true;
}
