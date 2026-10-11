// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/screens/navigation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransitionScreen extends StatefulWidget {
  const TransitionScreen({super.key});

  @override
  State<TransitionScreen> createState() => _TransitionScreenState();
}

class _TransitionScreenState extends State<TransitionScreen> {
  //final _firestore = locator.get<FirestoreMethods>();
  //final _auth = locator.get<AuthMethods>();

  // Future<bool> _initialize() async {
  //   debugPrint('Got called but not reset when login');
  //   // await _firestore.initializeUser(_auth.currentUser);
  //   if (context.mounted) {
  //     Navigator.canPop(context) ? Navigator.pop(context) : null;
  //   }
  //   // await _firestore.initializeUser(_auth.currentUser);
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: sharedPrefs(),
        builder: (context, AsyncSnapshot<void> snapStart) {
          if (snapStart.connectionState == ConnectionState.done) {
            return NavigationScreen();
            // return StreamBuilder(
            //   // listen to authentication changes
            //   stream: _auth.userStream,
            //   builder: (context, snapshot) {
            //     // return nav screen if user logged in
            //     if (snapshot.connectionState == ConnectionState.active) {
            //       if (snapshot.hasData) {
            //         if (!snapshot.data!.emailVerified) {
            //           return const VerifyEmail();
            //         }
            //         return FutureBuilder(
            //             future: _initialize(),
            //             builder: (context, snapshota) {
            //               if (snapshota.hasData) {
            //                 if (locator
            //                     .get<FirestoreMethods>()
            //                     .userModel
            //                     .name
            //                     .isEmpty) {
            //                   return const SetNameWelcomeScreen();
            //                 } else {
            //                   return const NavigationScreen();
            //                 }
            //               } else if (snapshota.hasError) {
            //                 return Padding(
            //                   padding: const EdgeInsets.only(top: 16),
            //                   child: Text('Error: ${snapshota.error}',
            //                       style: const TextStyle(color: Colors.white)),
            //                 );
            //               } else {
            //                 return const Center(
            //                   child: CircularProgressIndicator(),
            //                 );
            //               }
            //             });
            //       } else if (snapshot.hasError) {
            //         return Padding(
            //           padding: const EdgeInsets.only(top: 16),
            //           child: Text('Error: ${snapshot.error}'),
            //         );
            //       }
            //     }
            //     // return indicator if loading
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const SizedBox(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //     // return login screen if user not logged in
            //     return const WelcomeScreen();
            //   },
            // );
          } else if (snapStart.hasError) {
            return const Text(
                "Error loading settings, please reload app from settings");
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<void> sharedPrefs() async {
    debugPrint('sharedPrefs started');
    SharedPreferences getdata = await SharedPreferences.getInstance();
    int? themeOption;
    if (getdata.getInt('themeColor') == null) {
      debugPrint('Themecolor is set to 0');
      themeOption = 0;
      await getdata.setInt('themeColor', themeOption);

      locator.get<LocalData>().currentColorTheme = themeOption;
    } else {
      debugPrint('Themecolor is set to either 0 or 1');
      themeOption = getdata.getInt('themeColor');
      locator.get<LocalData>().currentColorTheme = themeOption!;
      //set in localdata
    }

    if (getdata.getStringList('blockedUsers') == null) {
      debugPrint('created it the blocked list');
      await getdata.setStringList("blockedUsers", []);
    } else {
      debugPrint('not created the blocked list');
    }

    if (getdata.getString('Language') == null) {
      debugPrint('The language was set');
      await getdata.setString('Language', "English");
      locator.get<LocalData>().filterLanguage.value = "English";
    }

    if (getdata.getString('uiLanguage') == null) {
      await getdata.setString('uiLanguage', "English");
      locator.get<LocalData>().changeUIlanguage('English');
      debugPrint('The uiLanguage was set');
    }

    if (getdata.getStringList('likedTexts') == null) {
      debugPrint('No LikedTexts');
      await getdata.setStringList('likedTexts', []);

      //themeOption = 0;
      //await getdata.setInt('themeColor', themeOption);

      //locator.get<LocalData>().currentColorTheme = themeOption;
    } else {
      debugPrint('LikedTextsCreated');
      // List<String> likedTexts = getdata.getStringList('likedTexts')!;
      locator.get<LocalData>().likedTexts.value =
          getdata.getStringList('likedTexts')!;
      //set in localdata
    }

    if (getdata.getStringList('likedTextsTitles') == null) {
      debugPrint('No LikedTextsTitles');
      await getdata.setStringList('likedTextsTitles', []);

      //themeOption = 0;
      //await getdata.setInt('themeColor', themeOption);

      //locator.get<LocalData>().currentColorTheme = themeOption;
    } else {
      debugPrint('LikedTextsTitlesCreated');
      // List<String> likedTextsTitles = getdata.getStringList('likedTextsTitles')!;
      locator.get<LocalData>().likedTextsTitles.value =
          getdata.getStringList('likedTextsTitles')!;
      //set in localdata
    }
  }
}
