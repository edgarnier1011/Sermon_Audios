import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sermons_audio/models/audio_model.dart';
import 'package:sermons_audio/models/sermon_model.dart';
import 'package:sermons_audio/pages/SermonPage/PageUI/PageUI/audio_components.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';

class SermonPages extends StatefulWidget {
  final DocumentParagraphs alldataofsermon;
  final String sermonTextid;
  final int audioCount;
  const SermonPages(
      {required this.audioCount,
      required this.sermonTextid,
      required this.alldataofsermon,
      super.key});
  @override
  State<SermonPages> createState() {
    return _SermonPages();
  }
}

class _SermonPages extends State<SermonPages> with TickerProviderStateMixin {
  late TabController _tabbarController;

  @override
  void initState() {
    super.initState();

    _tabbarController = TabController(length: 1, vsync: this);

    if (widget.alldataofsermon.audiosCount != 0) {
      locator.get<LocalData>().changesermonpagecomponents([
        widget.alldataofsermon.latestAudiourl,
        widget.alldataofsermon.latestnarratorid,
        widget.alldataofsermon.latestAudioid
      ]);
    } else {}
  }

  @override
  void dispose() {
    super.dispose();
    locator.get<LocalData>().resetsermonpagecomponents();
    _tabbarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black.withOpacity(0.4),
            pinned: true,
            primary: false,
            elevation: 0.0,
            flexibleSpace: SingleChildScrollView(
                child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
              child: Column(
                children: [
                  Text(
                    'Title: ${widget.alldataofsermon.sermonName}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, height: 3),
                  ),
                  SelectableText(
                    enableInteractiveSelection: true,
                    widget.alldataofsermon.paragraphs.first,
                    style: const TextStyle(
                        color: Colors.white,
                        wordSpacing: 2.0,
                        height: 2,
                        fontSize: 16),
                  ),
                ],
              ),
            )),
            expandedHeight: 300),
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          pinned: true,
          primary: false,
          elevation: 8.0,
          title: TabBar(
              tabAlignment: TabAlignment.center,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              controller: _tabbarController,
              isScrollable: true,
              tabs: const [
                Tab(
                  text: "Narrator Audio",
                ),
                // Tab(text: "Narrator Profile"),
                // Tab(text: "Narrate text "),
                // Tab(text: 'Share Text'),
              ]),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: (locator.get<LocalData>().changesermonpage.value.isNotEmpty)
                ? TabBarView(
                    dragStartBehavior: DragStartBehavior.start,
                    controller: _tabbarController,
                    children: [
                      Column(
                        children: [
                          ValueListenableBuilder(
                              valueListenable:
                                  locator.get<LocalData>().changesermonpage,
                              builder: (context, arrayvalues, __) {
                                return AudioComponents(
                                  title: widget.alldataofsermon.sermonName,
                                  textid: widget.sermonTextid,
                                  audioUrl: arrayvalues[0],
                                  audioId: arrayvalues[2],
                                  narratorid: arrayvalues[1],
                                );
                              }),
                        ],
                      ),
                      // ValueListenableBuilder(
                      //     valueListenable:
                      //         locator.get<LocalData>().changesermonpage,
                      //     builder: (context, arrayvalues, __) {
                      //       return UserProfileSermon(
                      //           showappBar: false, id: arrayvalues[1]);
                      //     }),
                      // !kIsWeb
                      //     ? _recorderMenu(context)
                      //     : const Text(
                      //         'Download app to record audio',
                      //         style:
                      //             TextStyle(color: Colors.white, fontSize: 14),
                      //       ),
                      // ShareTextFollowers(
                      //     id: AuthMethods().uid,
                      //     textid: widget.alldataofsermon.id,
                      //     title: widget.alldataofsermon.sermonName)
                    ],
                  )
                : TabBarView(controller: _tabbarController, children: [
                    const Column(
                      children: [
                        Text(
                          'No Audios',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    // const Column(
                    //   children: [
                    //     Text(
                    //       "No profile",
                    //       style: TextStyle(color: Colors.white, fontSize: 14),
                    //     )
                    //   ],
                    // ),
                    // !kIsWeb
                    //     ? _recorderMenu(context)
                    //     : const Text('Download app to record audio'),
                    // ShareTextFollowers(
                    //     id: AuthMethods().uid,
                    //     textid: widget.alldataofsermon.id,
                    //     title: widget.alldataofsermon.sermonName)
                  ]),
          ),
        )
      ],
    );
  }

  Widget _recorderMenu(BuildContext context) {
    Future<String> recordExists = checkifRecordexists();
    return FutureBuilder(
        future: recordExists,
        builder: (context, AsyncSnapshot<String> audiosnap) {
          if (audiosnap.hasData) {
            if (audiosnap.data!.isNotEmpty) {
              return Column(
                children: [
                  const Text(
                    'My Recording:',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  FutureBuilder(
                      future: AudioCreate.fromID(audiosnap.data!),
                      builder: (context, AsyncSnapshot<AudioCreate?> snapshot) {
                        if (snapshot.hasData) {
                          return AudioComponentsFromProfile(
                            title: widget.alldataofsermon.sermonName,
                            textid: snapshot.data!.textid,
                            narratorid: AuthMethods().uid,
                            audioid: snapshot.data!.id,
                            audioUrl: snapshot.data!.urlfromstorage,
                            recordMenu: true,
                          );
                        } else if (snapshot.hasError) {
                          return const Text('Error loading your narration',
                              style: TextStyle(color: Colors.white));
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 60.0),
                  //   child: ElevatedButton(
                  //       onPressed: () {
                  //         locator.get<AudioResources>().player.stop();
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => Material(
                  //                       child: Recorder(
                  //                         existingRecord:
                  //                             audiosnap.data!.isNotEmpty
                  //                                 ? false
                  //                                 : true,
                  //                         nameSermon:
                  //                             widget.alldataofsermon.sermonName,
                  //                         language:
                  //                             widget.alldataofsermon.language,
                  //                         textString: widget
                  //                             .alldataofsermon.paragraphs.first,
                  //                         nameofAuthor:
                  //                             widget.alldataofsermon.authorName,
                  //                         authorid:
                  //                             widget.alldataofsermon.authorid,
                  //                         textid: widget.alldataofsermon.id,
                  //                       ),
                  //                     )));
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //           foregroundColor: Colors.white,
                  //           backgroundColor: Colors.blueGrey[300]),
                  //       child: const Text("Replace Recording")),
                  // ),
                ],
              );
            } else {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You do not have a recording',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 60.0),
                  //   child: ElevatedButton(
                  //       onPressed: AuthMethods().uid.isNotEmpty
                  //           ? () {
                  //               locator.get<AudioResources>().player.stop();
                  //               Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) => Material(
                  //                             child: Recorder(
                  //                               existingRecord:
                  //                                   audiosnap.data!.isNotEmpty
                  //                                       ? false
                  //                                       : true,
                  //                               nameSermon: widget
                  //                                   .alldataofsermon.sermonName,
                  //                               language: widget
                  //                                   .alldataofsermon.language,
                  //                               textString: widget
                  //                                   .alldataofsermon
                  //                                   .paragraphs
                  //                                   .first,
                  //                               nameofAuthor: widget
                  //                                   .alldataofsermon.authorName,
                  //                               authorid: widget
                  //                                   .alldataofsermon.authorid,
                  //                               textid:
                  //                                   widget.alldataofsermon.id,
                  //                             ),
                  //                           )));
                  //             }
                  //           : () {
                  //               showDialog(
                  //                   context: context,
                  //                   builder: (context) => const AlertDialog(
                  //                         title: Text('Register'),
                  //                         content: Text(
                  //                             'Register to access recording feature'),
                  //                       ));
                  //             },
                  //       style: ElevatedButton.styleFrom(
                  //           foregroundColor: Colors.white,
                  //           backgroundColor: Colors.blueGrey[300]),
                  //       child: const Text("Create Recording")),
                  // ),
                ],
              );
            }
          } else if (audiosnap.hasError) {
            return const Text('Some error occured on recording',
                style: TextStyle(color: Colors.white));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<String> checkifRecordexists() async {
    final snapshot = await FirestoreService.instance
        .collectionQuery(
            path: FirestorePath.audioadd(),
            queryBuilder: (query) =>
                query.where('textid', isEqualTo: widget.alldataofsermon.id))
        .where('userid', isEqualTo: AuthMethods().uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    } else {
      return '';
    }
  }
}
