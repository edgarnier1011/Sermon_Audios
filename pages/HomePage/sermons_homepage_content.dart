import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sermons_audio/models/sermon_model.dart';
import 'package:sermons_audio/pages/HomePage/home_text_fragment.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/utils/shimmer_effect_for_loading_2026.dart';

class SermonTextHomePage extends StatefulWidget {
  const SermonTextHomePage({super.key});

  @override
  State<SermonTextHomePage> createState() {
    return _SermonHorizontal();
  }
}

class _SermonHorizontal extends State<SermonTextHomePage> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //The query to get data from database
    return ValueListenableBuilder(
        valueListenable: locator.get<LocalData>().filterLanguage,
        builder: (context, value, __) {
          return FirestoreListView(
            controller: scrollController,
            pageSize: 5,
            addAutomaticKeepAlives: true,
            query: FirestoreService.instance.collectionQuery(
                path: FirestorePath.addText(),
                queryBuilder: (query) {
                  //The default language is English.
                  return query.where('language', isEqualTo: value);
                }),
            //how the data will be displayed.
            itemBuilder: (context, snapshot) {
              DocumentParagraphs model = DocumentParagraphs.fromSnap(
                  snapshot.data() as Map<String, dynamic>);
              //if approved text
              if (model.approval) {
                return TextDataDisplayHomePage(modelData: model);
              } else {
                return const SizedBox();
              }
            },
            emptyBuilder: (context) => const Text('Nothing to Show',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            loadingBuilder: (context) => const GlassPostSkeleton(),
          );
        });
  }
}
/*
class TextDataDisplayHomePage extends StatefulWidget {
  final DocumentParagraphs modelData;

  const TextDataDisplayHomePage({required this.modelData, super.key});

  @override
  State<TextDataDisplayHomePage> createState() =>
      _TextDataDisplayStateHomePage();
}

class _TextDataDisplayStateHomePage extends State<TextDataDisplayHomePage>
    with AutomaticKeepAliveClientMixin {
  bool hideContent = false;
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
                      border: const Border(
                          bottom: BorderSide(color: Colors.blueGrey)),
                      color: Colors.black.withOpacity(0.3)),
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: Theuser.fromId(widget.modelData.userid),
                          builder: (context, AsyncSnapshot<Theuser> snap) {
                            if (snap.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          ProfilePicSermon(
                                            id: widget.modelData.userid,
                                            size: 40,
                                            url: snap.data!.profileImage,
                                            //allowChange: false,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: SizedBox(
                                              width: 200,
                                              child: Text(
                                                displayName(snap.data!.name),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () => pushScreenWithoutNavBar(
                                        context,
                                        UserProfileV(
                                            previous: '',
                                            showappBar: true,
                                            userData: snap.data!),
                                      ),
                                    ),
                                    TextButton(
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
                                  ],
                                ),
                              );
                            } else if (snap.hasError) {
                              return const Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Profile Not Available',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }),
                      hideContent
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  (widget.modelData.paragraphs.first
                                              .trim()
                                              .length >
                                          900)
                                      ? Expanded(
                                          child: Text(
                                            '${widget.modelData.paragraphs.first.trim().substring(0, 900)}...',
                                            softWrap: true,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                wordSpacing: 2.0,
                                                height: 2),
                                          ),
                                        )
                                      : Expanded(
                                          child: Text(
                                              widget.modelData.paragraphs.first
                                                  .trim(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  wordSpacing: 2.0,
                                                  height: 2)),
                                        )
                                ],
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Title: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Flexible(
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                widget.modelData.sermonName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.record_voice_over,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                        widget.modelData.audiosCount.toString())
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () => showModalBottomSheet(
                                            constraints: BoxConstraints(
                                                minWidth: locator
                                                    .get<ScreenDimensions>()
                                                    .getDimensions(context)
                                                    .size
                                                    .width),
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) => Material(
                                                  child: TextLikesList(
                                                      textid:
                                                          widget.modelData.id),
                                                )),
                                        icon: const Icon(
                                          Icons.thumb_up_sharp,
                                          color: Colors.white,
                                        )),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(widget.modelData.likes.toString())
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ),
          onTap: () => pushScreenWithoutNavBar(
                context,
                Material(
                  child: SermonPageFinal(
                    alldataofsermon: widget.modelData,
                  ),
                ),
              )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

                /*FutureBuilder(
                  //if user author is not blocked by author,
                  future: locator
                      .get<FirestoreMethods>()
                      .checkIfuserblocked(model.userid),
                  builder: (context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      //if it returns nothing, it means author user is not blocked.
                      if (snapshot.data!.isEmpty) {
                        return TextDataDisplayHomePage(modelData: model);
                      } else {
                        return const SizedBox();
                      }
                    } else if (snapshot.hasError) {
                      return Container(
                          decoration:
                              BoxDecoration(color: Colors.black.withOpacity(0.4)),
                          child: const Text('Error loading text'));
                    } else {
                      return SizedBox(
                        height: 100,
                        child: Shimmer.fromColors(
                            baseColor: Colors.black.withOpacity(0.4),
                            highlightColor: Colors.blueGrey,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4)),
                              height: 100,
                            )),
                      );
                    }
                  }) ; */
*/
