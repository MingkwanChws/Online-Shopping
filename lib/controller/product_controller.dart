import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import '../session_manager.dart';

class ProductController with ChangeNotifier {
  final firestore = FirebaseFirestore.instance.collection('products').doc();
  final firestore_update = FirebaseFirestore.instance.collection('products');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final wholesalePriceController = TextEditingController();
  final wholesaleQuantityController = TextEditingController();
  final categoryController = TextEditingController();
  final brandController = TextEditingController();
  final sizeController = TextEditingController();
  final materialController = TextEditingController();

  String name = 'enter product name';
  String description = 'enter product description';
  String price = '0';
  int quantity = 0;
  String wholesalePrice = '0';
  String wholesaleQuantity = '0';
  String category = '';
  String brand = ' ';
  String size = ' ';
  String material = ' ';

  final picker = ImagePicker();
  XFile? _image;
  XFile? get image => _image;

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future pickGalleryImaeg(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      // uploadImage(context);
      notifyListeners();
    }
  }

  Future pickCameraImaeg(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      // uploadImage(context);
      notifyListeners();
    }
  }

  void pickImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                    onTap: () {
                      pickCameraImaeg(context);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Gallery'),
                    onTap: () {
                      pickGalleryImaeg(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void uploadToDtb(BuildContext context) async {
    setLoading(true);

    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref('/productImage' + firestore.id);
    firebase_storage.UploadTask uploadTask =
        storageRef.putFile(File(image!.path).absolute);
    await Future.value(uploadTask);
    final newURL = await storageRef.getDownloadURL();

    await firestore.set({
      'product_id': firestore.id,
      'product_image': newURL.toString(),
      'product_name': name,
      'product_des': description,
      'product_price': price,
      'product_quantity': quantity,
      'product_wholesale_quantity': wholesaleQuantity,
      'product_wholesale_price': wholesalePrice,
      'product_category': category,
      'product_brand': brand,
      'product_size': size,
      'product_material': material,
      'isPublish': true,
      'timestamp': FieldValue.serverTimestamp()
    }).then((value) {
      _image = null;
      name = ' ';
      description = ' ';
      price = '0';
      quantity = 0;
      wholesalePrice = '0';
      wholesaleQuantity = '0';
      category = '';
      brand = ' ';
      size = ' ';
      material = ' ';
      showMessageToast('Product Add');
      setLoading(false);
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      showMessageToast(error.toString());
      setLoading(false);
    });
  }

  void updateToDtb(BuildContext context, String productId) async {
    setLoading(true);

    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref('/profileImage' + SessionController().userId.toString());
    firebase_storage.UploadTask uploadTask =
        storageRef.putFile(File(image!.path).absolute);
    await Future.value(uploadTask);
    final newURL = await storageRef.getDownloadURL();

    firestore.update({
      'image': newURL.toString(),
      'product_name': name,
      'product_des': description,
      'product_price': price,
      'product_quantity': quantity,
      'product_wholesale_quantity': wholesaleQuantity,
      'product_wholesale_price': wholesalePrice,
      'product_category': category,
      'product_brand': brand,
      'product_size': size,
      'product_material': material,
    }).then((value) {
      _image = null;
      name = ' ';
      description = ' ';
      price = '0';
      quantity = 0;
      wholesalePrice = '0';
      wholesaleQuantity = '0';
      category = '';
      brand = ' ';
      size = ' ';
      material = ' ';
      showMessageToast('Product Add');
      setLoading(false);
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      showMessageToast(error.toString());
      setLoading(false);
    });
  }

  void showMessageToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.grey[400],
        textColor: Colors.white,
        fontSize: 16.0,
        webShowClose: true);
  }

  Future<void> showBottomSheetDelist(BuildContext context, String product_id) {
    return showModalBottomSheet(
        useSafeArea: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              // height: 120,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      firestore_update.doc(product_id).update({
                        'isPublish': false,
                        'timestamp': FieldValue.serverTimestamp()
                      }).then((value) => Navigator.pop(context));
                    },
                    child: Text(
                      'Delist',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  TextButton(
                    onPressed: () {
                      firestore_update
                          .doc(product_id)
                          .delete()
                          .then((value) => Navigator.pop(context));
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> showBottomSheetPublish(BuildContext context, String product_id) {
    return showModalBottomSheet(
        useSafeArea: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              // height: 120,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      firestore_update.doc(product_id).update({
                        'isPublish': true,
                        'timestamp': FieldValue.serverTimestamp()
                      }).then((value) => Navigator.pop(context));
                    },
                    child: Text(
                      'Publish',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  TextButton(
                    onPressed: () {
                      firestore_update
                          .doc(product_id)
                          .delete()
                          .then((value) => Navigator.pop(context));
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> showNameDialogAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Product name')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: kTextFieldDecoration,
                    keyboardType: TextInputType.text,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    name = nameController.text;
                    notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> showDescriptionDialogAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Product description')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: descriptionController,
                    decoration: kTextFieldDecoration,
                    keyboardType: TextInputType.text,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    description = descriptionController.text;
                    notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> showPriceDialogAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Price')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: priceController,
                    decoration: kTextFieldDecoration,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    price = priceController.text;
                    notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> showQuantityDialogAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Quantity')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: quantityController,
                    decoration: kTextFieldDecoration,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    quantity = int.parse(quantityController.text);
                    notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> showCategoryDialogAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Category')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: categoryController,
                    decoration: kTextFieldDecoration,
                    keyboardType: TextInputType.text,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    category = categoryController.text;
                    notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> showBrandDialogAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Brand')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: brandController,
                    decoration: kTextFieldDecoration,
                    keyboardType: TextInputType.text,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    brand = brandController.text;
                    notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> showSizeDialogAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Size')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: sizeController,
                    decoration: kTextFieldDecoration,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    size = sizeController.text;
                    notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> showMaterialDialogAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Material')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: materialController,
                    decoration: kTextFieldDecoration,
                    keyboardType: TextInputType.text,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    material = materialController.text;
                    notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> showWholesaleDialogAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Wholesale')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Center(child: Text('Psc or more'))),
                      Expanded(child: Center(child: Text('Price'))),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: wholesaleQuantityController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: wholesalePriceController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    wholesalePrice = wholesalePriceController.text;
                    wholesaleQuantity = wholesaleQuantityController.text;
                    notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> updateNameDialogAlert(
      BuildContext context, String value, String product_id) {
    nameController.text = value;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Product name')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: kTextFieldDecoration,
                    keyboardType: TextInputType.text,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    firestore_update.doc(product_id).update({
                      'product_name': nameController.text.toString(),
                    }).then((value) => nameController.clear());
                    Navigator.pop(context);
                    showMessageToast('Update product name successfully!');
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> updateDescriptionDialogAlert(
      BuildContext context, String value, String product_id) {
    descriptionController.text = value;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Product description')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: descriptionController,
                    decoration: kTextFieldDecoration,
                    keyboardType: TextInputType.text,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    firestore_update.doc(product_id).update({
                      'product_des': descriptionController.text.toString(),
                    }).then((value) => descriptionController.clear());
                    Navigator.pop(context);
                    showMessageToast(
                        'Update product description successfully!');
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> updatePriceDialogAlert(
      BuildContext context, String value, String product_id) {
    priceController.text = value;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Price')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: priceController,
                    decoration: kTextFieldDecoration,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    price = priceController.text;
                    firestore_update.doc(product_id).update({
                      'product_price': price,
                    }).then((value) => priceController.clear());
                    Navigator.pop(context);
                    showMessageToast('Update product price successfully!');
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> updateQuantityDialogAlert(
      BuildContext context, String value, String product_id) {
    quantityController.text = value;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Quantity')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: quantityController,
                    decoration: kTextFieldDecoration,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    firestore_update.doc(product_id).update({
                      'product_quantity': quantityController.text.toString(),
                    }).then((value) => quantityController.clear());
                    Navigator.pop(context);
                    showMessageToast('Update product quantity successfully!');
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> updateCategoryDialogAlert(
      BuildContext context, String value, String product_id) {
    categoryController.text = value;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Category')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: categoryController,
                    decoration: kTextFieldDecoration,
                    keyboardType: TextInputType.text,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    firestore_update.doc(product_id).update({
                      'product_category': categoryController.text.toString(),
                    }).then((value) => categoryController.clear());
                    Navigator.pop(context);
                    showMessageToast('Update product category successfully!');
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> updateBrandDialogAlert(
      BuildContext context, String value, String product_id) {
    brandController.text = value;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Brand')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: brandController,
                    decoration: kTextFieldDecoration,
                    keyboardType: TextInputType.text,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    firestore_update.doc(product_id).update({
                      'product_brand': brandController.text.toString(),
                    }).then((value) => brandController.clear());
                    Navigator.pop(context);
                    showMessageToast('Update product brand successfully!');
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> updateSizeDialogAlert(
      BuildContext context, String value, String product_id) {
    sizeController.text = value;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Size')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: sizeController,
                    decoration: kTextFieldDecoration,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    firestore_update.doc(product_id).update({
                      'product_size': sizeController.text.toString(),
                    }).then((value) => sizeController.clear());
                    Navigator.pop(context);
                    showMessageToast('Update product size successfully!');
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> updateMaterialDialogAlert(
      BuildContext context, String value, String product_id) {
    materialController.text = value;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Material')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: materialController,
                    decoration: kTextFieldDecoration,
                    keyboardType: TextInputType.text,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    firestore_update.doc(product_id).update({
                      'product_material': materialController.text.toString(),
                    }).then((value) => materialController.clear());
                    Navigator.pop(context);
                    showMessageToast('Update product material successfully!');
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> updateWholesaleDialogAlert(
      BuildContext context, String value1, String value2, String product_id) {
    wholesaleQuantityController.text = value1;
    wholesalePriceController.text = value2;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Wholesale')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Center(child: Text('Psc or more'))),
                      Expanded(child: Center(child: Text('Price'))),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: wholesaleQuantityController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: wholesalePriceController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    firestore_update.doc(product_id).update({
                      'product_wholesale_quantity':
                          wholesaleQuantityController.text.toString(),
                      'product_wholesale_price':
                          wholesalePriceController.text.toString(),
                    }).then((value) {
                      wholesaleQuantityController.clear();
                      wholesalePriceController.clear();
                    });
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }
}
