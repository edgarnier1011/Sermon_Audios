import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sermons_audio/models/audio_model.dart';
import 'package:sermons_audio/models/sermon_model.dart';
import 'package:sermons_audio/models/user_model.dart';
import 'package:sermons_audio/pages/ProfilePage/user_profile_audio.dart';
import 'package:sermons_audio/pages/ProfilePage/user_profile_visitor.dart';
import 'package:sermons_audio/pages/SermonPage/PageUI/PageUI/sermon_page.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/screen_dimensions.dart';

class UserNotifications {
  //final String myid;
  final String documentid;
  final String likedby; //name
  final DateTime? date;
  final String notifiedBy;
  final String data; //name
  final String title;
  final String type;
  UserNotifications({
    // required this.myid,
    required this.documentid,
    required this.likedby,
    required this.date,
    required this.notifiedBy,
    required this.data,
    required this.title,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      //'myid': myid,
      'documentid': documentid,
      'likedby': likedby,
      'date': date,
      'notifiedBy': notifiedBy,
      'data': data,
      'title': title,
      'type': type,
    };
  }

  static UserNotifications fromJson(Map<String, dynamic> json) {
    return UserNotifications(
      // myid: json['myid'] ?? '',
      documentid: json['documentid'] ?? '',
      likedby: json['likedby'] ?? '',
      date: json['date'] != null ? (json['date'] as Timestamp).toDate() : null,
      notifiedBy: json['notifiedBy'] ?? '',
      data: json['data'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class UserNotificationDisplay extends StatefulWidget {
  final UserNotifications notification;
  const UserNotificationDisplay({super.key, required this.notification});
  @override
  State<UserNotificationDisplay> createState() => _UserNotificationDisplay();
}

class _UserNotificationDisplay extends State<UserNotificationDisplay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.notification.type == 'text'
          ? () async {
              Theuser temp =
                  await Theuser.fromId(widget.notification.notifiedBy);
              if (context.mounted) {
                pushScreenWithoutNavBar(
                  context,
                  UserProfileV(
                    previous: '',
                    userData: temp,
                    showappBar: true,
                  ),
                );
              }
            }
          : widget.notification.type == 'audio'
              ? () async {
                  Theuser temp =
                      await Theuser.fromId(widget.notification.notifiedBy);
                  if (context.mounted) {
                    pushScreenWithoutNavBar(
                      context,
                      UserProfileV(
                        previous: '',
                        userData: temp,
                        showappBar: true,
                      ),
                    );
                  }
                }
              : widget.notification.type == 'share-text'
                  ? () async {
                      DocumentParagraphs temp = await DocumentParagraphs.fromId(
                          widget.notification.documentid);
                      if (context.mounted) {
                        pushScreenWithoutNavBar(
                          context,
                          SermonPageFinal(
                            alldataofsermon: temp,
                          ),
                        );
                      }
                    }
                  : widget.notification.type == 'share-audio'
                      ? () async {
                          AudioCreate? temp = await AudioCreate.fromID(
                              widget.notification.documentid);
                          if (context.mounted) {
                            pushScreenWithoutNavBar(
                              context,
                              AudioProfileSelect(
                                  title: temp!.sermonName,
                                  narratorid: temp.userid,
                                  audioid: temp.id,
                                  audioUrl: temp.urlfromstorage,
                                  textid: temp.textid),
                            );
                          }
                        }
                      : widget.notification.type == 'text-admin'
                          ? null
                          : widget.notification.type == 'audio-admin'
                              ? null
                              : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width:
              locator.get<ScreenDimensions>().getDimensions(context).size.width,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                widget.notification.type == 'text'
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.textsms_sharp,
                          color: Colors.white,
                        ),
                      )
                    : widget.notification.type == 'audio'
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.audio_file_sharp,
                              color: Colors.white,
                            ),
                          )
                        : widget.notification.type == 'share-text'
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                              )
                            : widget.notification.type == 'share-audio'
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                  )
                                : widget.notification.type == 'text-admin'
                                    ? const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.approval,
                                          color: Colors.white,
                                        ),
                                      )
                                    : widget.notification.type == 'audio-admin'
                                        ? const Icon(
                                            Icons.approval,
                                            color: Colors.white,
                                          )
                                        : const SizedBox(),
                Expanded(
                  child: Text(
                    widget.notification.data,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat.yMMMd()
                        .add_jm()
                        .format(widget.notification.date ??
                            DateTime.now().toLocal())
                        .toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
