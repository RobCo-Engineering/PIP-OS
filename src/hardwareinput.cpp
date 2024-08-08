// gpiomonitor.cpp
#include "hardwareinput.h"
#include <QDebug>

HardwareEventHandler::HardwareEventHandler(QObject *parent)
    : InputEventHandler(parent), abort(false) {
  this->moveToThread(&workerThread);
  connect(&workerThread, &QThread::started, this, &HardwareEventHandler::run);
  workerThread.start();
}

HardwareEventHandler::~HardwareEventHandler() {
  stopMonitoring();
  workerThread.quit();
  workerThread.wait();
}

void HardwareEventHandler::startMonitoring() {
  QMutexLocker locker(&mutex);

  // Set input pin modes
  gpio.pinMode(SW_STAT, false);
  gpio.pinMode(SW_ITEM, false);
  gpio.pinMode(SW_DATA, false);
  gpio.pinMode(ENC_A, false);
  gpio.pinMode(ENC_B, false);
  gpio.pinMode(ENC_SW, false);

  abort = false;
  condition.wakeOne();
}

void HardwareEventHandler::stopMonitoring() {
  QMutexLocker locker(&mutex);
  abort = true;
  condition.wakeOne();
}

void HardwareEventHandler::run() {
  while (true) {
    mutex.lock();
    if (abort) {
      mutex.unlock();
      break;
    }

    // Read pin states
    pinStates[SW_STAT] = gpio.digitalRead(SW_STAT);
    pinStates[SW_ITEM] = gpio.digitalRead(SW_ITEM);
    pinStates[SW_DATA] = gpio.digitalRead(SW_DATA);
    pinStates[ENC_A] = gpio.digitalRead(ENC_A);
    pinStates[ENC_B] = gpio.digitalRead(ENC_B);
    pinStates[ENC_SW] = gpio.digitalRead(ENC_SW);

    // Handle switch state changes
    for (int i = 0; i < 3; ++i) {
      if (pinStates[i] != prevEncoderStates[i]) {
        switch (i) {
        case SW_STAT:
          emit statPressed();
          break;
        case SW_ITEM:
          emit itemPressed();
          break;
        case SW_DATA:
          emit dataPressed();
        case ENC_SW:
          emit scrollPress();
        default:
          break;
        }
        prevEncoderStates[i] = pinStates[i];
      }
    }

    // Handle rotary encoder
    bool encA = pinStates[ENC_A];
    bool encB = pinStates[ENC_B];
    int direction = 0;

    if ((prevEncoderStates[0] == false && encA == true) ||
        (prevEncoderStates[0] == true && encA == false)) {
      direction = (prevEncoderStates[1] == encB) ? 1 : -1;
      if (direction == 1) {
        emit scrollUp();
      } else if (direction == -1) {
        emit scrollDown();
      }
    }

    prevEncoderStates[0] = encA;
    prevEncoderStates[1] = encB;

    mutex.unlock();
    QThread::msleep(50);
  }
}
