import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/config.dart';

class NewGroup extends StatefulWidget {
  NewGroup(String _uid) {
    this.uid = _uid;
  }
  String uid;
  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  List<String> usersID = [];
  List<String> userEmail = [];
  String groupName = "";
  String error = '';
  bool findUser = false;
  String emailTocheck;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
              title: Text(
                'New group',
                style: TextStyle(fontFamily: 'LogoFont'),
              ),
              backgroundColor: appBarBackgroundColor,
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                    icon: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    label: Text('SAVE', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      SaveGroup();
                      Navigator.pop(context);
                    }),
              ]),
          body: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Column(children: <Widget>[
                Flexible(
                    child: ListView(children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Group Name',
                    ),
                    validator: (val) =>
                        val.isEmpty ? 'Enter a name of your recipe' : null,
                    onChanged: (val) {
                      setState(() => groupName = val);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'email Name',
                    ),
                    validator: (val) =>
                        val.isEmpty ? 'Enter a name of your recipe' : null,
                    onChanged: (val) {
                      setState(() => emailTocheck = val);
                    },
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                  RawMaterialButton(
                    onPressed: () => saveUser(emailTocheck),
                    elevation: 0.2,
                    fillColor: Colors.brown[300],
                    child: Icon(
                      Icons.add,
                      size: 18.0,
                    ),
                    padding: EdgeInsets.all(5.0),
                    shape: CircleBorder(),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  new Text(
                    'Users in this group:',
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w700),
                  ),
                  new Padding(padding: EdgeInsets.only(top: 10.0)),
                  Column(children: <Widget>[
                    for (var j = 0; j < userEmail.length; j++)
                      Text(
                        (j + 1).toString() + "." + "  " + userEmail[j],
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            color: Colors.grey[800], fontSize: 25.0),
                      ),
                    new Padding(padding: EdgeInsets.only(top: 20.0)),
                  ]),
                ])),
              ])),
          resizeToAvoidBottomPadding: false,
        ));
  }

  Future<void> SaveGroup() async {
    // print(usersID);
    usersID.add(widget.uid);
    final db = Firestore.instance;
    var currentRecipe = await db
        .collection('Group')
        .add({'groupName': groupName, 'users': usersID});
    String id = currentRecipe.documentID.toString();
    for (int i = 0; i < usersID.length; i++) {
      var currentRecipe = await db
          .collection('users')
          .document(usersID[i])
          .collection('groups')
          .add({'groupName': groupName, 'groupId': id});
    }
  }

  Future<void> saveUser(String email) async {
    String mailCheck;
    // print(email);
    QuerySnapshot snap =
        await Firestore.instance.collection('users').getDocuments();
    snap.documents.forEach((element) async {
      mailCheck = element.data['Email'] ?? '';
      print(mailCheck);
      if (mailCheck == email) {
        //print("sucsses");
        findUser = true;
        //return element.documentID;
        setState(() {
          error = '';
          String firstName = element.data['firstName'] ?? '';
          String lastName = element.data['lastName'] ?? '';
          String mailName = mailCheck + " = " + firstName + " " + lastName;
          userEmail.add(mailName);
          usersID.add(element.documentID);
        });
      }
    });
    if (!findUser) {
      setState(() {
        error = 'there is no such user, try again';
      });
    }
    findUser = false;
  }
}
