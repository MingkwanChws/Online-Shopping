import 'package:flutter/material.dart';
import 'package:online_shop/screens/login_screen.dart';
import 'package:online_shop/screens/registration_screen.dart';

class RegisterOrLoginScreen extends StatefulWidget {
  const RegisterOrLoginScreen({super.key});

  @override
  State<RegisterOrLoginScreen> createState() => _RegisterOrLoginScreenState();
}

class _RegisterOrLoginScreenState extends State<RegisterOrLoginScreen> {
  bool showLoginScreen = true;

  void toggleScreen() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen)
      return LoginScreen();
    else
      return RegistrationScreen();
  }
}
