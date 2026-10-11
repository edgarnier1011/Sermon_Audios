import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sermons_audio/models/user_model.dart';
import 'package:sermons_audio/pages/ProfilePage/user_profile_visitor.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/utils/profilepic.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() {
    return _SearchUser();
  }
}

class _SearchUser extends State<SearchUser> {
  String _textSearch = "";

  final TextEditingController _searchTextEditingController =
      TextEditingController();

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
                title: const Text(
                  'Search',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.black.withOpacity(0.4),
                elevation: 0,
              ),
              body: Column(
                children: [
                  buildSearchBar(),
                  if (_textSearch.isNotEmpty)
                    Expanded(
                      child: FirestoreListView(
                        showFetchingIndicator: true,
                        pageSize: 10,
                        query: FirestoreService.instance.collectionQuery(
                            path: FirestorePath.userC(),
                            queryBuilder: (query) => query.where('name',
                                isGreaterThanOrEqualTo: _textSearch)),
                        itemBuilder: (context, snapshot) {
                          debugPrint('hello world');
                          Theuser model = Theuser.fromSnap(
                              snapshot.data() as Map<String, dynamic>);

                          return GestureDetector(
                            onTap: () => pushScreenWithoutNavBar(
                                context,
                                Material(
                                    child: UserProfileV(
                                        previous: AuthMethods().uid,
                                        userData: model,
                                        showappBar: true))),
                            child: DefaultTextStyle.merge(
                              style: const TextStyle(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Container(
                                  color: Colors.black.withOpacity(0.4),
                                  child: Row(
                                    children: [
                                      ProfilePicSermon(
                                          //  id: model.id,
                                          //  url: model.profileImage,
                                          size: 50),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              displayName(model.name),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        emptyBuilder: (context) => const Text('Nothing to Show',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                ],
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
                  });
                } else {
                  setState(() {
                    _textSearch = "";
                  });
                }
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Search here...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
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
