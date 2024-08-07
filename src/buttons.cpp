#include "buttons.h"
#include "pigpio.h"
#include "pigpiod_if2.h"
#include <chrono>
#include <iostream>
#include <thread>

typedef unsigned int uint;

// Set bit <n> in <number> either high or low <x>
inline uint bit_set_to(uint number, uint n, bool x) {
  return (number & ~((uint)1 << n)) | ((uint)x << n);
}

// Check if bit <v> is set in <number>
inline bool bit_check(uint number, uint n) { return (number >> n) & (uint)1; }

// Given <last> state and <current> state, check if <bit> has changed. When <rising_edge> is set,
// only returns true if the bit is high in <current> and was low in <last>.
inline bool bit_state_changed(uint last, uint current, uint bit, bool rising_edge) {
  bool a = bit_check(last, bit);
  bool b = bit_check(current, bit);
  return a != b && b == rising_edge;
}

PipBoyButtonModule::PipBoyButtonModule(unsigned int i2c_bus, unsigned int i2c_addr) {
  // IP address of remote GPIO can be set via PIGPIO_ADDR and PIGPIO_PORT, port defaults to 8888
  m_pi = pigpio_start(NULL, NULL);
  if (m_pi < 0) {
    throw std::runtime_error("Failed to connect");
  }

  m_handle = i2c_open(m_pi, i2c_bus, i2c_addr, 0);
  if (m_handle < 0) {
    throw std::runtime_error("Unable to open connection");
  }

  std::cout << "Setting up PipBoy module pins" << std::endl;

  // LED pin set as output, the rest are input
  i2c_write_byte_data(m_pi, m_handle, IODIRA, 0b01111111);

  // All input pins have internal pull-ups enabled
  i2c_write_byte_data(m_pi, m_handle, GPPUA, 0b111111);

  // All input pins set high
  i2c_write_byte_data(m_pi, m_handle, OLATA, 0b111111);

  // All input are inverted
  i2c_write_byte_data(m_pi, m_handle, IPOLA, 0b111111);

  m_enc_state = R_START;
}

void PipBoyButtonModule::shutdown() {
  set_info_light(false);
  pigpio_stop(m_pi);
}

/* Toggle on/off the 'INFO' light on the board */
void PipBoyButtonModule::set_info_light(bool mode) {
  int before = i2c_read_byte_data(m_pi, m_handle, OLATA);
  i2c_write_byte_data(m_pi, m_handle, OLATA, bit_set_to(before, INFO_LED, mode));
}

void PipBoyButtonModule::watch_for_events() {
  while (true) {
    int state = i2c_read_byte_data(m_pi, m_handle, GPIOA);

    if (state >= 0) {
      unsigned char enc_state = (bit_check(state, ENC_CW) << 1) | bit_check(state, ENC_CCW);
      unsigned char last_enc_state =
          (bit_check(m_last_state_a, ENC_CW) << 1) | bit_check(m_last_state_a, ENC_CCW);

      if (enc_state != last_enc_state) {
        m_enc_state = ttable[m_enc_state & 0xf][enc_state];

        switch (m_enc_state) {
        case R_CW_FINAL:
          if (m_actions[ENC_CW])
            m_actions[ENC_CW]();
          break;

        case R_CCW_FINAL:
          if (m_actions[ENC_CCW])
            m_actions[ENC_CCW]();
        }
      }

      if (state != m_last_state_a) {
        // std::cout << "event = \t" << std::bitset<8>(state) << std::endl;

        // Handle switches, all button presses are on pins < 5
        for (size_t i = 0; i < 4; i++) {
          if (bit_state_changed(m_last_state_a, state, i, true) && m_actions[i] != nullptr) {
            m_actions[i]();
          }
        }
      }

      m_last_state_a = state;
    } else {
      // If the state read less than 0 then it was an i2c read error
      switch (state) {
      case PI_BAD_HANDLE:
        std::cout << "ReadError: Bad Handle" << std::endl;
        break;

      case PI_BAD_PARAM:
        std::cout << "ReadError: Bad Param" << std::endl;
        break;

      case PI_I2C_READ_FAILED:
        std::cout << "ReadError: I2C Read Failure" << std::endl;
        break;
      }
    }

    std::this_thread::sleep_for(std::chrono::milliseconds(1));
  }
}

// Registers a callback function for a given key press
void PipBoyButtonModule::update_keybind(unsigned btn_id, void (*new_action)()) {
  m_actions[btn_id] = new_action;
}
