#pragma once

#include <QMediaPlayer>
#include <QObject>
#include <QSoundEffect>
#include <QTimer>

namespace PipOS {
class Radio : public QObject {
  Q_OBJECT
  Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged FINAL)
  Q_PROPERTY(bool playing READ playing NOTIFY playingChanged FINAL)

  public:
  explicit Radio(QObject *parent = nullptr);

  Q_INVOKABLE void play() { m_player->play(); }
  Q_INVOKABLE void stop() { m_player->stop(); }
  QUrl source() { return m_player->source(); };
  Q_INVOKABLE void setSource(const QUrl &url)
  {
      m_player->setSource(url);
      emit sourceChanged();
      if (url.isEmpty())
          m_sfxRadioOff.play();
      else
          m_sfxRadioOn.play();
  }
  bool playing() { return m_player->isPlaying(); };

  signals:
  void playbackStalled();
  void sourceChanged();
  void playingChanged(bool playing);

  public slots:
  void positionChanged(qint64 pos);
  void checkPlayback();
  // void playingChanged(bool playing);

  private:
  QMediaPlayer *m_player;

  qint64 lastPosition = 0;
  qint64 lastPositionUpdate = 0;
  QTimer *watchdogTimer;

  QSoundEffect m_sfxRadioOn;
  QSoundEffect m_sfxRadioOff;
};
}; // namespace PipOS
