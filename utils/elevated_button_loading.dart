import 'package:flutter/material.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/screens/navigation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElevatedButtonLoading extends StatefulWidget {
  final BuildContext? context;
  //final String buttonText;
  //final Future<void> Function() onPressed;
  const ElevatedButtonLoading({
    super.key,
    required this.context,
  });

  @override
  State<ElevatedButtonLoading> createState() => _ElevatedButtonLoadingState();
}

class _ElevatedButtonLoadingState extends State<ElevatedButtonLoading> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return !_isLoading
        ? ElevatedButton(
            onPressed: () => setState(() {
                  _isLoading = true;
                }),
            child: Text('Continue'))
        : FutureBuilder(
            future: sharedPrefs(),
            builder: (context, AsyncSnapshot<void> snap) {
              if (snap.connectionState == ConnectionState.done) {
                return ElevatedButton(
                    onPressed: () => goToNavigationPage(context),
                    child: Text('Continue'));
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

  void goToNavigationPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            NavigationScreen(),
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
}
