import 'package:flutter/material.dart';
import 'package:sermons_audio/models/user_model.dart';
import 'package:sermons_audio/pages/ProfilePage/user_profile_visitor.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/utils/profilepic.dart';

class UserProfileSermon extends StatefulWidget {
  final String id;
  final bool showappBar;

  const UserProfileSermon(
      {required this.showappBar, required this.id, super.key});

  @override
  State<UserProfileSermon> createState() => _UserProfileSermonState();
}

class _UserProfileSermonState extends State<UserProfileSermon>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return FutureBuilder(
        future: Theuser.fromId(widget.id),
        builder: (context, AsyncSnapshot<Theuser> snapshot) {
          if (snapshot.hasData) {
            return DefaultTabController(
                length: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.showappBar
                        ? AppBar(
                            iconTheme: const IconThemeData(color: Colors.white),
                            title: const Text('profile'),
                          )
                        : const SizedBox(),
                    Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: queryData.size.width,
                              height: 125,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4)),
                              /*child: BannerPicSermon(
                                  size: queryData.size.width,
                                  id: snapshot.data!.id,
                                  url: snapshot.data!.bannerImage),*/
                            ),
                            Container(
                              width: queryData.size.width,
                              height: 175,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Builder(builder: (context) {
                                          return (widget.id !=
                                                  AuthMethods().uid)
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      top: queryData
                                                              .size.height *
                                                          0.10),
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              foregroundColor:
                                                                  Colors.white,
                                                              backgroundColor:
                                                                  Colors.blueGrey[
                                                                      300]),
                                                      onPressed: AuthMethods()
                                                              .uid
                                                              .isNotEmpty
                                                          ? () =>
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          Material(
                                                                              child:
                                                                                  UserProfileV(
                                                                            previous:
                                                                                AuthMethods().uid,
                                                                            showappBar:
                                                                                true,
                                                                            userData:
                                                                                snapshot.data!,
                                                                          ))))
                                                          : () => showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        const AlertDialog(
                                                                  title: Text(
                                                                      'Register'),
                                                                  content: Text(
                                                                      'Register to see profiles'),
                                                                ),
                                                              ),
                                                      child: const Text(
                                                          'See Profile')),
                                                )
                                              : const SizedBox();
                                        }),
                                      ]),
                                ],
                              ),
                            )
                          ],
                        ),
                        Positioned(
                            top: 100,
                            left: 20,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: queryData.size.width * 0.5),
                                      child: ProfilePicSermon(
                                        // id: snapshot.data!.id,
                                        size: 100,
                                        // url: snapshot.data!.profileImage
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: queryData.size.width * 0.80,
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    displayName(snapshot.data!.name),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ],
                ));
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Profile Not Available',
                  style: TextStyle(color: Colors.white)),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
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
