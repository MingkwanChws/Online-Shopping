import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:online_shop/screens/login_screen.dart';
import 'package:online_shop/screens/welcome_screen.dart';
import 'package:online_shop/screens_seller/account_seller_screen.dart';
import 'package:online_shop/screens_seller/myproduct_screen.dart';
import 'package:online_shop/screens_seller/report_screen.dart';
import 'package:online_shop/session_manager.dart';

class HomeSellerScreen extends StatefulWidget {
  const HomeSellerScreen({super.key});
  static const id = 'home_seller';

  @override
  State<HomeSellerScreen> createState() => _HomeSellerScreenState();
}

class _HomeSellerScreenState extends State<HomeSellerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              color: Colors.black,
              onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                await auth.signOut().then((value) {
                  SessionController().userId = '';
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return WelcomeScreen();
                  }));
                });
                // Navigator.pushNamed(context, LoginScreen.id);
              },
              icon: Icon(Icons.logout_outlined))
        ],
        title: Text(
          'My Shop',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            child: Icon(
              Icons.account_circle_outlined,
              size: 120,
            ),
            onTap: () {
              Navigator.pushNamed(context, AccountSellerScreen.id);
              print(FirebaseAuth.instance.currentUser?.uid);
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.storefront_outlined,
              size: 120,
            ),
            onTap: () {
              Navigator.pushNamed(context, MyProductScreen.id);
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.analytics_outlined,
              size: 120,
            ),
            onTap: () {
              Navigator.pushNamed(context, SalesReportScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
