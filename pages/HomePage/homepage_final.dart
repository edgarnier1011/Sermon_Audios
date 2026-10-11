//notifactions, audio fragments, texts.
import 'package:flutter/material.dart';
import 'package:sermons_audio/pages/HomePage/audio_player_top_home.dart';
import 'package:sermons_audio/pages/HomePage/sermons_homepage_content.dart';
import 'package:sermons_audio/pages/SubmitText/author_info.dart';
//import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
//import 'package:sermons_audio/utils/ads.dart';

class HomePageMainComponent extends StatefulWidget {
  const HomePageMainComponent({
    super.key,
  });

  @override
  State<HomePageMainComponent> createState() => _HomePageMainComponentState();
}

class _HomePageMainComponentState extends State<HomePageMainComponent> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: locator.get<LocalData>().themeColorspallete[
                  locator.get<LocalData>().currentColorTheme],
              stops: const [0.0, 0.15, 0.60, 1.0])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black.withOpacity(0.4),
          title: const Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
        ),
        body: DefaultTextStyle.merge(
          style: const TextStyle(color: Colors.white),
          child: Column(
            children: [
              //Initial values are placeholders, they will be updated when the first audio is loaded.
              SimpleAudioPlayer(title: 'Temp', audioUrl: ""),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Recent Texts',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 300,
                child: Padding(
                    padding: EdgeInsets.all(8.0), child: LanguageSelector()),
              ),
              Expanded(
                child: SermonTextHomePage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
