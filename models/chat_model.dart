import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String to;
  final String from;
  final String text;
  final DateTime? time;
  final bool seen;

  const ChatModel({
    this.id = "",
    required this.to,
    required this.from,
    required this.text,
    required this.time,
    this.seen = false,
  });

  Map<String, dynamic> toJson() {
    return ({
      'id': id,
      'to': to,
      'from': from,
      'text': text,
      'time': time,
      'seen': seen,
    });
  }

  static ChatModel fromSnap(Map<String, dynamic> snap) {
    return ChatModel(
      id: snap['id'],
      to: snap['to'],
      from: snap['from'],
      text: snap['text'] ?? '',
      time: snap['time'] != null ? (snap['time'] as Timestamp).toDate() : null,
      seen: snap['seen'] ?? false,
    );
  }
}
