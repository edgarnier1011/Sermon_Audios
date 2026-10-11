import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sermons_audio/screens/forgot_password.dart';
import 'package:sermons_audio/screens/newsignup_screen.dart';
import 'package:sermons_audio/screens/transition_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool errordisplay = false;
  String errorMessage =
      'Some Error Occurred. Please try again. Make sure email and password are correct, and internet connection is active.';
  bool showPassword = true;

  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        _isLoading = true;
      });

      // Navigate to the home screen or do something with the userCredential
    } catch (error) {
      setState(() {
        errordisplay = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.blueGrey,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  const Text('Sermon Audios',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Sign In',
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                  DecoratedBox(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blueGrey[300]),
                              onPressed: () async {
                                await _signIn();

                                if (!errordisplay) {
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TransitionScreen()));
                                  }
                                }
                              },
                              child: const Text('Sign In'),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Colors.red.withOpacity(0.8)),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen())),
                                child: const Text('No Account?, Sign Up')),
                          ],
                        ),
                  errordisplay
                      ? Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueGrey[300]),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Material(
                                  child: ResetPasswordScreen()))),
                      child: const Text('Forgot Password?'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
