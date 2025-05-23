#include <QAudioOutput>
#include <QDateTime>
#include <QMediaPlayer>
#include <QTimer>

#include "radio.h"

namespace PipOS {
Radio::Radio(QObject *parent)
    : QObject(parent), m_player(new QMediaPlayer(this)) {
  m_player->setAudioOutput(new QAudioOutput);

  watchdogTimer = new QTimer(this);

  connect(m_player, &QMediaPlayer::positionChanged, this,
          &Radio::positionChanged);
  connect(watchdogTimer, &QTimer::timeout, this, &Radio::checkPlayback);

  connect(m_player, &QMediaPlayer::playingChanged, this,
          &Radio::playingChanged);

  // connect(m_player, &QMediaPlayer::playingChanged, this,
  // &Radio::playingChanged);

  watchdogTimer->start(200);

  m_sfxRadioOn.setSource(QUrl("qrc:/sounds/radio_on.wav"));
  m_sfxRadioOff.setSource(QUrl("qrc:/sounds/radio_off.wav"));
}

// Called every time the track position moves
void Radio::positionChanged(qint64 pos) {
  lastPosition = pos;
  lastPositionUpdate = QDateTime::currentMSecsSinceEpoch();
}

// When the playing state of the radio changes, play sound effects
// void Radio::playingChanged(bool playing)
// {
//     if (playing)
//         m_sfxRadioOn.play();
//     else
//         m_sfxRadioOff.play();
// };

// Streaming OGG Vorbis seems to sometimes stick at the end of a song, this
// workaround checks for stalled media and restarts
void Radio::checkPlayback() {
  qint64 now = QDateTime::currentMSecsSinceEpoch();

  // If position hasn't changed for more than 1 seconds and we're supposed to be
  // playing
  if (now - lastPositionUpdate > 1000 &&
      m_player->playbackState() == QMediaPlayer::PlayingState) {
    emit playbackStalled();
    m_player->stop();
    m_player->setPosition(0);
    m_player->play();
  }
}
}; // namespace PipOS
