import 'package:flutter/material.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() {
    return _Logout();
  }
}

class _Logout extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await FirestoreService.instance.updateDocument(
            path: FirestorePath.currUser(), data: {'letfcms': ''});
        locator.get<FirestoreMethods>().cancelSubscription();

        await AuthMethods().signout();
      },
      child: const Text(
        'Logout',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
