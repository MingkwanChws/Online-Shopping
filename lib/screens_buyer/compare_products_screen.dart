import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/rounded_button.dart';

class CompareProductsScreen extends StatefulWidget {
  static const id = 'productComparison';
  final String category;

  const CompareProductsScreen({super.key, required this.category});

  @override
  State<CompareProductsScreen> createState() => _CompareProductsScreenState();
}

class _CompareProductsScreenState extends State<CompareProductsScreen> {
  final _firestore = FirebaseFirestore.instance.collection('products');
  List<String> productList = [];
  String? selectedValue;
  String? selectedKey1;
  String? selectedKey2;
  dynamic data;
  final Map<dynamic, dynamic> mapData = HashMap();

  Future<dynamic> getData() async {
    await _firestore
        .where('product_name', isEqualTo: selectedValue)
        .get()
        .then((value) {
      setState(() {
        data = value.docs;
      });
    });
    // print(data[0]['product_name']);
  }

  Future<dynamic> getInfo() async {
    await _firestore
        .where('product_name', isEqualTo: selectedValue)
        .get()
        .then((value) {
      setState(() {
        data = value.docs;
      });
    });
    // print(data[0]['product_name']);
  }

  Future<dynamic> getItem() async {
    await FirebaseFirestore.instance
        .collection('products')
        .where('product_category', isEqualTo: widget.category)
        .where('isPublish', isEqualTo: true)
        .get()
        .then((value) async {
      var list = value.docs;
      list.forEach((element) {
        mapData.addAll({element.id: element.get('product_name')});
        productList.add(element.get('product_name'));
      });

      mapData.forEach((key, value) {
        print('$key  $value');
      });

      print(productList.last);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItem();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'Compare ' + widget.category,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) => Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return productList.where((String element) {
                              return element.contains(
                                  textEditingValue.text.toUpperCase());
                            });
                          },
                          onSelected: (String item) {
                            setState(() {
                              selectedValue = item;
                              selectedKey1 = mapData.keys.firstWhere(
                                  (element) =>
                                      mapData[element] == selectedValue);
                              print(selectedKey1);
                            });
                          },
                          fieldViewBuilder: (context, textEditingController,
                              focusNode, onFieldSummited) {
                            return TextFormField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              onEditingComplete: onFieldSummited,
                              decoration: InputDecoration(
                                hintText: 'search by product name',
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) =>
                              Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(4.0)),
                              ),
                              child: Container(
                                height: 80.0 * options.length,
                                width: constraints
                                    .biggest.width, // <-- Right here !
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: options.length,
                                  shrinkWrap: false,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final String option =
                                        options.elementAt(index);
                                    return GestureDetector(
                                      onTap: () => onSelected(option),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(option),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      FutureBuilder(
                        future: _firestore.doc(selectedKey1).get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              Map<dynamic, dynamic>? map =
                                  snapshot.data!.data();

                              return map == null
                                  ? Column(
                                      children: [
                                        Container(
                                          width: 160,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: ClipRRect(
                                            child: Icon(
                                              Icons.photo_outlined,
                                              size: 70,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text('-'),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text('-'),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text('-'),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text('-'),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: map!['product_image'] == ''
                                              ? Icon(Icons.photo_outlined)
                                              : ClipRRect(
                                                  child: Image(
                                                    image: NetworkImage(
                                                        map['product_image']
                                                            .toString()),
                                                    fit: BoxFit.cover,
                                                    height: 160,
                                                    width: 160,
                                                  ),
                                                ),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            map['product_price'] == ''
                                                ? '-'
                                                : '฿' + map['product_price'],
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            map['product_brand'] == ''
                                                ? '-'
                                                : map['product_brand'],
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            map['product_size'] == ''
                                                ? '-'
                                                : map['product_size'],
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            map['product_material'] == ''
                                                ? '-'
                                                : map['product_material'],
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            }
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.error.toString()));
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 290,
                  ),
                  Text(
                    'Price',
                  ),
                  SizedBox(
                    height: 77,
                  ),
                  Text(
                    'Brand',
                  ),
                  SizedBox(
                    height: 77,
                  ),
                  Text(
                    'Size',
                  ),
                  SizedBox(
                    height: 77,
                  ),
                  Text(
                    'Material',
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) => Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return productList.where((String element) {
                              return element.contains(
                                  textEditingValue.text.toUpperCase());
                            });
                          },
                          onSelected: (String item) {
                            setState(() {
                              selectedValue = item;
                              selectedKey2 = mapData.keys.firstWhere(
                                  (element) =>
                                      mapData[element] == selectedValue);
                              print(selectedKey2);
                            });
                          },
                          fieldViewBuilder: (context, textEditingController,
                              focusNode, onFieldSummited) {
                            return TextFormField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              onEditingComplete: onFieldSummited,
                              decoration: InputDecoration(
                                hintText: 'search by product name',
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) =>
                              Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(4.0)),
                              ),
                              child: Container(
                                height: 80.0 * options.length,
                                width: constraints
                                    .biggest.width, // <-- Right here !
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: options.length,
                                  shrinkWrap: false,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final String option =
                                        options.elementAt(index);
                                    return GestureDetector(
                                      onTap: () => onSelected(option),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(option),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      FutureBuilder(
                        future: _firestore.doc(selectedKey2).get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              Map<dynamic, dynamic>? map =
                                  snapshot.data!.data();

                              return map == null
                                  ? Column(
                                      children: [
                                        Container(
                                          width: 160,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: ClipRRect(
                                            child: Icon(
                                              Icons.photo_outlined,
                                              size: 70,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text('-'),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text('-'),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text('-'),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text('-'),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: map!['product_image'] == ''
                                              ? Icon(Icons.photo_outlined)
                                              : ClipRRect(
                                                  child: Image(
                                                    image: NetworkImage(
                                                        map['product_image']
                                                            .toString()),
                                                    fit: BoxFit.cover,
                                                    height: 160,
                                                    width: 160,
                                                  ),
                                                ),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            map['product_price'] == ''
                                                ? '-'
                                                : '฿' + map['product_price'],
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            map['product_brand'] == ''
                                                ? '-'
                                                : map['product_brand'],
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            map['product_size'] == ''
                                                ? '-'
                                                : map['product_size'],
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 77,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            map['product_material'] == ''
                                                ? '-'
                                                : map['product_material'],
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            }
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.error.toString()));
                          } else {
                            return Text('data');
                            // Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

// DropdownMenu(
// width: 180,
// onSelected: (String? value) {
// setState(() {
// dropdownValue = value!;
// });
// // Map<dynamic, dynamic>? map = snapshot.data!.data();
// },
// dropdownMenuEntries: productList
//     .map<DropdownMenuEntry<String>>((String value) {
// return DropdownMenuEntry(value: value, label: value);
// }).toList(),
// ),
