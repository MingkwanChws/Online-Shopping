import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:online_shop/controller/login_controller.dart';
import 'package:online_shop/constants.dart';
import 'package:online_shop/components/rounded_button.dart';
import 'package:online_shop/controller/signup_controller.dart';
import 'package:online_shop/screens/login_screen.dart';
import 'package:online_shop/screens/verified_email_screen.dart';
import 'package:online_shop/screens_seller/home_seller_screen.dart';
import 'package:provider/provider.dart';

import '../session_manager.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'register';

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');
  late String email;
  late String password;
  bool showLoading = false;
  final formKey = GlobalKey<FormState>();

  void showErrorMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.grey[400],
        textColor: Colors.white,
        fontSize: 16.0,
        webShowClose: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: ChangeNotifierProvider(
          create: (_) => SignUpController(),
          child: Consumer<SignUpController>(
            builder: (context, provider, child) {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      child: Hero(
                        tag: 'logo',
                        child: Container(
                          height: 200.0,
                          child: Image.asset('images/logo.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 48.0,
                    ),
                    Text(
                      'Let\'s create an account for you!',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TextFormField(
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Please enter your email.'),
                        EmailValidator(errorText: 'Invalid email format')
                      ]),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Please enter your password.'),
                        MinLengthValidator(8,
                            errorText:
                                'password must be at least 8 digits long'),
                        PatternValidator(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])',
                            errorText:
                                'at least one upper case/one lower case/one digit')
                      ]),
                      controller: passwordController,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.grey[400])),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Please enter your confirm password.'),
                        MinLengthValidator(8,
                            errorText:
                                'password must be at least 8 digits long'),
                        PatternValidator(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])',
                            errorText:
                                'at least one upper case/one lower case/one digit')
                      ]),
                      controller: confirmPasswordController,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter confirm password',
                          hintStyle: TextStyle(color: Colors.grey[400])),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    RoundedButton(
                      loading: provider.loading,
                      colour: Colors.black,
                      onPressed: () async {
                        try {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              provider.signup(
                                context,
                                emailController.text,
                                passwordController.text,
                                confirmPasswordController.text,
                              );
                            });
                            formKey.currentState!.reset();
                            // Navigator.pushNamed(context, HomeSellerScreen.id);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      title: 'Register',
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text('or sign up with'),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 75,
                          height: 55,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            onPressed: () async {
                              setState(() {
                                showLoading = true;
                              });
                              if (await LoginController().signInWithGoogle() !=
                                  null) {
                                Navigator.pushNamed(
                                    context, HomeSellerScreen.id);
                              }
                              setState(() {
                                showLoading = false;
                              });
                            },
                            child: Image.asset('images/logo_google.png'),
                          ),
                        ),
                        SizedBox(
                          width: 75,
                          height: 55,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            onPressed: () {},
                            child: Image.asset('images/logo_facebook.png'),
                          ),
                        ),
                        SizedBox(
                          width: 75,
                          height: 55,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            onPressed: () {},
                            child: Image.asset('images/logo_google.png'),
                          ),
                        ),
                        SizedBox(
                          width: 75,
                          height: 55,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            onPressed: () {},
                            child: Image.asset('images/logo_facebook.png'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have a account?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginScreen();
                            }));
                          },
                          child: Text(
                            'Login now',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
//
// try {
// if (passwordController.text ==
// confirmPasswordController.text) {
// await auth
//     .createUserWithEmailAndPassword(
// email: emailController.text, password: passwordController.text)
//     .then((value) {
// SessionController().userId =
// value.user!.uid.toString();
// ref.child(value.user!.uid.toString()).set({
// 'uid': value.user!.uid.toString(),
// 'email': value.user!.email.toString(),
// }).then((value) => Navigator.pushNamed(
// context, VerifiedEmailScreen.id));
// }).onError((error, stackTrace) {
// showErrorMessage(error.toString());
// });
// } else {
// showErrorMessage('Password don\'t match!');
// }
// } on FirebaseAuthException catch (e) {
// showErrorMessage(e.code);
// } catch (e) {
// print(e);
// }

// dynamic newUser = SignUpController().signup(
//     context,
//     emailController.text,
//     passwordController.text,
//     confirmPasswordController.text);
//
// if (await newUser != null) {
//   SessionController().userId =
//       newUser.user!.uid.toString();
//   ref.child(newUser.user!.uid.toString()).set({
//     'uid': newUser.user!.uid.toString(),
//     'email': newUser.user!.email.toString(),
//   }).then((value) {
//     Navigator.pushNamed(context, VerifiedEmailScreen.id);
//   });
// }
