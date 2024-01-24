import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/controller/product_controller.dart';
import 'package:online_shop/screens_seller/myproduct_screen.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../components/reusable_container.dart';
import '../components/rounded_button.dart';

class AddProductScreen extends StatefulWidget {
  static const id = 'addProduct';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final brandController = TextEditingController();
  final sizeController = TextEditingController();
  final materialController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          'Product',
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
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
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
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: ClipRRect(
                                          // borderRadius: BorderRadius.circular(100),
                                          child: provider.image == null
                                              ? Icon(Icons.storefront_outlined,
                                                  size: 35)
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
                            provider.showNameDialogAlert(context);
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
                                    child: Text(provider.name),
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
                            provider.showDescriptionDialogAlert(context);
                          },
                          child: Container(
                            height: 100,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    horizontal: 24.0,
                                  ),
                                  child: SizedBox(
                                    height: 60,
                                    child: Text(provider.description),
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
                            provider.showPriceDialogAlert(context);
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
                              value: Text('฿' + provider.price)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.showQuantityDialogAlert(context);
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
                              value: Text(provider.quantity.toString())),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.showWholesaleDialogAlert(context);
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
                            provider.showCategoryDialogAlert(context);
                          },
                          child: ReusableContainer(
                              title: Text(
                                'Category',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              value: Text(provider.category)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.showBrandDialogAlert(context);
                          },
                          child: ReusableContainer(
                              title: Text(
                                'Brand',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              value: Text(provider.brand)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.showSizeDialogAlert(context);
                          },
                          child: ReusableContainer(
                              title: Text(
                                'Size',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              value: Text(provider.size)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.showMaterialDialogAlert(context);
                          },
                          child: ReusableContainer(
                              title: Text(
                                'Material',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              value: Text(provider.material)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: 80,
                    child: RoundedButton(
                      loading: provider.loading,
                      colour: Colors.black,
                      onPressed: () {
                        provider.uploadToDtb(context);
                        // Navigator.pushNamed(context, MyProductScreen.id);
                      },
                      title: 'Save',
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
