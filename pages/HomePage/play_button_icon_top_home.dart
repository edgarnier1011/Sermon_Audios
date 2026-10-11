import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sermons_audio/resources/audio_resources.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';

class PlayButtonIconHome extends StatefulWidget {
  final String audioUrl;
  final String title;

  const PlayButtonIconHome({
    super.key,
    required this.audioUrl,
    required this.title,
  });

  @override
  State<PlayButtonIconHome> createState() => _PlayButtonIconHomeState();
}

class _PlayButtonIconHomeState extends State<PlayButtonIconHome>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  final AudioResources _player1 = locator.get<AudioResources>();
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation = Tween<double>(begin: 1.0, end: 1.2).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: locator.get<LocalData>().audioPlayerHomeLoaded,
        builder: (context, value, __) {
          if (widget.audioUrl != value || value.isEmpty) {
            return IconButton(
              // When button Pressed, togglePlay function is triggered.
              onPressed: togglePlay,
              iconSize: 42,
              icon: Icon(
                isPlaying ? Icons.play_arrow : Icons.play_circle,
                color: Colors.white,
              ),
            ).animate(target: isPlaying ? 1 : 0).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2),
                  duration: 300.ms,
                );
          } else {
            return Icon(
              Icons.play_circle_fill_sharp,
              color: Colors.red,
              size: 44,
            )
                .animate(
                  target: isPlaying ? 1 : 0,
                  // autoPlay: true,
                  onComplete: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(0.8, 0.8),
                  duration: 500.ms,
                );
          }
        });
  }

  // togglePlay function to stop the current audio and load the new audio from the url and set the title in the local data
  Future<void> togglePlay() async {
    await _player1.player.stop();
    await _player1.player.clearAudioSources();
    debugPrint('Section C');

    locator.get<LocalData>().setaudioPlayerHomeLoaded(widget.audioUrl);
    locator.get<LocalData>().setaudioPlayerHomeLoadedTitle(widget.title);

    isPlaying = !isPlaying;
  }

  Future<void> animationTesting() async {
    await controller.reverse();
    await controller.forward();
  }
}
