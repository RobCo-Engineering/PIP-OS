#ifndef HID_H
#define HID_H
#include <QDebug>
#include <QEvent>
#include <QObject>
class EventFilter : public QObject {
  Q_OBJECT
protected:
    bool eventFilter(QObject *obj, QEvent *event) override;
};
#endif // HID_H
