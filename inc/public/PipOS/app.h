#pragma once

#include <QGuiApplication>
#include <QObject>
#include <QQmlApplicationEngine>

#include "PipOS/dweller.h"
#include "PipOS/hid.h"
#include "PipOS/settings.h"

namespace PipOS {
class App : public QObject {
  Q_OBJECT
  Q_PROPERTY(QQmlApplicationEngine *mainWindowEngine READ mainWindowEngine WRITE
                 setMainWindowEngine NOTIFY mainWindowEngineChanged)
  Q_PROPERTY(HumanInterfaceDevice *hid READ hid CONSTANT)
  Q_PROPERTY(Settings *settings READ settings WRITE setSettings NOTIFY settingsChanged)
  Q_PROPERTY(Dweller *dweller READ dweller WRITE setDweller NOTIFY
                 dwellerChanged FINAL)

public:
  explicit App();

  void init();

  QQmlApplicationEngine *mainWindowEngine() const {
    return m_mainWindowEngine.get();
  }
  Settings *settings() const { return m_settings.get(); }
  Dweller *dweller() const { return m_dweller.get(); };
  HumanInterfaceDevice *hid() const { return m_hid.get(); };

  signals:
  void mainWindowEngineChanged(QQmlApplicationEngine *mainWindowEngine);
  void settingsChanged(PipOS::Settings *settings);
  void dwellerChanged(PipOS::Dweller *dweller);

public slots:
  void setMainWindowEngine(QQmlApplicationEngine *mainWindowEngine);
  void setSettings(Settings *settings);
  void setDweller(Dweller *newDweller);

private:
  std::unique_ptr<QQmlApplicationEngine> m_mainWindowEngine;
  std::shared_ptr<Settings> m_settings;
  std::shared_ptr<Dweller> m_dweller;
  std::shared_ptr<HumanInterfaceDevice> m_hid;
};
} // namespace PipOS
