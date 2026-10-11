import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sermons_audio/screens/transition_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final bool _isLoading = false;
  bool agreetoTerms = false;
  bool showPassword = true;
  String errordisplay =
      'Some Error Occurred. Please try again. Make sure email has not already been used and internet connection is available.';
  bool showError = false;

  Future<void> _signUp() async {
    if ((_passwordController.text != _confirmPasswordController.text) ||
        (_passwordController.text.length < 6 &&
            _confirmPasswordController.text.length < 6) ||
        !agreetoTerms ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Make Sure passwords match and are valid ,email is valid, and agree to the terms and conditions')),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to the home screen or do something with the userCredential
    } finally {}
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.4),
          title: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                DecoratedBox(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                ),
                const SizedBox(height: 10),
                DecoratedBox(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: showPassword
                            ? IconButton(
                                onPressed: () => setState(
                                    () => showPassword = !showPassword),
                                icon: const Icon(Icons.visibility))
                            : IconButton(
                                onPressed: () => setState(
                                    () => showPassword = !showPassword),
                                icon: const Icon(Icons.visibility_off))),
                    obscureText: showPassword,
                  ),
                ),
                const SizedBox(height: 10),
                DecoratedBox(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        suffixIcon: showPassword
                            ? IconButton(
                                onPressed: () => setState(
                                    () => showPassword = !showPassword),
                                icon: const Icon(Icons.visibility))
                            : IconButton(
                                onPressed: () => setState(
                                    () => showPassword = !showPassword),
                                icon: const Icon(Icons.visibility_off))),
                    obscureText: showPassword,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () async {
                            final Uri url = Uri.parse(
                                'https://sermonaudiosprivacy.web.app');
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                          child: const Text(
                            'Read Terms and Conditions, Privacy Policy',
                            style: TextStyle(color: Colors.blue),
                          )),
                      Column(
                        children: [
                          const Text(
                            textAlign: TextAlign.center,
                            'By Checking the Box, I agree to the terms and conditions, and Privacy Policy',
                            style: TextStyle(color: Colors.white),
                          ),
                          Checkbox(
                              fillColor: WidgetStateProperty.all(Colors.blue),
                              value: agreetoTerms,
                              onChanged: (value) => setState(() {
                                    agreetoTerms = value!;
                                  })),
                          const Text(
                            'Check Box To Agree To Terms and Conditions',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueGrey[300]),
                        onPressed: () async {
                          await _signUp();
                          if (!showError) {
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TransitionScreen()),
                                  (Route<dynamic> route) => false);
                            }
                          }
                        },
                        child: const Text('Agree and Sign Up'),
                      ),
                showError
                    ? Text(
                        errordisplay,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const SizedBox(),
              ]),
            )),
      ),
    );
  }
}
