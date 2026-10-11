import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sermons_audio/models/author_model.dart';
import 'package:sermons_audio/pages/SearchPages/results_by_filters.dart';
import 'package:sermons_audio/pages/SearchPages/results_select_author.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';

class SearchTextFilters extends StatefulWidget {
  final String givenNameAuthor;
  const SearchTextFilters({super.key, this.givenNameAuthor = ''});

  @override
  State<SearchTextFilters> createState() {
    return _SearchTextFilters();
  }
}

class _SearchTextFilters extends State<SearchTextFilters> {
  bool? _byFilters = false;
  String _textSearch = "";
  final TextEditingController _searchTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
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
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.black.withOpacity(0.4),
                  elevation: 0,
                  title: const Text(
                    'search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                body: DefaultTextStyle(
                  style: const TextStyle(color: Colors.white),
                  child: Column(
                    children: [
                      !_byFilters! ? buildSearchBar() : const SizedBox(),
                      // !_byFilters!
                      //     ? Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: ElevatedButton(
                      //           onPressed: () => setState(() {
                      //             _byFilters = true;
                      //           }),
                      //           style: ElevatedButton.styleFrom(
                      //               padding: const EdgeInsets.all(8),
                      //               foregroundColor: Colors.white,
                      //               backgroundColor: Colors.blueGrey[300]),
                      //           child: const Text(
                      //             'Show Filters',
                      //             style: TextStyle(fontSize: 10),
                      //           ),
                      //         ),
                      //       )
                      //     : Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: ElevatedButton(
                      //           onPressed: () => setState(() {
                      //             _byFilters = false;
                      //           }),
                      //           style: ElevatedButton.styleFrom(
                      //               foregroundColor: Colors.white,
                      //               backgroundColor: Colors.blueGrey[300]),
                      //           child: const Text('Hide Filters'),
                      //         ),
                      //       ),
                      _byFilters!
                          ? const Expanded(child: ResultsFilters())
                          : !_byFilters!
                              ? Expanded(
                                  child: FirestoreListView(
                                    query: FirestoreService.instance
                                        .collectionQuery(
                                      path: FirestorePath.authorsadd(),
                                      queryBuilder: (query) {
                                        return query.where('name',
                                            isGreaterThanOrEqualTo:
                                                _textSearch);
                                      },
                                    ),
                                    itemBuilder: (context, snapshot) {
                                      Author model = Author.fromsnap(snapshot
                                          .data() as Map<String, dynamic>);
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2),
                                        child: Container(
                                          height: 50,
                                          color: Colors.black.withOpacity(0.4),
                                          child: GestureDetector(
                                            child: Text(
                                              displayName(model.name),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            onTap: () =>
                                                pushScreenWithoutNavBar(
                                              context,
                                              Material(
                                                child: ResultsFiltersNewScreen(
                                                    givenAuthorid: model.id,
                                                    givenNameAuthor:
                                                        model.name),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    emptyBuilder: (context) => const Text(
                                        'Nothing to Show',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                  ),
                                )
                              : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.person_search,
            color: Colors.grey,
            size: 24,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: _searchTextEditingController,
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _textSearch = value;
                    _byFilters = false;
                  });
                } else {
                  setState(() {
                    _textSearch = "";
                  });
                }
              },
              decoration: InputDecoration.collapsed(
                hintText: widget.givenNameAuthor.isNotEmpty
                    ? widget.givenNameAuthor
                    : 'Search here ...',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
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
}
