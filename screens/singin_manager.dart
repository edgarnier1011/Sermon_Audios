import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SignInScreen(
          showPasswordVisibilityToggle: true,
          showAuthActionSwitch: true,
          resizeToAvoidBottomInset: false,
          providers: [EmailAuthProvider()],
        ),
      ),
    );
  }
}
