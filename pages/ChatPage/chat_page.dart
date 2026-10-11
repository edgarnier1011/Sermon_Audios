import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sermons_audio/models/chat_group_model.dart';
import 'package:sermons_audio/models/chat_model.dart';
import 'package:sermons_audio/models/user_model.dart';
import 'package:sermons_audio/pages/ProfilePage/user_profile_visitor.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:intl/intl.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/resources/screen_dimensions.dart';
import 'package:sermons_audio/utils/profilepic.dart';

class ChatPage extends StatefulWidget {
  final String group;
  final String name;
  final List<String> members;
  const ChatPage(
      {required this.group,
      required this.name,
      required this.members,
      super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController _promptController;
  late ScrollController _listScrollController;
  late FocusNode _focusNode;
  Future<int>? messageCount;

  @override
  void initState() {
    _promptController = TextEditingController();
    _listScrollController = ScrollController();
    _focusNode = FocusNode();
    messageCount = messagesCount();

    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    _promptController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Main UI
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
                    stops: const [0.0, 0.15, 0.60, 1.0])),
            child: Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.black.withOpacity(0.4),
                elevation: 0,
                actions: [
                  IconButton(
                      onPressed: () => Navigator.popUntil(context,
                          (Route<dynamic> predicate) => predicate.isFirst),
                      icon: const Icon(
                        Icons.home_filled,
                        color: Colors.white,
                      )),
                ],
              ),
              backgroundColor: Colors.transparent,
              body: FutureBuilder(
                  future: listmembers(widget.members),
                  builder:
                      (context, AsyncSnapshot<List<Theuser>> snapshotusers) {
                    if (snapshotusers.hasData) {
                      return FutureBuilder(
                          future: messageCount,
                          builder:
                              (context, AsyncSnapshot<int> snapshotMessages) {
                            if (snapshotMessages.hasData) {
                              locator
                                  .get<LocalData>()
                                  .setmessageTosend(snapshotMessages.data!);
                              return FutureBuilder(
                                  future: locator
                                      .get<FirestoreMethods>()
                                      .getChatGroup(widget.group),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        children: [
                                          Flexible(
                                            child:
                                                StreamBuilder<List<ChatModel>>(
                                              initialData: const [],
                                              stream: locator
                                                  .get<FirestoreMethods>()
                                                  .getChatStream(widget.group),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return ListView.builder(
                                                    reverse: true,
                                                    itemCount:
                                                        snapshot.data!.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      bool showDate = false;
                                                      if (index !=
                                                          snapshot.data!
                                                                  .length -
                                                              1) {
                                                        if (!DateUtils
                                                            .isSameDay(
                                                          snapshot.data![index]
                                                              .time,
                                                          snapshot
                                                              .data![index + 1]
                                                              .time,
                                                        )) {
                                                          showDate = true;
                                                        }
                                                      } else {
                                                        showDate = true;
                                                      }
                                                      return ChatWidget(
                                                        chatModel: snapshot
                                                            .data![index],
                                                        user: snapshotusers
                                                            .data!
                                                            .firstWhere(
                                                          (element) =>
                                                              element.id ==
                                                              snapshot
                                                                  .data![index]
                                                                  .from,
                                                        ),
                                                        showDate: showDate,
                                                      );
                                                    },
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return const Center(
                                                    child: Text(
                                                        'Something went wrong!',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  );
                                                } else {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          ValueListenableBuilder(
                                              valueListenable: locator
                                                  .get<LocalData>()
                                                  .messagesCount,
                                              builder: (context, theValue, __) {
                                                return Material(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          height: 60,
                                                          width: locator
                                                                  .get<
                                                                      ScreenDimensions>()
                                                                  .getDimensions(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.75,
                                                          child:
                                                              ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount: locator
                                                                .get<
                                                                    LocalData>()
                                                                .messagesTosend
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: GestureDetector(
                                                                    onTap: (locator.get<LocalData>().messagesCount.value < 5)
                                                                        ? () async {
                                                                            locator.get<FirestoreMethods>().sendChatMessage(
                                                                                //_promptController.text,
                                                                                locator.get<LocalData>().messagesTosend[index],
                                                                                widget.group,
                                                                                snapshotusers.data!.first.id);
                                                                            _promptController.clear();
                                                                            _focusNode.unfocus();

                                                                            locator.get<LocalData>().increasemessageCount();
                                                                          }
                                                                        : () => showModalBottomSheet(
                                                                            backgroundColor: Colors.blueGrey,
                                                                            context: context,
                                                                            builder: (context) => Material(
                                                                                  color: Colors.blueGrey,
                                                                                  child: AlertDialog(
                                                                                    backgroundColor: Colors.black.withOpacity(0.4),
                                                                                    title: const Text(
                                                                                      'Limit Reached for this conversation\nonly text and audio sharing is allowed',
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                    child: Container(
                                                                      decoration: const BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              8)),
                                                                          color:
                                                                              Colors.blueGrey),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              Text(
                                                                            locator.get<LocalData>().messagesTosend[index],
                                                                            style:
                                                                                const TextStyle(color: Colors.white),
                                                                            softWrap:
                                                                                true,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            '{$theValue}/5',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ],
                                      );
                                      //);
                                    } else if (snapshot.hasError) {
                                      return const Text(
                                        "Some Error occured",
                                        style: TextStyle(color: Colors.white),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  });
                            } else if (snapshotMessages.hasError) {
                              return const Text(
                                  'Error receiving total messages send',
                                  style: TextStyle(color: Colors.white));
                            } else {
                              return const CircularProgressIndicator();
                            }
                          });
                    } else if (snapshotusers.hasError) {
                      return const Text('Error uploading chat');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
          );
        });
  }

  Future<int> messagesCount() async {
    int messagesCount = 0;
    ChatGroup? temp;
    await FirestoreService.instance.documentFuture(
        path: FirestorePath.chatGroup(widget.group),
        builder: (snap) => {
              temp = ChatGroup.fromSnap(snap),
              messagesCount = temp!.messagesCount
            });

    return messagesCount;
  }
}

// to display the UI of chat messages and how they are displayed
class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.chatModel,
    required this.user,
    this.showDate = false,
  });

  final ChatModel chatModel;
  final Theuser user;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    bool me = user.id == locator.get<FirestoreMethods>().userModel.id;
    String time = DateFormat.jm().format(chatModel.time!.toLocal());
    String date = DateFormat.yMMMd('en_US').format(chatModel.time!.toLocal());
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          if (showDate) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Divider(
                      indent: 20,
                      endIndent: 10,
                      color: Colors.white,
                    ),
                  ),
                  Text(date, style: const TextStyle(color: Colors.white)),
                  const Expanded(
                    child: Divider(
                      indent: 10,
                      endIndent: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                me ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (me) ...[
                const SizedBox(width: 100),
                Text(time, style: const TextStyle(color: Colors.white)),
              ] else ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => pushScreenWithoutNavBar(
                      context,
                      UserProfileV(
                          previous: '', showappBar: true, userData: user)),
                  child: ProfilePicSermon(
                    // url: user.profileImage,
                    size: 36,
                    // id: '',
                  ),
                ),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!me) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          displayName(user.name),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      child: FutureBuilder(
                        future: _isEvent(chatModel.text),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!;
                          } else if (snapshot.hasError) {
                            return Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (!me) ...[
                Text(
                  time,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 100),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<Widget> _isEvent(String chat) async {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        chatModel.text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}

Future<List<Theuser>> listmembers(List<String> userids) async {
  List<Theuser> temp = [];

  for (int i = 0; i < userids.length; i++) {
    temp.add(await Theuser.fromId(userids[i]));
  }

  return temp;
}

String displayName(String nameFromdatabase) {
  String finalString = '';
  List<String> tokensname = nameFromdatabase.split(' ');
  for (int i = 0; i < tokensname.length; i++) {
    finalString =
        '$finalString${tokensname[i][0].toUpperCase()}${tokensname[i].substring(1)} ';
  }

  return finalString.trimRight();
}
