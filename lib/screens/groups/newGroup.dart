import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/config.dart';

// ignore: must_be_immutable
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
                // ignore: deprecated_member_use
                FlatButton.icon(
                    icon: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    label: Text('SAVE', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      saveGroup();
                      Navigator.pop(context);
                    }),
              ]),
          body: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Column(children: <Widget>[
                Flexible(
                    child: ListView(children: [
                  Text(
                    'Hey let\'s create a new group!',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 25,
                        color: Colors.blueGrey[800]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  groupNameField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Adding participants:',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 20,
                        color: Colors.blueGrey[800]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  groupEmailField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                  RawMaterialButton(
                    onPressed: () => saveUser(emailTocheck),
                    elevation: 0.9,
                    fillColor: Colors.blueGrey[300],
                    child: Icon(
                      Icons.person_add_alt_1,
                      size: 30.0,
                    ),
                    padding: EdgeInsets.all(5.0),
                    shape: CircleBorder(),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Text(
                  //   'Participants:',
                  //   style: TextStyle(
                  //       fontFamily: 'Raleway',
                  //       fontSize: 20,
                  //       color: Colors.blueGrey[800]),
                  //   textAlign: TextAlign.center,
                  // ),
                  new Padding(padding: EdgeInsets.only(top: 10.0)),
                  Column(children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: userEmail.length,
                        itemBuilder: (context, index) {
                          return Text(
                            (index + 1).toString() +
                                "." +
                                "  " +
                                userEmail[index],
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                fontSize: 20, color: Colors.blueGrey[800]),
                          );
                        }),
                    new Padding(padding: EdgeInsets.only(top: 20.0)),
                  ]),
                ])),
              ])),
          //   resizeToAvoidBottomPadding: false,
        ));
  }

  Widget groupNameField() {
    return TextFormField(
      cursorWidth: 10,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.edit),
        icon: Icon(Icons.closed_caption),
        hintText: 'Group Name',
      ),
      validator: (val) => val.isEmpty ? 'Enter a name of your group' : null,
      onChanged: (val) {
        setState(() => groupName = val);
      },
    );
  }

  Widget groupEmailField() {
    return TextFormField(
      cursorWidth: 10,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.edit),
        icon: Icon(Icons.contact_mail),
        hintText: 'email adress',
      ),
      validator: (val) => val.isEmpty ? 'Enter an email of your friend' : null,
      onChanged: (val) {
        setState(() => emailTocheck = val);
      },
    );
  }

  Future<void> saveGroup() async {
    // print(usersID);
    usersID.add(widget.uid);
    final db = Firestore.instance;
    var currentRecipe = await db
        .collection('Group')
        .add({'groupName': groupName, 'users': usersID});
    String id = currentRecipe.documentID.toString();
    for (int i = 0; i < usersID.length; i++) {
      await db
          .collection('users')
          .document(usersID[i])
          .collection('groups')
          .add({'groupName': groupName, 'groupId': id});
    }
  }

  Future<void> saveUser(String email) async {
    //print("save user");
    //print(email);
    String mailCheck;
    // print(email);
    QuerySnapshot snap =
        await Firestore.instance.collection('users').getDocuments();
    snap.documents.forEach((element) async {
      mailCheck = element.data['Email'] ?? '';
      //print(mailCheck);
      if (mailCheck == email) {
        //print("sucsses");
        findUser = true;
        //return element.documentID;
        setState(() {
          error = '';
          String firstName = element.data['firstName'] ?? '';
          String lastName = element.data['lastName'] ?? '';
          String mailName = firstName + " " + lastName;

          if (mailName == ' ') {
            mailName = 'this user has no name:(';
          }
          if (!userEmail.contains(mailName)) {
            userEmail.add(mailName);
            usersID.add(element.documentID);
          } else {
            error = 'This user is already in this group';
          }
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
