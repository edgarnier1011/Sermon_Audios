import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sermons_audio/models/about_file.dart';
import 'package:sermons_audio/resources/firestore_services.dart';

class MethodsForUpdate2026 {
  AboutFile? aboutFile;
  late String currentVersionOnDevice;
  //Check the current version of the app on the device
  Future<void> initializeVersionCheck() async {
    currentVersionOnDevice = await PackageInfo.fromPlatform()
        .then((PackageInfo packageInfo) => packageInfo.version);
    // Fetch the current version information from database
    try {
      aboutFile = await FirestoreService.instance.documentFuture(
          path: 'Announcement/LEhd5hoAWCH9GKdLHVp7',
          builder: (data) => AboutFile.fromJson(data));
    } catch (e) {
      debugPrint('Error fetching AboutFile: $e');
      aboutFile = AboutFile(
          currentVersionAndroid: '',
          currentVersioniOS: '',
          email: '',
          privacyPolicyLink: '',
          androidLink: '',
          iosLink: '',
          updateRequired: false);
    }
  }

  //functions to be used to check if the current version of the app on the device is the same as the current version in the database for iOS and Android.
  bool checkCurrentVersionIos() {
    if (currentVersionOnDevice == aboutFile?.currentVersioniOS) {
      return true;
    } else {
      return false;
    }
  }

  bool checkCurrentVersionAndroid() {
    if (currentVersionOnDevice == aboutFile?.currentVersionAndroid) {
      return true;
    } else {
      return false;
    }
  }

  /*
  // Fuction to see email of users in the database.
    Future<List<String>> listfromId() async {
    List<String> emailaddresses = [];
    List<Theuser>? usertemp = await FirestoreService.instance.collectionFuture(
        path: FirestorePath.userC(),
        queryBuilder: (query) =>
            query.where('id', isNotEqualTo: 'lSnhNsg1X5aOZu5dSW0Ao9i9AV82'),
        builder: (data) => Theuser.fromSnap(data));
    if (usertemp.isEmpty) {
      debugPrint("User not found");
    }

    for (int i = 0; i < usertemp.length; i++) {
      emailaddresses.add(usertemp[i].email);
    }

    return emailaddresses;


  }
  */
}
