// import 'dart:async';
// import 'dart:io';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:record_mp3_plus/record_mp3_plus.dart';
// import 'package:sermons_audio/models/audio_model.dart';
// import 'package:sermons_audio/models/audio_model_sample.dart';
// import 'package:sermons_audio/resources/auth_methods.dart';
// import 'package:sermons_audio/resources/firestore_methods.dart';
// import 'package:sermons_audio/resources/firestore_path.dart';
// import 'package:sermons_audio/resources/firestore_services.dart';

// import 'package:sermons_audio/resources/global.dart';
// import 'package:sermons_audio/resources/local_data.dart';
// import 'package:sermons_audio/resources/screen_dimensions.dart';

// class Recorder extends StatefulWidget {
//   final String textString;
//   final String textid;
//   final String authorid;
//   final String nameofAuthor;
//   final String language;
//   final String nameSermon;
//   final bool existingRecord;
//   const Recorder(
//       {required this.existingRecord,
//       required this.nameSermon,
//       required this.language,
//       required this.nameofAuthor,
//       required this.authorid,
//       required this.textid,
//       required this.textString,
//       super.key});

//   @override
//   State<Recorder> createState() => _MyRecorderState();
// }

// class _MyRecorderState extends State<Recorder> with WidgetsBindingObserver {
//   String _statusText = "";
//   bool _isComplete = false;
//   String? _recordFilePath;
//   bool _isRecording = false;
//   String _statusofPlayer = 'Play';
//   AudioPlayer audioPlayer = AudioPlayer();

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     super.didChangeAppLifecycleState(state);

//     switch (state) {
//       case AppLifecycleState.inactive:
//         RecordMp3.instance.stop();
//         if (audioPlayer.state == PlayerState.playing ||
//             audioPlayer.state == PlayerState.paused) {
//           audioPlayer.stop();
//           audioPlayer.release();
//         }
//         if (_recordFilePath != null) {
//           File(_recordFilePath!).delete(recursive: true);
//         }
//         break;
//       case AppLifecycleState.detached:
//         break;

//       case AppLifecycleState.resumed:
//         break;

//       case AppLifecycleState.hidden:
//         RecordMp3.instance.stop();
//         if (audioPlayer.state == PlayerState.playing ||
//             audioPlayer.state == PlayerState.paused) {
//           audioPlayer.stop();
//           audioPlayer.release();
//         }
//         if (_recordFilePath != null) {
//           File(_recordFilePath!).delete(recursive: true);
//         }

//         break;

//       case AppLifecycleState.paused:
//         RecordMp3.instance.stop();
//         if (audioPlayer.state == PlayerState.playing ||
//             audioPlayer.state == PlayerState.paused) {
//           audioPlayer.stop();
//           audioPlayer.release();
//         }
//         if (_recordFilePath != null) {
//           File(_recordFilePath!).delete(recursive: true);
//         }

//         break;
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     RecordMp3.instance.stop();
//     if (_recordFilePath != null) {
//       File(_recordFilePath!).delete(recursive: true);
//     }
//     if (audioPlayer.state == PlayerState.playing ||
//         audioPlayer.state == PlayerState.paused) {
//       audioPlayer.stop();
//       audioPlayer.release();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     Timer.run(() {
//       showModalBottomSheet(
//           backgroundColor: Colors.blueGrey,
//           context: context,
//           isDismissible: true,
//           builder: (context) {
//             //name cannot be empty, request name
//             return AlertDialog(
//               content: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                     style: TextStyle(color: Colors.white),
//                     'Please wait for adminstrator to approve your recording. Note that recordings in english or spanish are approved faster than recordings in other languages.'),
//               ),
//               backgroundColor: Colors.black.withOpacity(0.3),
//               title: const Text(
//                 'Note',
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             );
//           });
//     });

