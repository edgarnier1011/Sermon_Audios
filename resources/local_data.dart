import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//For state mamangement of application. allows efficient change of UI
class LocalData with ChangeNotifier {
  ValueNotifier<String> currentProfilepicUrl = ValueNotifier('');

  void changeProfilePic(String newUrl) {
    currentProfilepicUrl.value = newUrl;
    notifyListeners();
  }

  ValueNotifier<String> currentBannerpicUrl = ValueNotifier('');

  void changeBannerPic(String newUrl) {
    currentBannerpicUrl.value = newUrl;
    notifyListeners();
  }

  ValueNotifier<List<String>> changesermonpage = ValueNotifier([]);
  void changesermonpagecomponents(List<String> newcomponents) {
    changesermonpage.value = newcomponents;
    notifyListeners();
  }

  void resetsermonpagecomponents() {
    changesermonpage.value = [];
  }

  ValueNotifier<bool> currentlyNarrating = ValueNotifier(false);

  List<String> globaltags = [
    'Christian',
    'Catholic',
    'Baptist',
    'Methodist',
    'Lutheran',
    'Presbyterian',
    'Episcopal',
    'Penteconstal',
    'Protestant',
    'Evangelical',
    'Reformed',
    'Wesleyan',
    'Anglican',
    'Calvinist',
  ];

  List<String> messagesTosend = [
    'Hello',
    'I read a text from you, is pretty good!',
    'Thank you!',
    'I heard a audio narrated by you, is pretty good!',
    'I have my social media sites posted in my bio, I would like for us to be friends!, If interested, check my profile info',
    'Will do!'
  ];

  ValueNotifier<int> messagesCount = ValueNotifier(0);

  void setmessageTosend(int i) {
    messagesCount.value = i;
    notifyListeners();
  }

  void increasemessageCount() {
    messagesCount.value++;
    notifyListeners();
  }

  List<int> chosenTags = [];

  List<String> returnTags() {
    List<String> mytags = ['Any'];
    for (int i = 0; i < chosenTags.length; i++) {
      mytags.add(globaltags[chosenTags[i]]);
    }

    return mytags;
  }

  void addtagindex(int index) {
    chosenTags.add(index);
    notifyListeners();
  }

  void removetagindex(int index) {
    chosenTags.remove(index);
    notifyListeners();
  }

  void resertagschosen() {
    chosenTags = [];
    notifyListeners();
  }

  String uiLanguage = 'English';
  void changeUIlanguage(String newlanguage) {
    uiLanguage = newlanguage;
  }

  AudioPlayer? globalaudio;
  void audioDisposal() {
    globalaudio!.stop();
    //globalaudio!.dispose();
  }

  void setglobalaudio() {
    globalaudio = AudioPlayer();
  }

  void resetinitializeAudio() {
    if (globalaudio != null) {
      globalaudio!.stop();
      globalaudio!.dispose();
      globalaudio!.release();
      globalaudio = null;
    }
  }

  ValueNotifier<String> filterLanguage = ValueNotifier('English');
  void setLanguage(String language) {
    filterLanguage.value = language;
    notifyListeners();
  }

  ValueNotifier<List<String>> filtertags = ValueNotifier(['Any']);
  void setfilterTags(List<String> denominations) {
    if (denominations.isEmpty) {
      filtertags.value = ['Any'];
    } else {
      filtertags.value = denominations;
    }
    notifyListeners();
  }

  ValueNotifier<bool> themeColors = ValueNotifier(false);

  ValueNotifier<bool> changesettings = ValueNotifier(false);
  void settingstoggle() {
    changesettings.value = !changesettings.value;
    notifyListeners();
  }

  int currentColorTheme = 0;

  List<List<Color>> themeColorspallete = [
    [
      const Color.fromARGB(239, 0, 0, 0),
      const Color.fromARGB(239, 0, 0, 0),
      const Color.fromARGB(239, 0, 0, 0),
      const Color.fromARGB(239, 0, 0, 0)
    ],
    [
      const Color.fromARGB(99, 0, 0, 0),
      const Color.fromARGB(99, 0, 0, 0),
      const Color.fromARGB(99, 0, 0, 0),
      const Color.fromARGB(99, 0, 0, 0)
    ]
  ];

  ValueNotifier<bool> notificationBadge = ValueNotifier(true);

  void arrivedNotification() {
    notificationBadge.value = false;
    notifyListeners();
  }

  void openedNotification() {
    notificationBadge.value = true;
    notifyListeners();
  }

  List<String> filtersnames = [
    'no filter',
    'likes',
    'audiosCount',
  ];
  ValueNotifier<int> filterchosen = ValueNotifier(0);

  void setfilertchosen(int filternumber) {
    filterchosen.value = filternumber;
    notifyListeners();
  }

  void resetfilterchosen() {
    filterchosen.value = 0;
    notifyListeners();
  }

  Map<String, String> verificationPageuiTextEnglish = {
    'a':
        'A email was send to your email address. Please verify it and tap on continue',
    'b': 'If email was not received, push on Resend Verification button',
    'c': 'resend verification',
    'd': 'continue',
  };

  Map<String, String> setNamePageuiTextEnglish = {
    'a': '',
    'b': '',
    'c': '',
    'd': ''
  };

  Future<void> getsharedprefs() async {}

  ValueNotifier<String> audioPlayerHomeLoaded = ValueNotifier('');
  ValueNotifier<String> audioPlayerHomeLoadedTitle = ValueNotifier('');

  void setaudioPlayerHomeLoaded(String audioUrl) {
    audioPlayerHomeLoaded.value = audioUrl;
    debugPrint('Hello world again');
    notifyListeners();
  }

  void setaudioPlayerHomeLoadedTitle(String title) {
    audioPlayerHomeLoadedTitle.value = title;
    notifyListeners();
  }

  ValueNotifier<List<String>> likedTexts = ValueNotifier([]);

  List<String> getLikedTextsFromLocalData() {
    return likedTexts.value;
  }

  void addToLikedTextsFromLocalData(String textID) async {
    likedTexts.value.add(textID);
    SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    sharedprefs.setStringList('likedTexts', likedTexts.value);
  }

  void removeFromLikedTextsFromLocalData(String textID) async {
    likedTexts.value.removeWhere((textIDo) => textIDo == textID);
    SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    sharedprefs.setStringList('likedTexts', likedTexts.value);
  }

  ValueNotifier<List<String>> likedTextsTitles = ValueNotifier([]);

  List<String> getLikedTextsTitlesFromLocalData() {
    return likedTextsTitles.value;
  }

  void addToLikedTextsTitlesFromLocalData(String textTitle) async {
    likedTextsTitles.value = [...likedTextsTitles.value, textTitle];
    SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    await sharedprefs.setStringList('likedTextsTitles', likedTextsTitles.value);
    notifyListeners();
  }

  void removeFromLikedTextsTitlesFromLocalData(String textTitle) async {
    likedTextsTitles.value =
        likedTextsTitles.value.where((title) => title != textTitle).toList();
    SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    await sharedprefs.setStringList('likedTextsTitles', likedTextsTitles.value);
    notifyListeners();
  }
}
