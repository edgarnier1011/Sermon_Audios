import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

//listens for change in user login status and access to user id
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?>? get userStream {
    return _auth.authStateChanges();
  }

  User get currentUser {
    return _auth.currentUser!;
  }

  String get uid => _auth.currentUser != null ? _auth.currentUser!.uid : '';

  Future<void> signout() async {
    await _auth.signOut();
  }
}
