import 'package:flutter/material.dart';
import 'package:online_shop/screens/auth_screen.dart';
import 'package:online_shop/screens/verified_email_screen.dart';
import 'package:online_shop/screens_buyer/cart_screen.dart';
import 'package:online_shop/screens_buyer/compare_products_screen.dart';
import 'package:online_shop/screens_buyer/home_buyer_screen.dart';
import 'package:online_shop/screens/login_screen.dart';
import 'package:online_shop/screens_buyer/account_buyer_screen.dart';
import 'package:online_shop/screens/registration_screen.dart';
import 'package:online_shop/screens_buyer/product_detail_screen.dart';
import 'package:online_shop/screens_buyer/product_list_screen.dart';
import 'package:online_shop/screens_seller/account_seller_screen.dart';
import 'package:online_shop/screens_seller/addproduct_screen.dart';
import 'package:online_shop/screens_seller/myproduct_screen.dart';
import 'package:online_shop/screens_seller/report_screen.dart';
import 'package:online_shop/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:online_shop/screens_seller/home_seller_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AuthScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomeBuyerScreen.id: (context) => HomeBuyerScreen(),
        AccountBuyerScreen.id: (context) => AccountBuyerScreen(),
        HomeSellerScreen.id: (context) => HomeSellerScreen(),
        AccountSellerScreen.id: (context) => AccountSellerScreen(),
        SalesReportScreen.id: (context) => SalesReportScreen(),
        MyProductScreen.id: (context) => MyProductScreen(),
        AddProductScreen.id: (context) => AddProductScreen(),
        VerifiedEmailScreen.id: (context) => VerifiedEmailScreen(),
        AuthScreen.id: (context) => AuthScreen(),
        ProductListScreen.id: (context) => ProductListScreen(
              product_category: '',
            ),
        CompareProductsScreen.id: (context) =>
            CompareProductsScreen(category: ''),
        CartScreen.id: (context) => CartScreen(),
        ProductDetailScreen.id: (context) =>
            ProductDetailScreen(product_id: ''),
      },
      theme: ThemeData(),
    );
  }
}
