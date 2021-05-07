import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../config.dart';

// ignore: must_be_immutable
class ChangeNameGroup extends StatefulWidget {
  List userId = [];
  String groupId;
  String groupName;
  bool done = false;
  ChangeNameGroup(List _userId, String _groupId, String _groupName) {
    this.userId = _userId.toList();
    this.groupId = _groupId;
    this.groupName = _groupName;
  }

  @override
  _ChangeNameGroupState createState() => _ChangeNameGroupState();
}

class _ChangeNameGroupState extends State<ChangeNameGroup> {
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
            nameBox(),
            updateBox(),
          ]))
        ]));
  }

  Widget nameBox() {
    return TextFormField(
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
    );
  }

  Widget title() {
    return Text("Change group name:");
  }

  Widget updateBox() {
    return MaterialButton(
        minWidth: 200.0,
        height: 35,
        color: appBarBackgroundColor,
        child: Text('Update name',
            style: TextStyle(fontSize: 16.0, color: Colors.white)),
        onPressed: () {
          saveUser(emailTocheck);
        });
  }

  // database function //
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
