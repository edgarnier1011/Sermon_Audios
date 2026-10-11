import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sermons_audio/models/sermon_model.dart';
import 'package:sermons_audio/pages/HomePage/home_text_fragment.dart';
import 'package:sermons_audio/pages/SubmitText/author_info.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
//import 'package:sermons_audio/utils/ads.dart';

class ResultsFilters extends StatefulWidget {
  final String givenAuthorid;
  final String givenNameAuthor;
  const ResultsFilters(
      {super.key, this.givenNameAuthor = '', this.givenAuthorid = ''});

  @override
  State<ResultsFilters> createState() {
    return _ResultsFilters();
  }
}

class _ResultsFilters extends State<ResultsFilters> {
  var localvariables = locator.get<LocalData>();
  bool mostlikes = false;
  bool mostAudios = false;

  bool oldest = false;
  Query<Object?>? selectedQuery;

  @override
  void dispose() {
    super.dispose();
    locator.get<LocalData>().filterLanguage.value =
        locator.get<FirestoreMethods>().userModel.prefferedLanguage;
    locator.get<LocalData>().resetfilterchosen();
    locator.get<LocalData>().resertagschosen();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: localvariables.filterLanguage,
        builder: (context, thelanguage, __) {
          return ValueListenableBuilder(
              valueListenable: locator.get<LocalData>().changesettings,
              builder: (context, theValue, __) {
                return DefaultTextStyle.merge(
                  style: const TextStyle(color: Colors.white),
                  child: Column(
                    children: [
                      // const Padding(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: BannerAdWidget(),
                      // ),
                      const SizedBox(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: LanguageSelector(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => showModalBottomSheet(
                                  context: context,
                                  builder: (context) => const ListTags())
                              .then((value) {
                            List<String> temp = [];
                            for (int i = 0;
                                i < locator.get<LocalData>().chosenTags.length;
                                i++) {
                              temp.add(locator.get<LocalData>().globaltags[
                                  locator.get<LocalData>().chosenTags[i]]);
                            }

                            locator.get<LocalData>().setfilterTags(temp);
                          }),
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blueGrey[300]),
                          child: const Text(
                            'Select denomination',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                          valueListenable: localvariables.filtertags,
                          builder: (context, thetags, __) {
                            return ValueListenableBuilder(
                                valueListenable:
                                    locator.get<LocalData>().filterchosen,
                                builder: (context, filters, __) {
                                  return Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () => locator
                                                    .get<LocalData>()
                                                    .setfilertchosen(1),
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Colors.blueGrey[300]),
                                                child: const Text(
                                                  "Most Liked",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () => locator
                                                    .get<LocalData>()
                                                    .setfilertchosen(2),
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Colors.blueGrey[300]),
                                                child: const Text(
                                                  "Most Audios",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: FirestoreListView(
                                            query: FirestoreService.instance
                                                .collectionQuery(
                                              path: FirestorePath.addText(),
                                              queryBuilder: (query) {
                                                selectedQuery = querySingle(
                                                    query: query,
                                                    language: thelanguage,
                                                    tags: thetags,
                                                    filter: locator
                                                        .get<LocalData>()
                                                        .filtersnames[filters]);
                                                return selectedQuery!;
                                              },
                                            ),
                                            itemBuilder: (context, snapshot) {
                                              DocumentParagraphs model =
                                                  DocumentParagraphs.fromSnap(
                                                      snapshot.data() as Map<
                                                          String, dynamic>);
                                              return TextDataDisplayHomePage(
                                                modelData: model,
                                              );
                                            },
                                            emptyBuilder: (context) =>
                                                const Text('Nothing to Show',
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
              });
        });
  }

  Query<Object?> querySingle(
      {required Query<Object?> query,
      required String language,
      required List<String> tags,
      required String filter}) {
    if (language == 'any' && tags.isNotEmpty) {
      return query.where('tags', arrayContainsAny: tags);
    } else if (language != 'any' && tags.isEmpty) {
      return query.where('language', isEqualTo: language);
    } else if (language != 'any' && tags.isNotEmpty) {
      if (locator.get<LocalData>().filterchosen.value != 0) {
        return query
            .where('language', isEqualTo: language)
            .where('tags', arrayContainsAny: tags)
            .orderBy(filter, descending: true);
      } else {
        return query
            .where('language', isEqualTo: language)
            .where('tags', arrayContainsAny: tags);
      }
    } else {
      return query;
    }
  }

  Query<Object?> querylastFilter(
      {required Query<Object?> query, required String lastFilter}) {
    return query.orderBy(lastFilter, descending: true);
  }

  Query<Object?> queryByAuthorName(
      {required Query<Object?> query, required String authorName}) {
    return query.where('authorName', isEqualTo: authorName);
  }
}
