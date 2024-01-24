import 'package:flutter/material.dart';

class CartItem {
  final String id;
  int quantity;

  CartItem({required this.id, required this.quantity});

  Map toMap() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }
}

// Map toMap() {
//   return {
//     'id': id,
//     'quantity': quantity,
//   };
// }

// List<Map> ConvertToMap() {
//   List<Map> cartItems = [];
//   customSteps.forEach((CustomStep customStep) {
//     Map step = customStep.toMap();
//     steps.add(step);
//   });
//   return steps;
// }
