import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/screens/welcome_screen.dart';
import 'firebase_options.dart';
import 'package:just_audio_background/just_audio_background.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  //Enviroment variables (Database, Ids, etc)
  // await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  // Initializes Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // global variables (Database methods CURD for class models established and features)
  setupLocator();

  // MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: WelcomeScreen()),
    );
  }
}
