import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color colour;
  final VoidCallback onPressed;
  final String title;
  final bool loading;

  RoundedButton(
      {required this.colour,
      required this.onPressed,
      required this.title,
      required this.loading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Material(
        elevation: 5,
        color: colour,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          onPressed: loading ? null : onPressed,
          minWidth: 200,
          height: 42,
          child: loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
