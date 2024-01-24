import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/screens_buyer/compare_products_screen.dart';
import 'package:online_shop/screens_buyer/product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  static const id = 'productList';
  const ProductListScreen({super.key, required this.product_category});
  final String product_category;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _firestore = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          widget.product_category,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CompareProductsScreen(category: widget.product_category),
                ),
              );
            },
            icon: Icon(Icons.compare_outlined),
          ),
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Badge(
              child: Icon(Icons.shopping_cart),
              isLabelVisible: true,
              label: Text('0'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 35),
        child: StreamBuilder(
          stream: _firestore
              .where('product_category', isEqualTo: widget.product_category)
              .where('isPublish', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                      itemCount: snapshot.data?.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 250,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                    product_id: snapshot.data?.docs[index]
                                        .get('product_id')),
                              ),
                            );
                          },
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 170,
                                  child: snapshot.data?.docs[index]
                                              .get('product_image') ==
                                          ''
                                      ? Icon(Icons.person_outline)
                                      : ClipRRect(
                                          child: Image(
                                            image: NetworkImage(snapshot
                                                .data?.docs[index]
                                                .get('product_image')),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 20,
                                  child: Text(
                                    snapshot.data?.docs[index]
                                        .get('product_name'),
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  child: Text(
                                    snapshot.data?.docs[index]
                                        .get('product_price'),
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              }
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No product'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
