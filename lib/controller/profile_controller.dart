import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:online_shop/constants.dart';
import 'package:online_shop/session_manager.dart';
import 'dart:io';

class ProfileController with ChangeNotifier {
  final firestore = FirebaseFirestore.instance.collection('users');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final userNameController = TextEditingController();
  final emailController = TextEditingController();

  final picker = ImagePicker();
  XFile? _image;
  XFile? get image => _image;

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _changePassword(String password) async {
    final user = FirebaseAuth.instance.currentUser;

    user?.updatePassword(password).then((_) {
      showMessageToast("Successfully changed password");
    }).catchError((error) {
      showMessageToast("Password can't be changed" + error.toString());
    });
  }

  Future pickGalleryImaeg(BuildContext context) async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 400,
        maxWidth: 400,
        imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage(context);
      notifyListeners();
    }
  }

  Future pickCameraImaeg(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage(context);
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

  void uploadImage(BuildContext context) async {
    setLoading(true);

    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref('/profileImage' + SessionController().userId.toString());
    firebase_storage.UploadTask uploadTask =
        storageRef.putFile(File(image!.path).absolute);
    await Future.value(uploadTask);
    final newURL = await storageRef.getDownloadURL();

    firestore.doc(SessionController().userId.toString()).update({
      'image': newURL.toString(),
    }).then((value) {
      showMessageToast('Profile Update');
      setLoading(false);
      _image = null;
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

  Future<void> showUsernameDialogAlert(BuildContext context, String name) {
    userNameController.text = name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Update Username')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: userNameController,
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
                    firestore.doc(SessionController().userId).update({
                      'username': userNameController.text.toString()
                    }).then((value) => userNameController.clear());
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<void> showEmailDialogAlert(BuildContext context, String email) {
    emailController.text = email;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Update Email')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: kTextFieldDecoration,
                    keyboardType: TextInputType.emailAddress,
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
                    firestore.doc(SessionController().userId).update({
                      'email': emailController.text.toString()
                    }).then((value) => emailController.clear());
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }
}
