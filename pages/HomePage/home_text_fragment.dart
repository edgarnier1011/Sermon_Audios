import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sermons_audio/models/sermon_model.dart';
import 'package:sermons_audio/pages/HomePage/like_button_from_text_fragment.dart';
import 'package:sermons_audio/pages/HomePage/play_button_icon_top_home.dart';
import 'package:sermons_audio/pages/HomePage/show_modal_animated_framgent_text.dart';
import 'package:sermons_audio/utils/profilepic.dart';

class TextDataDisplayHomePage extends StatefulWidget {
  final DocumentParagraphs modelData;

  const TextDataDisplayHomePage({required this.modelData, super.key});

  @override
  State<TextDataDisplayHomePage> createState() =>
      _TextDataDisplayStateHomePage();
}

class _TextDataDisplayStateHomePage extends State<TextDataDisplayHomePage>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();
  bool hideContent = false;
  bool isLiked = false;
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Center(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),

                  // 🔥 Glass gradient (dark)
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.03),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  // subtle border
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1,
                  ),

                  // soft glow
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                height: 275,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Row(
                              children: [
                                ProfilePicSermon(
                                  size: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SizedBox(
                                    width: 200,
                                    child: Text(
                                      displayName(
                                          widget.modelData.submitterName),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                  onPressed: () => setState(
                                      () => hideContent = !hideContent),
                                  child: FittedBox(
                                      child: Text(
                                    softWrap: false,
                                    hideContent
                                        ? 'Show Content'
                                        : 'Hide Content',
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    hideContent
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 100,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                                color: Colors.white10,
                                                width: 2),
                                            bottom: BorderSide(
                                                color: Colors.white10,
                                                width: 2),
                                            right: BorderSide(
                                                color: Colors.white10,
                                                width: 2),
                                          ),
                                          color: Colors.black12),
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: Text(
                                            widget.modelData.paragraphs.first
                                                .trim(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                wordSpacing: 2.0,
                                                height: 2)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LikeTextButton(
                                    textID: widget.modelData.id,
                                    textTitle: widget.modelData.sermonName,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 8),
                    hideContent
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //Color of play button is changed to grey when there is no audio available for the sermon. Else, the widget PlayButtonIconHome decides the color, red by default.
                              widget.modelData.latestAudiourl == 'a'
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.play_circle_fill_rounded,
                                        color: const Color.fromARGB(
                                            255, 46, 46, 46),
                                        size: 42,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PlayButtonIconHome(
                                        audioUrl:
                                            widget.modelData.latestAudiourl,
                                        title: widget.modelData.sermonName,
                                      )),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.modelData.sermonName,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                  ],
                )),
          ),
        ),
        onTap: () => showModalBottomSheet(
            backgroundColor: Colors.black,
            context: context,
            builder: (context) => AnimatedGlassBottomSheet(
                  title: widget.modelData.sermonName,
                  fullText: widget.modelData.paragraphs.first.trim(),
                )),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
  }

  @override
  bool get wantKeepAlive => true;
}

// This function takes a name string from the database, splits it into tokens, capitalizes the first letter of each token, and returns the final formatted string.
String displayName(String nameFromdatabase) {
  String finalString = '';
  List<String> tokensname = nameFromdatabase.split(' ');
  for (int i = 0; i < tokensname.length; i++) {
    finalString =
        '$finalString${tokensname[i][0].toUpperCase()}${tokensname[i].substring(1)} ';
  }

  return finalString.trimRight();
}

void togglePlay() {}
