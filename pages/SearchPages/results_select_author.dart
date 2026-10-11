import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sermons_audio/models/sermon_model.dart';
import 'package:sermons_audio/pages/HomePage/home_text_fragment.dart';
import 'package:sermons_audio/pages/SubmitText/author_info.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
//import 'package:sermons_audio/utils/ads.dart';

class ResultsFiltersNewScreen extends StatefulWidget {
  final String givenAuthorid;
  final String givenNameAuthor;
  const ResultsFiltersNewScreen(
      {super.key, required this.givenNameAuthor, required this.givenAuthorid});

  @override
  State<ResultsFiltersNewScreen> createState() {
    return _ResultsFiltersNewScreen();
  }
}

class _ResultsFiltersNewScreen extends State<ResultsFiltersNewScreen> {
  var localvariables = locator.get<LocalData>();
  bool mostlikes = false;
  bool mostAudios = false;

  bool oldest = false;
  Query<Object?>? selectedQuery;

  @override
  void dispose() {
    super.dispose();
    // locator.get<LocalData>().filterLanguage.value =
    //   locator.get<FirestoreMethods>().userModel.prefferedLanguage;
    locator.get<LocalData>().resetfilterchosen();
    locator.get<LocalData>().resertagschosen();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: locator.get<LocalData>().changesettings,
        builder: (context, theValue, __) {
          return DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: locator.get<LocalData>().themeColorspallete[
                        locator.get<LocalData>().currentColorTheme],
                    stops: const [0.0, 0.5, 0.8, 1.0])),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                title: Text(
                  displayName(widget.givenNameAuthor),
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.black.withOpacity(0.4),
                elevation: 0,
              ),
              body: ValueListenableBuilder(
                  valueListenable: localvariables.filterLanguage,
                  builder: (context, thelanguage, __) {
                    return DefaultTextStyle(
                      style: const TextStyle(color: Colors.white),
                      child: Column(
                        children: [
                          // const Padding(
                          //   padding: EdgeInsets.all(8.0),
                          //   child: BannerAdWidget(),
                          // ),
                          const SizedBox(
                            width: 300,
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: LanguageSelector()),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: ElevatedButton(
                          //     onPressed: () => showModalBottomSheet(
                          //             context: context,
                          //             builder: (context) => const ListTags())
                          //         .then((value) {
                          //       List<String> temp = [];
                          //       for (int i = 0;
                          //           i <
                          //               locator
                          //                   .get<LocalData>()
                          //                   .chosenTags
                          //                   .length;
                          //           i++) {
                          //         temp.add(locator.get<LocalData>().globaltags[
                          //             locator.get<LocalData>().chosenTags[i]]);
                          //       }

                          //       locator.get<LocalData>().setfilterTags(temp);
                          //     }),
                          //     style: ElevatedButton.styleFrom(
                          //         padding: const EdgeInsets.all(8),
                          //         foregroundColor: Colors.white,
                          //         backgroundColor: Colors.blueGrey[300]),
                          //     child: const Text(
                          //       'Select denomination',
                          //       style: TextStyle(fontSize: 10),
                          //     ),
                          //   ),
                          // ),
                          ValueListenableBuilder(
                              valueListenable: localvariables.filtertags,
                              builder: (context, thetags, __) {
                                return ValueListenableBuilder(
                                    valueListenable:
                                        locator.get<LocalData>().filterchosen,
                                    builder: (context, filter, __) {
                                      return Expanded(
                                        child: Column(
                                          children: [
                                            // Wrap(
                                            //   children: [
                                            //     ElevatedButton(
                                            //       onPressed: () => locator
                                            //           .get<LocalData>()
                                            //           .setfilertchosen(1),
                                            //       style:
                                            //           ElevatedButton.styleFrom(
                                            //               padding:
                                            //                   const EdgeInsets
                                            //                       .all(8),
                                            //               foregroundColor:
                                            //                   Colors.white,
                                            //               backgroundColor:
                                            //                   Colors.blueGrey[
                                            //                       300]),
                                            //       child: const Text(
                                            //         "Most Liked",
                                            //         style:
                                            //             TextStyle(fontSize: 10),
                                            //       ),
                                            //     ),
                                            //     ElevatedButton(
                                            //       onPressed: () => locator
                                            //           .get<LocalData>()
                                            //           .setfilertchosen(2),
                                            //       style:
                                            //           ElevatedButton.styleFrom(
                                            //               padding:
                                            //                   const EdgeInsets
                                            //                       .all(8),
                                            //               foregroundColor:
                                            //                   Colors.white,
                                            //               backgroundColor:
                                            //                   Colors.blueGrey[
                                            //                       300]),
                                            //       child: const Text(
                                            //         "Most Audios",
                                            //         style:
                                            //             TextStyle(fontSize: 10),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            // AuthMethods().uid.isNotEmpty
                                            //     ? Padding(
                                            //         padding:
                                            //             const EdgeInsets.all(
                                            //                 8.0),
                                            //         child: FollowButtonAuthor(
                                            //             authorName: widget
                                            //                 .givenNameAuthor,
                                            //             userid:
                                            //                 AuthMethods().uid,
                                            //             authorid: widget
                                            //                 .givenAuthorid),
                                            //       )
                                            //     : const SizedBox(),
                                            Expanded(
                                              child: FirestoreListView(
                                                query: FirestoreService.instance
                                                    .collectionQuery(
                                                        path: FirestorePath
                                                            .addText(),
                                                        queryBuilder: (query) {
                                                          selectedQuery = queryByAuthorName(
                                                              query: query,
                                                              authorName: widget
                                                                  .givenNameAuthor,
                                                              language:
                                                                  thelanguage,
                                                              tags: thetags,
                                                              filter: locator
                                                                      .get<
                                                                          LocalData>()
                                                                      .filtersnames[
                                                                  filter]);
                                                          return selectedQuery!;
                                                        }),
                                                itemBuilder:
                                                    (context, snapshot) {
                                                  DocumentParagraphs model =
                                                      DocumentParagraphs
                                                          .fromSnap(
                                                              snapshot.data()
                                                                  as Map<String,
                                                                      dynamic>);
                                                  return TextDataDisplayHomePage(
                                                    modelData: model,
                                                  );
                                                },
                                                emptyBuilder: (context) =>
                                                    const Text(
                                                        'Nothing to Show',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              })
                        ],
                      ),
                    );
                  }),
            ),
          );
        });
  }

  Query<Object?> queryByAuthorName(
      {required Query<Object?> query,
      required String authorName,
      required String language,
      required List<String> tags,
      required String filter}) {
    if (locator.get<LocalData>().filterchosen.value != 0) {
      return query
          .where('authorName', isEqualTo: authorName)
          .where('language', isEqualTo: language)
          .where('tags', arrayContainsAny: tags)
          .orderBy(filter);
    } else {
      return query
          .where('authorName', isEqualTo: authorName)
          .where('language', isEqualTo: language);
    }
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
