import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/controller/login_controller.dart';

class AuthScreen extends StatelessWidget {
  static const id = 'auth';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: LoginController().isLogin(context),
    );
  }
}

// StreamBuilder(
// stream: FirebaseAuth.instance.authStateChanges(),
// builder: (context, user) {
// print(user);
// if (user != null) {
// return HomeSellerScreen();
// } else {
// return WelcomeScreen();
// }
// })
