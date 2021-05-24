import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../config.dart';

class UploadingImageToFirebaseStorage extends StatefulWidget {
  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState
    extends State<UploadingImageToFirebaseStorage> {
  File _imageFile;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile == null) {
      return;
    }
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL();
    Navigator.pop(context, fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: title(),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 0.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: _imageFile != null
                                ? Image.file(_imageFile)
                                : ListView(children: [
                                    subTitle(),
                                    SizedBox(height: 40),
                                    cameraButton(),
                                    SizedBox(height: 30),
                                    galleryButton(),
                                  ])),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    cancleButton(context),
                    if (_imageFile != null) uploadImageButton(context)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: 150,
            height: 50,
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 40.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                color: _imageFile != null ? Colors.blueGrey : Colors.grey,
                borderRadius: BorderRadius.circular(10.0)),
            // ignore: deprecated_member_use
            child: FlatButton(
              onPressed: _imageFile != null ? () => a(context) : null,
              child: Text(
                "Upload",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void a(BuildContext context) {
    uploadImageToFirebase(context);
  }

  Widget cancleButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: 140,
            height: 50,
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 30.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                color: _imageFile != null
                    ? Colors.blueGrey[200]
                    : Colors.blueGrey[400],
                borderRadius: BorderRadius.circular(10.0)),
            // ignore: deprecated_member_use
            child: FlatButton(
              onPressed: () => {Navigator.pop(context, "")},
              child: Text(
                "Cancle",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget galleryButton() {
    // ignore: deprecated_member_use
    return FlatButton(
      height: 10,
      child: Image.asset(
        galleryPath,
        height: 100,
      ),
      onPressed: chooseImage,
    );
  }

  Widget cameraButton() {
    // ignore: deprecated_member_use
    return FlatButton(
      height: 10,
      child: Image.asset(
        cameraPath,
        height: 100,
      ),
      onPressed: pickImage,
    );
  }

  Widget subTitle() {
    return Text(
      'Choose how you want to upload image:',
      textAlign: TextAlign.center,
      style:
          TextStyle(color: Colors.black, fontSize: 18, fontFamily: ralewayFont),
    );
  }

  Widget title() {
    return Text(
      "Uploading Your Image",
      textAlign: TextAlign.center,
      style:
          TextStyle(color: Colors.black, fontSize: 28, fontFamily: ralewayFont),
    );
  }
}
