import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image_v2/flutter_native_image_v2.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';

/*This class was to upload profile pictures and banner pictures when a profile page was still part of the application, it is no longer needed for now. */
class Fileupload extends StatefulWidget {
  //hold string to decide of it is profile or banner picture
  final String profileorBanner;
  const Fileupload({
    super.key,
    required this.profileorBanner,
  });
  @override
  State<Fileupload> createState() => _Fileupload();
}

class _Fileupload extends State<Fileupload> {
  //variables predefined by the import of the library that performs the upload operations.
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  Uint8List? webpickedFile;
  String? path;
  File? file;

  //the corresponding folder in database.
  String toFolder = "";
  String? toRoot;
  bool isformatCorrect = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    toFolder = widget.profileorBanner;

    if (toFolder == 'profileImage') {
      toRoot = 'profileImage';
    } else {
      toRoot = 'bannerImage';
    }
  }

  Future uploadFile() async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path!);
      final Reference? thepathreal;
      if (!kIsWeb) {
        TaskSnapshot thepath = await ref.putFile(file!);
        thepathreal = FirebaseStorage.instance.ref(thepath.ref.fullPath);
      } else {
        TaskSnapshot thepath = await ref.putData(webpickedFile!);
        thepathreal = FirebaseStorage.instance.ref(thepath.ref.fullPath);
      }
      String temp = await ref.getDownloadURL();

      if (widget.profileorBanner != 'bannerImage') {
        await FirestoreService.instance.updateDocument(
            path: FirestorePath.currUser(),
            data: {
              'imageProfilerealPath': thepathreal.fullPath,
              widget.profileorBanner: temp
            });
      } else {
        await FirestoreService.instance.updateDocument(
            path: FirestorePath.currUser(),
            data: {
              'imageBannerrealPath': thepathreal.fullPath,
              widget.profileorBanner: temp
            });
      }
    } catch (error) {
      errorMessage = error.toString();
    }
  }

  Future selectFile() async {
    await Permission.photos.request();
    final returnedFile =
        await FilePicker.platform.pickFiles(type: FileType.image);

    File compressedFile = await FlutterNativeImage.compressImage(
      returnedFile!.files.first.path!,
      quality: 10,
    );

    if (!kIsWeb) {
      setState(() {
        pickedFile = returnedFile.files.first;
        path = '$toRoot/$toFolder/${AuthMethods().uid}/$toRoot';

        file = compressedFile;
        isformatCorrect =
            lookupMimeType(returnedFile.files.first.path!)!.contains('image/');
      });
    } else {
      setState(() {
        path = '$toRoot/$toFolder/${AuthMethods().uid}/$toRoot';

        webpickedFile = compressedFile.readAsBytesSync();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Upload Photo",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black.withOpacity(0.4),
        ),
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: Column(
            children: [
              if (pickedFile != null)
                Expanded(
                  child: Container(
                      decoration: const BoxDecoration(color: Colors.blueGrey),
                      child: Image.file(
                        File(pickedFile!.path!),
                        width: double.infinity,
                        fit: BoxFit.contain,
                      )),
                ),
              if (webpickedFile != null)
                Expanded(
                  child: Container(
                      decoration: const BoxDecoration(color: Colors.blueGrey),
                      child: Image.memory(
                        webpickedFile!,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      )),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueGrey[300]),
                    onPressed: selectFile,
                    child: const Text("Select File")),
              ),
              isformatCorrect
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blueGrey[300]),
                          onPressed: () => showModalBottomSheet(
                              isDismissible: false,
                              backgroundColor: Colors.blueGrey,
                              context: context,
                              builder: (context) => Center(
                                    child: FutureBuilder(
                                      future: uploadFile(),
                                      builder:
                                          (context, AsyncSnapshot<void> snap) {
                                        if (snap.connectionState ==
                                            ConnectionState.active) {
                                          return const CircularProgressIndicator();
                                        } else if (snap.connectionState ==
                                            ConnectionState.done) {
                                          return Column(
                                            children: [
                                              errorMessage.isEmpty
                                                  ? const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        'Done. If picture error appears, try again with different photo. Only photos are allowed and Maximum size is 10MB',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        errorMessage,
                                                        style: const TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Colors.blueGrey[300]),
                                                child: const Text('Exit'),
                                              ),
                                            ],
                                          );
                                        } else if (snap.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          return const Text(
                                              'Error to upload photo',
                                              style: TextStyle(
                                                  color: Colors.white));
                                        }
                                      },
                                    ),
                                  )),
                          child: const Text("Confirm")),
                    )
                  : const SizedBox(),
            ],
          ),
        ));
  }
}
