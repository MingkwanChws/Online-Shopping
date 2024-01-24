import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/constants.dart';
import 'package:online_shop/components/rounded_button.dart';
import 'package:provider/provider.dart';

import '../components/bottom_navbar.dart';
import '../controller/profile_controller.dart';
import '../screens/welcome_screen.dart';
import '../screens_seller/account_seller_screen.dart';
import '../session_manager.dart';

class AccountBuyerScreen extends StatefulWidget {
  static const id = 'personal';
  const AccountBuyerScreen({super.key});

  @override
  State<AccountBuyerScreen> createState() => _AccountBuyerScreenState();
}

class _AccountBuyerScreenState extends State<AccountBuyerScreen> {
  int selectedPage = 1;
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          'Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ChangeNotifierProvider(
        create: (_) => ProfileController(),
        child: Consumer<ProfileController>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: StreamBuilder(
                stream: _firestore
                    .doc(SessionController().userId.toString())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    Map<dynamic, dynamic>? map = snapshot.data!.data();
                    return Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: provider.image == null
                                        ? map!['image'].toString() == ""
                                            ? Icon(Icons.person, size: 35)
                                            : Image(
                                                image: NetworkImage(
                                                    map['image'].toString()),
                                                fit: BoxFit.cover,
                                              )
                                        : Image.file(File(provider.image!.path)
                                            .absolute)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.pickImage(context);
                              },
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.black,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 36,
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.showUsernameDialogAlert(
                                context, map['username']);
                          },
                          child: ReusableRow(
                              title: 'Username',
                              value: map!['username'],
                              iconData: Icons.person_outline),
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.showEmailDialogAlert(
                                context, map['email']);
                          },
                          child: ReusableRow(
                              title: 'Email',
                              value: map!['email'],
                              iconData: Icons.email_outlined),
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.showEmailDialogAlert(context, '');
                          },
                          child: ReusableRow(
                              title: 'Password',
                              value: map!['email'],
                              iconData: Icons.vpn_key_outlined),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        RoundedButton(
                          loading: false,
                          colour: Colors.black,
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
                          title: 'Logout',
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
