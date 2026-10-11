import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sermons_audio/models/sermon_model.dart';
import 'package:sermons_audio/pages/SermonPage/PageUI/PageUI/audio_components.dart';
import 'package:sermons_audio/pages/SermonPage/PageUI/PageUI/sermon_page.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:url_launcher/url_launcher.dart';

class AudioProfileSelect extends StatefulWidget {
  final String narratorid;
  final String audioid;
  final String textid;
  final String audioUrl;
  final String title;
  const AudioProfileSelect(
      {required this.title,
      required this.narratorid,
      required this.audioid,
      required this.audioUrl,
      required this.textid,
      super.key});
  @override
  State<AudioProfileSelect> createState() {
    return _SermonPages();
  }
}

class _SermonPages extends State<AudioProfileSelect>
    with TickerProviderStateMixin {
  late TabController tabbarController;

  @override
  void initState() {
    super.initState();
    tabbarController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabbarController.dispose();
  }

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
                    stops: const [0.0, 0.15, 0.60, 1.0])),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.black.withOpacity(0.4),
                elevation: 0,
                title: const Text(
                  'Audio',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.popUntil(context,
                        (Route<dynamic> predicate) => predicate.isFirst),
                    icon: const Icon(Icons.home),
                    color: Colors.white,
                  )
                ],
              ),
              body: FutureBuilder(
                  future: DocumentParagraphs.fromId(widget.textid),
                  builder:
                      (context, AsyncSnapshot<DocumentParagraphs> snapshot) {
                    if (snapshot.hasData) {
                      return DefaultTextStyle(
                        style: const TextStyle(color: Colors.white),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Material(
                                              child: SermonPageFinal(
                                                  alldataofsermon:
                                                      snapshot.data!)))),
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blueGrey[300]),
                                  child: const Text('Go to text page')),
                            ),
                            Expanded(
                              child: CustomScrollView(
                                slivers: [
                                  SliverAppBar(
                                      automaticallyImplyLeading: false,
                                      backgroundColor:
                                          Colors.black.withOpacity(0.3),
                                      pinned: true,
                                      primary: false,
                                      elevation: 0.0,
                                      flexibleSpace: SingleChildScrollView(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          snapshot.data!.paragraphs.first,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              wordSpacing: 2,
                                              height: 2),
                                        ),
                                      )),
                                      expandedHeight: 300),
                                  SliverAppBar(
                                    automaticallyImplyLeading: false,
                                    backgroundColor: Colors.transparent,
                                    pinned: true,
                                    primary: false,
                                    elevation: 8.0,
                                    title: Align(
                                        alignment: AlignmentDirectional.center,
                                        child: TabBar(
                                            labelColor: Colors.white,
                                            tabAlignment: TabAlignment.center,
                                            indicatorColor: Colors.white,
                                            controller: tabbarController,
                                            isScrollable: true,
                                            tabs: const [
                                              Tab(
                                                text: "Audio",
                                              ),
                                            ])),
                                  ),
                                  SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: 300,
                                      child: TabBarView(
                                        dragStartBehavior:
                                            DragStartBehavior.start,
                                        controller: tabbarController,
                                        children: [
                                          Column(
                                            children: [
                                              widget.narratorid ==
                                                      AuthMethods().uid
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await downloadAudio(
                                                                    widget
                                                                        .audioUrl);
                                                              },
                                                              child: const Text(
                                                                'Download',
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              )),
                                                          TextButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                              actionsAlignment: MainAxisAlignment.spaceBetween,
                                                                              title: const Text('Confirm'),
                                                                              content: const Text(
                                                                                'Are you sure you want to delete your audio? it will no longer be available and will PERMANENTLY be deleted from our database',
                                                                                style: TextStyle(fontSize: 16),
                                                                              ),
                                                                              actions: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    TextButton(
                                                                                        onPressed: () async {
                                                                                          await deleteAudio(widget.audioid, widget.textid, widget.narratorid, widget.audioUrl);
                                                                                          if (context.mounted) {
                                                                                            Navigator.pop(context);
                                                                                          }
                                                                                        },
                                                                                        child: const Text(
                                                                                          'Confirm',
                                                                                          style: TextStyle(fontSize: 18),
                                                                                        )),
                                                                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ));
                                                              },
                                                              child: const Text(
                                                                'Delete',
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ))
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              AudioComponentsFromProfile(
                                                  title: widget.title,
                                                  textid: widget.textid,
                                                  audioid: widget.audioid,
                                                  narratorid: widget.narratorid,
                                                  audioUrl: widget.audioUrl),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return const Text("Error in profile audio specific",
                          style: TextStyle(color: Colors.white));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
          );
        });
  }
}

Future<void> deleteAudio(
    String audioId, String textid, String narratorid, String url) async {
  await FirestoreService.instance.addDocument(
      path: 'UserAudioDeletes',
      data: {'audioid': audioId, 'textid': textid, 'userid': narratorid});
}

Future<void> downloadAudio(String urlstorage) async {
  Uri? filewebpath;

  filewebpath = Uri.parse(urlstorage);

  if (!kIsWeb) {
    launchUrl(filewebpath, mode: LaunchMode.inAppBrowserView);
  } else {
    if (await canLaunchUrl(filewebpath)) {
      launchUrl(filewebpath, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $filewebpath');
    }
  }
}
