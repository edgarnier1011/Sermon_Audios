import 'package:sermons_audio/resources/firestore_services.dart';

class AboutFile {
  final String currentVersionAndroid;
  final String currentVersioniOS;
  final String email;
  final String privacyPolicyLink;
  final String androidLink;
  final String iosLink;
  final bool updateRequired;

  AboutFile(
      {required this.currentVersionAndroid,
      required this.currentVersioniOS,
      required this.email,
      required this.privacyPolicyLink,
      required this.androidLink,
      required this.iosLink,
      required this.updateRequired});

  Map<String, dynamic> toJson() {
    return {
      'currentVersionAndroid': currentVersionAndroid,
      'currentVersioniOS': currentVersioniOS,
      'email': email,
      'privacyPolicyLink': privacyPolicyLink,
      'androidLink': androidLink,
      'iosLink': iosLink,
      'updateRequired': updateRequired,
    };
  }

  factory AboutFile.fromJson(Map<String, dynamic> json) {
    return AboutFile(
      currentVersionAndroid: json['currentVersionAndroid'],
      currentVersioniOS: json['currentVersioniOS'],
      email: json['email'],
      privacyPolicyLink: json['privacyPolicyLink'],
      androidLink: json['androidLink'],
      iosLink: json['iosLink'],
      updateRequired: json['updateRequired'],
    );
  }

  static Future<AboutFile> fromSnap(Map<String, dynamic> snap) async {
    AboutFile aboutfile = AboutFile(
        currentVersionAndroid: snap['currentVersionAndroid'],
        currentVersioniOS: snap['currentVersioniOS'],
        email: snap['email'],
        privacyPolicyLink: snap['privacyPolicyLink'],
        androidLink: snap['androidLink'],
        iosLink: snap['iosLink'],
        updateRequired: snap['updateRequired']);
    try {
      await FirestoreService.instance.documentFuture(
          path: 'Announcement/LEhd5hoAWCH9GKdLHVp7',
          builder: (data) {
            aboutfile = AboutFile.fromJson(data);
          });
    } catch (e) {
      // Handle the error, e.g., log it or return a default AboutFile
      print('Error fetching AboutFile: $e');
    }
    return aboutfile;
  }
}
