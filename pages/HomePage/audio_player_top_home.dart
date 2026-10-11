import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:sermons_audio/pages/HomePage/audio_player-top_home_placeholder.dart';
import 'package:sermons_audio/pages/HomePage/play_button_seperated.dart';
import 'package:sermons_audio/pages/HomePage/slider_bar_for_top_home.dart';
import 'package:sermons_audio/resources/audio_resources.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'dart:io';

class SimpleAudioPlayer extends StatefulWidget {
  final String title;
  final String audioUrl;

  const SimpleAudioPlayer({
    super.key,
    required this.title,
    required this.audioUrl,
  });

  @override
  State<SimpleAudioPlayer> createState() => _SimpleAudioPlayerState();
}

class _SimpleAudioPlayerState extends State<SimpleAudioPlayer> {
  final AudioResources _player1 = locator.get<AudioResources>();

  File? _cachedFile;

  bool isPlaying = true;

  static final _cache = DefaultCacheManager();

  String pathOfCachedFile = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> togglePlay() async {
    if (isPlaying) {
      setState(() {
        _player1.player.pause();
        isPlaying = false;
      });
    } else {
      setState(() {
        _player1.player.play();
        isPlaying = true;
      });
    }
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes);
    final seconds = twoDigits(d.inSeconds % 60);
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<String>(
            valueListenable: locator.get<LocalData>().audioPlayerHomeLoaded,
            builder: (context, value, _) {
              debugPrint('Section A');

              if (value.isNotEmpty) {
                return FutureBuilder<void>(
                    future: _setAudio(
                        locator.get<LocalData>().audioPlayerHomeLoaded.value),
                    builder: (context, asyncSnapshot) {
                      debugPrint('Section B');
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.done) {
                        return Column(
                          children: [
                            // Title
                            Text(
                              locator
                                  .get<LocalData>()
                                  .audioPlayerHomeLoadedTitle
                                  .value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Controls
                            Row(
                              children: [
                                PlayButtonSeparated(),
                                Expanded(child: SliderBarForTopHome()),
                              ],
                            ),
                          ],
                        );
                      } else if (asyncSnapshot.hasError) {
                        return const AudioPlayerPlaceholder(
                            title: "Error loading audio");
                      } else {
                        return const AudioPlayerPlaceholder(
                            title: "No audio selected");
                      }
                    });
              } else {
                return const AudioPlayerPlaceholder(title: "No audio selected");
              }
            }),
      ),
    );
  }

  Future<void> _setAudio(String audiourl) async {
    if (_player1.player.audioSource == null) {
      try {
        _cachedFile = await _cache.getSingleFile(audiourl);

        DateTime now = DateTime.now();
        String formattedDateTime =
            "${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}";
        String newFileName = "cached_audio_$formattedDateTime.mp3";
        _cachedFile =
            await _cachedFile!.copy('${_cachedFile!.parent.path}/$newFileName');

        debugPrint("Called again to set audio source");
        await _player1.player.setAudioSource(AudioSource.file(
          _cachedFile!.path,
          tag: MediaItem(
            // Specify a unique ID for each media item:
            id: '1',
            // Metadata to display in the notification:
            album: locator.get<LocalData>().audioPlayerHomeLoadedTitle.value,
            title: "Sermon Audios",

            // artUri: Uri.parse('https://example.com/albumart.jpg'),
          ),
        ));

        _player1.player.play();
      } catch (e) {
        debugPrint("Error setting audio source: $e");
      }
    } else {}
  }
}
