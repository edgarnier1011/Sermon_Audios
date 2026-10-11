import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as temp;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:sermons_audio/pages/SermonPage/PageUI/PageUI/like_audio_button.dart';
import 'package:sermons_audio/pages/SermonPage/PageUI/PageUI/narrator_list.dart';
import 'package:sermons_audio/resources/audio_resources.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';

class AudioComponents extends StatefulWidget {
  final String textid;
  final String audioUrl;
  final String audioId;
  final String narratorid;
  final String title;
  const AudioComponents(
      {required this.title,
      required this.textid,
      required this.narratorid,
      required this.audioId,
      required this.audioUrl,
      super.key});

  @override
  State<AudioComponents> createState() {
    return _AudioComponents();
  }
}

class _AudioComponents extends State<AudioComponents>
    with AutomaticKeepAliveClientMixin {
  AudioResources tempPlayer = locator.get<AudioResources>();

  //StreamSubscription<bool>? theListener;
  final TextEditingController reportController = TextEditingController();
  Future<bool>? doneLoading;

  @override
  void dispose() {
    super.dispose();
    //theListener!.cancel();
    reportController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder(
              future: _setAudio(),
              builder: (context, AsyncSnapshot<bool> snapshot) {
                debugPrint('rebuilded');
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return LoadAudio(
                      audioUrl: widget.audioUrl,
                    );
                  } else {
                    return const Text('Error loading audio)');
                  }
                } else if (snapshot.hasError) {
                  return const Text('Error loading audio)');
                } else {
                  return const Text('Loading...');
                }
              }),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Align(
          //       alignment: Alignment.centerLeft,
          //       child: (AuthMethods().uid.isNotEmpty)
          //           ? LikeAudio(
          //               title: widget.title,
          //               textid: widget.textid,
          //               audioid: widget.audioId,
          //               narratorid: widget.narratorid,
          //             )
          //           : const SizedBox()),
          // ),
          // Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: GestureDetector(
          //       child: const Row(
          //         children: [
          //           Icon(
          //             Icons.person,
          //             color: Colors.blueGrey,
          //           ),
          //           Icon(Icons.thumb_up_sharp, color: Colors.blueGrey)
          //         ],
          //       ),
          //       onTap: () => showModalBottomSheet(
          //           constraints: BoxConstraints(
          //               minWidth: locator
          //                   .get<ScreenDimensions>()
          //                   .getDimensions(context)
          //                   .size
          //                   .width),
          //           context: context,
          //           builder: (context) => Material(
          //                 child: AudioLikesList(
          //                     audioid: widget.audioId, textid: widget.textid),
          //               )),
          //     )),
          AuthMethods().uid.isNotEmpty
              ? IconButton(
                  onPressed: () => showModalBottomSheet(
                      backgroundColor: Colors.blueGrey,
                      context: context,
                      builder: (context) => Material(
                            color: Colors.blueGrey,
                            child: AlertDialog(
                              backgroundColor: Colors.black.withOpacity(0.4),
                              title: const Text(
                                'Report Audio',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: const Text(
                                'Note: All texts and audios are reviewd by administrator for approval. If you found something on the audio that seems to go against our user agreement policy, located in your profile menu, please let us known in the text box.',
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                        onTap: () async {
                                          bool checkif =
                                              await alreadyReportedAudio(
                                                  widget.audioId);
                                          if (!checkif) {
                                            await FirestoreService.instance
                                                .addDocument(
                                                    path: FirestorePath
                                                        .audioReports(),
                                                    data: {
                                                  'userid': AuthMethods().uid,
                                                  'audioid': widget.audioId,
                                                });
                                          } else {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'You have already submitted a report for this text')));
                                            }
                                          }
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text('Confirm')),
                                    GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: const Text('Cancel')),
                                  ],
                                ),
                              ],
                            ),
                          )),
                  icon: Icon(
                    color: Colors.red.withOpacity(0.8),
                    Icons.flag,
                    size: 20,
                  ))
              : const SizedBox()
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<bool> _setAudio() async {
    try {
      await tempPlayer.player.setAudioSource(AudioSource.uri(
        Uri.parse(widget.audioUrl),
        tag: const MediaItem(
          // Specify a unique ID for each media item:
          id: '1',
          // Metadata to display in the notification:
          album: "Album name",
          title: "Sermon Audios",
          // artUri: Uri.parse('https://example.com/albumart.jpg'),
        ),
      ));
      return true;
    } catch (e) {
      return false;
    }
  }
}

//for when visiting audio from use profile
class AudioComponentsFromProfile extends StatefulWidget {
  final String audioid;
  final String narratorid;
  final String audioUrl;
  final String textid;
  final bool recordMenu;
  final String title;
  const AudioComponentsFromProfile(
      {required this.title,
      required this.textid,
      required this.narratorid,
      required this.audioid,
      required this.audioUrl,
      this.recordMenu = false,
      super.key});

