import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:online_shop/screens/login_screen.dart';
import 'package:online_shop/screens/welcome_screen.dart';
import 'package:online_shop/screens_buyer/main_buyer_screen.dart';
import 'package:online_shop/screens_seller/home_seller_screen.dart';
import 'package:online_shop/session_manager.dart';

import '../screens_buyer/home_buyer_screen.dart';

class LoginController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('users');

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  isLogin(BuildContext context) {
    final user = auth.currentUser;
    if (user != null) {
      SessionController().userId = user.uid.toString();
      Timer(
          Duration(seconds: 0),
          () => SessionController().userId == 'bRUauejvXIRpEtOimGAKw0Z50dE2'
              ? Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                  return HomeSellerScreen();
                }))
              : Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                  return MainScreen();
                })));
    } else {
      Timer(
          Duration(seconds: 0),
          () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return LoginScreen();
              })));
    }
  }

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  loginWithEmailPass(
      BuildContext context, String email, String password) async {
    setLoading(true);
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        if (auth.currentUser != null) {
          SessionController().userId = await value.user!.uid.toString();
          print(SessionController().userId);
          setLoading(false);
          await firestore.doc(value.user!.uid).get().then((value) {
            print(value.get('role'));
            if (value.get('role') == 'admin') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeSellerScreen()),
                (Route<dynamic> route) => false,
              );
            } else if (value.get('role') == 'customer') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
                (Route<dynamic> route) => false,
              );
            }
          });

          // print(role);
        }
      });
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message!);
      setLoading(false);
    } catch (e) {
      print(e);
      setLoading(false);
    }
  }

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
}
