import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sermons_audio/models/audio_model.dart';
import 'package:sermons_audio/models/user_model.dart';
import 'package:sermons_audio/pages/ProfilePage/user_profile_visitor.dart';
import 'package:sermons_audio/resources/audio_resources.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';

class NarratorList extends StatefulWidget {
  final String textid;

  const NarratorList({required this.textid, super.key});
  @override
  State<NarratorList> createState() {
    return _NarratorList();
  }
}

class _NarratorList extends State<NarratorList> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ValueListenableBuilder(
          valueListenable: locator.get<LocalData>().changesettings,
          builder: (context, theValue, __) {
            return DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: locator.get<LocalData>().themeColorspallete[
                        locator.get<LocalData>().currentColorTheme],
                    stops: const [0.0, 0.15, 0.60, 1.0]),
              ),
              child: Column(
                children: [
                  const Text(
                    'Narrator List',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Expanded(
                      child: FirestoreListView(
                    query: FirestoreService.instance.collectionQuery(
                        path: FirestorePath.audioadd(),
                        queryBuilder: (query) {
                          return !kIsWeb
                              ? query
                                  .where('textid', isEqualTo: widget.textid)
                                  .orderBy('datesubmit')
                              : query.where('textid', isEqualTo: widget.textid);
                        }),
                    itemBuilder: (context, snapshot) {
                      AudioCreate model = AudioCreate.fromsnap(
                          snapshot.data() as Map<String, dynamic>);

                      return GestureDetector(
                          onTap: () {
                            locator.get<AudioResources>().player.stop();

                            locator.get<LocalData>().changesermonpagecomponents(
                                [model.urlfromstorage, model.userid, model.id]);

                            Navigator.pop(context);
                          },
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4)),
                              child: Text(
                                displayName(model.nameOfnarrator),
                                style: const TextStyle(color: Colors.white),
                              )));
                    },
                    emptyBuilder: (context) => const Text('Nothing to Show',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ))
                ],
              ),
            );
          }),
    );
  }
}

class TextLikesList extends StatefulWidget {
  final String textid;

  const TextLikesList({required this.textid, super.key});
  @override
  State<TextLikesList> createState() {
    return _TextLikesList();
  }
}

class _TextLikesList extends State<TextLikesList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: locator.get<LocalData>().changesettings,
        builder: (context, theValue, __) {
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: locator.get<LocalData>().themeColorspallete[
                      locator.get<LocalData>().currentColorTheme],
                  stops: const [0.0, 0.15, 0.60, 1.0]),
            ),
            child: Column(
              children: [
                const Text(
                  "List",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Expanded(
                    child: FirestoreListView(
                  query: FirestoreService.instance.collectionQuery(
                      path: FirestorePath.likes(),
                      queryBuilder: (query) {
                        return !kIsWeb
                            ? query
                                .where('textid', isEqualTo: widget.textid)
                                .orderBy('dateLiked')
                            : query.where('textid', isEqualTo: widget.textid);
                      }),
                  itemBuilder: (context, snapshot) {
                    return FutureBuilder(
                        future: Theuser.fromId(snapshot.get('likedby')),
                        builder:
                            (context, AsyncSnapshot<Theuser> snapshotUser) {
                          if (snapshotUser.hasData) {
                            return GestureDetector(
                                onTap: () {
                                  pushScreenWithoutNavBar(
                                    context,
                                    UserProfileV(
                                        previous: '',
                                        userData: snapshotUser.data!,
                                        showappBar: true),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.4)),
                                      child: Text(
                                        displayName(snapshotUser.data!.name),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )),
                                ));
                          } else if (snapshotUser.hasError) {
                            return const Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 50,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Not Available',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        });
                  },
                  emptyBuilder: (context) => const Text('Nothing to Show',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ))
              ],
            ),
          );
        });
  }
}

class AudioLikesList extends StatefulWidget {
  final String textid;
  final String audioid;

  const AudioLikesList(
      {required this.audioid, required this.textid, super.key});
  @override
  State<AudioLikesList> createState() {
    return _AudioLikesList();
  }
}

class _AudioLikesList extends State<AudioLikesList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: locator.get<LocalData>().changesettings,
        builder: (context, theValue, __) {
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: locator.get<LocalData>().themeColorspallete[
                      locator.get<LocalData>().currentColorTheme],
                  stops: const [0.0, 0.15, 0.60, 1.0]),
            ),
            child: Column(
              children: [
                const Text(
                  "List",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Expanded(
                    child: FirestoreListView(
                  query: FirestoreService.instance.collectionQuery(
                      path: FirestorePath.audiolikes(),
                      queryBuilder: (query) {
                        return query
                            .where('textid', isEqualTo: widget.textid)
                            .where('audioid', isEqualTo: widget.audioid);
                      }),
                  itemBuilder: (context, snapshot) {
                    return FutureBuilder(
                        future: Theuser.fromId(snapshot.get('likedby')),
                        builder:
                            (context, AsyncSnapshot<Theuser> snapshotUser) {
                          if (snapshotUser.hasData) {
                            return GestureDetector(
                                onTap: () {
                                  pushScreenWithoutNavBar(
                                    context,
                                    UserProfileV(
                                        previous: '',
                                        userData: snapshotUser.data!,
                                        showappBar: true),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.4)),
                                      child: Text(
                                        displayName(snapshotUser.data!.name),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )),
                                ));
                          } else if (snapshotUser.hasError) {
                            return const Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 50,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Not Available',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        });
                  },
                  emptyBuilder: (context) => const Text('Nothing to Show',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ))
              ],
            ),
          );
        });
  }
}
