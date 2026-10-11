import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sermons_audio/models/audio_model.dart';
import 'package:sermons_audio/models/sermon_model.dart';
import 'package:sermons_audio/models/user_model.dart';
import 'package:sermons_audio/pages/ProfilePage/user_profile_visitor.dart';
import 'package:sermons_audio/pages/ProfilePage/user_profile_audio.dart';
import 'package:sermons_audio/pages/SearchPages/results_select_author.dart';
import 'package:sermons_audio/pages/SermonPage/PageUI/PageUI/sermon_page.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/resources/screen_dimensions.dart';
import 'package:sermons_audio/utils/logout.dart';
import 'package:sermons_audio/utils/profilepic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatelessWidget {
  final String id;
  final bool showappBar;

  const UserProfile({required this.showappBar, required this.id, super.key});

  @override
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

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
              endDrawer: Drawer(
                backgroundColor: Colors.blueGrey,
                child: DefaultTextStyle(
                  style: const TextStyle(color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Settings',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const Text('Color Mode:'),
                      const Row(
                        children: [ChangeThemeColor()],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'My email:',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        locator.get<FirestoreMethods>().userModel.email,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                          child: const Text(
                            'Credits',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          onTap: () => pushScreenWithoutNavBar(
                                context,
                                const AboutDialog(),
                              )),
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                          child: const Text(
                            'User Agreement',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          onTap: () async {
                            final Uri url = Uri.parse(
                                'https://sermonaudiosprivacy.web.app');
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          }),
                      const SizedBox(height: 16),
                      GestureDetector(
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onTap: () async {
                          final Uri url = Uri.parse(
                              'https://sites.google.com/view/sermonaudios/home');
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch $url');
                          }
                        },
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const Logout(),
                      const SizedBox(
                        height: 32,
                      ),
                      const Center(
                        child: Text(
                          'Contact email:',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'edgar101193nier@gmail.com',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: TextButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          actionsAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          backgroundColor: Colors.blueGrey,
                                          title: const Text(
                                            "WARNING",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.red),
                                          ),
                                          content: const SingleChildScrollView(
                                            child: Text(
                                              'Deleting the account will PERMANENTLY DELETE ALL AUDIOS AND IMAGES you have submitted from our database. The TEXTS SUBMITTED by you, WILL BE KEPT in case other users have narrations on them. Once the account is deleted, YOU WILL NO LONGER OWN your TEXTS SUBMITTED and cannot be recovered. Download any audios you have submitted in case you want to use them later, they will be no longer be available.',
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  await locator
                                                      .get<FirestoreMethods>()
                                                      .deleteAccount();

                                                  // if (context.mounted) {
                                                  //   Navigator.of(context,
                                                  //           rootNavigator: true)
                                                  //       .pushAndRemoveUntil(
                                                  //           MaterialPageRoute(
                                                  //               maintainState:
                                                  //                   false,
                                                  //               builder:
                                                  //                   (context) =>
                                                  //                       const MaterialApp(
                                                  //                         debugShowCheckedModeBanner:
                                                  //                             false,
                                                  //                         home:
                                                  //                             MyApp(),
                                                  //                       )),
                                                  //           (route) => false);
                                                  // }
                                                  if (context.mounted) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: const Text('Confirm')),
                                            ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cancel'))
                                          ],
                                        ));
                              },
                              child: const Text(
                                'Delete Account',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              body: DefaultTabController(
                  length: 9,
                  child: DefaultTextStyle(
                    style: const TextStyle(color: Colors.white),
                    child: Column(
                      children: [
                        showappBar
                            ? AppBar(
                                iconTheme:
                                    const IconThemeData(color: Colors.white),
                                backgroundColor: Colors.black.withOpacity(0.4),
                                elevation: 0,
                                title: const Text(
                                  'profile',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : const SizedBox(),
                        Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: queryData.size.width,
                                  height: 125,
                                  /* child: Stack(
                                    children: [
                                      BannerPic(
                                          size: queryData.size.width,
                                          id: id,
                                          url: locator
                                              .get<FirestoreMethods>()
                                              .userModel
                                              .bannerImage),
                                    ],
                                  ),*/
                                ),
                                Container(
                                  height: 175,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4)),
                                )
                              ],
                            ),
                            Positioned(
                                top: 100,
                                left: 20,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right:
                                                  queryData.size.width * 0.50),
                                          child: ProfilePic(
                                              id: id,
                                              size: 100,
                                              url: locator
                                                  .get<FirestoreMethods>()
                                                  .userModel
                                                  .profileImage),
                                        ),
                                        SizedBox(
                                          width: queryData.size.width * 0.80,
                                          child: Text(
                                            textAlign: TextAlign.start,
                                            displayName(locator
                                                .get<FirestoreMethods>()
                                                .userModel
                                                .name),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Container(
                          width: queryData.size.width,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4)),
                          child: const Center(
                            child: TabBar(
                              tabAlignment: TabAlignment.center,
                              indicatorColor: Colors.white,
                              labelColor: Colors.white,
                              tabs: [
                                Tab(text: 'My Texts'),
                                Tab(text: 'My Audios'),
                                Tab(
                                  text: 'Authors',
                                ),
                                Tab(
                                  text: 'Following',
                                ),
                                Tab(
                                  text: 'Followers',
                                ),
                                Tab(
                                  text: 'About me',
                                ),
                                Tab(
                                  text: 'Text Likes',
                                ),
                                Tab(
                                  text: 'Audio Likes',
                                ),
                                Tab(
                                  text: 'Blocked',
                                )
                              ],
                              isScrollable: true,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(children: [
                            MyTexts(id: AuthMethods().uid),
                            MyAudios(userID: AuthMethods().uid),
                            LikedAuthors(id: AuthMethods().uid),
                            MyFollowing(id: id),
                            MyFollowers(id: id),
                            const AboutMeButton(),
                            LikedTexts(userID: id),
                            LikedAudios(id: id),
                            const BlockedUsers()
                          ]),
                        )
                      ],
                    ),
                  )),
            ),
          );
        });
  }
}

