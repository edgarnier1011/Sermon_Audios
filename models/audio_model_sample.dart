import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';

class AudioCreateSample {
  final String id;
  final String urlfromstorage;
  final String userid;
  final String textid;
  final String nameOfnarrator;
  final int likes;
  final DateTime? datesubmit;
  final String nameofAuthor;
  final List<String> userlikesList;
  final String language;
  final String sermonName;
  final String audioIDorigin;
  final bool approval;
  final bool newAudio;

  const AudioCreateSample(
      {required this.newAudio,
      required this.approval,
      required this.audioIDorigin,
      required this.sermonName,
      required this.language,
      required this.nameofAuthor,
      required this.nameOfnarrator,
      this.likes = 0,
      this.userlikesList = const [],
      required this.datesubmit,
      required this.urlfromstorage,
      this.id = '',
      required this.textid,
      required this.userid});

  Map<String, dynamic> toJson() {
    return ({
      'newAudio': newAudio,
      'approval': approval,
      'language': language,
      'nameofAuthor': nameofAuthor,
      'nameOfnarrator': nameOfnarrator,
      'userlikesList': userlikesList,
      'likes': likes,
      'datesubmit': datesubmit,
      'id': id,
      'userid': userid,
      'textid': textid,
      'urlfromstorage': urlfromstorage,
      'sermonName': sermonName,
      'audioIDorigin': audioIDorigin
    });
  }

  static AudioCreateSample fromsnap(Map<String, dynamic> snap) {
    List<String> userlikeslist = [];

    for (int i = 0; i < snap['userlikesList'].length; i++) {
      userlikeslist.add(snap['userlikesList'][i]);
    }
    return AudioCreateSample(
        newAudio: snap['newAudio'] ?? true,
        approval: snap['approval'] ?? false,
        audioIDorigin: snap['audioIDorigin'],
        language: snap['language'] ?? 'any',
        nameofAuthor: snap['nameofAuthor'] ?? 'not ava',
        nameOfnarrator: snap['nameOfnarrator'] ?? 'Not available',
        userlikesList: userlikeslist,
        likes: snap['likes'],
        datesubmit: snap['datesubmit'] != null
            ? (snap['datesubmit'] as Timestamp).toDate()
            : null,
        urlfromstorage: snap['urlfromstorage'],
        id: snap['id'],
        textid: snap['textid'],
        userid: snap['userid'],
        sermonName: snap['sermonName']);
  }

  static Future<AudioCreateSample?> fromID(String audioid) async {
    AudioCreateSample? temp;
    temp = await FirestoreService.instance.documentFuture(
        path: FirestorePath.audiogetdata(audioid),
        builder: (data) => AudioCreateSample.fromsnap(data));

    return temp;
  }
}
