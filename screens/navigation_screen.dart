//import 'package:firebase_auth/firebase_auth.dart';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'dart:async';

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sermons_audio/models/about_file.dart';
import 'package:sermons_audio/pages/HomePage/CardPostGlassAnimatedSample.dart';

//import 'package:sermons_audio/pages/ChatPage/chat_list_page.dart';
import 'package:sermons_audio/pages/HomePage/homepage_final.dart';
//import 'package:sermons_audio/pages/ProfilePage/user_profile.dart';
//import 'package:sermons_audio/pages/SearchPages/search_page_main.dart';
//import 'package:sermons_audio/resources/auth_methods.dart';
//import 'package:sermons_audio/resources/firestore_methods.dart';
//import 'package:sermons_audio/resources/global.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart'
    as temp;
import 'package:sermons_audio/pages/ProfilePage/top_bar_settings_and_liked.dart';
import 'package:sermons_audio/pages/SearchPages/search_by_title_2026.dart';
//import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/methods_for_update_2026.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationScreen extends StatefulWidget {
  //final BuildContext? context;
  const NavigationScreen({super.key});
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  //variable to get data of current tab
  late temp.PersistentTabController _controller;

  BuildContext? tabContext;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = temp.PersistentTabController();

    if (Platform.isAndroid) {
      if (!locator.get<MethodsForUpdate2026>().checkCurrentVersionAndroid()) {
        AboutFile? aboutFile = locator.get<MethodsForUpdate2026>().aboutFile;
        if (aboutFile != null) {
          Timer.run(() {
            showDialog(
                barrierDismissible: !aboutFile.updateRequired,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Update Available'),
                    content:
                        const Text('A new version of the app is available.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          try {
                            launchUrl(Uri.parse(aboutFile.androidLink));
                          } catch (e) {
                            debugPrint('Could not launch URL: $e');
                          }
                        },
                        child: const Text('Update Now'),
                      ),
                    ],
                  );
                });
          });
        }
      }
    }

    if (Platform.isIOS) {
      if (!locator.get<MethodsForUpdate2026>().checkCurrentVersionIos()) {
        AboutFile? aboutFile = locator.get<MethodsForUpdate2026>().aboutFile;
        if (aboutFile != null) {
          Timer.run(() {
            showDialog(
                barrierDismissible: !aboutFile.updateRequired,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Update Available'),
                    content:
                        const Text('A new version of the app is available.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          try {
                            launchUrl(Uri.parse(aboutFile.iosLink));
                          } catch (e) {
                            debugPrint('Could not launch URL: $e');
                          }
                        },
                        child: const Text('Update Now'),
                      ),
                    ],
                  );
                });
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return temp.PersistentTabView(
        backgroundColor: Colors.black,
        tabs: [
          temp.PersistentTabConfig(
              screen: const HomePageMainComponent(),
              item: temp.ItemConfig(
                icon: const Icon(Icons.home),
                title: 'Home',
                activeForegroundColor: Colors.white,
              )),
          temp.PersistentTabConfig(
              screen: const SearchTextByTitle(),
              item: temp.ItemConfig(
                  activeForegroundColor: Colors.white,
                  icon: const Icon(Icons.search),
                  title: 'Search')),
          temp.PersistentTabConfig(
              screen: const Center(
                child: GlassEmailSenderWidget(),
              ),
              item: temp.ItemConfig(
                  activeForegroundColor: Colors.white,
                  icon: const Icon(Icons.person),
                  title: 'Submit')),
          temp.PersistentTabConfig(
            item: temp.ItemConfig(
                icon: const Icon(Icons.person),
                activeForegroundColor: Colors.white,
                title: 'Info'),
            screen: GlassTabbedPage(),
          ),
        ],
        //The style of the navigation bar
        navBarBuilder: (temporary) => temp.Style4BottomNavBar(
              navBarConfig: temporary,
              navBarDecoration: temp.NavBarDecoration(
                color: Colors.black.withOpacity(0.5),
              ),
            ));
  }
}
/*
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
  
}*/
