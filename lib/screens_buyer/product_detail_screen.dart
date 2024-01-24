import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/components/rounded_button.dart';
import 'package:online_shop/model/cart_item.dart';
import 'package:online_shop/screens_buyer/cart_screen.dart';
import 'package:online_shop/session_manager.dart';
import 'package:provider/provider.dart';
import 'package:online_shop/model/cart.dart';

class ProductDetailScreen extends StatefulWidget {
  static const id = 'productDetail';
  final String product_id;

  const ProductDetailScreen({super.key, required this.product_id});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _firestoreProduct = FirebaseFirestore.instance.collection('products');
  // final _firestore = FirebaseFirestore.instance;
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CartScreen.id);
            },
            icon: Badge(
              child: Icon(Icons.shopping_cart),
              isLabelVisible: true,
              label: Text('0'),
            ),
          )
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => Cart(),
        child: Consumer<Cart>(
          builder: (context, provider, child) {
            return Column(
              children: [
                FutureBuilder(
                  future: _firestoreProduct.doc(widget.product_id).get(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        Map<dynamic, dynamic>? map = snapshot.data!.data();

                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: map!['product_image'] == ''
                                  ? Icon(Icons.photo_outlined)
                                  : ClipRRect(
                                      child: Image(
                                        image: NetworkImage(
                                            map['product_image'].toString()),
                                        fit: BoxFit.cover,
                                        height: 400,
                                        width: 400,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(map!['product_name']),
                                  Text(map!['product_price']),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(map['product_des']),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 110,
                                    color: Colors.grey,
                                    child: Center(
                                      child: Text(
                                        'Price',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 110,
                                    color: Colors.grey,
                                    child: Center(
                                      child: Text(
                                        map['product_price'],
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 110,
                                    color: Colors.grey,
                                    child: Center(
                                      child: Text(
                                        map['product_wholesale_price'],
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 110,
                                    color: Colors.grey,
                                    child: Center(
                                      child: Text(
                                        'Amount',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 110,
                                    color: Colors.grey,
                                    child: Center(
                                      child: Text(
                                        ((int.parse(map['product_wholesale_quantity'])) -
                                                    1)
                                                .toString() +
                                            ' pieces',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 110,
                                    color: Colors.grey,
                                    child: Center(
                                      child: Text(
                                        '>' +
                                            ((int.parse(map[
                                                        'product_wholesale_quantity'])) -
                                                    1)
                                                .toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    CupertinoButton(
                                      child: CircleAvatar(
                                        child: Icon(Icons.remove),
                                      ),
                                      onPressed: () {
                                        if (quantity > 0) {
                                          quantity--;
                                        } else {
                                          quantity = 0;
                                        }
                                      },
                                    ),
                                    Text(quantity.toString()),
                                    CupertinoButton(
                                      child: CircleAvatar(
                                        child: Icon(Icons.add),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                                RoundedButton(
                                    colour: Colors.black,
                                    onPressed: () async {
                                      print('add');
                                      provider.addCartItem(
                                          widget.product_id, quantity);
                                      print('length');
                                      print(provider.cart.length);
                                      print('show');
                                      provider.cart.forEach((element) {
                                        print(element.id);
                                        print(element.quantity);
                                      });

                                      // await _firestore
                                      //     .collection('carts')
                                      //     .doc(SessionController().userId)
                                      //     .set({
                                      //   'items': provider.ConvertToMap()
                                      // });
                                    },
                                    title: 'Add to cart',
                                    loading: false)
                              ],
                            )
                          ],
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
