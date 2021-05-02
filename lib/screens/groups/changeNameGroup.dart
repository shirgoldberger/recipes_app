import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../config.dart';

// ignore: must_be_immutable
class ChangeNameGroup extends StatefulWidget {
  ChangeNameGroup(List _userId, String groupId, String _groupName) {
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
  _ChangeNameGroupState createState() => _ChangeNameGroupState();
}

class _ChangeNameGroupState extends State<ChangeNameGroup> {
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
            Text("change the group name:"),
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
            MaterialButton(
                minWidth: 200.0,
                height: 35,
                color: appBarBackgroundColor,
                child: new Text('update name',
                    style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                onPressed: () {
                  saveUser(emailTocheck);
                }),
          ]))
        ]));
  }

  Future<void> saveUser(String email) async {
    final db = Firestore.instance;
    if (widget.groupName != null) {
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
      Navigator.pop(context, widget.groupName);
    }
  }
}
