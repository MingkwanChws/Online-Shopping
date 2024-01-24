import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:online_shop/controller/product_controller.dart';
import 'package:online_shop/screens_seller/addproduct_screen.dart';
import 'package:online_shop/screens_seller/updateproduct_screen.dart';

import '../components/rounded_button.dart';

class MyProductScreen extends StatefulWidget {
  static const id = 'myProduct';
  const MyProductScreen({super.key});

  @override
  State<MyProductScreen> createState() => _MyProductScreenState();
}

class _MyProductScreenState extends State<MyProductScreen> {
  final firestore = FirebaseFirestore.instance.collection('products');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          'My Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: StreamBuilder(
              stream: firestore
                  .orderBy('isPublish', descending: true)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return snapshot.data?.docs[index].get('isPublish')
                              ? Card(
                                  // color: Colors.grey,
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.all(16),
                                          horizontalTitleGap: 20,
                                          onTap: () {
                                            ProductController()
                                                .showBottomSheetDelist(
                                                    context,
                                                    snapshot.data?.docs[index]
                                                        .get('product_id'));
                                          },
                                          leading: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: snapshot.data?.docs[index]
                                                        .get('product_image') ==
                                                    ''
                                                ? Icon(
                                                    Icons.storefront_outlined)
                                                : ClipRRect(
                                                    child: Image(
                                                      image: NetworkImage(snapshot
                                                          .data?.docs[index]
                                                          .get(
                                                              'product_image')),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                          ),
                                          title: Container(
                                            height: 50,
                                            child: Text(
                                              snapshot.data?.docs[index]
                                                  .get('product_name'),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          // subtitle: Text(snapshot.data?.docs[index]
                                          //     .get('product_des')),
                                          trailing: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                            ),
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateProductScreen(
                                                          product_id: snapshot
                                                              .data?.docs[index]
                                                              .get(
                                                                  'product_id')),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Card(
                                  color: Colors.grey,
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.all(16),
                                          horizontalTitleGap: 20,
                                          onTap: () {
                                            ProductController()
                                                .showBottomSheetPublish(
                                                    context,
                                                    snapshot.data?.docs[index]
                                                        .get('product_id'));
                                          },
                                          leading: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: snapshot.data?.docs[index]
                                                        .get('product_image') ==
                                                    ''
                                                ? Icon(Icons.person_outline)
                                                : ClipRRect(
                                                    child: Image(
                                                      image: NetworkImage(snapshot
                                                          .data?.docs[index]
                                                          .get(
                                                              'product_image')),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                          ),
                                          title: Container(
                                            height: 50,
                                            child: Text(
                                              snapshot.data?.docs[index]
                                                  .get('product_name'),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          // subtitle: Text(snapshot.data?.docs[index]
                                          //     .get('product_des')),
                                          trailing: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              // foregroundColor:
                                              //     MaterialStateProperty.all(Colors.grey),
                                            ),
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateProductScreen(
                                                          product_id: snapshot
                                                              .data?.docs[index]
                                                              .get(
                                                                  'product_id')),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        });
                  }
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                child: RoundedButton(
                  loading: false,
                  colour: Colors.black,
                  onPressed: () {
                    Navigator.pushNamed(context, AddProductScreen.id);
                  },
                  title: 'Add New Product',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
