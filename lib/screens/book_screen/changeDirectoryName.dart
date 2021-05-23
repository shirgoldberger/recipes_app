import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/directory.dart';
import '../../config.dart';

// ignore: must_be_immutable
class ChangeDirectoryName extends StatefulWidget {
  Directory directory;
  String uid;
  bool done = false;
  ChangeDirectoryName(Directory _directory, String _uid) {
    this.directory = _directory;
    this.uid = _uid;
  }

  @override
  _ChangeDirectoryNameState createState() => _ChangeDirectoryNameState();
}

class _ChangeDirectoryNameState extends State<ChangeDirectoryName> {
  String error = '';
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
        hintText: widget.directory.name,
      ),
      validator: (val) => val.isEmpty ? widget.directory.name : null,
      onChanged: (val) {
        setState(() {
          widget.directory.name = val;
          widget.done = true;
        });
      },
    );
  }

  Widget title() {
    return Text("Change directory name:");
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
    if (widget.directory.name != null) {
      if (widget.done) {
        db
            .collection('users')
            .document(widget.uid)
            .collection('Directory')
            .document(widget.directory.id)
            .updateData({'name': widget.directory.name});
      }
      Navigator.pop(context, widget.directory);
    }
  }
}
