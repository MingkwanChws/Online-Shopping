import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:online_shop/constants.dart';
import 'package:online_shop/components/rounded_button.dart';
import 'package:online_shop/screens/registration_screen.dart';
import 'package:online_shop/screens_seller/home_seller_screen.dart';
import 'package:provider/provider.dart';

import '../controller/login_controller.dart';
import '../components/bottom_navbar.dart';
import '../session_manager.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
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
          create: (_) => LoginController(),
          child: Consumer<LoginController>(
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
                      'Welcome back you\'ve been missed',
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
                          hintStyle: TextStyle(color: Colors.grey[400])),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Please enter your password.'),
                      ]),
                      controller: passwordController,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.grey[400])),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    RoundedButton(
                      loading: provider.loading,
                      colour: Colors.grey,
                      onPressed: () async {
                        try {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              provider.loginWithEmailPass(
                                  context,
                                  emailController.text,
                                  passwordController.text);
                            });
                            // PersistentNavBarNavigator.pushNewScreen(context,
                            //     screen: BottomNavBar(menuScreenContext: context));

                            formKey.currentState!.reset();
                            // Navigator.pushNamed(context, HomeSellerScreen.id);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      title: 'Login',
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
                        Text('or sign in with'),
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
                          'Not a member?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return RegistrationScreen();
                            }));
                          },
                          child: Text(
                            'Register now',
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
