#include "string.h"
#include "stdio.h"
#include <unistd.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdlib.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <signal.h>
#include <linux/input.h>
#include <linux/uinput.h>
#include <stdbool.h>

// Cribbed a lot of this from https://github.com/othermod/I2C-Linux-Gamepad-using-ADS1015-ADS1115-and-MCP23017

#define DIR_NONE 0x0 // No complete step yet.
#define DIR_CW 0x10  // Clockwise step.
#define DIR_CCW 0x20 // Anti-clockwise step.

#define R_START 0x0

#define R_CW_FINAL 0x1
#define R_CW_BEGIN 0x2
#define R_CW_NEXT 0x3
#define R_CCW_BEGIN 0x4
#define R_CCW_FINAL 0x5
#define R_CCW_NEXT 0x6

// Encoder state cribbed from https://github.com/buxtronix/arduino/tree/master/libraries/Rotary
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

uint8_t MCP_Buffer[2];

uint8_t previousEncoderState = R_START;
u_int8_t previousBankAState;

// specify addresses for expander
#define MCP_ADDR 0x20
#define I2C_BUS "/dev/i2c-11" // specify which I2C bus to use

#define PIPBOY_KEY_STAT KEY_F1
#define PIPBOY_KEY_ITEM KEY_F2
#define PIPBOY_KEY_DATA KEY_F3
#define PIPBOY_SCROLL_PRESS KEY_SPACE
#define PIPBOY_SCROLL_UP KEY_UP
#define PIPBOY_SCROLL_DOWN KEY_DOWN

int MCP_select(int file)
{
  // initialize the device
  if (ioctl(file, I2C_SLAVE, MCP_ADDR) < 0)
  {
    printf("Unable to communicate with the MCP23017\n");
    exit(1);
  }
}

void MCP_writeConfig(int file)
{
  MCP_Buffer[0] = 0x00; // GPIO direction register A
  MCP_Buffer[1] = 0xFF; // Set GPIO A
  write(file, MCP_Buffer, 2);
  MCP_Buffer[0] = 0x01; // GPIO direction register B
  MCP_Buffer[1] = 0xFF; // Set GPIO B
  write(file, MCP_Buffer, 2);
  MCP_Buffer[0] = 0x0C; // GPIO Pullup Register A
  MCP_Buffer[1] = 0xFF; // Enable Pullup
  write(file, MCP_Buffer, 2);
  MCP_Buffer[0] = 0x0D; // GPIO Pullup Register B
  MCP_Buffer[1] = 0xFF; // Enable Pullup
  if (write(file, MCP_Buffer, 2) != 2)
  {
    printf("MCP23017 was not detected at address 0x%X. Check wiring and try again.\n", MCP_ADDR);
    exit(1);
  }
}

void MCP_read(int file)
{
  MCP_Buffer[0] = 0x12;
  write(file, MCP_Buffer, 1); // prepare to read ports A and B
  // reading two bytes causes it to autoincrement to the next byte, so it reads port B
  if (read(file, MCP_Buffer, 2) != 2)
  {
    printf("Unable to communicate with the MCP23017\n");
    MCP_Buffer[0] = 0xFF;
    MCP_Buffer[1] = 0xFF;
    sleep(1);
  }
}