class MyTexts extends StatefulWidget {
  final String id;
  const MyTexts({required this.id, super.key});

  @override
  State<MyTexts> createState() {
    return _MyTexts();
  }
}

class _MyTexts extends State<MyTexts> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      query: FirestoreService.instance.collectionQuery(
          path: FirestorePath.addText(),
          queryBuilder: (query) => query.where('userid', isEqualTo: widget.id)),
      itemBuilder: (context, snapshot) {
        DocumentParagraphs model = DocumentParagraphs.fromSnap(
            snapshot.data() as Map<String, dynamic>);

        return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          overflow: TextOverflow.ellipsis,
                          'Title: ',
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            model.sermonName,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Name of Author: ',
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            displayName(model.authorName),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total Likes: ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(model.likes.toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Total audios: ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        Text(model.audiosCount.toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Status: ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        model.approval
                            ? const Text('Approved',
                                style: TextStyle(
                                  fontSize: 14,
                                ))
                            : const Text('Pending Approval',
                                style: TextStyle(
                                  fontSize: 14,
                                ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            onTap: () => model.approval
                ? pushScreenWithoutNavBar(
                    context,
                    Material(
                      child: SermonPageFinal(
                        alldataofsermon: model,
                      ),
                    ),
                  )
                : showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                          backgroundColor: Colors.blueGrey,
                          title: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Notice'),
                          ),
                          content: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Your text is pending approval, please wait for approval',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        )));
      },
      emptyBuilder: (context) => const Text('Nothing to Show',
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }
}

class MyAudios extends StatefulWidget {
  final String userID;

  const MyAudios({required this.userID, super.key});
  @override
  State<MyAudios> createState() {
    return _MyAudios();
  }
}

class _MyAudios extends State<MyAudios> {
  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      query: FirestoreService.instance.collectionQuery(
          path: FirestorePath.audioadd(),
          queryBuilder: (query) =>
              query.where('userid', isEqualTo: widget.userID)),
      itemBuilder: (context, snapshot) {
        AudioCreate model =
            AudioCreate.fromsnap(snapshot.data() as Map<String, dynamic>);
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String dateformat = formatter.format(model.datesubmit!);

        return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Text Title: ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        Flexible(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            displayName(model.sermonName),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Name of author: ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        Flexible(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            displayName(model.nameofAuthor),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Date submitted: ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        Text(dateformat),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Amount of likes: ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        Text(model.likes.toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Status',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        model.approval
                            ? const Text('Approved',
                                style: TextStyle(
                                  fontSize: 14,
                                ))
                            : const Text('Pending Approval',
                                style: TextStyle(
                                  fontSize: 14,
                                ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            onTap: () => model.approval
                ? pushScreenWithoutNavBar(
                    context,
                    Material(
                      child: AudioProfileSelect(
                          title: model.sermonName,
                          narratorid: model.userid,
                          audioid: model.id,
                          audioUrl: model.urlfromstorage,
                          textid: model.textid),
                    ),
                  )
                : showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                          backgroundColor: Colors.blueGrey,
                          title: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Notice',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          content: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                                'Your audio is pending approval, please wait for approval',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ),
                        )));
      },
      emptyBuilder: (context) => const Text('Nothing to Show',
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }
}

class LikedAuthors extends StatefulWidget {
  final String id;
  const LikedAuthors({required this.id, super.key});

  @override
  State<LikedAuthors> createState() {
    return _LikedAuthors();
  }
}

class _LikedAuthors extends State<LikedAuthors> {
  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      query: FirestoreService.instance.collectionQuery(
          path: FirestorePath.authorfollows(),
          queryBuilder: (query) =>
              query.where('follower', isEqualTo: widget.id)),
      itemBuilder: (context, snapshot) {
        Map<String, dynamic> model = (snapshot.data() as Map<String, dynamic>);

        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 30,
              width: double.infinity,
              color: Colors.black.withOpacity(0.4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    displayName(model['authorName']),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
          onTap: () => pushScreenWithoutNavBar(
            context,
            Material(
              child: ResultsFiltersNewScreen(
                givenAuthorid: model['following'],
                givenNameAuthor: model['authorName'],
              ),
            ),
          ),
        );
      },
      emptyBuilder: (context) => const Text('Nothing to Show',
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }
}

class LikedTexts extends StatefulWidget {
  final String userID;
  const LikedTexts({required this.userID, super.key});

  @override
  State<LikedTexts> createState() {
    return _LikedTexts();
  }
}

class _LikedTexts extends State<LikedTexts> {
  @override
  Widget build(BuildContext context) {
    return
        //Scaffold(
        // appBar: AppBar(
        //   iconTheme: const IconThemeData(color: Colors.white),
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        // ),
        // backgroundColor: Colors.transparent,
        // body:
        FirestoreListView(
      query: FirestoreService.instance.collectionQuery(
        path: FirestorePath.likes(),
        queryBuilder: (query) {
          return query.where('likedby', isEqualTo: widget.userID);
        },
      ),
      itemBuilder: (context, snapshot) {
        Future<DocumentParagraphs> model =
            DocumentParagraphs.fromId(snapshot.get('textid'));

        return FutureBuilder(
            future: model,
            builder: (context, AsyncSnapshot<DocumentParagraphs> snapshot) {
              if (snapshot.hasData) {
                return DefaultTextStyle(
                  style: const TextStyle(color: Colors.white),
                  child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    overflow: TextOverflow.ellipsis,
                                    'Title: ',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Flexible(
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      snapshot.data!.sermonName,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Name of Author: ',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Flexible(
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      displayName(snapshot.data!.authorName),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Total Likes: ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(snapshot.data!.likes.toString()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Total audios: ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Text(snapshot.data!.audiosCount.toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () => pushScreenWithoutNavBar(
                            context,
                            Material(
                              child: SermonPageFinal(
                                alldataofsermon: snapshot.data!,
                              ),
                            ),
                          )),
                );
              } else if (snapshot.hasError) {
                return const Text('Some error in text likes list',
                    style: TextStyle(color: Colors.white));
              } else {
                return const CircularProgressIndicator();
              }
            });
      },
      emptyBuilder: (context) => const Text('Nothing to Show',
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );
    //);
  }
}

class LikedAudios extends StatefulWidget {
  final String id;
  const LikedAudios({required this.id, super.key});

  @override
  State<LikedAudios> createState() {
    return _LikedAudios();
  }
}

class _LikedAudios extends State<LikedAudios> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //  appBar: AppBar(
    //  iconTheme: const IconThemeData(color: Colors.white),
    //   backgroundColor: Colors.transparent,
    //   elevation: 0,
    // ),
    // backgroundColor: Colors.transparent,
    // body:
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: FirestoreListView(
        query: FirestoreService.instance.collectionQuery(
          path: FirestorePath.audiolikes(),
          queryBuilder: (query) {
            return query.where('likedby', isEqualTo: widget.id);
          },
        ),
        itemBuilder: (context, snapshot) {
          Future<AudioCreate?> model =
              AudioCreate.fromID(snapshot.get('audioId'));
          DateFormat formatter = DateFormat('yyyy-MM-dd');

          return FutureBuilder(
              future: model,
              builder: (context, AsyncSnapshot<AudioCreate?> snapshot) {
                if (snapshot.hasData) {
                  final String dateformat =
                      formatter.format(snapshot.data!.datesubmit!);

                  return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Text Title: ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Flexible(
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      displayName(snapshot.data!.sermonName),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Name of author: ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Flexible(
                                    child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        displayName(
                                            snapshot.data!.nameofAuthor)),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Date submitted: ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Text(dateformat),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Amount of likes: ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    snapshot.data!.likes.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () => pushScreenWithoutNavBar(
                          context,
                          Material(
                              child: AudioProfileSelect(
                                  title: snapshot.data!.sermonName,
                                  narratorid: snapshot.data!.userid,
                                  audioid: snapshot.data!.id,
                                  audioUrl: snapshot.data!.urlfromstorage,
                                  textid: snapshot.data!.textid))));
                } else if (snapshot.hasError) {
                  return const Text('Error on list text',
                      style: TextStyle(color: Colors.white));
                } else {
                  return const CircularProgressIndicator();
                }
              });
        },
        emptyBuilder: (context) => const Text('Nothing to Show',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
    //);
  }
}

class MyFollowers extends StatefulWidget {
  final String id;
  const MyFollowers({required this.id, super.key});

  @override
  State<MyFollowers> createState() {
    return _MyFollowers();
  }
}

class _MyFollowers extends State<MyFollowers>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FirestoreListView(
      query: FirestoreService.instance.collectionQuery(
          path: FirestorePath.follows(),
          queryBuilder: (query) =>
              query.where('following', isEqualTo: widget.id)),
      itemBuilder: (context, snapshot) {
        String theidoffollower =
            (snapshot.data() as Map<String, dynamic>)['follower'] as String;
        Future<Theuser> model = Theuser.fromId(theidoffollower);

        return FutureBuilder(
            future: model,
            builder: (context, AsyncSnapshot<Theuser> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.4)),
                    child: GestureDetector(
                      onTap: () async {
                        pushScreenWithoutNavBar(
                          context,
                          Material(
                            child: UserProfileV(
                                previous: widget.id,
                                userData: snapshot.data!,
                                showappBar: true),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          ProfilePicSermon(
                              //id: snapshot.data!.id,
                              // url: snapshot.data!.profileImage,
                              size: 50),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  displayName(snapshot.data!.name),
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
                );
              } else if (snapshot.hasError) {
                return const Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 50,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                return const Center(child: CircularProgressIndicator());
              }
            });
      },
      emptyBuilder: (context) => const Text('Nothing to Show',
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MyFollowing extends StatefulWidget {
  final String id;
  const MyFollowing({required this.id, super.key});

  @override
  State<MyFollowing> createState() {
    return _MyFollowing();
  }
}

class _MyFollowing extends State<MyFollowing>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FirestoreListView(
      query: FirestoreService.instance.collectionQuery(
          path: FirestorePath.follows(),
          queryBuilder: (query) =>
              query.where('follower', isEqualTo: widget.id)),
      itemBuilder: (context, snapshot) {
        String theidoffollower =
            (snapshot.data() as Map<String, dynamic>)['following'] as String;
        Future<Theuser> model = Theuser.fromId(theidoffollower);

        return FutureBuilder(
            future: model,
            builder: (context, AsyncSnapshot<Theuser> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DecoratedBox(
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.4)),
                    child: GestureDetector(
                      onTap: () {
                        pushScreenWithoutNavBar(
                          context,
                          Material(
                            child: UserProfileV(
                                previous: widget.id,
                                userData: snapshot.data!,
                                showappBar: true),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          ProfilePicSermon(
                              //id: snapshot.data!.id,
                              //url: snapshot.data!.profileImage,
                              size: 50),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  displayName(snapshot.data!.name),
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
                );
              } else if (snapshot.hasError) {
                return const Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 50,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                return const Center(child: CircularProgressIndicator());
              }
            });
      },
      emptyBuilder: (context) => const Text('Nothing to Show',
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BlockedUsers extends StatefulWidget {
  const BlockedUsers({super.key});

  @override
  State<BlockedUsers> createState() {
    return _BlockedUsers();
  }
}

class _BlockedUsers extends State<BlockedUsers> {
  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      query: FirestoreService.instance.collectionQuery(
          path: FirestorePath.userblocks(),
          queryBuilder: (query) =>
              query.where('blockedby', isEqualTo: AuthMethods().uid)),
      itemBuilder: (context, snapshot) {
        String theidoffollower =
            (snapshot.data() as Map<String, dynamic>)['userid'] as String;
        Future<Theuser> model = Theuser.fromId(theidoffollower);

        return FutureBuilder(
            future: model,
            builder: (context, AsyncSnapshot<Theuser> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DecoratedBox(
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.4)),
                    child: GestureDetector(
                      onTap: () {
                        pushScreenWithoutNavBar(
                          context,
                          Material(
                            child: UserProfileV(
                                previous: '',
                                userData: snapshot.data!,
                                showappBar: true),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          ProfilePicSermon(
                              //id: snapshot.data!.id,
                              //url: snapshot.data!.profileImage,
                              size: 50),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  displayName(snapshot.data!.name),
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
                );
              } else if (snapshot.hasError) {
                return const Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 50,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                return const Center(child: CircularProgressIndicator());
              }
            });
      },
      emptyBuilder: (context) => const Text('Nothing to Show',
          style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }
}

class ChangeThemeColor extends StatefulWidget {
  const ChangeThemeColor({super.key});

  @override
  State<ChangeThemeColor> createState() {
    return _ChangeThemeColor();
  }
}

class _ChangeThemeColor extends State<ChangeThemeColor> {
  late String themeText;
  late bool currentTheme;

  @override
  void initState() {
    super.initState();
    var referencetoData = locator.get<LocalData>();

    if (referencetoData.currentColorTheme == 0) {
      currentTheme = false;
      themeText = 'dark';
    } else {
      currentTheme = true;
      themeText = 'light';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(themeText),
        Switch(
            // activeThumbColor: Colors.blueGrey,
            activeTrackColor: Colors.white,
            inactiveThumbColor: Colors.black,
            value: currentTheme,
            onChanged: (bool value) async {
              if (value) {
                SharedPreferences temp = await SharedPreferences.getInstance();
                temp.setInt("themeColor", 1);
                //  FirestoreService.instance.updateDocument(
                //    path: FirestorePath.user(AuthMethods().uid),
                //  data: {'themeColor': 1});

                setState(() {
                  themeText = 'light';
                  locator.get<LocalData>().currentColorTheme = 1;
                  locator.get<LocalData>().settingstoggle();
                  currentTheme = value;
                });
              } else {
                SharedPreferences temp = await SharedPreferences.getInstance();
                temp.setInt("themeColor", 0);
                //FirestoreService.instance.updateDocument(
                //  path: FirestorePath.user(AuthMethods().uid),
                // data: {'themeColor': 0});
                setState(() {
                  themeText = 'dark';
                  locator.get<LocalData>().currentColorTheme = 0;
                  locator.get<LocalData>().settingstoggle();
                  currentTheme = value;
                });
              }
            })
      ],
    );
  }
}

class AboutMeButton extends StatefulWidget {
  const AboutMeButton({super.key});

  @override
  State<AboutMeButton> createState() => _AboutMeButtonState();
}

class _AboutMeButtonState extends State<AboutMeButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
          width:
              locator.get<ScreenDimensions>().getDimensions(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              locator.get<FirestoreMethods>().userModel.bio,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
            onPressed: () => pushScreenWithoutNavBar(
                  context,
                  AboutMe(
                      bio: locator.get<FirestoreMethods>().userModel.bio,
                      id: AuthMethods().uid),
                ),
            child: const Text('Edit')),
      ],
    );
  }
}

class AboutMe extends StatefulWidget {
  final String id;
  final String bio;
  const AboutMe({required this.bio, required this.id, super.key});

  @override
  State<AboutMe> createState() {
    return _AboutMe();
  }
}

class _AboutMe extends State<AboutMe> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    _text = widget.bio;

    if (_text!.isEmpty) {
      _text = 'No Bio';
    }
  }

  String? _text;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.blueGrey,
          body: DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'My Bio:',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: locator
                              .get<ScreenDimensions>()
                              .getDimensions(context)
                              .size
                              .height *
                          0.75,
                      child: DecoratedBox(
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.4)),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              enableInteractiveSelection: true,
                              cursorColor: Colors.blueGrey,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              minLines: null,
                              maxLines: null,
                              expands: true,
                              initialValue: _text,
                              onChanged: (value) => setState(() {
                                _text = value;
                              }),
                            )),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            FirestoreService.instance.updateDocument(
                                path: FirestorePath.user(widget.id),
                                data: {'bio': _text});
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blueGrey[300]),
                          child: const Text('Save')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blueGrey[300]),
                          child: const Text('Cancel')),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
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
