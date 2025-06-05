#include "atomiccommand.h"

AtomicCommand::AtomicCommand(QObject *parent)
    : QObject{parent}
{
    qInfo() << "Starting Atomic Command";
}