int createGamepad()
{
  int fd;
  fd = open("/dev/uinput", O_WRONLY | O_NDELAY);
  if (fd < 0)
  {
    fprintf(stderr, "Unable to create gamepad with uinput. Try running as sudo.\n");
    exit(1);
  }

  // device structure
  // struct uinput_user_dev uidev;
  struct uinput_setup usetup;
  memset(&usetup, 0, sizeof(usetup));

  // init event
  ioctl(fd, UI_SET_EVBIT, EV_KEY);
  // ioctl(fd, UI_SET_EVBIT, EV_REL);

  // ioctl(fd, UI_SET_RELBIT, REL_DIAL);    // Dial twist
  ioctl(fd, UI_SET_KEYBIT, PIPBOY_SCROLL_PRESS); // Dial press

  ioctl(fd, UI_SET_KEYBIT, PIPBOY_SCROLL_UP);
  ioctl(fd, UI_SET_KEYBIT, PIPBOY_SCROLL_DOWN);

  ioctl(fd, UI_SET_KEYBIT, PIPBOY_KEY_STAT); // STAT
  ioctl(fd, UI_SET_KEYBIT, PIPBOY_KEY_ITEM); // ITEM
  ioctl(fd, UI_SET_KEYBIT, PIPBOY_KEY_DATA); // DATA

  snprintf(usetup.name, UINPUT_MAX_NAME_SIZE, "PipBoy Control Board");
  usetup.id.bustype = BUS_USB;
  usetup.id.vendor = 0x1234;  /* sample vendor */
  usetup.id.product = 0x5678; /* sample product */
  // usetup.id.version = 1;

  ioctl(fd, UI_DEV_SETUP, &usetup);
  if (ioctl(fd, UI_DEV_CREATE))
  {
    fprintf(stderr, "Error while creating uinput device!\n");
    exit(1);
  }
  return fd;
}

void emit(int virtualGamepad, int type, int code, int val)
{
  struct input_event ie;
  ie.type = type;
  ie.code = code;
  ie.value = val;
  /* timestamp values below are ignored */
  ie.time.tv_sec = 0;
  ie.time.tv_usec = 0;
  write(virtualGamepad, &ie, sizeof(ie));
}

bool pinState(uint8_t state, int pin)
{
  return (state >> pin) & 1;
}

int main(int argc, char *argv[])
{
  // create uinput device
  int virtualGamepad = createGamepad();

  // open the i2c bus
  int file;
  if ((file = open(I2C_BUS, O_RDWR)) < 0)
  {
    perror("Failed to open the bus.");
    return EXIT_FAILURE;
  }

  MCP_select(file);
  MCP_writeConfig(file);
  MCP_read(file);

  while (1)
  {
    MCP_select(file);
    MCP_read(file);

    u_int8_t bankA = ~MCP_Buffer[0];
    u_int8_t bankB = ~MCP_Buffer[1]; // Extra ports on board, not currently in use

    // Work out rotary encoder state
    unsigned char encoderState = (pinState(bankA, 4) << 1) | pinState(bankA, 5);
    previousEncoderState = ttable[previousEncoderState & 0xf][encoderState];
    unsigned char result = previousEncoderState & 0x30;

    // Emit events for rotary encoder state
    switch (result)
    {
    case DIR_CW:
      emit(virtualGamepad, EV_KEY, PIPBOY_SCROLL_UP, 1);
      // emit(virtualGamepad, EV_REL, REL_DIAL, 1);
      break;

    case DIR_CCW:
      emit(virtualGamepad, EV_KEY, PIPBOY_SCROLL_DOWN, 1);
      // emit(virtualGamepad, EV_REL, REL_DIAL, -1);
      break;

    default:
      emit(virtualGamepad, EV_KEY, PIPBOY_SCROLL_UP, 0);
      emit(virtualGamepad, EV_KEY, PIPBOY_SCROLL_DOWN, 0);
    }

    emit(virtualGamepad, EV_KEY, PIPBOY_SCROLL_PRESS, pinState(bankA, 0));
    emit(virtualGamepad, EV_KEY, PIPBOY_KEY_STAT, pinState(bankA, 1));
    emit(virtualGamepad, EV_KEY, PIPBOY_KEY_ITEM, pinState(bankA, 2));
    emit(virtualGamepad, EV_KEY, PIPBOY_KEY_DATA, pinState(bankA, 3));

    // Submit report
    if (previousBankAState != bankA)
    {
      emit(virtualGamepad, EV_SYN, SYN_REPORT, 0);
    }

    previousBankAState = bankA;

    usleep(1000);
  }

  return 0;
}
