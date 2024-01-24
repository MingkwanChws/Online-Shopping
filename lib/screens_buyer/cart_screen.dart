import 'package:flutter/material.dart';
import 'package:online_shop/model/cart.dart';

class CartScreen extends StatefulWidget {
  static const id = 'cart';

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart shoppingCart = Cart();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(shoppingCart.cart[index].id.toString()),
          );
        },
      ),
    );
  }
}
