import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../config.dart';

// ignore: must_be_immutable
class AddParticipent extends StatefulWidget {
  List userId = [];
  String groupId;
  bool done = false;
  String groupName;
  AddParticipent(List _userId, String groupId, String _groupName) {
    this.userId = _userId.toList();
    this.groupId = groupId;
    this.groupName = _groupName;
  }

  @override
  _AddParticipentState createState() => _AddParticipentState();
}

class _AddParticipentState extends State<AddParticipent> {
  List usersID = [];
  String error = '';
  bool findUser = false;
  String emailTocheck = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Column(children: <Widget>[
          Flexible(
              child: ListView(children: [
            heightBox(10),
            title(),
            heightBox(10),
            emailBox(),
            errorText(),
            box,
            addButton(),
          ]))
        ]));
  }

  Widget title() {
    return Text("Add new member to your group:");
  }

  Widget emailBox() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Add new member Email',
      ),
      validator: (val) => val.isEmpty ? '' : null,
      onChanged: (val) {
        setState(() => emailTocheck = val);
      },
    );
  }

  Widget errorText() {
    return Text(
      error,
      style: TextStyle(color: errorColor),
    );
  }

  Widget addButton() {
    return MaterialButton(
        minWidth: 200.0,
        height: 35,
        color: appBarBackgroundColor,
        child: Text('Add user & save',
            style: TextStyle(fontSize: 16.0, color: Colors.white)),
        onPressed: () {
          saveUser(emailTocheck);
        });
  }

  // database function //
  Future<void> saveUser(String email) async {
    final db = Firestore.instance;
    String mailCheck;
    QuerySnapshot snap =
        await Firestore.instance.collection('users').getDocuments();
    snap.documents.forEach((element) async {
      mailCheck = element.data['Email'] ?? '';

      if (mailCheck == email) {
        if (!usersID.contains(element.documentID)) {
          findUser = true;

          usersID.add(element.documentID);

          await db
              .collection('Group')
              .document(widget.groupId)
              .updateData({'users': usersID});
          await db
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
