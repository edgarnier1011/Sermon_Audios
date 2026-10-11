import 'package:flutter/material.dart';
import 'package:sermons_audio/models/sermon_model.dart';
import 'package:sermons_audio/pages/SermonPage/PageUI/PageUI/sermon_page_componets.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';

class SermonPageFinal extends StatefulWidget {
  final DocumentParagraphs alldataofsermon;

  const SermonPageFinal({required this.alldataofsermon, super.key});

  @override
  State<SermonPageFinal> createState() {
    return _SermonPageFinal();
  }
}

class _SermonPageFinal extends State<SermonPageFinal> {
  final TextEditingController reportController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    reportController.dispose();
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
                  stops: const [0.0, 0.15, 0.60, 1.0]),
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    displayName(widget.alldataofsermon.authorName),
                    style: const TextStyle(color: Colors.white),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.black.withOpacity(0.2),
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.popUntil(context,
                          (Route<dynamic> predicate) => predicate.isFirst),
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                body: Column(children: [
                  // const BannerAdWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Flexible(
                      //   flex: 1,
                      //   child: (AuthMethods().uid.isNotEmpty)
                      //       ? LikeText(
                      //           title: widget.alldataofsermon.sermonName,
                      //           userid: widget.alldataofsermon.userid,
                      //           authorid: widget.alldataofsermon.authorid,
                      //           textid: widget.alldataofsermon.id)
                      //       : const SizedBox(),
                      // ),
                      // Flexible(
                      //   flex: 1,
                      //   child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //           foregroundColor: Colors.white,
                      //           backgroundColor: Colors.blueGrey[300]),
                      //       child: const Text("Narrators"),
                      //       onPressed: () => showModalBottomSheet(
                      //           constraints: BoxConstraints(
                      //               minWidth: locator
                      //                   .get<ScreenDimensions>()
                      //                   .getDimensions(context)
                      //                   .size
                      //                   .width),
                      //           backgroundColor: Colors.blueGrey,
                      //           context: (context),
                      //           builder: (BuildContext context) {
                      //             return NarratorList(
                      //                 textid: widget.alldataofsermon.id);
                      //           }))
                      // ,
                      //),
                      AuthMethods().uid.isNotEmpty
                          ? IconButton(
                              onPressed: () => showModalBottomSheet(
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) => Material(
                                        color: Colors.blueGrey,
                                        child: SingleChildScrollView(
                                          child: AlertDialog(
                                            backgroundColor:
                                                Colors.black.withOpacity(0.4),
                                            title: const Text(
                                              'Report Text',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            content: Column(
                                              children: [
                                                const Text(
                                                  'Note: All texts and audios are reviewd by administrator for approval. If you found something on the text that seems to go against our user agreement policy, located in your profile menu, please let us known in the text box.',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                      height: 50,
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: Colors
                                                                    .white),
                                                        child: TextField(
                                                          cursorColor:
                                                              Colors.white,
                                                          maxLength: 50,
                                                          controller:
                                                              reportController,
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () async {
                                                        bool already =
                                                            await alreadyReported(
                                                                widget
                                                                    .alldataofsermon
                                                                    .id);
                                                        if (!already) {
                                                          await FirestoreService
                                                              .instance
                                                              .addDocument(
                                                                  path: FirestorePath
                                                                      .textReports(),
                                                                  data: {
                                                                'userid':
                                                                    AuthMethods()
                                                                        .uid,
                                                                'textid': widget
                                                                    .alldataofsermon
                                                                    .id,
                                                                'text reason':
                                                                    reportController
                                                                        .text
                                                              });
                                                        } else {
                                                          if (context.mounted) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text('You have already submitted a report for this text')));
                                                          }
                                                        }
                                                        if (context.mounted) {
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Confirm',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                  GestureDetector(
                                                      onTap: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
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
                  Expanded(
                      child: SermonPages(
                    alldataofsermon: widget.alldataofsermon,
                    audioCount: widget.alldataofsermon.audiosCount,
                    sermonTextid: widget.alldataofsermon.id,
                  )),
                ])),
          );
        });
  }
}

Future<bool> alreadyReported(String textid) async {
  final snapshot = await FirestoreService.instance
      .collectionQuery(
          path: FirestorePath.textReports(),
          queryBuilder: (query) => query
              .where('textid', isEqualTo: textid)
              .where('userid', isEqualTo: AuthMethods().uid))
      .get();

  if (snapshot.docs.isNotEmpty) {
    return true;
  } else {
    return false;
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