  @override
  State<AudioComponentsFromProfile> createState() {
    return _AudioComponentsFromProfile();
  }
}

class _AudioComponentsFromProfile extends State<AudioComponentsFromProfile>
    with WidgetsBindingObserver {
  temp.AudioPlayer tempPlayer = temp.AudioPlayer();
  bool _playing = false;
  StreamSubscription<bool>? theListener;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        if (tempPlayer.state == temp.PlayerState.playing) {
          tempPlayer.stop();
        }
        break;
      case AppLifecycleState.detached:
        break;

      case AppLifecycleState.resumed:
        break;

      case AppLifecycleState.hidden:
        if (tempPlayer.state == temp.PlayerState.playing) {
          tempPlayer.stop();
        }
        break;

      case AppLifecycleState.paused:
        if (tempPlayer.state == temp.PlayerState.playing) {
          tempPlayer.stop();
        }
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    theListener!.cancel();
    tempPlayer.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    theListener =
        locator.get<AudioResources>().player.playingStream.listen((event) {
      if (!event) {
        setState(() {
          _playing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !_playing
              ? IconButton(
                  icon: const Icon(
                    Icons.play_circle_fill_rounded,
                    size: 50,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () async {
                    await _setAudio();
                    bool check = await locator
                        .get<FirestoreMethods>()
                        .checkIfuserblocked(widget.narratorid);
                    if (!check) {
                      tempPlayer.play(tempPlayer.source!);
                    } else {
                      if (context.mounted) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('User Blocked'),
                                  content: const Text(
                                      'You have blocked the user, you cannot listen to the narration. To unblock user, visit his profile in the narrator profile section'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'))
                                  ],
                                ));
                      }
                    }
                  })
              : IconButton(
                  icon: const Icon(
                    Icons.pause_circle_filled_rounded,
                    size: 50,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {
                    tempPlayer.pause();
                    setState(() {
                      _playing = false;
                    });
                  }),
          !widget.recordMenu
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: LikeAudio(
                    title: widget.title,
                    textid: widget.textid,
                    audioid: widget.audioid,
                    narratorid: widget.narratorid,
                  ))
              : const SizedBox(
                  height: 1,
                ),
          !widget.recordMenu
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: const Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.blueGrey,
                        ),
                        Icon(Icons.thumb_up_sharp, color: Colors.blueGrey)
                      ],
                    ),
                    onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => Material(
                              child: AudioLikesList(
                                  audioid: widget.audioid,
                                  textid: widget.textid),
                            )),
                  ))
              : const SizedBox(
                  height: 1,
                ),
        ],
      ),
    );
  }

  Future _setAudio() async {
    tempPlayer.setSourceUrl(widget.audioUrl);

    //setState(() {
    // _playing = true;
    //});
  }
}

Future<bool> alreadyReportedAudio(String audioid) async {
  final snapshot = await FirestoreService.instance
      .collectionQuery(
          path: FirestorePath.textReports(),
          queryBuilder: (query) => query
              .where('textid', isEqualTo: audioid)
              .where('userid', isEqualTo: AuthMethods().uid))
      .get();

  if (snapshot.docs.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

class LoadAudio extends StatefulWidget {
  final String audioUrl;
  const LoadAudio({super.key, required this.audioUrl});

  @override
  State<LoadAudio> createState() => _LoadAudio();
}

class _LoadAudio extends State<LoadAudio> {
  AudioResources tempPlayer = locator.get<AudioResources>();

  bool _playing = false;
  StreamSubscription<bool>? theListener;

  @override
  void initState() {
    super.initState();

    theListener =
        locator.get<AudioResources>().player.playingStream.listen((event) {
      if (!event) {
        setState(() {
          _playing = false;
        });
      }
    });

    locator.get<AudioResources>().player.positionStream.listen((event) {
      if (tempPlayer.player.duration!.inSeconds == event.inSeconds) {
        tempPlayer.player.stop();
        setState(() {
          _playing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    theListener!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: locator.get<LocalData>().changesettings,
        builder: (context, theValue, __) {
          return SizedBox(
            width: 300,
            child: Column(
              children: [
                const Row(
                  children: [],
                ),
                !_playing
                    ? GestureDetector(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Listen Narration',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        onTap: () {
                          if (locator.get<LocalData>().globalaudio != null) {
                            if (locator.get<LocalData>().globalaudio!.state ==
                                temp.PlayerState.playing) {
                              locator.get<LocalData>().globalaudio!.stop();
                            }
                          }
                          tempPlayer.player.play();
                          setState(() {
                            _playing = true;
                            //  tempPlayer.player.play();
                          });
                        })
                    : GestureDetector(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Stop Narration',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        onTap: () {
                          tempPlayer.player.pause();
                          setState(() {
                            _playing = false;
                          });
                        },
                      )
              ],
            ),
          );
        });
  }
}
