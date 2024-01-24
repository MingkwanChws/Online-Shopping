import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:online_shop/screens_buyer/home_buyer_screen.dart';
import 'package:online_shop/screens_buyer/account_buyer_screen.dart';
import 'package:online_shop/screens_buyer/category_buyer_screen.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar(
      {super.key,
      required this.selectedPage,
      required this.onDestinationSelected});

  final int selectedPage;
  final void Function(int) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
            labelTextStyle: MaterialStatePropertyAll(Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.black))),
        child: NavigationBar(
          height: 50,
          selectedIndex: selectedPage,
          indicatorColor: Colors.transparent,
          onDestinationSelected: (int index) {
            onDestinationSelected(index);
          },
          // backgroundColor: Colors.grey,
          destinations: [
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: NavigationDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: 8),
            //   child: NavigationDestination(
            //     selectedIcon: Icon(Icons.history),
            //     icon: Icon(Icons.history_outlined),
            //     label: 'Orders',
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: NavigationDestination(
                selectedIcon: Icon(Icons.person),
                icon: Icon(Icons.person_outlined),
                label: 'Profile',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({required this.menuScreenContext, super.key});
  final BuildContext menuScreenContext;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late PersistentTabController controller;
  late bool hideNavBar;

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController();
    hideNavBar = false;
  }

  List<Widget> buildScreens() {
    return [
      HomeBuyerScreen(),
      AccountBuyerScreen(),
      CategoryScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("PersonalInfo"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.menu),
        title: ("Categories"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: buildScreens(),
      items: navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(0.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style13,
    );
  }
}
