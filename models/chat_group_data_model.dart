import 'package:cloud_firestore/cloud_firestore.dart';

class ChatGroupData {
  final String id;
  final String name; //of other user
  final String nameid; //of other user
  final int unopenedMessages;
  final DateTime? time;
  final String myid;

  const ChatGroupData({
    required this.myid,
    required this.nameid,
    this.id = '',
    required this.name,
    required this.unopenedMessages,
    this.time,
  });

  static ChatGroupData fromSnap(Map<String, dynamic> snap) {
    return ChatGroupData(
      myid: snap['myid'],
      nameid: snap['nameid'],
      id: snap['id'],
      name: snap['name'],
      unopenedMessages: snap['unopenedMessages'],
      time: snap['time'] != null
          ? (snap['time'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'myid': myid,
      'nameid': nameid,
      'id': id,
      'name': name,
      'unopenedMessages': unopenedMessages,
      'time': time,
    };
  }
}
