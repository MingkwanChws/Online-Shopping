import 'package:flutter/material.dart';
import 'package:online_shop/components/bottom_navbar.dart';
import 'package:online_shop/screens_buyer/home_buyer_screen.dart';
import 'package:online_shop/screens_buyer/account_buyer_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedPage = 0;
  List pageList = [HomeBuyerScreen(), AccountBuyerScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList.elementAt(selectedPage),
      bottomNavigationBar: AppBottomNavBar(
          selectedPage: selectedPage,
          onDestinationSelected: (index) {
            setState(() {
              selectedPage = index;
            });
          }),
    );
  }
}
