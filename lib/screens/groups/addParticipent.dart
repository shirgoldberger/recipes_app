import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddParticipent extends StatefulWidget {
  AddParticipent(List _userId, String groupId, String _groupName) {
    this.userId = _userId.toList();
    this.groupId = groupId;
    this.groupName = _groupName;

    // this.userName = _userName;
  }
  //List userName;
  List userId = [];
  String groupId;
  bool done = false;
  String groupName;

  @override
  _AddParticipentState createState() => _AddParticipentState();
}

class _AddParticipentState extends State<AddParticipent> {
  List usersID = [];
//  List<String> userEmail = [];
  //String groupName;
  String error = '';
  bool findUser = false;
  String emailTocheck = '';
  // bool done = false;
  @override
  Widget build(BuildContext context) {
    usersID = widget.userId;
    //groupName = widget.groupName;
    // userEmail = widget.userName;
    //if (widget.doneLoad) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Column(children: <Widget>[
          Flexible(
              child: ListView(children: [
            SizedBox(
              height: 10.0,
            ),
            Text("add new member or change the group name:"),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: widget.groupName,
              ),
              validator: (val) => val.isEmpty ? widget.groupName : null,
              onChanged: (val) {
                setState(() {
                  widget.groupName = val;
                  widget.done = true;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'add new mamber Email',
              ),
              validator: (val) => val.isEmpty ? '' : null,
              onChanged: (val) {
                setState(() => emailTocheck = val);
              },
            ),
            Text(
              error,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(
              height: 20.0,
            ),
            MaterialButton(
                minWidth: 200.0,
                height: 35,
                color: Color(0xFF801E48),
                child: new Text('add user and save',
                    style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                onPressed: () {
                  saveUser(emailTocheck);
                }),
          ]))
        ]));
  }

  Future<void> saveUser(String email) async {
    final db = Firestore.instance;
    if (widget.done) {
      db
          .collection('Group')
          .document(widget.groupId)
          .updateData({'groupName': widget.groupName});
      for (int i = 0; i < widget.userId.length; i++) {
        QuerySnapshot a = await Firestore.instance
            .collection('users')
            .document(widget.userId[i])
            .collection('groups')
            .getDocuments();
        a.documents.forEach((element) {
          if (element.data['groupId'] == widget.groupId) {
            db
                .collection('users')
                .document(widget.userId[i])
                .collection('groups')
                .document(element.documentID)
                .updateData({'groupName': widget.groupName});
          }
        });
      }
    }
    String mailCheck;

    QuerySnapshot snap =
        await Firestore.instance.collection('users').getDocuments();
    snap.documents.forEach((element) async {
      mailCheck = element.data['Email'] ?? '';

      if (mailCheck == email) {
        if (!usersID.contains(element.documentID)) {
          print("contains");

          findUser = true;

          usersID.add(element.documentID);

          var currentRecipe = await db
              .collection('Group')
              .document(widget.groupId)
              .updateData({'users': usersID});
          var currentRecipe2 = await db
              .collection('users')
              .document(element.documentID)
              .collection('groups')
              .add({'groupName': widget.groupName, 'groupId': widget.groupId});
          Navigator.pop(context, {'a': usersID, 'b': widget.groupName});
        } else {
          setState(() {
            error = "this user alrady exicst";
          });
          findUser = true;
        }
      }
    });
    if (!findUser) {
      setState(() {
        error = 'there is no such user, try again';
      });
    }
    if (email == '') {
      Navigator.pop(context, {'a': usersID, 'b': widget.groupName});
    }
    findUser = false;
  }
}
