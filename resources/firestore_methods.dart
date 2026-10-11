import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sermons_audio/models/author_model.dart';
import 'package:sermons_audio/models/chat_group_data_model.dart';
import 'package:sermons_audio/models/chat_group_model.dart';
import 'package:sermons_audio/models/chat_model.dart';
import 'package:sermons_audio/models/user_model.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FirestoreMethods {
  final FirestoreService _firestore = FirestoreService.instance;
  late Theuser userModel;
  late StreamSubscription _userSubscription;
  late String currentversionvalue;

  Future<void> cancelSubscription() async {
    await _userSubscription.cancel();
  }

  //data initialization when login occurs
  Future<bool> initializeUser(User user) async {
    _userSubscription = _firestore
        .documentStream(
            path: FirestorePath.currUser(),
            builder: (data) => Theuser.fromSnap(data))
        .listen((event) {
      userModel = event;
    });
    Theuser? checkUser = await _firestore.documentFuture(
        path: FirestorePath.currUser(),
        builder: (data) => Theuser.fromSnap(data));
    if (checkUser == null) {
      userModel = Theuser(
        id: user.uid,
        email: user.email!,
      );
      await _firestore.addDocument(
        path: FirestorePath.userC(),
        data: userModel.toJson(),
        myId: user.uid,
      );
    } else {
      userModel = checkUser;
    }

    locator.get<LocalData>().changeProfilePic(userModel.profileImage);

    if (!kIsWeb) {
      //To send Notifications to Device, get the device token and store it in the database
      String? temp1 = await temp();
      // check current version
      PackageInfo theversion = await PackageInfo.fromPlatform();
      currentversionvalue = theversion.version;
      // goes in navigation screen
      String temp2 = await checkIfdeviceexists(temp1!);

      if (temp2.isEmpty) {
        await FirestoreService.instance.addDocument(
            path: FirestorePath.userDevices(userModel.id),
            data: {
              'deviceNumber': temp1,
              'lastActive': DateTime.now(),
              'myid': userModel.id
            });
        await FirestoreService.instance.updateDocument(
            path: FirestorePath.currUser(), data: {'letfcms': temp1});
      } else {
        await FirestoreService.instance.updateDocument(
            path: FirestorePath.userDevicesspecific(userModel.id, temp2),
            data: {'lastActive': DateTime.now()});

        await FirestoreService.instance.updateDocument(
            path: FirestorePath.currUser(), data: {'letfcms': temp1});
      }
    }
    //returns a value to indicate that the initialization is complete and the user can proceed to the next screen.
    return true;
  }

  //Search Text by author name.
  Stream<List<Author>> authorSearch(int limit, String? textSearch) {
    if (textSearch?.isNotEmpty == true && textSearch!.length > 2) {
      textSearch[0].toUpperCase();
      return _firestore
          .collectionStream(
            path: FirestorePath.authorsadd(),
            queryBuilder: (query) => query
                .limit(limit)
                .where('name', isGreaterThanOrEqualTo: textSearch)
                .where('name', isLessThanOrEqualTo: ('$textSearch\uf8ff')),
            builder: (data) => Author.fromsnap(data),
          )
          .asBroadcastStream();
    } else {
      return _firestore
          .collectionStream(
            path: FirestorePath.authorsadd(),
            queryBuilder: (query) => query.limit(limit),
            builder: (data) => Author.fromsnap(data),
          )
          .asBroadcastStream();
    }
  }

  //Follow feature to follow other users.
  Future<void> follow(String id) async {
    WriteBatch batch = _firestore.newBatch();
    _firestore.addDocument(
      path: FirestorePath.follows(),
      data: {
        'follower': userModel.id,
        'following': id,
      },
      batch: batch,
    );
    _firestore.updateDocument(
      path: FirestorePath.currUser(),
      data: {
        'followingCnt': FieldValue.increment(1),
      },
      batch: batch,
    );
    _firestore.updateDocument(
      path: FirestorePath.user(id),
      data: {
        'followerCnt': FieldValue.increment(1),
      },
      batch: batch,
    );
    batch.commit();
  }

  Future<void> unfollow(String docId, String id) async {
    WriteBatch batch = _firestore.newBatch();
    await _firestore.deleteDocument(
      path: FirestorePath.follow(docId),
      batch: batch,
    );
    await _firestore.updateDocument(
      path: FirestorePath.currUser(),
      data: {
        'followingCnt': FieldValue.increment(-1),
      },
      batch: batch,
    );
    await _firestore.updateDocument(
      path: FirestorePath.user(id),
      data: {
        'followerCnt': FieldValue.increment(-1),
      },
      batch: batch,
    );
    batch.commit();
  }

  //checks if a user is being followed, to decide whether to show follow or unfollow button.
  Future<String> checkIfFollowing(String id) async {
    final snapshot = await _firestore
        .collectionQuery(
            path: FirestorePath.follows(),
            queryBuilder: (query) => query
                .where('follower', isEqualTo: userModel.id)
                .where('following', isEqualTo: id))
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    } else {
      return '';
    }
  }

  Future<void> likePost(
      String submitterid, String textid, String userid, String title) async {
    String casewherenameislarge = '';
    DateTime now = DateTime.now();
    await _firestore.addDocument(path: FirestorePath.likes(), data: {
      'dateLiked': now,
      'textid': textid,
      'likedby': userid,
      'submittedby': submitterid,
    });

    await _firestore.updateDocument(
        path: FirestorePath.getText(textid),
        data: {'likes': FieldValue.increment(1)});
    if (submitterid != userid) {
      if (userModel.name.length > 20) {
        casewherenameislarge = userModel.name.substring(0, 20);
      }
      FirestoreService.instance
          .addDocument(path: FirestorePath.notifications(), data: {
        'notificationTo': submitterid,
        'onDate': now,
        'notifiedBy': userid,
        'textid': textid,
        'type': 'text',
        'name': casewherenameislarge.isEmpty
            ? userModel.name
            : casewherenameislarge,
        'data': casewherenameislarge.isEmpty
            ? '${userModel.name} likes your text, $title'
            : '$casewherenameislarge likes your text, $title',
      });

      FirestoreService.instance.addDocument(
          path: FirestorePath.userNotifications(submitterid),
          data: {
            'myid': submitterid,
            'text': textid,
            'likedby': casewherenameislarge.isEmpty
                ? userModel.name
                : casewherenameislarge,
            'date': now,
            'notifiedBy': userid,
            'data': casewherenameislarge.isEmpty
                ? '${userModel.name} likes your text, $title'
                : '$casewherenameislarge likes your text, $title',
            'title': title,
            'type': 'text',
          });
    }
  }

  Future<void> unlikePost(String likeid, String textid) async {
    _firestore.deleteDocument(path: FirestorePath.likesgetdata(likeid));

    _firestore.updateDocument(
        path: FirestorePath.gettextdata(textid),
        data: {'likes': FieldValue.increment(-1)});
  }

  Future<String> checkifLikedpost(
    String textid,
  ) async {
    final snapshot = await _firestore
        .collectionQuery(
            path: FirestorePath.likes(),
            queryBuilder: (query) => query
                .where('textid', isEqualTo: textid)
                .where('likedby', isEqualTo: AuthMethods().uid))
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    } else {
      return "";
    }
  }

  Future<void> likeAudiopost(String userid, String audioid, String submitterid,
      String textid, String title) async {
    String casewherenameislarge = '';
    DateTime now = DateTime.now();
    _firestore.addDocument(path: FirestorePath.audiolikes(), data: {
      'audioid': audioid,
      'textid': textid,
      'dateLiked': now,
      'audioId': audioid,
      'likedby': userid,
      'submittedby': submitterid,
    });

    _firestore.updateDocument(
        path: FirestorePath.audiogetdata(audioid),
        data: {'likes': FieldValue.increment(1)});
    if (submitterid != userid) {
      if (userModel.name.length > 20) {
        casewherenameislarge = userModel.name.substring(0, 20);
      }
      FirestoreService.instance
          .addDocument(path: FirestorePath.notifications(), data: {
        'notificationTo': submitterid,
        'onDate': now,
        'notifiedBy': userid,
        'audioid': audioid,
        'textid': textid,
        'type': 'audio',
        'name': casewherenameislarge.isEmpty
            ? userModel.name
            : casewherenameislarge,
        'data': casewherenameislarge.isEmpty
            ? '${userModel.name} likes your audio from text, $title'
            : '$casewherenameislarge likes your audio from text, $title'
      });
      //data for user notifications on the device.
      FirestoreService.instance.addDocument(
          path: FirestorePath.userNotifications(submitterid),
          data: {
            'audio': audioid,
            'likedby': casewherenameislarge.isEmpty
                ? userModel.name
                : casewherenameislarge,
            'date': now,
            'notifiedBy': userid,
            'data': casewherenameislarge.isEmpty
                ? '${userModel.name} likes your audio from text, $title'
                : '$casewherenameislarge likes your audio from text, $title',
            'title': title,
            'type': 'audio',
          });
    }
  }

  Future<void> unlikeAudiopost(String audiolikeid, String audioid) async {
    _firestore.deleteDocument(
        path: FirestorePath.audiolikesgetdata(audiolikeid));

    _firestore.updateDocument(
        path: FirestorePath.audiogetdata(audioid),
        data: {'likes': FieldValue.increment(-1)});
  }

  Future<String> checkifLikedAudiopost(
    String audioid,
  ) async {
    final snapshot = await _firestore
        .collectionQuery(
            path: FirestorePath.audiolikes(),
            queryBuilder: (query) => query
                .where('audioId', isEqualTo: audioid)
                .where('likedby', isEqualTo: AuthMethods().uid))
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    } else {
      return "";
    }
  }

  Future<String> followAuthor(String authorid, String authorName) async {
    String documentauthorID = await _firestore.addDocument(
      path: FirestorePath.authorfollows(),
      data: {
        'authorName': authorName,
        'follower': userModel.id,
        'following': authorid,
      },
    );

    _firestore.updateDocument(
      path: FirestorePath.authorsgetdata(authorid),
      data: {
        'followers': FieldValue.increment(1),
      },
    );

    return documentauthorID;
  }

  Future<void> unfollowAuthor(String docId, String id, String authorid) async {
    _firestore.deleteDocument(
      path: FirestorePath.authorfollowsD(docId),
    );

    _firestore.updateDocument(
      path: FirestorePath.authorsgetdata(authorid),
      data: {
        'followers': FieldValue.increment(-1),
      },
    );
  }

  Future<String> checkifFollowingAuthor(
    String authorid,
  ) async {
    final snapshot = await _firestore
        .collectionQuery(
            path: FirestorePath.authorfollows(),
            queryBuilder: (query) => query
                .where('following', isEqualTo: authorid)
                .where('follower', isEqualTo: AuthMethods().uid))
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    } else {
      return '';
    }
  }

  //Old manner to set user preferences. It utilized a database, but it was incorrectly implemented. The new method uses shared preferences to store user preferences locally on the device, which is more efficient and reliable.
  Future<void> setUserNameandLanguage(
      String firstname, String secondname) async {
    return await _firestore.updateDocument(
        path: FirestorePath.user(AuthMethods().uid),
        data: {
          'name': '$firstname $secondname',
          'prefferedLanguage': 'English'
        });
  }

  Future<void> setprefferedLanguage(String language) {
    return _firestore.updateDocument(
        path: FirestorePath.user(userModel.id),
        data: {'prefferedLanguage': language});
  }

  //From lines 411 to 562 are the methods for the chat feature, which includes sending messages, creating chat groups, and retrieving chat data. It was removed from previous version because
  //users were not using it. It also requires more code organization for future references in case it is to be used again. It is also not a priority for the app's current functionality.
  Stream<List<ChatGroupData>> getChatDataStream() {
    return _firestore.collectionStream(
      path: FirestorePath.chatGroupDatas(userModel.id),
      builder: (data) => ChatGroupData.fromSnap(data),
      queryBuilder: (query) => query.orderBy('time', descending: true),
    );
  }

  Stream<ChatGroup> getChatGroupStream(String id) {
    return _firestore.documentStream(
        path: FirestorePath.chatGroup(id),
        builder: (data) => ChatGroup.fromSnap(data));
  }

  Future<ChatGroup?> getChatGroup(String id) {
    return _firestore.documentFuture(
      path: FirestorePath.chatGroup(id),
      builder: (data) => ChatGroup.fromSnap(data),
    );
  }

  Stream<List<ChatModel>> getChatStream(String id) {
    return _firestore.collectionStream(
      path: FirestorePath.chats(),
      queryBuilder: (query) => query.where('to', isEqualTo: id),
      builder: (data) {
        return ChatModel.fromSnap(data);
      },
      sort: (lhs, rhs) => rhs.time!.compareTo(lhs.time!),
    );
  }

  Future<void> sendChatMessage(
      String text, String chatGroupId, String nameid) async {
    DateTime time = DateTime.now();
    await _firestore.addDocument(
      path: FirestorePath.chats(),
      data: ChatModel(
        to: chatGroupId,
        from: userModel.id,
        text: text,
        time: time,
      ).toJson(),
    );

    ChatGroup? group = await _firestore.documentFuture(
      path: FirestorePath.chatGroup(chatGroupId),
      builder: (data) => ChatGroup.fromSnap(data),
    );

    if (group!.messagesCount <= 0) {
      await _firestore
          .updateDocument(path: FirestorePath.chatGroup(chatGroupId), data: {
        'latestText': text,
        'latestId': userModel.id,
        'messageCount': FieldValue.increment(1),
        'subProfile': nameid
      });
    }

    await _firestore
        .updateDocument(path: FirestorePath.chatGroup(chatGroupId), data: {
      'messageCount': FieldValue.increment(1),
    });

    for (String userId in group.members.keys) {
      ChatGroupData? data = await _firestore.documentFuture(
        path: FirestorePath.chatGroupData(userId, chatGroupId),
        builder: (data) => ChatGroupData.fromSnap(data),
      );
      if (data == null) {
        String name = "";
        for (String i in group.members.keys) {
          Theuser user = await Theuser.fromId(i);
          if (user.id != userId) {
            if (name != "") {
              name += ", ${user.name}";
            } else {
              name += user.name;
            }
          }
        }
        await _firestore.addDocument(
          path: FirestorePath.chatGroupDatas(userId),
          data: ChatGroupData(
            myid: userModel.id,
            nameid: nameid,
            name: name,
            unopenedMessages: 0,
            time: DateTime.now(),
          ).toJson(),
          myId: chatGroupId,
        );
      }
      _firestore.updateDocument(
        path: FirestorePath.chatGroupData(userId, chatGroupId),
        data: {
          'unopenedMessages':
              FieldValue.increment(userId != userModel.id ? 1 : 0),
          'time': DateTime.now(),
        },
      );
    }
  }

  Future<String> createChatGroup(List<Theuser> members) async {
    Map<String, dynamic> m = {};
    String groupName = "";
    for (int i = 0; i < members.length; i++) {
      Theuser user = members[i];
      m.addAll({user.id: 0});
      if (groupName == "") {
        groupName += user.name;
      } else {
        groupName += ", ${user.name}";
      }
    }
    List<ChatGroup> groups = await _firestore.collectionFuture(
      path: FirestorePath.chatGroups(),
      queryBuilder: (query) => query.where('members', isEqualTo: m),
      builder: (data) => ChatGroup.fromSnap(data),
    );
    //to collection if it does not exists, new chat and get id created by firebase
    if (groups.isEmpty) {
      List<Theuser> temp =
          members.where((element) => element.id != userModel.id).toList();
      String mainProf = temp[0].profileImage;
      String subProf = "";
      if (members.length > 2) {
        subProf = temp[1].profileImage;
      }

      return await _firestore.addDocument(
        path: FirestorePath.chatGroups(),
        data: ChatGroup(
          members: m,
          name: groupName,
          latestProfile: mainProf,
          subProfile: subProf,
        ).toJson(),
      );
    } else {
      //get existing file, existing chat, and get existing id created from firebase too
      ChatGroup? group = await _firestore.documentFuture(
        path: FirestorePath.chatGroup(groups.first.id),
        builder: (data) => ChatGroup.fromSnap(data),
      );
      return group!.id;
    }
  }

  Stream<List<Theuser>> userSearch(int limit, String? textSearch) {
    if (textSearch?.isNotEmpty == true) {
      Stream<List<Theuser>> two = _firestore.collectionStream(
          path: FirestorePath.userC(),
          queryBuilder: (query) => query.limit(limit).where(
                'name',
                isGreaterThanOrEqualTo: textSearch!.toLowerCase(),
              ),
          builder: (data) {
            return Theuser.fromSnap(data);
          });
      // return MergeStream([one, two]).asBroadcastStream();
      return two.asBroadcastStream();
    } else {
      return _firestore
          .collectionStream(
            path: FirestorePath.userC(),
            queryBuilder: (query) => query.limit(limit),
            builder: (data) => Theuser.fromSnap(data),
          )
          .asBroadcastStream();
    }
  }

  Future<String?> temp() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<String> checkIfdeviceexists(String device) async {
    final snapshot = await FirestoreService.instance
        .collectionQuery(
            path: FirestorePath.userDevices(AuthMethods().uid),
            queryBuilder: (query) {
              return query.where('deviceNumber', isEqualTo: device);
            })
        .get();

    if (snapshot.docs.isEmpty) {
      return '';
    } else {
      return snapshot.docs.first.id;
    }
  }

  Future<void> deleteAccount() async {
    FirestoreService.instance.addDocument(
        path: ('UserDeletes'),
        data: {'userid': AuthMethods().uid, 'time': DateTime.now()});
    await cancelSubscription();
    await FirebaseAuth.instance.currentUser!.delete();
    //await AuthMethods().currentUser.reload();
  }

  Future<bool> checkIfuserblocked(String userId) async {
    SharedPreferences temp = await SharedPreferences.getInstance();

    List<String>? listblockedUsers = temp.getStringList('blockedUsers');

    if (listblockedUsers!.contains(userId)) {
      debugPrint('hihghg');
      return true;
    } else {
      debugPrint('hiiioipphghg');

      return false;
    }
  }

  Future<void> blockUser(String userId) async {
    SharedPreferences temp = await SharedPreferences.getInstance();
    List<String> blockedUsers = temp.getStringList("blockedUsers")!;
    if (!blockedUsers.contains(userId)) {
      blockedUsers.add(userId);
      temp.setStringList('blockedUsers', blockedUsers);
    }
  }

  Future<void> unblockUser(String docId) async {
    SharedPreferences temp = await SharedPreferences.getInstance();
    List<String>? listofBlocked = temp.getStringList("blockedUsers");
    listofBlocked!.remove(docId);
  }

  Future<void> currentversion(BuildContext context) async {
    _firestore.documentFuture(
        path: 'Announcement/5YCftyZHRDyEbnZSmO7o',
        builder: (data) {
          Timer.run(() {
            if (data['version'] != currentversionvalue) {
              showDialog(
                  barrierDismissible: data['allowdismissial'],
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text(data['type']),
                        content: Text(data['text']),
                        actions: [
                          (Platform.isIOS)
                              ? TextButton(
                                  onPressed: () async {
                                    final Uri url =
                                        Uri.parse(data['storelink']);
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                  child: const Text('Go to store'))
                              : const SizedBox(),
                        ]);
                  });
            }
          });
        });
  }
}
