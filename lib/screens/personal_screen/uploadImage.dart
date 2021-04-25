import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../config.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Storage Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UploadingImageToFirebaseStorage(),
    );
  }
}

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
    final pickedFile = await picker.getImage(source: ImageSource.camera);
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
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
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
                    if (_imageFile != null)
                      uploadImageButton(context)
                    else
                      SizedBox(
                        width: 110,
                      ),
                    cancleButton(context)
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
            width: 190,
            height: 50,
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                color: _imageFile != null ? Colors.blueGrey : Colors.grey,
                borderRadius: BorderRadius.circular(10.0)),
            child: FlatButton(
              onPressed: _imageFile != null
                  ? () => uploadImageToFirebase(context)
                  : null,
              child: Text(
                "Upload Image",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
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
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                color: _imageFile != null
                    ? Colors.blueGrey[200]
                    : Colors.blueGrey[400],
                borderRadius: BorderRadius.circular(10.0)),
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
          TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Raleway'),
    );
  }

  Widget title() {
    return Text(
      "Uploading Your Image",
      textAlign: TextAlign.center,
      style:
          TextStyle(color: Colors.black, fontSize: 28, fontFamily: 'Raleway'),
    );
  }
}