import 'dart:ffi';

import 'package:flutter/material.dart';

class SalesReportScreen extends StatefulWidget {
  static const id = 'report';
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sales Report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Daily',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[400]),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Monthly'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 150,
                  height: 100,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        child: Text(
                          'Order Quantity',
                          style: TextStyle(fontSize: 16),
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      Align(
                        child: Text('0'),
                        alignment: Alignment.bottomLeft,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 150,
                  height: 100,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        child: Text(
                          'Sale',
                          style: TextStyle(fontSize: 16),
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      Align(
                        child: Text('฿0'),
                        alignment: Alignment.bottomLeft,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
