#include "holotape.h"

namespace PipOS {
HolotapeProvider::HolotapeProvider(QObject *parent)
    : QObject{parent}
{
    // Example emit, this would map to NTAG ID's or something eventually
    // emit holotapeLoaded("AtomicCommand");
}

} // namespace PipOS
