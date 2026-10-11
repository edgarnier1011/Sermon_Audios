class ChatGroup {
  final String id;
  final String name;
  final Map<String, dynamic> members;
  final String latestProfile;
  final String subProfile;
  final String latestText;
  final String latestId;
  final int messagesCount;
  const ChatGroup({
    this.id = "",
    this.name = "Group Chat",
    required this.members,
    this.latestProfile = "",
    this.subProfile = "",
    this.latestText = "",
    this.latestId = "",
    this.messagesCount = 0,
  });

  static ChatGroup fromSnap(Map<String, dynamic> snap) {
    return ChatGroup(
      id: snap['id'],
      name: snap['name'] ?? 'Group Chat',
      members: snap['members'],
      latestProfile: snap['latestProfile'] ?? '',
      subProfile: snap['subProfile'] ?? '',
      latestText: snap['latestText'] ?? '',
      latestId: snap['latestId'] ?? '',
      messagesCount: snap['messageCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return ({
      'id': id,
      'name': name,
      'members': members,
      'latestProfile': latestProfile,
      'subProfile': subProfile,
      'latestText': latestText,
      'latestId': latestId,
      'messageCount': messagesCount,
    });
  }
}
