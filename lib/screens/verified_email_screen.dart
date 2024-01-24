import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/components/rounded_button.dart';
import 'package:online_shop/screens_seller/home_seller_screen.dart';

class VerifiedEmailScreen extends StatefulWidget {
  static const id = 'verified_email';

  const VerifiedEmailScreen({super.key});

  @override
  State<VerifiedEmailScreen> createState() => _VerifiedEmailScreenState();
}

class _VerifiedEmailScreenState extends State<VerifiedEmailScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool isEmailVerified = false;
  bool showSpinner = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });

      await Future.delayed(Duration(seconds: 5));

      setState(() {
        canResendEmail = true;
      });
    } catch (e) {}
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomeSellerScreen()
      : Scaffold(
          appBar: AppBar(
            title: Text('Verify Email'),
            backgroundColor: Colors.grey,
          ),
          body: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'A verification email has been send to your email.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                RoundedButton(
                    loading: false,
                    colour: Colors.black,
                    onPressed: () {
                      canResendEmail ? sendVerificationEmail() : null;
                    },
                    title: 'Resend Email'),
                // SizedBox(height: 8),
                RoundedButton(
                    loading: false,
                    colour: Colors.grey,
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    title: 'Cancel'),
              ],
            ),
          ),
        );
}
