import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/directory.dart';

// ignore: must_be_immutable
class NewDirectory extends StatefulWidget {
  String uid;
  List<Directory> directories;
  String error2 = "";

  NewDirectory(String _uid, List<Directory> _directories) {
    this.uid = _uid;
    this.directories = _directories;
  }

  @override
  _NewDirectoryState createState() => _NewDirectoryState();
}

class _NewDirectoryState extends State<NewDirectory> {
  List<String> usersID = [];
  List<String> userFullNames = [];
  String directoryName = "";
  String error = '';
  String errorDirectoryName = '';
  bool findUser = false;
  String emailTocheck;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: _formKey,
        height: 100,
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(),
          body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
              child: Column(children: <Widget>[
                Flexible(
                    child: ListView(children: [
                  title(),
                  heightBox(30),
                  directoryNameField(),
                  heightBox(20),
                  heightBox(20),
                  errorText(),
                  new Padding(padding: EdgeInsets.only(top: 10.0)),
                ])),
              ])),
          resizeToAvoidBottomInset: false,
        ));
  }

  Widget appBar() {
    return AppBar(
        title: Text(
          'New Directory',
          style: TextStyle(fontFamily: logoFont),
        ),
        backgroundColor: appBarBackgroundColor,
        actions: <Widget>[
          // ignore: deprecated_member_use
          saveGroupWidget()
        ]);
  }

  Widget title() {
    return Text(
      'let\'s create a new directory!',
      style: TextStyle(
          fontFamily: 'Raleway', fontSize: 25, color: Colors.blueGrey[800]),
      textAlign: TextAlign.center,
    );
  }

  Widget directoryNameField() {
    return TextFormField(
      cursorWidth: 10,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.edit),
        icon: Icon(Icons.dns),
        hintText: 'Directory Name',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter Directory name';
        }
        if (checkDirectoryName(value)) {
          return 'You have directory with this name';
        }
        return null;
      },
      onChanged: (val) {
        setState(() => directoryName = val);
      },
    );
  }

  Widget errorText() {
    return Text(
      widget.error2,
      style: TextStyle(color: errorColor),
    );
  }

  Widget saveGroupWidget() {
    return FlatButton.icon(
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text('SAVE', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          if ((directoryName == null) || (directoryName == "")) {
            setState(() {
              widget.error2 = "Fill directory name!";
            });
          } else if (checkDirectoryName(directoryName)) {
            setState(() {
              widget.error2 = 'You have directory with this name';
            });
          } else {
            List<String> a = [];
            print(widget.uid);
            DocumentReference d = await Firestore.instance
                .collection('users')
                .document(widget.uid)
                .collection('Directory')
                .add({"name": directoryName, "Recipes": a});
            Navigator.pop(context);
          }
        });
  }

  bool checkDirectoryName(String name) {
    for (Directory d in widget.directories) {
      if (d.name == name) {
        return true;
      }
    }
    return false;
  }
}
