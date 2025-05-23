#pragma once

#include <QGuiApplication>
#include <QObject>
#include <QQmlApplicationEngine>
#include <jsoncons/json.hpp>

#include "radio.h"
#include "settings.h"

namespace PipOS {

class App : public QObject {
  Q_OBJECT
  Q_PROPERTY(Radio *radio READ radio CONSTANT)

public:
  explicit App(QObject *parent = nullptr) : QObject(parent) {
    m_mainWindowEngine = new QQmlApplicationEngine(parent);
    m_settings = new Settings(this);
    m_radio = new Radio(this);
	m_externalData = jsoncons::json::parse(R"({
    })");
  }

  void init();

  // Getters
  QQmlApplicationEngine mainWindowEngine() const { return m_mainWindowEngine; }
  Radio *radio() const { return m_radio; }
  jsoncons::json externalData() const { return m_externalData; }

  private:
  QQmlApplicationEngine *m_mainWindowEngine = nullptr;
  Settings *m_settings = nullptr;
  Radio *m_radio = nullptr;
  jsoncons::json m_externalData = nullptr;
};
} // namespace PipOS
