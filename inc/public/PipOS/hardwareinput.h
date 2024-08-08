// gpiomonitor.h
#pragma once

#include <QKeyEvent>
#include <QMutex>
#include <QObject>
#include <QThread>
#include <QWaitCondition>

#include "gpio.h"

class InputEventHandler : public QObject {
  Q_OBJECT

public:
  explicit InputEventHandler(QObject *parent = nullptr) : QObject(parent) {}

signals:
  void statPressed();
  void itemPressed();
  void dataPressed();
  void mapPressed();
  void radioPressed();

  void scrollUp();
  void scrollDown();
  void scrollPress();

  // Extra buttons some PipBoy models may have
  void button1Press();
  void button2Press();
  void button3Press();
  void button4Press();
};

class HardwareEventHandler : public InputEventHandler {
public:
  HardwareEventHandler(QObject *parent = nullptr);
  ~HardwareEventHandler() override;

  void startMonitoring();
  void stopMonitoring();

protected:
  void run();

  static constexpr int SW_STAT = 1;
  static constexpr int SW_ITEM = 2;
  static constexpr int SW_DATA = 3;
  static constexpr int ENC_A = 4;
  static constexpr int ENC_B = 5;
  static constexpr int ENC_SW = 0;

  std::array<bool, 6> pinStates{};
  std::array<bool, 2> prevEncoderStates{};

private:
  GPIO gpio;
  QThread workerThread;
  QMutex mutex;
  QWaitCondition condition;
  bool abort;
};

class KeyboardEventHandler : public InputEventHandler {
public:
  KeyboardEventHandler(QObject *parent = nullptr);
  ~KeyboardEventHandler() override;

protected:
  bool eventFilter(QObject *obj, QEvent *event) override;
};
