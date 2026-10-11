import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sermons_audio/models/user_model.dart';

import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/screens/set_name.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  void initState() {
    super.initState();
    // AuthMethods().currentUser.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Verifiy Email',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Is your email, ${AuthMethods().currentUser.email}?. If yes, tap on SEND VERIFICATION. Please verify email in your email inbox, then tap on continue',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'If email was not received, push on SEND VERIFICATION again.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'If email is incorrect, push return to register with correct email',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.currentUser!.delete();
                    },
                    child: const Text('Return')),
                ElevatedButton(
                    onPressed: () =>
                        AuthMethods().currentUser.sendEmailVerification(),
                    child: const Text(
                      'Send Verification',
                      style: TextStyle(fontSize: 16),
                    )),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () async {
                  await AuthMethods().currentUser.reload();
                  if (AuthMethods().currentUser.emailVerified) {
                    // await AuthMethods().currentUser.reload();

                    await FirestoreService.instance.addDocument(
                        path: FirestorePath.userC(),
                        data: Theuser(
                                email: AuthMethods().currentUser.email!,
                                id: AuthMethods().uid)
                            .toJson(),
                        myId: AuthMethods().uid);

                    FirestoreService.instance.updateDocument(
                        path: FirestorePath.currUser(),
                        data: {'dateJoined': DateTime.now()});

                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Material(
                                    child: SetNameWelcomeScreen(),
                                  )),
                          (Route<dynamic> route) => false);
                    }
                  }
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }
}
