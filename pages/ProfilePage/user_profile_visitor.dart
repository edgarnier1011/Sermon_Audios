import 'package:flutter/material.dart';
import 'package:sermons_audio/models/user_model.dart';
import 'package:sermons_audio/pages/ProfilePage/user_profile.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/resources/screen_dimensions.dart';
import 'package:sermons_audio/utils/profilepic.dart';

class UserProfileV extends StatefulWidget {
  final String previous;
  final Theuser userData;
  final bool showappBar;

  const UserProfileV(
      {required this.previous,
      required this.userData,
      required this.showappBar,
      super.key});

  @override
  State<UserProfileV> createState() => _UserProfileVState();
}

class _UserProfileVState extends State<UserProfileV> {
  Future<String>? checkifblocked;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: locator.get<LocalData>().changesettings,
          builder: (context, theValue, __) {
            return DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: locator.get<LocalData>().themeColorspallete[
                          locator.get<LocalData>().currentColorTheme],
                      stops: const [0.0, 0.15, 0.60, 1.0],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              child: PopScope(
                onPopInvoked: (bool didpop) async {
                  if (didpop) {
                    await locator
                        .get<FirestoreMethods>()
                        .checkIfFollowing(widget.previous);
                  }
                },
                child: DefaultTabController(
                    length: 6,
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(color: Colors.white),
                      child: Column(
                        children: [
                          widget.showappBar
                              ? AppBar(
                                  iconTheme:
                                      const IconThemeData(color: Colors.white),
                                  elevation: 0,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.4),
                                  title: const Text(
                                    'profile',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  actions: [
                                    IconButton(
                                        onPressed: () => Navigator.popUntil(
                                            context,
                                            (Route<dynamic> predicate) =>
                                                predicate.isFirst),
                                        icon: const Icon(
                                          Icons.home_filled,
                                          color: Colors.white,
                                        )),
                                  ],
                                )
                              : const SizedBox(),
                          Stack(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 125,
                                  ),
                                  Container(
                                    height: 175,
                                    width: queryData.size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.end,
                                        //   children: [
                                        //     (widget.userData.id !=
                                        //             AuthMethods().uid)
                                        //         ? FollowButton(
                                        //             userid: widget.userData.id)
                                        //         : const SizedBox(),
                                        //     (AuthMethods().uid !=
                                        //             widget.userData.id)
                                        //         ? Padding(
                                        //             padding:
                                        //                 const EdgeInsets.all(
                                        //                     8.0),
                                        //             child: ElevatedButton(
                                        //                 onPressed: () async {
                                        //                   String groupid = await locator
                                        //                       .get<
                                        //                           FirestoreMethods>()
                                        //                       .createChatGroup([
                                        //                     locator
                                        //                         .get<
                                        //                             FirestoreMethods>()
                                        //                         .userModel,
                                        //                     widget.userData
                                        //                   ]);
                                        //                   if (context.mounted) {
                                        //                     Navigator.push(
                                        //                         context,
                                        //                         MaterialPageRoute(
                                        //                             builder:
                                        //                                 (context) =>
                                        //                                     Material(
                                        //                                       child: ChatPage(group: groupid, name: '', members: [
                                        //                                         widget.userData.id,
                                        //                                         locator.get<FirestoreMethods>().userModel.id,
                                        //                                       ]),
                                        //                                     )));
                                        //                   }
                                        //                 },
                                        //                 style: ElevatedButton
                                        //                     .styleFrom(
                                        //                         foregroundColor:
                                        //                             Colors
                                        //                                 .white,
                                        //                         backgroundColor:
                                        //                             Colors.blueGrey[
                                        //                                 300]),
                                        //                 child: const Text(
                                        //                     "message")),
                                        //           )
                                        //         : const SizedBox(),
                                        //   ],
                                        // ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            (widget.userData.id !=
                                                    AuthMethods().uid)
                                                ? IconButton(
                                                    onPressed: () =>
                                                        showModalBottomSheet(
                                                            backgroundColor:
                                                                Colors.blueGrey,
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    Material(
                                                                      color: Colors
                                                                          .blueGrey,
                                                                      child:
                                                                          AlertDialog(
                                                                        backgroundColor: Colors
                                                                            .black
                                                                            .withOpacity(0.4),
                                                                        title:
                                                                            const Text(
                                                                          'Report User',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                        content:
                                                                            const Text(
                                                                          'Note: If you found something on the user profile that seems to go against our user agreement policy, which is located in your profile menu, please let us known in the text box.',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                        actions: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              GestureDetector(
                                                                                  onTap: () async {
                                                                                    bool checkif = await alreadyReporteduser(widget.userData.id);
                                                                                    if (!checkif) {
                                                                                      await FirestoreService.instance.addDocument(path: FirestorePath.userReports(), data: {
                                                                                        'userid': widget.userData.id,
                                                                                        'reportedby': AuthMethods().uid,
                                                                                      });
                                                                                    } else {
                                                                                      if (context.mounted) {
                                                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have already submitted a report for this user')));
                                                                                      }
                                                                                    }
                                                                                    if (context.mounted) {
                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  },
                                                                                  child: const Text('Confirm')),
                                                                              GestureDetector(onTap: () => Navigator.pop(context), child: const Text('Cancel')),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                    icon: Icon(
                                                      Icons.flag,
                                                      size: 20,
                                                      color: Colors.red
                                                          .withOpacity(0.8),
                                                    ))
                                                : const SizedBox(),
                                            (widget.userData.id !=
                                                    AuthMethods().uid)
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8,
                                                            right: 8,
                                                            bottom: 32),
                                                    child: BlockButton(
                                                        userid:
                                                            widget.userData.id),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                  top: 100,
                                  left: 20,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right:
                                                  queryData.size.width * 0.5),
                                          child: ProfilePicSermon(
                                            // id: widget.userData.profileImage,
                                            size: 100,
                                            //  url:
                                            //     widget.userData.profileImage
                                          ),
                                        ),
                                        SizedBox(
                                          width: queryData.size.width * 0.8,
                                          child: Text(
                                            textAlign: TextAlign.start,
                                            softWrap: false,
                                            displayName(widget.userData.name),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                          Container(
                            width: queryData.size.width,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4)),
                            child: const Center(
                              child: TabBar(
                                indicatorColor: Colors.white,
                                labelColor: Colors.white,
                                tabAlignment: TabAlignment.center,
                                tabs: [
                                  Tab(text: 'Texts'),
                                  Tab(text: 'Audios'),
                                  Tab(text: 'Authors'),
                                  Tab(text: 'Following'),
                                  Tab(text: 'Followers'),
                                  Tab(text: 'About me')
                                ],
                                isScrollable: true,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(children: [
                              MyTexts(
                                id: widget.userData.id,
                              ),
                              MyAudios(
                                userID: widget.userData.id,
                              ),
                              LikedAuthors(id: widget.userData.id),
                              MyFollowing(id: widget.userData.id),
                              MyFollowers(id: widget.userData.id),
                              AboutMeDisplay(
                                  bio: widget.userData.bio,
                                  id: widget.userData.id)
                            ]),
                          )
                        ],
                      ),
                    )),
              ),
            );
          }),
    );
  }
}

