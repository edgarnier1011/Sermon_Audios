import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';

class Theuser {
  final String name;
  final String id;
  final String email;
  final String profileImage;
  final String bannerImage;
  final int followerCnt;
  final int followingCnt;
  final String prefferedLanguage;
  final int themeColor; //light, dark = false
  final String bio;
  final bool pendingNotfs;
  final String letfcms;
  final String imageProfilerealPath;
  final String imageBannerrealPath;

  const Theuser({
    this.imageProfilerealPath = '',
    this.imageBannerrealPath = '',
    this.letfcms = '',
    this.pendingNotfs = false,
    this.bio = '',
    this.themeColor = 1,
    this.prefferedLanguage = 'English',
    this.followerCnt = 0,
    this.followingCnt = 0,
    this.profileImage = '',
    this.bannerImage = '',
    required this.email,
    this.name = '',
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return ({
      'imageProfilerealPath': imageProfilerealPath,
      'imageBannerrealPath': imageBannerrealPath,
      'letfcms': letfcms,
      'pendingNotfs': pendingNotfs,
      'themeColor': themeColor,
      'prefferedLanguage': prefferedLanguage,
      'followerCnt': followerCnt,
      'followingCnt': followingCnt,
      'profileImage': profileImage,
      'bannerImage': bannerImage,
      'name': name,
      'id': id,
      'email': email,
      'bio': bio,
    });
  }

  static Theuser fromSnap(Map<String, dynamic> snap) {
    return Theuser(
      imageProfilerealPath: snap['imageProfilerealPath'] ?? '',
      imageBannerrealPath: snap['imageBannerrealPath'] ?? '',
      themeColor: snap['themeColor'] ?? 1,
      prefferedLanguage: snap['prefferedLanguage'] ?? 'English',
      followingCnt: snap['followingCnt'] ?? 0,
      followerCnt: snap['followerCnt'] ?? 0,
      email: snap['email'],
      id: snap['id'],
      name: snap['name'] ?? '',
      profileImage: snap['profileImage'] ?? '',
      bannerImage: snap['bannerImage'] ?? '',
      bio: snap['bio'] ?? '',
      pendingNotfs: snap['pendingNotfs'] ?? false,
      letfcms: snap['letfcms'] ?? '',
    );
  }

  static Future<Theuser> fromId(String userid) async {
    Theuser? usertemp;
    await FirestoreService.instance.documentFuture(
        path: FirestorePath.user(userid),
        builder: (data) => usertemp = Theuser.fromSnap(data));

    return usertemp!;
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
      return device;
    }
  }
}
