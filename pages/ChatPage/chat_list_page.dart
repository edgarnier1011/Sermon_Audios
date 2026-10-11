import 'package:flutter/material.dart';
import 'package:sermons_audio/models/chat_group_data_model.dart';
import 'package:sermons_audio/models/chat_group_model.dart';
import 'package:sermons_audio/models/user_model.dart';
import 'package:sermons_audio/pages/ChatPage/chat_page.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/utils/profilepic.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: locator.get<LocalData>().changesettings,
        builder: (context, theValue, __) {
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: locator.get<LocalData>().themeColorspallete[
                      locator.get<LocalData>().currentColorTheme],
                  stops: const [0.0, 0.15, 0.60, 1.0]),
            ),
            child: Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.black.withOpacity(0.4),
                elevation: 0,
                title: const Text(
                  "Chats",
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  // IconButton(
                  //     onPressed: () => pushScreenWithoutNavBar(
                  //           context,
                  //           const Material(child: SearchUser()),
                  //         ),
                  //     icon: const Icon(
                  //       Icons.search,
                  //       color: Colors.white,
                  //     )),
                ],
              ),
              backgroundColor: Colors.transparent,
              body: DefaultTextStyle(
                style: const TextStyle(color: Colors.white),
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream:
                            locator.get<FirestoreMethods>().getChatDataStream(),
                        builder: (context, chatGroupDatas) {
                          if (chatGroupDatas.hasData) {
                            if (chatGroupDatas.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No Chats",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                  itemCount: chatGroupDatas.data!.length,
                                  itemBuilder: (context, index) {
                                    ChatGroupData chat =
                                        chatGroupDatas.data![index];
                                    return StreamBuilder(
                                        stream: locator
                                            .get<FirestoreMethods>()
                                            .getChatGroupStream(chat.id),
                                        builder: (context, chatGroup) {
                                          if (chatGroup.hasData) {
                                            ChatGroup group = chatGroup.data!;

                                            return GestureDetector(
                                              onTap: () {
                                                if (context.mounted) {
                                                  null;
                                                  pushScreenWithoutNavBar(
                                                    context,
                                                    Material(
                                                      child: ChatPage(
                                                        group: chat.id,
                                                        name: chat.name,
                                                        members: [
                                                          group.latestId,
                                                          group.subProfile,
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                margin: const EdgeInsets.only(
                                                  left: 12,
                                                  right: 12,
                                                  top: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Row(
                                                  children: [
                                                    chat.nameid !=
                                                            AuthMethods().uid
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                FutureBuilder(
                                                                    future: Theuser
                                                                        .fromId(chat
                                                                            .nameid),
                                                                    builder: (context,
                                                                        AsyncSnapshot<Theuser>
                                                                            snapshot) {
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        return ProfilePicSermon(
                                                                          //   id: snapshot
                                                                          //   .data!.id,
                                                                          size:
                                                                              40,
                                                                          //  url:
                                                                          //      snapshot.data!.profileImage);
                                                                        );
                                                                      } else if (snapshot
                                                                          .hasError) {
                                                                        return const Text(
                                                                            '?',
                                                                            style:
                                                                                TextStyle(color: Colors.white));
                                                                      } else {
                                                                        return const CircularProgressIndicator();
                                                                      }
                                                                    }),
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                FutureBuilder(
                                                                    future: Theuser
                                                                        .fromId(chat
                                                                            .myid),
                                                                    builder: (context,
                                                                        AsyncSnapshot<Theuser>
                                                                            snapshot) {
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        return ProfilePicSermon(
                                                                          // id: snapshot
                                                                          //     .data!.id,
                                                                          size:
                                                                              40,
                                                                          // url:
                                                                          //     snapshot.data!.profileImage
                                                                        );
                                                                      } else if (snapshot
                                                                          .hasError) {
                                                                        return const Icon(
                                                                            Icons
                                                                                .error,
                                                                            size:
                                                                                50);
                                                                      } else {
                                                                        return const CircularProgressIndicator();
                                                                      }
                                                                    }),
                                                          ),
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          chat.name,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
/*
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: ProfilePic(
                                                                        id: snapshot
                                                                            .data!
                                                                            .id,
                                                                        size:
                                                                            40,
                                                                        url: snapshot
                                                                            .data!
                                                                            .profileImage),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Text(
                                                                      snapshot
                                                                          .data!
                                                                          .name,
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              */
                                                // child: Row(
                                                //   children: [
                                                //     if (group.members
                                                //             .length >
                                                //         2) ...[
                                                //       SizedBox(
                                                //         height: 50,
                                                //         width: 50,
                                                //         child: Stack(
                                                //           children: [
                                                //             Positioned(
                                                //               bottom: 0,
                                                //               right: 0,
                                                //               child:
                                                //                   ProfilePicSermon(
                                                //                 id: group
                                                //                     .subProfile,
                                                //                 url: group
                                                //                     .subProfile,
                                                //                 size: 20,
                                                //               ),
                                                //             ),
                                                //             ProfilePicSermon(
                                                //                 id: group
                                                //                     .latestId,
                                                //                 url: group
                                                //                     .latestProfile,
                                                //                 size: 20),
                                                //           ],
                                                //         ),
                                                //       ),
                                                //     ] else ...[
                                                //       ProfilePicSermon(
                                                //         id: group
                                                //             .latestProfile,
                                                //         url: group
                                                //             .latestProfile,
                                                //         size: 20,
                                                //       ),
                                                //     ],
                                                //     const SizedBox(
                                                //         width: 8),
                                                //     Expanded(
                                                //       child: Column(
                                                //         crossAxisAlignment:
                                                //             CrossAxisAlignment
                                                //                 .start,
                                                //         children: [
                                                //           Text(
                                                //             chat.name,
                                                //             style:
                                                //                 const TextStyle(
                                                //               fontSize: 18,
                                                //               fontWeight:
                                                //                   FontWeight
                                                //                       .bold,
                                                //             ),
                                                //           ),
                                                //           Text(
                                                //             group.latestId ==
                                                //                     locator
                                                //                         .get<
                                                //                             FirestoreMethods>()
                                                //                         .userModel
                                                //                         .id
                                                //                 ? 'You: ${group.latestText}'
                                                //                 : group
                                                //                     .latestText,
                                                //             style:
                                                //                 const TextStyle(
                                                //               fontSize: 18,
                                                //             ),
                                                //           ),
                                                //         ],
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                              ),
                                            );
                                          } else if (chatGroup.hasError) {
                                            return const Text(
                                              'Error loading chat messages',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            );
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        });
                                  });
                            }
                          } else {
                            return const Text(
                              'No messages',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
