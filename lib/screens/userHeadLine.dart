import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/screens/userRecipeList.dart';
import 'package:recipes_app/services/mobileStorage.dart';

import '../config.dart';

class UserHeadLine extends StatefulWidget {
  UserHeadLine(String _uid) {
    this.uid = _uid;
  }
  String uid;
  String firstName = '';
  String lastName = '';
  NetworkImage image;
  String imagePath = '';
  String mail = '';
  @override
  _UserHeadLineState createState() => _UserHeadLineState();
}

class _UserHeadLineState extends State<UserHeadLine> {
  void initState() {
    super.initState();
    getUserdata();
  }

  Future<void> getUserdata() async {
    DocumentSnapshot snap =
        await Firestore.instance.collection('users').document(widget.uid).get();
    setState(() {
      widget.firstName = snap.data['firstName'] ?? '';
      widget.lastName = snap.data['lastName'] ?? '';
      widget.mail = snap.data['Email'] ?? '';
      widget.imagePath = snap.data['imagePath'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    _getImage(context);
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
        child: InkWell(
            highlightColor: Colors.blueGrey,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserRecipeList(widget.uid)));
            },
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // CircleAvatar(
                  //   backgroundImage: (widget.image == "")
                  //       ? ExactAssetImage(noImagePath)
                  //       : NetworkImage(widget.image),
                  //   radius: 35.0,
                  // ),
                  Row(children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                      child: Image(
                        height: 80,
                        image: (widget.image == null)
                            ? ExactAssetImage(noImagePath)
                            : (widget.image),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.firstName + " " + widget.lastName,
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                color: Colors.black,
                                fontSize: 20),
                          ),
                          Text(
                            widget.mail,
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                color: Colors.grey[700],
                                fontSize: 15),
                          )
                        ])
                  ])
                ])));
  }

  void _getImage(BuildContext context) async {
    if (widget.imagePath == "" || widget.image != null) {
      return;
    }
    String downloadUrl = await FireStorageService.loadFromStorage(
        context, "uploads/" + widget.imagePath);
    setState(() {
      widget.image = NetworkImage(downloadUrl);
    });
  }
}
