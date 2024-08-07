#include "gpio.h"

#ifdef __linux__
#include <gpiod.hpp>
#include <unordered_map>

class GPIO::Impl
{
public:
    Impl(const std::string &chipname)
        : chip(chipname)
    {}

    gpiod::chip chip;
    std::unordered_map<int, gpiod::line> lines;
};
#else
class GPIO::Impl
{
public:
    Impl(const std::string &) {} // Dummy constructor
};
#endif

GPIO::GPIO(const std::string &chipname)
    : pimpl(std::make_unique<Impl>(chipname))
{}

GPIO::~GPIO() = default;

void GPIO::pinMode(int pin, bool isOutput)
{
#ifdef __linux__
    auto line = pimpl->chip.get_line(pin);
    if (isOutput) {
        line.request({"myapp", gpiod::line_request::DIRECTION_OUTPUT, 0});
    } else {
        line.request({"myapp", gpiod::line_request::DIRECTION_INPUT, 0});
    }
    pimpl->lines[pin] = std::move(line);
#else
    // Dummy implementation for non-Linux systems
    (void) pin;
    (void) isOutput;
#endif
}

void GPIO::digitalWrite(int pin, bool value)
{
#ifdef __linux__
    if (pimpl->lines.find(pin) == pimpl->lines.end()) {
        throw std::runtime_error("Pin not configured");
    }
    pimpl->lines[pin].set_value(value ? 1 : 0);
#else
    // Dummy implementation for non-Linux systems
    (void) pin;
    (void) value;
#endif
}

bool GPIO::digitalRead(int pin)
{
#ifdef __linux__
    if (pimpl->lines.find(pin) == pimpl->lines.end()) {
        throw std::runtime_error("Pin not configured");
    }
    return pimpl->lines[pin].get_value() == 1;
#else
    // Dummy implementation for non-Linux systems
    (void) pin;
    return false;
#endif
}
