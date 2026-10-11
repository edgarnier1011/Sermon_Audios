class Author {
  final String name;
  final String id;
  final String lastTextid;
  final int followers;

  const Author(
      {this.followers = 0,
      this.lastTextid = '',
      required this.name,
      this.id = ""});

  Map<String, dynamic> toJson() {
    return ({
      'followers': followers,
      'name': name,
      'id': id,
      'lastTextid': lastTextid,
    });
  }

  static Author fromsnap(Map<String, dynamic> snap) {
    return Author(
        followers: snap['followers'] ?? 0,
        name: snap['name'] ?? 'replace fix',
        id: snap['id'],
        lastTextid: snap['lastTextid'] ?? '');
  }
}
