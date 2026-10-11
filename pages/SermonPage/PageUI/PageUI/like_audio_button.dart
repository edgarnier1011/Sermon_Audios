import 'package:flutter/material.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/global.dart';

class LikeAudio extends StatefulWidget {
  final String textid;
  final String narratorid;
  final String audioid;
  final String title;
  const LikeAudio(
      {required this.title,
      required this.textid,
      required this.audioid,
      required this.narratorid,
      super.key});

  @override
  State<LikeAudio> createState() {
    return _LikeAudio();
  }
}

class _LikeAudio extends State<LikeAudio> {
  Future<String>? check;

  @override
  void initState() {
    super.initState();
    check =
        locator.get<FirestoreMethods>().checkifLikedAudiopost(widget.audioid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: check,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                child: GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Text(
                          "Like Audio",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  onTap: () async {
                    await locator.get<FirestoreMethods>().likeAudiopost(
                        AuthMethods().uid,
                        widget.audioid,
                        widget.narratorid,
                        widget.textid,
                        widget.title);

                    setState(() {
                      check = locator
                          .get<FirestoreMethods>()
                          .checkifLikedAudiopost(widget.audioid);
                    });
                  },
                ),
              );
            } else {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Text("Unlike Audio",
                            style: TextStyle(color: Colors.white)),
                      )),
                  onTap: () async {
                    await locator.get<FirestoreMethods>().unlikeAudiopost(
                          snapshot.data!,
                          widget.audioid,
                        );
                    setState(() {
                      check = locator
                          .get<FirestoreMethods>()
                          .checkifLikedAudiopost(widget.audioid);
                    });
                  },
                ),
              );
            }
          } else if (snapshot.hasError) {
            return const Text("Error in like audio",
                style: TextStyle(color: Colors.white));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
