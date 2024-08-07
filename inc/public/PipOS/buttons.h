#ifndef PIPBOY_BUTTON_MODULE_H
#define PIPBOY_BUTTON_MODULE_H

#include <array>

#define IODIRA 0x00
#define IODIRB 0x01
#define IPOLA 0x02
#define IPOLB 0x03
#define GPINTENA 0x04
#define GPINTENB 0x05
#define DEFVALA 0x06
#define DEFVALB 0x07
#define INTCONA 0x08
#define INTCONB 0x09
#define IOCONA 0x0A
#define IOCONB 0x0B
#define GPPUA 0x0C
#define GPPUB 0x0D
#define INTFA 0x0E
#define INTFB 0x0F
#define INTCAPA 0x10
#define INTCAPB 0x11
#define GPIOA 0x12
#define GPIOB 0x13
#define OLATA 0x14
#define OLATB 0x15

#define SW_STAT 1
#define SW_ITEM 2
#define SW_DATA 3

#define ENC_CCW 4
#define ENC_CW 5
#define ENC_SW 0

#define INFO_LED 7

// No complete step yet.
#define DIR_NONE 0x0
// Clockwise step.
#define DIR_CW 0x10
// Anti-clockwise step.
#define DIR_CCW 0x20

// Use the full-step state table (emits a code at 00 only)
#define R_START 0x0
#define R_CW_FINAL 0x1
#define R_CW_BEGIN 0x2
#define R_CW_NEXT 0x3
#define R_CCW_BEGIN 0x4
#define R_CCW_FINAL 0x5
#define R_CCW_NEXT 0x6

// Borrowed from https://github.com/buxtronix/arduino/blob/master/libraries/Rotary/Rotary.cpp
const unsigned char ttable[7][4] = {
    // R_START
    {R_START, R_CW_BEGIN, R_CCW_BEGIN, R_START},
    // R_CW_FINAL
    {R_CW_NEXT, R_START, R_CW_FINAL, R_START | DIR_CW},
    // R_CW_BEGIN
    {R_CW_NEXT, R_CW_BEGIN, R_START, R_START},
    // R_CW_NEXT
    {R_CW_NEXT, R_CW_BEGIN, R_CW_FINAL, R_START},
    // R_CCW_BEGIN
    {R_CCW_NEXT, R_START, R_CCW_BEGIN, R_START},
    // R_CCW_FINAL
    {R_CCW_NEXT, R_CCW_FINAL, R_START, R_START | DIR_CCW},
    // R_CCW_NEXT
    {R_CCW_NEXT, R_CCW_FINAL, R_CCW_BEGIN, R_START},
};

class PipBoyButtonModule {
public:
  PipBoyButtonModule(unsigned int i2c_bus, unsigned int i2c_addr);
  void shutdown();
  void set_info_light(bool mode);
  void watch_for_events();
  void update_keybind(unsigned btn_id, void (*new_action)());

private:
  int m_pi;
  int m_handle;

  // Previous state of GPIOs
  int m_last_state_a;
  int m_last_state_b;

  unsigned char m_enc_state;

  std::array<void (*)(), 16> m_actions = {};
};

#endif
