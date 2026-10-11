import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';

class DocumentParagraphs {
  final String authorName;
  final String sermonName;
  final String id;
  final List<String> paragraphs;
  final String authorid;
  final List<String> tags;
  final String language;
  final String userid;
  final DateTime? dateSubmit;
  final int likes;
  final int audiosCount;
  final String latestAudiourl;
  final String latestnarratorid;
  final String latestAudioid;
  final String latestnarratorName;
  final String submitterName;
  final bool approval;

  const DocumentParagraphs({
    this.latestnarratorName = '',
    this.latestAudioid = '',
    this.latestnarratorid = '',
    this.latestAudiourl = '',
    this.audiosCount = 0,
    this.likes = 0,
    required this.dateSubmit,
    required this.language,
    required this.tags,
    required this.authorid,
    required this.authorName,
    required this.id,
    required this.paragraphs,
    required this.sermonName,
    required this.userid,
    required this.submitterName,
    this.approval = false,
  });

  Map<String, dynamic> toJson() {
    return ({
      'latestnarratorName': latestnarratorName,
      'latestAudioid': latestAudioid,
      'submitterName': submitterName,
      'latestnarratorid': latestnarratorid,
      'latestAudiourl': latestAudiourl,
      'audiosCount': audiosCount,
      'likes': likes,
      'authorName': authorName,
      'paragraphs': paragraphs,
      'sermonName': sermonName,
      'id': id,
      'authorid': authorid,
      'tags': tags,
      'language': language,
      'userid': userid,
      'dateSubmit': dateSubmit,
      'approval': approval,
    });
  }

  static DocumentParagraphs fromSnap(Map<String, dynamic> snap) {
    List<String> theparagraphs = [];
    List<String> thetags = [];
    for (int i = 0; i < snap['paragraphs'].length; i++) {
      theparagraphs.add(snap['paragraphs'][i]);
    }

    for (int i = 0; i < snap['tags'].length; i++) {
      thetags.add(snap['tags'][i]);
    }

    return DocumentParagraphs(
      latestnarratorName: snap['latestnarratorName'] ?? 'notavailable',
      latestAudioid: snap['latestAudioid'] ?? 'noaudio',
      submitterName: snap['submitterName'] ?? 'Temp',
      latestnarratorid: snap['latestnarratorid'],
      latestAudiourl: snap['latestAudiourl'],
      audiosCount: snap['audiosCount'] ?? 0,
      likes: snap['likes'],
      dateSubmit: snap['dateSubmit'] != null
          ? (snap['dateSubmit'] as Timestamp).toDate()
          : null,
      authorName: snap['authorName'] as String,
      paragraphs: theparagraphs,
      sermonName: snap['sermonName'] as String,
      id: snap['id'],
      authorid: snap['authorid'] as String,
      tags: thetags,
      language: snap['language'],
      userid: snap['userid'] ?? '',
      approval: snap['approval'] ?? false,
    );
  }

  static Future<DocumentParagraphs> fromId(String textid) async {
    DocumentParagraphs? temp;
    await FirestoreService.instance.documentFuture(
        path: FirestorePath.gettextdata(textid),
        builder: (data) => temp = DocumentParagraphs.fromSnap(data));

    return temp!;
  }

  static Future<DocumentParagraphs> fromIdTextInitial(String textid) async {
    DocumentParagraphs? temp;
    await FirestoreService.instance.documentFuture(
        path: FirestorePath.getText(textid),
        builder: (data) => temp = DocumentParagraphs.fromSnap(data));

    return temp!;
  }

  static Future<void> addaudio(
      String authorid, String textid, String userId, String audioID) async {
    await FirebaseFirestore.instance
        .collection(FirestorePath.authorsaddid(
          authorid,
        ))
        .doc(textid)
        .set({
      'audios': {userId: audioID}
    }, SetOptions(merge: true));
  }
}
