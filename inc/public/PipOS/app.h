#pragma once

#include <QGuiApplication>
#include <QObject>
#include <QQmlApplicationEngine>

#include "PipOS/dataprovider.h"
#include "PipOS/dweller.h"
#include "PipOS/hid.h"
#include "PipOS/radio.h"
#include "PipOS/settings.h"

namespace PipOS {
class App : public QObject {
  Q_OBJECT
  Q_PROPERTY(HumanInterfaceDevice *hid READ hid CONSTANT)
  Q_PROPERTY(DataProvider *dataProvider READ dataProvider CONSTANT)
  Q_PROPERTY(Settings *settings READ settings CONSTANT)
  Q_PROPERTY(Dweller *dweller READ dweller CONSTANT)
  Q_PROPERTY(Radio *radio READ radio CONSTANT)

public:
  explicit App(QObject *parent = nullptr) : QObject(parent) {
      m_mainWindowEngine = new QQmlApplicationEngine(parent);
      m_hid = new HumanInterfaceDevice(this);
      m_dataProvider = new DataProvider(this);
      m_settings = new Settings(this);
      m_dweller = new Dweller(this);
      m_radio = new Radio(this);
  }

  void init();

  // Getters
  QQmlApplicationEngine mainWindowEngine() const { return m_mainWindowEngine; }
  HumanInterfaceDevice *hid() const { return m_hid; }
  DataProvider *dataProvider() const { return m_dataProvider; }
  Settings *settings() const { return m_settings; }
  Dweller *dweller() const { return m_dweller; }
  Radio *radio() const { return m_radio; }

  private:
  QQmlApplicationEngine *m_mainWindowEngine = nullptr;
  HumanInterfaceDevice *m_hid = nullptr;
  DataProvider *m_dataProvider = nullptr;
  Settings *m_settings = nullptr;
  Dweller *m_dweller = nullptr;
  Radio *m_radio = nullptr;
};
} // namespace PipOS