//     audioPlayer.onPlayerComplete.listen((event) {
//       setState(() {
//         //which would be like showing a icon with the play button once is finished.
//         _statusofPlayer = 'Replay';
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       onPopInvoked: (bool didPop) async {
//         if (didPop) {
//           RecordMp3.instance.stop();
//           if (audioPlayer.state == PlayerState.playing ||
//               audioPlayer.state == PlayerState.paused) {
//             audioPlayer.stop();
//             audioPlayer.release();
//           }
//         }
//       },
//       child: ValueListenableBuilder(
//           valueListenable: locator.get<LocalData>().changesettings,
//           builder: (context, theValue, __) {
//             return DecoratedBox(
//               decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       colors: locator.get<LocalData>().themeColorspallete[
//                           locator.get<LocalData>().currentColorTheme],
//                       stops: const [0.0, 0.15, 0.60, 1.0])),
//               child: Scaffold(
//                 resizeToAvoidBottomInset: false,
//                 backgroundColor: Colors.black.withOpacity(0.3),
//                 appBar: AppBar(
//                   iconTheme: const IconThemeData(color: Colors.white),
//                   title: const Text(
//                     'Recorder',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   backgroundColor: Colors.transparent,
//                   elevation: 0,
//                 ),
//                 body: Column(children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       _isComplete && _recordFilePath != null
//                           ? Expanded(
//                               child: GestureDetector(
//                                 child: Container(
//                                   height: 48.0,
//                                   decoration:
//                                       BoxDecoration(color: Colors.red.shade300),
//                                   child: const Center(
//                                     child: Text(
//                                       'submit',
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           height: 2,
//                                           letterSpacing: 2),
//                                     ),
//                                   ),
//                                 ),
//                                 onTap: () async {
//                                   showModalBottomSheet(
//                                       isDismissible: false,
//                                       backgroundColor: Colors.blueGrey,
//                                       context: context,
//                                       builder: (context) {
//                                         return AlertDialog(
//                                           backgroundColor: Colors.blueGrey,
//                                           actions: [
//                                             ElevatedButton(
//                                                 onPressed: () =>
//                                                     showModalBottomSheet(
//                                                         backgroundColor:
//                                                             Colors.blueGrey,
//                                                         isDismissible: false,
//                                                         context: context,
//                                                         builder:
//                                                             (context) => Center(
//                                                                   child:
//                                                                       FutureBuilder(
//                                                                           future:
//                                                                               _uploadAudio(),
//                                                                           builder:
//                                                                               (context, AsyncSnapshot<void> snapshot) {
//                                                                             if (snapshot.connectionState ==
//                                                                                 ConnectionState.active) {
//                                                                               return const CircularProgressIndicator();
//                                                                             } else if (snapshot.connectionState == ConnectionState.done) {
//                                                                               return Column(
//                                                                                 children: [
//                                                                                   const Padding(
//                                                                                     padding: EdgeInsets.all(8.0),
//                                                                                     child: Text(
//                                                                                       'Audio has been uploaded, Please wait for audio to be approved by administrator',
//                                                                                       style: TextStyle(color: Colors.white, fontSize: 16),
//                                                                                     ),
//                                                                                   ),
//                                                                                   ElevatedButton(
//                                                                                     onPressed: () {
//                                                                                       if (context.mounted) {
//                                                                                         Navigator.pop(context);
//                                                                                         Navigator.pop(context);
//                                                                                         Navigator.pop(context);
//                                                                                       }
//                                                                                     },
//                                                                                     style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.blueGrey[300]),
//                                                                                     child: const Text(
//                                                                                       'Exit',
//                                                                                       style: TextStyle(color: Colors.white),
//                                                                                     ),
//                                                                                   ),
//                                                                                 ],
//                                                                               );
//                                                                             } else if (snapshot.connectionState == ConnectionState.waiting) {
//                                                                               return const CircularProgressIndicator();
//                                                                             } else {
//                                                                               return const Text('Some error occured while uploading audio', style: TextStyle(color: Colors.white));
//                                                                             }
//                                                                           }),
//                                                                 )),
//                                                 child: const Text("Confirm")),
//                                             ElevatedButton(
//                                               onPressed: () =>
//                                                   Navigator.pop(context),
//                                               style: ElevatedButton.styleFrom(
//                                                   foregroundColor: Colors.white,
//                                                   backgroundColor:
//                                                       Colors.blueGrey[300]),
//                                               child: const Text(
//                                                 "Cancel submit",
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                             )
//                                           ],
//                                         );
//                                       });
//                                 },
//                               ),
//                             )
//                           : const SizedBox(),
//                       _recordFilePath == null && _isComplete == false
//                           ? Expanded(
//                               child: GestureDetector(
//                                 child: Container(
//                                   height: 48.0,
//                                   decoration: const BoxDecoration(
//                                       color: Colors.blueGrey),
//                                   child: const Center(
//                                     child: Text(
//                                       'start',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                                 onTap: () async {
//                                   _startRecord();
//                                 },
//                               ),
//                             )
//                           : _recordFilePath != null && !_isRecording
//                               ? Expanded(
//                                   child: GestureDetector(
//                                     child: Container(
//                                       height: 48.0,
//                                       decoration: const BoxDecoration(
//                                           color: Colors.blueGrey),
//                                       child: const Center(
//                                         child: Text(
//                                           'restart',
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                     onTap: () async {
//                                       File(_recordFilePath!)
//                                           .delete(recursive: true);

//                                       setState(() {
//                                         _isComplete = false;
//                                         _isRecording = true;

//                                         _startRecord();
//                                       });
//                                     },
//                                   ),
//                                 )
//                               : const SizedBox(),
//                       _isRecording
//                           ? Expanded(
//                               child: GestureDetector(
//                                 child: Container(
//                                   height: 48.0,
//                                   decoration: BoxDecoration(
//                                       color: Colors.green.shade300),
//                                   child: const Center(
//                                     child: Text(
//                                       'stop',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                                 onTap: () {
//                                   _stopRecord();
//                                 },
//                               ),
//                             )
//                           : const SizedBox(),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 20.0),
//                     child: Text(
//                       _statusText,
//                       style: const TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                   ),
//                   (_isComplete && audioPlayer.state != PlayerState.playing)
//                       ? GestureDetector(
//                           behavior: HitTestBehavior.opaque,
//                           onTap: () {
//                             _play();
//                             setState(() {
//                               _statusofPlayer = 'Pause';
//                             });
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.only(top: 30),
//                             alignment: AlignmentDirectional.center,
//                             width: 100,
//                             height: 50,
//                             child: _isComplete && _recordFilePath != null
//                                 ? Text(
//                                     _statusofPlayer,
//                                     style: const TextStyle(
//                                         color: Colors.red, fontSize: 20),
//                                   )
//                                 : Container(),
//                           ),
//                         )
//                       : _statusofPlayer == 'Pause'
//                           ? GestureDetector(
//                               behavior: HitTestBehavior.opaque,
//                               onTap: () {
//                                 _pause();
//                                 setState(() {
//                                   _statusofPlayer = 'Continue Playing';
//                                 });
//                               },
//                               child: Container(
//                                 margin: const EdgeInsets.only(top: 30),
//                                 alignment: AlignmentDirectional.center,
//                                 width: 100,
//                                 height: 50,
//                                 child: _isComplete && _recordFilePath != null
//                                     ? Text(
//                                         softWrap: true,
//                                         _statusofPlayer,
//                                         style: const TextStyle(
//                                             color: Colors.red, fontSize: 20),
//                                       )
//                                     : Container(),
//                               ),
//                             )
//                           : _statusofPlayer == 'Continue Playing'
//                               ? GestureDetector(
//                                   behavior: HitTestBehavior.opaque,
//                                   onTap: () {
//                                     setState(() {
//                                       _resume();
//                                       _statusofPlayer = 'Pause';
//                                     });
//                                   },
//                                   child: Container(
//                                     margin: const EdgeInsets.only(top: 30),
//                                     alignment: AlignmentDirectional.center,
//                                     width: 100,
//                                     height: 50,
//                                     child:
//                                         _isComplete && _recordFilePath != null
//                                             ? Text(
//                                                 _statusofPlayer,
//                                                 style: const TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 20),
//                                               )
//                                             : Container(),
//                                   ),
//                                 )
//                               : const SizedBox(),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   Flexible(
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: SingleChildScrollView(
//                         child: Container(
//                           width: locator
//                               .get<ScreenDimensions>()
//                               .getDimensions(context)
//                               .size
//                               .width,
//                           decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.4)),
//                           child: Text(
//                             widget.textString,
//                             softWrap: true,
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 wordSpacing: 2,
//                                 fontSize: 16,
//                                 height: 2),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ]),
//               ),
//             );
//           }),
//     );
//   }

//   Future<bool> _checkPermission() async {
//     if (!kIsWeb) {
//       if (!await Permission.microphone.isGranted) {
//         PermissionStatus status = await Permission.microphone.request();
//         if (status != PermissionStatus.granted) {
//           return false;
//         }
//       }
//     }

//     return true;
//   }

//   void _startRecord() async {
//     bool hasPermission = await _checkPermission();
//     if (hasPermission) {
//       _recordFilePath = await _getFilePath();
//       debugPrint(_recordFilePath);
//       _isComplete = false;

//       RecordMp3.instance.start(_recordFilePath!, (type) {
//         _statusText = "Record error--->$type";
//         _statusText = "Recording...";
//       });

//       setState(() {
//         _statusText = "Recording...";
//         _isRecording = true;
//       });
//     } else {
//       setState(() {
//         _statusText = "No microphone permission";
//       });
//     }
//   }

//   void _stopRecord() {
//     bool s = RecordMp3.instance.stop();
//     if (s) {
//       _statusText = "Record complete";
//       _isComplete = true;
//       _isRecording = false;
//       setState(() {});
//     }
//   }

//   void _play() {
//     if (_recordFilePath != null && File(_recordFilePath!).existsSync()) {
//       audioPlayer.play(DeviceFileSource(_recordFilePath!));
//     }
//   }

//   void _pause() {
//     audioPlayer.pause();
//   }

//   void _resume() {
//     setState(() {
//       _statusofPlayer = 'Continue Playing';
//       audioPlayer.resume();
//     });
//   }

//   int i = 0;

//   Future<String> _getFilePath() async {
//     Directory storageDirectory = await getTemporaryDirectory();
//     String sdPath = "${storageDirectory.path}/record";
//     debugPrint(sdPath);
//     var d = Directory(sdPath);
//     if (!d.existsSync()) {
//       d.createSync(recursive: true);
//     }
//     return "$sdPath/${AuthMethods().uid}-${widget.textid}.mp3";
//   }

//   Future<void> _uploadAudio() async {
//     String storeto = await _getFilePath();

//     final temp = FirebaseStorage.instance
//         .ref()
//         .child('Audios/${widget.textid}/${AuthMethods().uid}.mp3');

//     await temp.putFile(File(storeto));

//     final temp1 = FirebaseStorage.instance
//         .ref()
//         .child('AudiosSamples/${widget.textid}/${AuthMethods().uid}.mp3');

//     Uint8List getSamplebytes = await File(storeto).readAsBytes();
//     getSamplebytes =
//         getSamplebytes.sublist(0, (getSamplebytes.length * 0.10).toInt());

//     await temp1.putData(
//       getSamplebytes,
//     );

//     String theurlOfFile = await temp.getDownloadURL();

//     String theurlOfFileSample = await temp1.getDownloadURL();

//     DateTime nowtime = DateTime.now();

//     String audioID = await FirestoreService.instance.addDocument(
//         path: FirestorePath.audioadd(),
//         data: AudioCreate(
//                 newAudio: widget.existingRecord,
//                 approval: false,
//                 sermonName: widget.nameSermon,
//                 language: widget.language,
//                 nameofAuthor: widget.nameofAuthor,
//                 nameOfnarrator: locator.get<FirestoreMethods>().userModel.name,
//                 datesubmit: nowtime,
//                 urlfromstorage: theurlOfFile,
//                 textid: widget.textid,
//                 userid: AuthMethods().uid)
//             .toJson());

//     FirestoreService.instance.addDocument(
//         path: FirestorePath.audioaddSample(),
//         data: AudioCreateSample(
//                 newAudio: widget.existingRecord,
//                 approval: false,
//                 audioIDorigin: audioID,
//                 sermonName: widget.nameSermon,
//                 language: widget.language,
//                 nameofAuthor: widget.nameofAuthor,
//                 nameOfnarrator: locator.get<FirestoreMethods>().userModel.name,
//                 datesubmit: nowtime,
//                 urlfromstorage: theurlOfFileSample,
//                 textid: widget.textid,
//                 userid: AuthMethods().uid)
//             .toJson());
//   }
// }
