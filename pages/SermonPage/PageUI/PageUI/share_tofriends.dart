import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sermons_audio/models/user_model.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/utils/profilepic.dart';

class ShareTextFollowers extends StatefulWidget {
  final String id;
  final String textid;
  final String title;
  const ShareTextFollowers(
      {required this.id, super.key, required this.textid, required this.title});

  @override
  State<ShareTextFollowers> createState() {
    return _ShareTextFollowers();
  }
}

class _ShareTextFollowers extends State<ShareTextFollowers>
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
                        String casewhennameislarge = '';

                        if (locator
                                .get<FirestoreMethods>()
                                .userModel
                                .name
                                .length >
                            20) {
                          casewhennameislarge = locator
                              .get<FirestoreMethods>()
                              .userModel
                              .name
                              .substring(0, 20);
                        }
                        FirestoreService.instance.addDocument(
                            path: FirestorePath.notifications(),
                            data: {
                              'notificationTo': snapshot.data!.id,
                              'date': DateTime.now(),
                              'notifiedBy': AuthMethods().uid,
                              'textid': widget.textid,
                              'type': 'share-text',
                              'name': casewhennameislarge.isEmpty
                                  ? locator
                                      .get<FirestoreMethods>()
                                      .userModel
                                      .name
                                  : casewhennameislarge,
                              'data': casewhennameislarge.isEmpty
                                  ? '${locator.get<FirestoreMethods>().userModel.name} shared a text with you, ${widget.title}'
                                  : '$casewhennameislarge shared a text with you, ${widget.title}'
                            });
                        FirestoreService.instance.addDocument(
                            path: FirestorePath.userNotifications(
                                snapshot.data!.id),
                            data: {
                              'date': DateTime.now(),
                              'notifiedBy': AuthMethods().uid,
                              'textid': widget.textid,
                              'type': 'share-text',
                              'name': casewhennameislarge.isEmpty
                                  ? locator
                                      .get<FirestoreMethods>()
                                      .userModel
                                      .name
                                  : casewhennameislarge,
                              'data': casewhennameislarge.isEmpty
                                  ? '${locator.get<FirestoreMethods>().userModel.name} shared a text with you, ${widget.title}'
                                  : '$casewhennameislarge shared a text with you, ${widget.title}'
                            });
                        //if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Shared!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        //}
                      },
                      child: Row(
                        children: [
                          ProfilePicSermon(
                              //  id: snapshot.data!.id,
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
                                    color: Colors.white,
                                    fontSize: 14,
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

String displayName(String nameFromdatabase) {
  String finalString = '';
  List<String> tokensname = nameFromdatabase.split(' ');
  for (int i = 0; i < tokensname.length; i++) {
    finalString =
        '$finalString${tokensname[i][0].toUpperCase()}${tokensname[i].substring(1)} ';
  }

  return finalString.trimRight();
}
