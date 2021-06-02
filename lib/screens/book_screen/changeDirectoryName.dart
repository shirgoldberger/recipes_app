import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:recipes_app/models/directory.dart';
import 'package:recipes_app/services/userFromDB.dart';
import '../../shared_screen/config.dart';

// ignore: must_be_immutable
class ChangeDirectoryName extends StatefulWidget {
  Directory directory;
  String uid;
  bool done = false;
  String error = '';
  String originalName = "";
  ChangeDirectoryName(Directory _directory, String _uid) {
    this.directory = _directory;
    this.originalName = directory.name;
    this.uid = _uid;
  }

  @override
  _ChangeDirectoryNameState createState() => _ChangeDirectoryNameState();
}

class _ChangeDirectoryNameState extends State<ChangeDirectoryName> {
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
            errorText(),
            updateBox(),
          ]))
        ]));
  }

  Widget errorText() {
    return Text(
      widget.error,
      style: TextStyle(color: Colors.black),
    );
  }

  Widget nameBox() {
    return TextFormField(
      initialValue: widget.directory.name,
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
          saveName();
        });
  }

  Future<void> saveName() async {
    BuildContext context1 = context;
    try {
      bool found = false;
      if (widget.directory.name == widget.originalName) {
        found = true;
        setState(() {
          widget.error = "this is the same name";
        });
        return;
      }
      if (widget.directory.name != "") {
        if (widget.done) {
          QuerySnapshot directories =
              await UserFromDB.getUserDirectories(widget.uid);
          for (int i = 0; i < directories.documents.length; i++) {
            String name = directories.documents[i].data['name'] ?? '';
            if (name == widget.directory.name) {
              found = true;
              setState(() {
                widget.error = "You have directory with this name";
                return;
              });
            }
          }
          if (!found) {
            UserFromDB.changeDirectoryName(
                widget.uid, widget.directory.id, widget.directory.name);
            Navigator.pop(context, widget.directory);
          }
        }
      }
    } catch (e) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Something wrong.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Phoenix.rebirth(context1);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
