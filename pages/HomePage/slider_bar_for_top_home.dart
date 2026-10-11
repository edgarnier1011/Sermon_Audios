import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sermons_audio/resources/audio_resources.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';

class SliderBarForTopHome extends StatefulWidget {
  const SliderBarForTopHome({super.key});

  @override
  State<SliderBarForTopHome> createState() => _SliderBarForTopHomeState();
}

class _SliderBarForTopHomeState extends State<SliderBarForTopHome> {
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final AudioResources _player1 = locator.get<AudioResources>();
  late StreamSubscription<Duration> _positionSubscription;
  late StreamSubscription<Duration?> _durationSubscription;
  //late StreamSubscription<Duration> _streamSubscriptionEnded;

  @override
  void dispose() {
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    //_streamSubscriptionEnded.cancel();
    //_positionSubscription.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _positionSubscription =
        locator.get<AudioResources>().player.positionStream.listen((event) {
      if (_player1.player.duration == null) return;
      if (_player1.player.duration!.inSeconds == event.inSeconds) {
        debugPrint("Audio completed");
        resetAudioPositionWhenFinished();
        if (context.mounted) {
          //resetAudioPositionWhenFinished();
          setState(() {
            _position = Duration.zero;
            // _player1.player.stop();
            // _player1.player.seek(Duration.zero);
          });
        }
        // else {
        //   if (context.mounted) {
        //     setState(() {
        //       _position = event;
        //     });
        //   }
        // }
        // }
      } else {
        if (context.mounted) {
          setState(() {
            _position = event;
          });
        }
      }
    });
    //FIXED, DOES NOT CHANGE
    _durationSubscription =
        locator.get<AudioResources>().player.durationStream.listen((event) {
      if (event != null) {
        if (_player1.player.playing) {
          if (context.mounted) {
            setState(() {
              _duration = event;
            });
          }
        }
      }
    });

    // _player1.player.playingStream.listen((playing) {
    //   setState(() {
    //     if (!playing) {
    //       debugPrint("Audio paused or stopped");
    //       setState(() {
    //         _position = _player1.player.position;
    //       });
    //       // _position = _player1.player.position;
    //     }
    //   });
    // });

    // locator.get<AudioResources>().player.positionStream.listen((event) {
    //   if (_player1.player.duration!.inSeconds == event.inSeconds) {
    //     debugPrint("Audio completed");
    //     // setState(() {
    //     //   _playing = false;
    //     // });
    //   }
    // });

    // _streamSubscriptionEnded =
    // locator.get<AudioResources>().player.positionStream.listen((event) {
    //   if (_player1.player.duration == null) return;
    //   if (_player1.player.duration!.inSeconds == event.inSeconds) {
    //     debugPrint("Audio completed");

    //     resetAudioPositionWhenFinished();
    //     setState(() {
    //       _position = Duration.zero;
    //       // _player1.player.pause();
    //     });
    //     //_streamSubscriptionEnded.pause();
    //     // _player1.player.stop();

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

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes);
    final seconds = twoDigits(d.inSeconds % 60);
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: locator.get<LocalData>().audioPlayerHomeLoaded,
        builder: (context, value, __) {
          if (value.isNotEmpty) {
            return FutureBuilder<void>(
                future: resetSlider(),
                builder: (context, asyncSnapshot) {
                  return Column(
                    children: [
                      Slider(
                        min: 0,
                        max: _duration.inSeconds.toDouble() == 0
                            ? 1
                            : _duration.inSeconds.toDouble(),
                        value: _position.inSeconds
                            .clamp(0, _duration.inSeconds)
                            .toDouble(),
                        onChanged: (value) async {
                          final position = Duration(seconds: value.toInt());
                          await _player1.player.seek(position);
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.white24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatTime(_position),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            formatTime(_duration),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  );
                });
          } else {
            return Slider(
              value: 0,
              min: 0,
              max: 0,
              onChanged: (value) {},
            );
          }
        });
  }

  Future<void> resetSlider() async {
    if (locator.get<AudioResources>().player.audioSource != null &&
        !locator.get<AudioResources>().player.playing) {
      if (_player1.player.bufferedPosition.inSeconds == 0) {
        // debugPrint("Audio stopped");
        // // await _player1.player.stop();
        // setState(() {
        //   _position = Duration.zero;
        //   _duration = Duration.zero;
        // });
      } else {
        debugPrint("Audio paused");
      }
      // } else {
      //   debugPrint("Audio stopped or changed");
      // }
      // _position = Duration.zero;
      // _duration = Duration.zero;
    }
  }

  Future<void> resetAudioPositionWhenFinished() async {
    await _player1.player.stop();
    await _player1.player.seek(Duration.zero);
    await _player1.player.stop();
  }
}
