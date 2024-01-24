import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_shop/screens_buyer/home_buyer_screen.dart';
import 'package:online_shop/screens_seller/home_seller_screen.dart';
import 'package:online_shop/session_manager.dart';
import '../screens/verified_email_screen.dart';

class SignUpController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  signup(BuildContext context, String email, String password,
      String confirmPassword) async {
    setLoading(true);
    try {
      if (password == confirmPassword) {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          if (auth.currentUser != null) {
            SessionController().userId = await value.user!.uid.toString();
            print(SessionController().userId);

            await firestore.collection('users').doc(value.user!.uid).set({
              'uid': value.user!.uid.toString(),
              'email': value.user!.email.toString(),
              'username': '',
              'image': '',
              'role': 'customer'
            }).then((value) => setLoading(false));
            setLoading(false);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeBuyerScreen()),
              (Route<dynamic> route) => false,
            );
          } else {
            setLoading(false);
          }
        }).onError((error, stackTrace) {
          setLoading(false);
          showErrorMessage(error.toString());
        });
      } else {
        showErrorMessage('Password don\'t match!');
        setLoading(false);
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
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
