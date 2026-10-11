import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sermons_audio/models/audio_model.dart';
import 'package:sermons_audio/models/sermon_model.dart';
import 'package:sermons_audio/pages/SermonPage/PageUI/PageUI/sermon_page.dart';
import 'package:sermons_audio/resources/audio_resources.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:shimmer/shimmer.dart';

//This class returns a list of audio snippets from the database.
class SermonHorizontal extends StatefulWidget {
  const SermonHorizontal({super.key});

  @override
  State<SermonHorizontal> createState() {
    return _SermonHorizontal();
  }
}

class _SermonHorizontal extends State<SermonHorizontal> {
  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      pageSize: 4,
      scrollDirection: Axis.horizontal,
      query: FirestoreService.instance.collectionQuery(
          path: FirestorePath.audioaddSample(),
          queryBuilder: (query) {
            return query;
          }),
      itemBuilder: (context, snapshot) {
        AudioCreate model =
            AudioCreate.fromsnap(snapshot.data() as Map<String, dynamic>);
        if (model.approval) {
          return FutureBuilder(
              future: locator
                  .get<FirestoreMethods>()
                  .checkIfuserblocked(model.userid),
              builder: (context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data! == false) {
                    return AudioHomePageHorizontal(
                        textid: model.textid,
                        nameofAuthor: model.nameofAuthor,
                        narratorName: model.nameOfnarrator,
                        urlaudio: model.urlfromstorage);
                  } else {
                    return const SizedBox();
                  }
                } else if (snapshot.hasError) {
                  return Container(
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.4)),
                      child: const Text('Error loading audio'));
                } else {
                  return SizedBox(
                    height: 200,
                    width: 200,
                    child: Shimmer.fromColors(
                        baseColor: Colors.black.withOpacity(0.4),
                        highlightColor: Colors.blueGrey,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4)),
                          height: 200,
                          width: 200,
                        )),
                  );
                }
              });
        } else {
          return const SizedBox();
        }
      },
      emptyBuilder: (context) => const Text('Nothing to Show',
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }
}

//This class configures how the data will be displayed for the audio snippets.
class AudioHomePageHorizontal extends StatefulWidget {
  final String nameofAuthor;
  final String urlaudio;
  final String narratorName;
  final String textid;
  const AudioHomePageHorizontal(
      {required this.textid,
      required this.nameofAuthor,
      required this.narratorName,
      required this.urlaudio,
      super.key});

  @override
  State<AudioHomePageHorizontal> createState() {
    return _AudioHomePageHorizontal();
  }
}

class _AudioHomePageHorizontal extends State<AudioHomePageHorizontal>
    with WidgetsBindingObserver {
  AudioPlayer? _theAudiosample;
  Uint8List? portionaudio;
  bool isplaying = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        if (_theAudiosample != null) {
          locator.get<LocalData>().resetinitializeAudio();
        }
        break;
      case AppLifecycleState.detached:
        break;

      case AppLifecycleState.resumed:
        break;

      case AppLifecycleState.hidden:
        if (_theAudiosample != null) {
          locator.get<LocalData>().resetinitializeAudio();
        }
        break;

      case AppLifecycleState.paused:
        if (_theAudiosample != null) {
          locator.get<LocalData>().resetinitializeAudio();
        }
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_theAudiosample != null) {
      locator.get<LocalData>().resetinitializeAudio();
    }
    if (locator.get<AudioResources>().player.playing) {
      locator.get<AudioResources>().player.stop();
    }
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: Colors.black.withOpacity(0.4)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayName(widget.nameofAuthor),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  displayName(widget.narratorName),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
        !isplaying
            ? IconButton(
                icon: const Icon(
                  Icons.play_circle,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (locator.get<LocalData>().globalaudio != null) {
                    if (locator.get<LocalData>().globalaudio!.state ==
                        PlayerState.playing) {
                      locator.get<LocalData>().globalaudio!.stop();
                    }
                  }
                  setState(() {
                    isplaying = !isplaying;
                    locator.get<LocalData>().setglobalaudio();
                    _theAudiosample = locator.get<LocalData>().globalaudio;

                    if (locator.get<AudioResources>().player.playing) {
                      locator.get<AudioResources>().player.stop();
                    }
                    _theAudiosample!.setSourceUrl(widget.urlaudio);
                    _theAudiosample!.play(_theAudiosample!.source!);
                  });
                })
            : FutureBuilder(
                future: DocumentParagraphs.fromId(widget.textid),
                builder: (context, AsyncSnapshot<DocumentParagraphs> snap) {
                  if (snap.hasData) {
                    return ElevatedButton(
                        onPressed: () => pushScreenWithoutNavBar(
                              context,
                              Material(
                                child: SermonPageFinal(
                                    alldataofsermon: snap.data!),
                              ),
                            ),
                        child: const Text(
                          'Visit Text',
                        ));
                  } else if (snap.hasError) {
                    return const Text('Error on audio horizontal',
                        style: TextStyle(color: Colors.white));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
      ],
    );
  }
}

String displayName(String nameFromdatabase) {
  String finalString = '';
  List<String> tokensname = nameFromdatabase.split(' ');
  for (int i = 0; i < tokensname.length; i++) {
    finalString =
        '$finalString${tokensname[i][0].toUpperCase()}${tokensname[i].substring(1)} ';
  }

  return finalString.trimRight();
}
