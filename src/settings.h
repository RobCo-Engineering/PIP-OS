#pragma once

#include <QKeySequence>
#include <QObject>
#include <QQmlEngine>
#include <QSettings>
#include <QtQmlIntegration/qqmlintegration.h>

#include "events.h"

namespace PipOS {
// class ActiveProfile;

// typedef QMap<Events::UserEvent, QKeySequence> KeyMap;

class Settings : public QObject {
  Q_OBJECT
  QML_ELEMENT
  QML_SINGLETON
  QML_UNCREATABLE("")
  Q_CLASSINFO("RegisterEnumClassesUnscoped", "false")

  Q_PROPERTY(QString interfaceColor READ interfaceColor WRITE setInterfaceColor NOTIFY
                 interfaceColorChanged FINAL)
  Q_PROPERTY(bool skipBoot READ skipBoot WRITE setSkipBoot NOTIFY skipBootChanged FINAL)
  Q_PROPERTY(bool scanLines READ scanLines WRITE setScanLines NOTIFY scanLinesChanged FINAL)
  Q_PROPERTY(bool hideMapTab READ hideMapTab WRITE setHideMapTab NOTIFY hideMapTabChanged FINAL)
  Q_PROPERTY(QString radioStationLocation READ radioStationLocation CONSTANT FINAL)
  Q_PROPERTY(QString inventoryFileLocation READ inventoryFileLocation CONSTANT FINAL)

  Q_PROPERTY(float scale READ scale WRITE setScale NOTIFY scaleChanged FINAL)
  Q_PROPERTY(int xOffset READ xOffset WRITE setXOffset NOTIFY xOffsetChanged FINAL)
  Q_PROPERTY(int yOffset READ yOffset WRITE setYOffset NOTIFY yOffsetChanged FINAL)

  Q_PROPERTY(QString mapApiKey READ mapApiKey CONSTANT FINAL)
  Q_PROPERTY(QString mapPositionSource READ mapPositionSource CONSTANT FINAL)

public:
  explicit Settings(QObject *parent = nullptr);

  QString interfaceColor() const;
  bool hideMapTab() const;
  bool skipBoot() const;
  bool scanLines() const;
  QString radioStationLocation() const;
  QString inventoryFileLocation() const;
  float scale() const;
  int xOffset() const;
  int yOffset() const;
  QString mapApiKey() const;
  QString mapPositionSource() const;

  Q_INVOKABLE QKeySequence getKeySequence(Events::UserEvent userEvent) const;

  signals:
  void interfaceColorChanged();
  void skipBootChanged();
  void scanLinesChanged();
  void scaleChanged();
  void xOffsetChanged();
  void yOffsetChanged();
  void hideMapTabChanged();

public slots:
  void setInterfaceColor(const QString &newInterfaceColor);
  void setHideMapTab(bool newHideMapTab);
  void setSkipBoot(bool newSkipBoot);
  void setScanLines(bool newScanLines);
  void setScale(float newScale);
  void setXOffset(int newOffset);
  void setYOffset(int newOffset);

private:
  QSettings m_settings;
  const QMap<QString, QVariant> defaultSettings;
  const QMap<Events::UserEvent, QKeySequence> m_keymap{
      {Events::UserEvent::APP_QUIT, QKeySequence(Qt::Key_Escape)},
      {Events::UserEvent::TAB_STAT, QKeySequence(Qt::Key_F1)},
      {Events::UserEvent::TAB_ITEM, QKeySequence(Qt::Key_F2)},
      {Events::UserEvent::TAB_DATA, QKeySequence(Qt::Key_F3)},
      {Events::UserEvent::TAB_MAP, QKeySequence(Qt::Key_F4)},
      {Events::UserEvent::TAB_RADIO, QKeySequence(Qt::Key_F5)},
      {Events::UserEvent::SUB_TAB_NEXT, QKeySequence(Qt::Key_Right)},
      {Events::UserEvent::SUB_TAB_PREVIOUS, QKeySequence(Qt::Key_Left)},
      {Events::UserEvent::BUTTON_SELECT, QKeySequence(Qt::Key_Space)},
      {Events::UserEvent::SCROLL_UP, QKeySequence(Qt::Key_Up)},
      {Events::UserEvent::SCROLL_DOWN, QKeySequence(Qt::Key_Down)},

      {Events::UserEvent::SCROLL_UP_NEW, QKeySequence(Qt::Key_O)},
      {Events::UserEvent::SCROLL_DOWN_NEW, QKeySequence(Qt::Key_L)},
  };

  void initializeDefaults();
  QStringList getAllKeys(QSettings &settings);

  // Helper method to create the default settings map
  static QMap<QString, QVariant> createDefaultSettings();
};
} // namespace PipOS
