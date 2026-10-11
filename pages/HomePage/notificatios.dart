import 'dart:io';
import 'package:eraser/eraser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sermons_audio/listcomponents/notificationUImodel.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';

class NotificationsIcon extends StatefulWidget {
  const NotificationsIcon({super.key});

  @override
  State<NotificationsIcon> createState() => _NotificationsIconState();
}

class _NotificationsIconState extends State<NotificationsIcon>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;

      case AppLifecycleState.resumed:
        if (locator.get<FirestoreMethods>().userModel.pendingNotfs) {
          setState(() {
            theValuelocal = true;
          });
        } else {
          setState(() {
            theValuelocal = false;
          });
        }
        Eraser.clearAllAppNotifications();

        break;

      case AppLifecycleState.hidden:
        break;

      case AppLifecycleState.paused:
        break;
    }
  }

  bool theValuelocal = false;
  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
    initialPermission(setState);
    WidgetsBinding.instance.addObserver(this);
    if (locator.get<FirestoreMethods>().userModel.pendingNotfs) {
      theValuelocal = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await FirestoreService.instance.updateDocument(
              path: FirestorePath.currUser(), data: {'pendingNotfs': false});
          setState(() {
            theValuelocal = false;
          });
          if (context.mounted) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Material(
                          child: Notifications(),
                        )));
          }
        },
        icon: theValuelocal
            ? const Icon(
                Icons.notifications,
                color: Colors.red,
              )
            : const Icon(
                Icons.notifications_active,
                color: Colors.white,
              ));
  }

  Future<void> setupInteractedMessage() async {
    final settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      // if not granted, ask it again
      await FirebaseMessaging.instance.requestPermission();
    }
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      // still didnot give access? just skip other parts. This user will not get notification anyway
      return;
    }

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen

    if (initialMessage != null) {
      if ((initialMessage.data['notifiedBy'] as String) == AuthMethods().uid) {
        _handleMessage(initialMessage, false);
      }
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        if ((message.data['notifiedBy'] as String) != AuthMethods().uid) {
          setState(() {
            theValuelocal = true;
          });

          _handleMessage(message, true);
        }
      },
    );

    // currently user is using your app, and suddenly get notification. you will listen it here:
    _listenWhenAppIsInForeground();
  }

  void _listenWhenAppIsInForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if ((message.data['notifiedBy'] as String) == AuthMethods().uid) {
        setState(() {
          theValuelocal = true;
        });

        _handleMessage(message, false);
      }
    });
  }

  void _handleMessage(RemoteMessage message, bool onTapNotif) {
    if (onTapNotif) {
      setState(() {
        theValuelocal = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const Material(child: Notifications());
      }));
    }
  }
}

Future<void> initialPermission(Function setmestate) async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Channel',
    description: 'This channel is used for important notifications',
    importance: Importance.high,
    playSound: true,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isAndroid || Platform.isIOS) {
    FirebaseMessaging? messaging;
    messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    if (Platform.isAndroid) {
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Future.delayed(const Duration(milliseconds: 1), () {});
  }

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
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.black.withOpacity(0.4),
                elevation: 0,
                title: const Text(
                  'Notifications',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: FirestoreListView(
                showFetchingIndicator: true,
                pageSize: 10,
                query: FirestoreService.instance.collectionQuery(
                    path: FirestorePath.userNotifications(AuthMethods().uid),
                    queryBuilder: (query) =>
                        query.orderBy('date', descending: true)),
                itemBuilder: (context, snapshot) {
                  UserNotifications noti = UserNotifications.fromJson(
                      snapshot.data() as Map<String, dynamic>);
                  return UserNotificationDisplay(
                      notification:
                          noti); /*
                  Map<String, dynamic> values =
                      snapshot.data() as Map<String, dynamic>;
                  debugPrint('nots');
              
                  return GestureDetector(
                    onTap: values['type'] == 'text'
                        ? () async {
                            Theuser temp =
                                await Theuser.fromId(values['notifiedBy']);
                            if (context.mounted) {
                              pushScreenWithoutNavBar(
                                context,
                                UserProfileV(
                                  previous: '',
                                  userData: temp,
                                  showappBar: true,
                                ),
                              );
                            }
                          }
                        : values['type'] == 'audio'
                            ? () async {
                                Theuser temp = await Theuser.fromId(
                                    values['notifiedBy']);
                                if (context.mounted) {
                                  pushScreenWithoutNavBar(
                                    context,
                                    UserProfileV(
                                      previous: '',
                                      userData: temp,
                                      showappBar: true,
                                    ),
                                  );
                                }
                              }
                            : values['type'] == 'share-text'
                                ? () async {
                                    DocumentParagraphs temp =
                                        await DocumentParagraphs.fromId(
                                            values['textid']);
                                    if (context.mounted) {
                                      pushScreenWithoutNavBar(
                                        context,
                                        SermonPageFinal(
                                          alldataofsermon: temp,
                                        ),
                                      );
                                    }
                                  }
                                : values['type'] == 'share-audio'
                                    ? () async {
                                        if (context.mounted) {}
                                      }
                                    : values['type'] == 'text-admin'
                                        ? null
                                        : values['type'] == 'audio-admin'
                                            ? null
                                            : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: locator
                            .get<ScreenDimensions>()
                            .getDimensions(context)
                            .size
                            .width,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              values['type'] == 'text'
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.textsms_sharp,
                                        color: Colors.white,
                                      ),
                                    )
                                  : values['type'] == 'audio'
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.audio_file_sharp,
                                            color: Colors.white,
                                          ),
                                        )
                                      : values['type'] == 'share-text'
                                          ? const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.share,
                                                color: Colors.white,
                                              ),
                                            )
                                          : values['type'] == 'share-audio'
                                              ? const Padding(
                                                  padding:
                                                      EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.share,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : values['type'] == 'text-admin'
                                                  ? const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        Icons.approval,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : values['type'] ==
                                                          'audio-admin'
                                                      ? const Icon(
                                                          Icons.approval,
                                                          color: Colors.white,
                                                        )
                                                      : const SizedBox(),
                              Expanded(
                                child: Text(
                                  values['data'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  DateFormat.yMMMd()
                                      .add_jm()
                                      .format(values['date'].toDate())
                                      .toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                */
                },
                emptyBuilder: (context) => const Text('Nothing to Show',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          );
        });
  }
}
