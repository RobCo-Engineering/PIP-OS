#pragma once

#include <memory>

class GPIO {
public:
  GPIO(const std::string &chipname = "gpiochip0");
  ~GPIO();

  void pinMode(int pin, bool isOutput);
  void digitalWrite(int pin, bool value);
  bool digitalRead(int pin);

  // Delete copy constructor and assignment operator
  GPIO(const GPIO &) = delete;
  GPIO &operator=(const GPIO &) = delete;

private:
  class Impl;
  std::unique_ptr<Impl> pimpl;
};
