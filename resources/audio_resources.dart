import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart' as ja;

class AudioResources {
  final ja.AudioPlayer player = ja.AudioPlayer();

  AudioResources() {
    functe();
  }

  void functe() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _handleInterruptions(session);
  }

  void _handleInterruptions(AudioSession audioSession) {
    // just_audio can handle interruptions for us, but we have disabled that in
    // order to demonstrate manual configuration.
    bool playInterrupted = false;
    audioSession.becomingNoisyEventStream.listen((_) {
      player.pause();
    });
    player.playingStream.listen((playing) {
      playInterrupted = false;
      if (playing) {
        audioSession.setActive(true);
      }
    });
    audioSession.interruptionEventStream.listen((event) {
      //If the event has begun, checks the interruption type and performs the corresponding action.
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes!.usage ==
                AndroidAudioUsage.game) {
              player.setVolume(player.volume / 2);
            }
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (player.playing) {
              player.pause();
              playInterrupted = true;
            }
            break;
        }
        //If the event has ended, checks the interruption type and performs the corresponding action.
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            player.pause();
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            if (playInterrupted) player.play();
            playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            playInterrupted = false;
            break;
        }
      }
    });
    audioSession.devicesChangedEventStream.listen((event) {});
  }
}
