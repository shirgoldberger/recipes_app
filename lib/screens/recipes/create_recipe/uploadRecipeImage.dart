import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:recipes_app/screens/personal_screen/uploadImage.dart';
import 'package:recipes_app/screens/recipes/create_recipe/addRecipeIngredients.dart';
import 'package:recipes_app/services/fireStorageService.dart';
import '../../../shared_screen/config.dart';
import 'dart:io';

// ignore: must_be_immutable
class UploadRecipeImage extends StatefulWidget {
  String username;
  String uid;
  String name;
  String description;
  UploadRecipeImage(
      String _username, String _uid, String _name, String _description) {
    username = _username;
    uid = _uid;
    name = _name;
    description = _description;
  }
  @override
  _UploadRecipeImageState createState() => _UploadRecipeImageState();
}

class _UploadRecipeImageState extends State<UploadRecipeImage> {
  String imagePath = "";
  File imageFile;
  bool hasImage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: ListView(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            children: [
              Container(
                height: 650,
                child: imageBox(),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  previousLevelButton(),
                  SizedBox(
                    width: 10,
                  ),
                  LinearPercentIndicator(
                    width: 240,
                    animation: true,
                    lineHeight: 18.0,
                    animationDuration: 500,
                    percent: 0.125,
                    center: Text(
                      "12.5%",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.grey[600],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  nextLevelButton()
                ],
              )
            ]));
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
                      PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) =>
                              AddRecipeIngredients(widget.username, widget.uid,
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
      return ListView(children: [
        box,
        box,
        box,
        box,
        // ignore: deprecated_member_use
        FlatButton(
          color: backgroundColor,
          height: 10,
          child: CircleAvatar(
              backgroundColor: backgroundColor,
              radius: 150,
              foregroundColor: Colors.black,
              child: Image.asset(uploadImagePath)),
          onPressed: uploadImagePressed,
        )
      ]);
    } else {
      hasImage = true;
      // show the image
      return Container(
          height: 450,
          child: Column(children: [
            heightBox(70),
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
                      backgroundColor: backgroundColor,
                      backgroundImage: snapshot.data,
                      radius: 150,
                    );
                  else
                    return Container(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator());
                }),
            box,
            TextButton(
                onPressed: uploadImagePressed,
                child: Text(
                    'If You want to change the recipe image\nplease tap here',
                    textAlign: TextAlign.center,
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
                imagePath = value;
              })
            });
  }

  Widget title() {
    return Text('Add Image to your recipe',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Raleway'));
  }
}
