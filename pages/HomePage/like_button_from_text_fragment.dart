import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeTextButton extends StatefulWidget {
  final String textID;
  final String textTitle;
  final bool showLikeButton;
  const LikeTextButton(
      {super.key,
      required this.textID,
      required this.textTitle,
      this.showLikeButton = true});

  @override
  State<LikeTextButton> createState() => _LikeTextButtonState();
}

class _LikeTextButtonState extends State<LikeTextButton> {
  bool isLiked = false;
  SharedPreferences? sharedPrefs;
  List<String>? likedTexts;
  @override
  void initState() {
    super.initState();
    // setSharedPrefs();
    likedTexts = locator.get<LocalData>().likedTexts.value;
    if (likedTexts!.isNotEmpty) {
      // List<String>? likedTexts = sharedPrefs!.getStringList('likedTexts');
      if (likedTexts!.contains(widget.textID)) {
        debugPrint('Id is cached');
        isLiked = true;
      } else {
        isLiked = false;
      }
    } else {
      isLiked = false;
    }
  }

  void toggleLike() async {
    //bool likedState;
    // if (!isLiked) {
    if (!likedTexts!.contains(widget.textID)) {
      locator.get<LocalData>().addToLikedTextsFromLocalData(widget.textID);
      locator
          .get<LocalData>()
          .addToLikedTextsTitlesFromLocalData(widget.textTitle);
      setState(() {
        isLiked = true;
      });
    } else {
      locator.get<LocalData>().removeFromLikedTextsFromLocalData(widget.textID);
      locator
          .get<LocalData>()
          .removeFromLikedTextsTitlesFromLocalData(widget.textTitle);
      setState(() {
        isLiked = false;
      });
    }
    return;
    // }
    // if (locator.get<LocalData>().likedTexts.value.contains(widget.textID)) {
    //   setState(() => isLiked = true);
    // } else {
    //   setState(() {
    //     isLiked = false;
    //   });
    // }
  }

  void setSharedPrefs() async {
    sharedPrefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return widget.showLikeButton
        ? IconButton(
            onPressed: toggleLike,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              size: 18,
              color: isLiked ? Colors.redAccent : Colors.white54,
            )
                .animate(target: isLiked ? 1 : 0)
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.4, 1.4),
                  duration: 200.ms,
                )
                .then()
                .scale(
                  begin: const Offset(1.4, 1.4),
                  end: const Offset(1, 1),
                ))
        : const SizedBox.shrink();
  }
}
