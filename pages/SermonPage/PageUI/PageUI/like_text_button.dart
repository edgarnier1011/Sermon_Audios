import 'package:flutter/material.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/global.dart';

class LikeText extends StatefulWidget {
  final String authorid;
  final String textid;
  final String userid;
  final String title;
  const LikeText(
      {required this.userid,
      required this.authorid,
      required this.textid,
      required this.title,
      super.key});

  @override
  State<LikeText> createState() {
    return _LikeText();
  }
}

class _LikeText extends State<LikeText> {
  Future<String>? likeStatus;
  @override
  void initState() {
    super.initState();
    likeStatus =
        locator.get<FirestoreMethods>().checkifLikedpost(widget.textid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: likeStatus,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
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
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          "Unlike text",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  onTap: () async {
                    await locator
                        .get<FirestoreMethods>()
                        .unlikePost(snapshot.data!, widget.textid);
                    setState(() {
                      likeStatus = locator
                          .get<FirestoreMethods>()
                          .checkifLikedpost(widget.textid);
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
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text("Like Text",
                            style: TextStyle(color: Colors.white)),
                      )),
                  onTap: () async {
                    await locator.get<FirestoreMethods>().likePost(
                        widget.userid,
                        widget.textid,
                        AuthMethods().uid,
                        widget.title);
                    setState(() {
                      likeStatus = locator
                          .get<FirestoreMethods>()
                          .checkifLikedpost(widget.textid);
                    });
                  },
                ),
              );
            }
          } else if (snapshot.hasError) {
            return const Text("Error in like text",
                style: TextStyle(color: Colors.white));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
