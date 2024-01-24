import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/reusable_container.dart';
import '../components/rounded_button.dart';
import '../controller/product_controller.dart';

class UpdateProductScreen extends StatefulWidget {
  final String product_id;
  const UpdateProductScreen({required this.product_id, super.key});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final _firestore = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.product_id,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ChangeNotifierProvider(
        create: (_) => ProductController(),
        child: Consumer<ProductController>(
          builder: (context, provider, child) {
            return StreamBuilder(
              stream: _firestore.doc(widget.product_id).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    Map<dynamic, dynamic>? map = snapshot.data!.data();

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: 120,
                              color: Colors.white,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 10),
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10),
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            // shape: BoxShape.circle,
                                            border:
                                                Border.all(color: Colors.black),
                                          ),
                                          child: ClipRRect(
                                              // borderRadius: BorderRadius.circular(100),
                                              child: provider.image == null
                                                  ? map!['product_image']
                                                              .toString() ==
                                                          ""
                                                      ? Icon(
                                                          Icons
                                                              .storefront_outlined,
                                                          size: 35)
                                                      : Image(
                                                          image: NetworkImage(
                                                              map['product_image']
                                                                  .toString()),
                                                          fit: BoxFit.cover,
                                                        )
                                                  : Image.file(
                                                      File(provider.image!.path)
                                                          .absolute)),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          provider.pickImage(context);
                                        },
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.black,
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.updateNameDialogAlert(context,
                                    map?['product_name'], widget.product_id);
                              },
                              child: Container(
                                height: 70,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.0, vertical: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Product name',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ' *',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0),
                                      child: SizedBox(
                                        height: 30,
                                        child: Text(map?['product_name']),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.updateDescriptionDialogAlert(context,
                                    map?['product_des'], widget.product_id);
                              },
                              child: Container(
                                height: 100,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.0, vertical: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Product description',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ' *',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0),
                                      child: SizedBox(
                                        height: 30,
                                        child: Text(map?['product_des']),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.updatePriceDialogAlert(context,
                                    map?['product_price'], widget.product_id);
                              },
                              child: ReusableContainer(
                                  title: Row(
                                    children: [
                                      Text(
                                        'Price',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                  value: Text('฿' + map?['product_price'])),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.updateQuantityDialogAlert(
                                    context,
                                    map!['product_quantity'].toString(),
                                    widget.product_id);
                              },
                              child: ReusableContainer(
                                  title: Row(
                                    children: [
                                      Text(
                                        'Quantity',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                  value: Text(
                                      map!['product_quantity'].toString())),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.updateWholesaleDialogAlert(
                                    context,
                                    map?['product_wholesale_quantity'],
                                    map?['product_wholesale_price'],
                                    widget.product_id);
                              },
                              child: ReusableContainer(
                                  title: Text(
                                    'Wholesale',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  value: Icon(Icons.navigate_next_outlined)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.updateCategoryDialogAlert(
                                    context,
                                    map?['product_category'],
                                    widget.product_id);
                              },
                              child: ReusableContainer(
                                  title: Text(
                                    'Category',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  value: Text(map?['product_category'])),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.updateBrandDialogAlert(context,
                                    map?['product_brand'], widget.product_id);
                              },
                              child: ReusableContainer(
                                  title: Text(
                                    'Brand',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  value: Text(map?['product_brand'])),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.updateSizeDialogAlert(context,
                                    map?['product_size'], widget.product_id);
                              },
                              child: ReusableContainer(
                                  title: Text(
                                    'Size',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  value: Text(map?['product_size'])),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.updateMaterialDialogAlert(
                                    context,
                                    map?['product_material'],
                                    widget.product_id);
                              },
                              child: ReusableContainer(
                                  title: Text(
                                    'Material',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  value: Text(map?['product_material'])),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        ),
      ),
    );
  }
}

//
