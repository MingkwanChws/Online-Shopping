import 'package:flutter/material.dart';

class ReusableContainer extends StatelessWidget {
  final Widget title, value;
  const ReusableContainer(
      {required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            ListTile(
              title: title,
              trailing: value,
            ),
          ],
        ),
      ),
    );
  }
}
