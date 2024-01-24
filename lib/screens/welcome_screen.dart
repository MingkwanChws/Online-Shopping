import 'package:flutter/material.dart';
import 'package:online_shop/components/rounded_button.dart';
import 'package:online_shop/screens/login_screen.dart';
import 'package:online_shop/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.forward();
  }

  @override
  dispose() {
    controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset(
                      ('images/logo.png'),
                      height: 50,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                AnimatedTextKit(animatedTexts: [
                  TypewriterAnimatedText(
                    'Rabbit.Tape',
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                ]),
              ],
            ),
            SizedBox(
              height: 48,
            ),
            RoundedButton(
                loading: false,
                colour: Colors.grey,
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }));
                },
                title: 'Login'),
            RoundedButton(
              loading: false,
              colour: Colors.black,
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return RegistrationScreen();
                }));
              },
              title: 'Register',
            )
          ],
        ),
      ),
    );
  }
}
