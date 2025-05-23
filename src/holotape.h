#ifndef HOLOTAPE_H
#define HOLOTAPE_H

#include <QObject>
#include <QQmlEngine>

namespace PipOS {
class HolotapeProvider : public QObject {
  Q_OBJECT
  QML_ELEMENT
  QML_SINGLETON

  public:
  explicit HolotapeProvider(QObject *parent = nullptr);

  signals:
  void holotapeLoaded(QString tape);
};
} // namespace PipOS
#endif
