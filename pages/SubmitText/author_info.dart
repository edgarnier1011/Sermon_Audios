import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sermons_audio/models/sermon_model.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/resources/screen_dimensions.dart';

//To hold language name.
String _finallanguage = "";

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  //to submit form once required fields are not empty
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //author controller
  final TextEditingController _authorFirstname = TextEditingController();
  //sermon name controller
  final TextEditingController _sermonname = TextEditingController();

  final TextEditingController _authoerSecondname = TextEditingController();

  final TextEditingController _typetextcontroller = TextEditingController();

  //tags to identify denomination(s) of texts

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      showModalBottomSheet(
          backgroundColor: Colors.blueGrey,
          context: context,
          isDismissible: true,
          builder: (context) {
            //name cannot be empty, request name
            return AlertDialog(
              content: const Text(
                  style: TextStyle(color: Colors.white),
                  'Please allow adminstrator to review your text. Note that texts in english or spanish are reviewed faster than texts in other languages.'),
              backgroundColor: Colors.black.withOpacity(0.3),
              title: const Text(
                'Note',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
    //dispose keyboard input
    _authorFirstname.dispose();
    _sermonname.dispose();
    _authoerSecondname.dispose();
    _typetextcontroller.dispose();
    locator.get<LocalData>().resertagschosen();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blueGrey, Colors.blueGrey[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
            title: const Text(
              "Author/Text information",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      maxLength: 26,

                      cursorWidth: 2,
                      textAlign: TextAlign.center,
                      controller: _authorFirstname,
                      decoration: const InputDecoration(
                        hintText: 'Enter author first name',
                      ),
                      // validator property does not allow empty fields
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }

                        if (value.length < 2) {
                          return 'Please enter two or more characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      maxLength: 26,
                      textAlign: TextAlign.center,
                      controller: _authoerSecondname,
                      decoration: const InputDecoration(
                        hintText: 'Enter author last name',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (value.length < 2) {
                          return 'Please enter two or more characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      maxLength: 50,
                      textAlign: TextAlign.center,
                      controller: _sermonname,
                      decoration: const InputDecoration(
                        hintText: 'Enter sermon name',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: const LanguageSelector()),
                  ),
                  //Show possible tags options
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (context) => const ListTags()),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueGrey[300]),
                        child: const Text("Select Tags")),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'Note: Select at least one tag if possible, so others can find it more easily',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.black),
                        )),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              height: queryData.size.height * 0.50,
                              width: queryData.size.width,
                              child: TextFormField(
                                maxLength: 63000,
                                controller: _typetextcontroller,
                                minLines: null,
                                maxLines: null,
                                expands: true,
                                enableInteractiveSelection: true,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          showModalBottomSheet(
                              backgroundColor: Colors.blueGrey,
                              isDismissible: false,
                              enableDrag: false,
                              context: context,
                              builder: (context) => Center(
                                      child: FutureBuilder(
                                    future: _uploadFile(),
                                    builder: (context,
                                        AsyncSnapshot<void> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Column(
                                          children: [
                                            const Text(
                                              'Text has been uploaded, please wait for administrator approval',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor:
                                                      Colors.blueGrey[300]),
                                              child: const Text(
                                                'Exit',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else {
                                        return const Text(
                                            'Some error occured while uploading file',
                                            style:
                                                TextStyle(color: Colors.white));
                                      }
                                    },
                                  )));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueGrey[700]),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadFile() async {
    DateTime datenow = DateTime.now();

    FirestoreService.instance.addDocument(
      path: FirestorePath.addText(),
      data: DocumentParagraphs(
        submitterName: locator.get<FirestoreMethods>().userModel.name,
        dateSubmit: datenow,
        authorName:
            '${_authorFirstname.text} ${_authoerSecondname.text}'.toLowerCase(),
        paragraphs: [_typetextcontroller.text],
        sermonName: _sermonname.text,
        id: '',
        authorid: '', //authorId,
        tags: locator.get<LocalData>().returnTags(),
        userid: AuthMethods().uid,
        language: _finallanguage,
        likes: 0,
        latestAudioid: 'a',
        latestAudiourl: 'a',
        latestnarratorName: 'a',
        latestnarratorid: 'a',
      ).toJson(),
    );
  }
}

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: DropdownMenu(
        textStyle: const TextStyle(color: Colors.white),
        leadingIcon: const Icon(
          Icons.language,
          color: Colors.white,
        ),
        dropdownMenuEntries: const <DropdownMenuEntry<String>>[
          DropdownMenuEntry(value: 'English', label: 'English'),
          DropdownMenuEntry(value: 'Spanish', label: 'Spanish'),
          // DropdownMenuEntry(value: 'Other', label: 'Other'),
        ],
        onSelected: (value) {
          _finallanguage = value!;
          locator.get<LocalData>().setLanguage(value);
        },
        initialSelection: 'English',
        width:
            locator.get<ScreenDimensions>().getDimensions(context).size.width *
                0.80,
      ),
    );
  }
}

//Displays lists of tags and a checkbox, checkbox counter depends on index created by ListView.builder when displayed
class ListTags extends StatefulWidget {
  const ListTags({super.key});

  @override
  State<ListTags> createState() {
    return _ListTags();
  }
}

class _ListTags extends State<ListTags> {
  List<String>? thetags;

  @override
  void initState() {
    super.initState();
    thetags = locator.get<LocalData>().globaltags;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: thetags!.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      //parallel arrays
                      Text(thetags![index]),
                      CheckBoxTags(counter: index)
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class CheckBoxTags extends StatefulWidget {
  final int? counter;
  const CheckBoxTags({super.key, required this.counter});

  @override
  State<CheckBoxTags> createState() => _CheckboxStateTags();
}

class _CheckboxStateTags extends State<CheckBoxTags> {
  bool? isChecked;
  int? mycounter;
  @override
  void initState() {
    super.initState();
    mycounter = widget.counter;
    //if checkbox is already selected, when it rebuilds again, it will still be checked
    if (alreadyselected(mycounter!)) {
      isChecked = true;
    } else {
      isChecked = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        tristate: false,
        value: isChecked,
        onChanged: (
          value,
        ) async {
          setState(() {
            if (value!) {
              locator.get<LocalData>().addtagindex(mycounter!);
            }
            if (!value) {
              locator.get<LocalData>().removetagindex(mycounter!);
            }

            isChecked = value;
          });
        });
  }

  //To determine if checkbox should be checked or not once a rebuild occurs when chosing tags.
  bool alreadyselected(int mycounter) {
    if (locator.get<LocalData>().chosenTags.contains(mycounter)) {
      return true;
    } else {
      return false;
    }
  }
}
