#include <QObject>
#include <QQmlEngine>

class AtomicCommand : public QObject {
  Q_OBJECT
  QML_ELEMENT

public:
  explicit AtomicCommand(QObject *parent = nullptr);
};
