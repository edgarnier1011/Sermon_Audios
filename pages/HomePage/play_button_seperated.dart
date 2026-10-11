import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sermons_audio/resources/audio_resources.dart';
import 'package:sermons_audio/resources/global.dart';

class PlayButtonSeparated extends StatefulWidget {
  //final VoidCallback onPressed;
  //final bool isPlaying;

  const PlayButtonSeparated({super.key});

  @override
  State<PlayButtonSeparated> createState() => _PlayButtonSeparatedState();
}

class _PlayButtonSeparatedState extends State<PlayButtonSeparated> {
  bool isPlaying = true;
  final AudioResources _player1 = locator.get<AudioResources>();
  late final StreamSubscription<bool> _streamSubscriptionPlayerState;

  @override
  void initState() {
    super.initState();
    // Initialize the audio player and set up listeners if needed
    // For example, you can listen to the player's state to update the isPlaying variable
    _streamSubscriptionPlayerState =
        _player1.player.playingStream.listen((playing) {
      //if (_player1.player.position != _player1.player.duration) {
      //debugPrint("Audio playing state changed: $playing");
      if (context.mounted) {
        setState(() {
          isPlaying = playing;
        });
        //}
      }
    });

    // _streamSubscriptionEnded =
    // locator.get<AudioResources>().player.positionStream.listen((event) {
    //   if (_player1.player.duration == null) return;
    //   if (_player1.player.duration!.inSeconds == event.inSeconds) {
    //     debugPrint("Audio completed");

    //     // setState(() {
    //     //   //_player1.player.pause();
    //     //   isPlaying = false;
    //     // });

    //     // _player1.player.stop();
    //     //  _streamSubscriptionEnded.pause();

    //     // _player1.player.stop();
    //     // _player1.player.clearAudioSources();
    //   }
    //   //   if (_player1.player.duration!.inSeconds == 0) {
    //   //     debugPrint("Audio Stopped or started.");
    //   //     setState(() {
    //   //       isPlaying = false;
    //   //     });
    //   //         _player1.player.stop();
    //   // _player1.player.clearAudioSources();
    //   //   }
    // });
  }

  @override
  void dispose() {
    _streamSubscriptionPlayerState.cancel();
    // _streamSubscriptionEnded.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: togglePlay,
      iconSize: 36,
      icon: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        color: Colors.white,
      ).animate(target: isPlaying ? 1 : 0).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.2, 1.2),
            duration: 300.ms,
          ),
    );
  }

  Future<void> togglePlay() async {
    //_streamSubscriptionEnded.resume();
    // setState(() {
    //   // debugPrint('Toggled play state. Now isPlaying: $isPlaying');
    //   isPlaying = !isPlaying;
    // });
    // _player1.player.play();
    // _player1.player.pause();
    // _player1.player.stop();
    if (isPlaying) {
      setState(() {
        _player1.player.pause();
        isPlaying = false;
      });
    } else {
      //debugPrint(
      // 'Trying to play from paused state at position: ${_position.inSeconds} seconds');
      //currentPositionSeconds = _position.inSeconds;
      // await _player1.player.seek(Duration(seconds: currentPositionSeconds));
      setState(() {
        _player1.player.play();
        isPlaying = true;
      });
    }
    //if (!mounted) return;
    //debugPrint('Toggled play state. Now isPlaying: $isPlaying');

    // setState(() {
    //   // debugPrint('Toggled play state. Now isPlaying: $isPlaying');
    //   isPlaying = !isPlaying;
    // });
  }
}
