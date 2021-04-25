import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/screens/personal_screen/uploadImage.dart';
import 'package:recipes_app/screens/recipes/create_recipe/addRecipeIngredients.dart';
import 'package:recipes_app/services/fireStorageService.dart';
import '../../../config.dart';

class UploadRecipeImage extends StatefulWidget {
  final db = Firestore.instance;
  String name;
  String description;
  UploadRecipeImage(String _name, String _description) {
    name = _name;
    description = _description;
  }
  @override
  _UploadRecipeImageState createState() => _UploadRecipeImageState();
}

class _UploadRecipeImageState extends State<UploadRecipeImage> {
  String imagePath = "";
  bool hasImage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Column(children: [
              box,
              box,
              imageBox(),
              box,
              box,
              Row(children: [
                previousLevelButton(),
                SizedBox(
                  width: 260,
                ),
                nextLevelButton()
              ])
            ])));
  }

  Widget nextLevelButton() {
    return new Visibility(
        visible: hasImage,
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.green,
          onPressed: !hasImage
              ? null
              : () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddRecipeIngredients(
                              widget.name, widget.description, imagePath)));
                },
          tooltip: 'next',
          child: Icon(Icons.navigate_next),
        ));
  }

  Widget previousLevelButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
      tooltip: 'previous',
      child: Icon(Icons.navigate_before),
    );
  }

  Widget imageBox() {
    if (imagePath == "") {
      // upload image button
      return FlatButton(
        height: 10,
        child: Image.asset(uploadImagePath),
        onPressed: uploadImagePressed,
      );
    } else {
      hasImage = true;
      // show the image
      return Container(
          height: 450,
          child: Column(children: [
            box,
            Text(
              'Your image upload successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Raleway', fontSize: 20),
            ),
            box,
            FutureBuilder(
                future: _getImage(context, imagePath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return CircleAvatar(
                      backgroundImage: snapshot.data,
                      radius: 150,
                    );
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container(
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width / 10,
                        child: CircularProgressIndicator());
                }),
            TextButton(
                onPressed: uploadImagePressed,
                child: Text(
                    'If You want to change the recipe image, please tap here',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14))),
          ]));
    }
  }

  Future<NetworkImage> _getImage(BuildContext context, String image) async {
    if (image == "") {
      return null;
    }
    image = "uploads/" + image;
    NetworkImage m;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      m = NetworkImage(
        downloadUrl.toString(),
      );
    });
    return m;
  }

  void uploadImagePressed() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UploadingImageToFirebaseStorage()))
        .then((value) => {
              setState(() {
                imagePath = value.toString();
              })
            });
  }
}