class FollowButton extends StatefulWidget {
  final String userid;
  const FollowButton({required this.userid, super.key});

  @override
  State<FollowButton> createState() {
    return _FollowButton();
  }
}

class _FollowButton extends State<FollowButton> {
  Future<String>? check;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    check = locator.get<FirestoreMethods>().checkIfFollowing(widget.userid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: check,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return (snapshot.data!.isEmpty)
                ? ElevatedButton(
                    onPressed: () async {
                      await locator
                          .get<FirestoreMethods>()
                          .follow(widget.userid);

                      setState(() {
                        check = locator
                            .get<FirestoreMethods>()
                            .checkIfFollowing(widget.userid);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueGrey[300]),
                    child: const Text('Follow'))
                : ElevatedButton(
                    onPressed: () async {
                      await locator
                          .get<FirestoreMethods>()
                          .unfollow(snapshot.data!, widget.userid);
                      setState(() {
                        check = locator
                            .get<FirestoreMethods>()
                            .checkIfFollowing(widget.userid);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueGrey[300]),
                    child: const Text("Unfollow"),
                  );
          } else if (snapshot.hasError) {
            return const Text("Some error occured in follow button",
                style: TextStyle(color: Colors.white));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class FollowButtonAuthor extends StatefulWidget {
  final String userid;
  final String authorid;
  final String authorName;
  const FollowButtonAuthor(
      {required this.authorName,
      required this.authorid,
      required this.userid,
      super.key});

  @override
  State<FollowButtonAuthor> createState() {
    return _FollowButtonAuthor();
  }
}

class _FollowButtonAuthor extends State<FollowButtonAuthor> {
  Future<String>? check;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    check =
        locator.get<FirestoreMethods>().checkifFollowingAuthor(widget.authorid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: check,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return ElevatedButton(
                onPressed: () async {
                  await locator
                      .get<FirestoreMethods>()
                      .followAuthor(widget.authorid, widget.authorName);

                  setState(() {
                    check = locator
                        .get<FirestoreMethods>()
                        .checkifFollowingAuthor(widget.authorid);
                  });
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueGrey[300]),
                child: const Text(
                  'Follow',
                ),
              );
            } else {
              return ElevatedButton(
                onPressed: () async {
                  await locator.get<FirestoreMethods>().unfollowAuthor(
                      snapshot.data!, widget.userid, widget.authorid);
                  setState(() {
                    check = locator
                        .get<FirestoreMethods>()
                        .checkifFollowingAuthor(widget.authorid);
                  });
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueGrey[300]),
                child: const Text("Unfollow"),
              );
            }
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error in follow',
                    style: TextStyle(color: Colors.white)));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class AboutMeDisplay extends StatefulWidget {
  final String id;
  final String bio;
  const AboutMeDisplay({required this.bio, required this.id, super.key});

  @override
  State<AboutMeDisplay> createState() {
    return _AboutMeDisplay();
  }
}

class _AboutMeDisplay extends State<AboutMeDisplay>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return
        //Scaffold(
        // body:
        DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('My Bio:'),
          ),
          SingleChildScrollView(
            child: SizedBox(
              width: locator
                  .get<ScreenDimensions>()
                  .getDimensions(context)
                  .size
                  .width,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.bio.isEmpty ? 'No Bio' : widget.bio,
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Future<bool> checkIfprofilestillexists(String userid) async {
  final snapshot = await FirestoreService.instance
      .collectionQuery(
          path: FirestorePath.user(userid),
          queryBuilder: ((query) => query.where('id', isEqualTo: userid)))
      .get();

  if (snapshot.docs.isEmpty) {
    return false;
  } else {
    return true;
  }
}

class BlockButton extends StatefulWidget {
  final String userid;
  const BlockButton({required this.userid, super.key});
  @override
  State<BlockButton> createState() {
    return _BlockButton();
  }
}

class _BlockButton extends State<BlockButton> {
  Future<bool>? checkifblocked;
  @override
  void initState() {
    super.initState();
    checkifblocked =
        locator.get<FirestoreMethods>().checkIfuserblocked(widget.userid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkifblocked,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data! == false) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red.withOpacity(0.8)),
                  onPressed: () async {
                    await locator
                        .get<FirestoreMethods>()
                        .blockUser(widget.userid);

                    setState(() {
                      checkifblocked = locator
                          .get<FirestoreMethods>()
                          .checkIfuserblocked(widget.userid);
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                  title: const Text("User has been blocked"),
                                  content: const Text(
                                      'User has been blocked, Content uploaded by user will no longer be visible, please give time to allow block action to take effect in Home Page content. You can unblock user by going to your profile, in blocked users section. In case you want block to take effect immediately, reset the application from your phone home menu'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Ok"))
                                  ])); //  showDialog(context: context, builder: builder)
                    });
                  },
                  child: const Text("Block"));
            } else {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueGrey[300]),
                  onPressed: () async {
                    await locator
                        .get<FirestoreMethods>()
                        .unblockUser(widget.userid);
                    setState(() {
                      checkifblocked = locator
                          .get<FirestoreMethods>()
                          .checkIfuserblocked(widget.userid);
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                  title: const Text("User has been unblocked"),
                                  content: const Text(
                                      'User has been unblocked, Content uploaded by user will be visible, please give time to allow block action to take effect in Home Page content. In case you want unblock to take effect immediately, reset the application from your phone home menu'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Ok"))
                                  ]));
                    });
                  },
                  child: const Text("Unblock"));
            }
          }
          if (snapshot.hasError) {
            return const Text(
              'Error',
              style: TextStyle(color: Colors.red),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

Future<bool> alreadyReporteduser(String userid) async {
  final snapshot = await FirestoreService.instance
      .collectionQuery(
          path: FirestorePath.userReports(),
          queryBuilder: (query) => query
              .where('reportedby', isEqualTo: AuthMethods().uid)
              .where('userid', isEqualTo: userid))
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
