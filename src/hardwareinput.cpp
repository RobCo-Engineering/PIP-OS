#include "hardwareinput.h"

namespace PipOS {
InputWatcher::InputWatcher(QObject *parent)
    : QObject{parent}
{}

void InputWatcher::watchForEvents()
{
    emit inputEvent();
}

HardwareInput::HardwareInput(QObject *parent)
    : QObject{parent}
{
    InputWatcher *watcher = new InputWatcher;
    watcher->moveToThread(&inputThread);
    connect(&inputThread, &QThread::finished, watcher, &QObject::deleteLater);
    connect(this, &HardwareInput::operate, watcher, &InputWatcher::watchForEvents);
    connect(watcher, &InputWatcher::inputEvent, this, &HardwareInput::handleEvents);
    inputThread.start();
}

void HardwareInput::handleEvents() {}
} // namespace PipOS
