#pragma once

#include <QGuiApplication>
#include <QObject>
#include <QQmlApplicationEngine>

#include "PipOS/radio.h"

namespace PipOS {

class App : public QObject {
  Q_OBJECT
  Q_PROPERTY(Radio *radio READ radio CONSTANT)

public:
  explicit App(QObject *parent = nullptr) : QObject(parent) {
    m_mainWindowEngine = new QQmlApplicationEngine(parent);
    m_radio = new Radio(this);
  }

  void init();

  // Getters
  QQmlApplicationEngine mainWindowEngine() const { return m_mainWindowEngine; }
  Radio *radio() const { return m_radio; }

private:
  QQmlApplicationEngine *m_mainWindowEngine = nullptr;
  Radio *m_radio = nullptr;
};
} // namespace PipOS
