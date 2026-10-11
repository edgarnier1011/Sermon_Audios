//import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/resources/methods_for_update_2026.dart';
import 'package:sermons_audio/screens/navigation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Initial screen, to login or register
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    // sharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.blueGrey, Colors.blueGrey[700]!],
            radius: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(),
              // const Spacer(flex: 2),
              const Text(
                'Welcome to:',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text('Sermon Audios',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Inspired by Charles H Spurgeon',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 48),
              !_isLoading
                  //When the button is pressed, isLoading is set to true and a progression circle is displayed until the application preferences and version check is completed. After that, the user is navigated to the main navigation page.
                  ? ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          textStyle: const WidgetStatePropertyAll(TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.blueGrey[900])),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await sharedPrefs();
                        await locator
                            .get<MethodsForUpdate2026>()
                            .initializeVersionCheck();

                        (context.mounted) ? goToNavigationPage(context) : null;
                      },
                      child: const Text('Continue'))
                  : const CircularProgressIndicator(),
              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void goToNavigationPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const NavigationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ));

          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 750),
      ),
    );
  }

  Future<void> sharedPrefs() async {
    SharedPreferences getdata = await SharedPreferences.getInstance();
    int? themeOption;
    // Checks the current settings of the application. if a setting is not set, default is set.
    // Settings are theme color, blocked users, language, and liked texts.
    if (getdata.getInt('themeColor') == null) {
      themeOption = 0;
      await getdata.setInt('themeColor', themeOption);

      locator.get<LocalData>().currentColorTheme = themeOption;
    } else {
      themeOption = getdata.getInt('themeColor');
      locator.get<LocalData>().currentColorTheme = themeOption!;
    }

    if (getdata.getStringList('blockedUsers') == null) {
      await getdata.setStringList("blockedUsers", []);
    } else {}

    if (getdata.getString('Language') == null) {
      await getdata.setString('Language', "English");
      locator.get<LocalData>().filterLanguage.value = "English";
    }

    if (getdata.getString('uiLanguage') == null) {
      await getdata.setString('uiLanguage', "English");
      locator.get<LocalData>().changeUIlanguage('English');
    }

    if (getdata.getStringList('likedTexts') == null) {
      await getdata.setStringList('likedTexts', []);
    } else {
      locator.get<LocalData>().likedTexts.value =
          getdata.getStringList('likedTexts')!;
    }

    if (getdata.getStringList('likedTextsTitles') == null) {
      await getdata.setStringList('likedTextsTitles', []);
    } else {
      locator.get<LocalData>().likedTextsTitles.value =
          getdata.getStringList('likedTextsTitles')!;
    }
  }

  /* Widget DisplaySignInButton() {
                // Container(
              //   decoration: BoxDecoration(
              //     color: Theme.of(context).colorScheme.primary,
              //     borderRadius: const BorderRadius.all(
              //       Radius.circular(12),
              //     ),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: TextButton(
              //       style: const ButtonStyle(),
              //       //Transition to sign in Page
              //       onPressed: () async {
              //         showModalBottomSheet(
              //           isScrollControlled: true,
              //           context: context,
              //           builder: (context) => const SignInScreen(),
              //         );
              //       },
              //       child: const Text(
              //         'Login',
              //         style: TextStyle(
              //           fontSize: 36,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
  }
  */
}
