import 'package:flutter/material.dart';

import 'cart_item.dart';

class Cart with ChangeNotifier {
  List<CartItem> cart = [];
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addCartItem(String productId, int quantity) {
    final cartItem = CartItem(id: productId, quantity: quantity);

    cart.add(cartItem);
    notifyListeners();

    // if (cart.length == 0) {
    //   cart.add(cartItem);
    //   print('add new');
    // } else if (cart.length > 0) {
    //   cart.forEach((element) {
    //     if (element.id == productId) {
    //       element.quantity++;
    //       notifyListeners();
    //       print('1');
    //     } else {
    //       cart.add(cartItem);
    //       notifyListeners();
    //       print('2');
    //     }
    //   });
    // }
    // print('3');
  }

  List<Map> ConvertToMap() {
    List<Map> cartItems = [];
    cart.forEach((CartItem cartItem) {
      Map item = cartItem.toMap();
      cartItems.add(item);
    });
    return cartItems;
  }

  // int get itemCount {
  //   return items.values.fold<int>(0, (currentValue, cartItem) {
  //     return currentValue += cartItem.quantity;
  //   });
  // }
  //
  // double get totalAmount {
  //   var total = 0.0;
  //   _items.forEach((key, cartItem) {
  //     total += cartItem.price * cartItem.quantity;
  //   });
  //   return total;
  // }
}
