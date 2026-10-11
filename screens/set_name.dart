import 'package:flutter/material.dart';

import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/firestore_methods.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/screens/navigation_screen.dart';

class SetNameWelcomeScreen extends StatefulWidget {
  const SetNameWelcomeScreen({
    super.key,
  });

  @override
  State<SetNameWelcomeScreen> createState() => _SetNameWelcomeScreenState();
}

class _SetNameWelcomeScreenState extends State<SetNameWelcomeScreen> {
  late TextEditingController _controllerFirstname;
  late TextEditingController _controllerSecondname;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controllerFirstname = TextEditingController();
    _controllerSecondname = TextEditingController();
    AuthMethods().currentUser.reload();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerFirstname.dispose();
    _controllerSecondname.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: locator
            .get<FirestoreMethods>()
            .initializeUser(AuthMethods().currentUser),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  title: const Text(
                    'Welcome',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                backgroundColor: Colors.blueGrey,
                body: DefaultTextStyle(
                  style: const TextStyle(color: Colors.white),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: Colors.white70,
                                    ),
                                    child: TextFormField(
                                      maxLength: 26,
                                      cursorWidth: 2,
                                      textAlign: TextAlign.center,
                                      controller: _controllerFirstname,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter your first name',
                                      ),
                                      // validator property does not allow empty fields
                                      validator: (value) {
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: Colors.white70,
                                    ),
                                    child: TextFormField(
                                      maxLength: 26,
                                      cursorWidth: 2,
                                      textAlign: TextAlign.center,
                                      controller: _controllerSecondname,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter your last name',
                                      ),
                                      // validator property does not allow empty fields
                                      validator: (value) {
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
                                ),
                                // const SelectLanguageUI(),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  "Default language is English. More languages to be added in future updates",
                                  softWrap: true,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Ingles es el lenguage preestablecido. Mas idiomas seran agregados en futuras mejoras.",
                                  softWrap: true,
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await locator
                                              .get<FirestoreMethods>()
                                              .setUserNameandLanguage(
                                                  _controllerFirstname.text
                                                      .trim()
                                                      .toLowerCase(),
                                                  _controllerSecondname.text
                                                      .trim()
                                                      .toLowerCase());
                                          /*         
                                      if (locator.get<LocalData>().uiLanguage !=
                                          'English' /* <- the default*/) {
                                        await locator
                                            .get<FirestoreMethods>()
                                            .setprefferedLanguage(locator
                                                .get<LocalData>()
                                                .uiLanguage);
                                      }
                                      */

                                          if (context.mounted) {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Material(
                                                            child:
                                                                NavigationScreen())),
                                                (Route<dynamic> route) =>
                                                    false);
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              Colors.blueGrey[300]),
                                      child: const Text('Submit')),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
                child: Text(
                    "Some error ocurred with the server, please restart application from phone home menu"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
