import 'dart:wasm';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/Setting_form.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screens/home_screen/GroupList.dart';
import 'package:recipes_app/screens/home_screen/logIn/log_in_wrapper.dart';
import 'package:recipes_app/screens/home_screen/newGroup.dart';
import 'package:recipes_app/screens/home_screen/plusRecipe.dart';
import 'package:recipes_app/screens/home_screen/recipesFolder.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/shared_screen/loading.dart';

import '../book_page.dart';

class HomeLogIn extends StatefulWidget {
  HomeLogIn(String _user) {
    this.uid = _user;
  }
  String uid;
  @override
  _HomeLogInState createState() => _HomeLogInState();
}

class _HomeLogInState extends State<HomeLogIn> {
  final db = Firestore.instance;
  final AuthService _auth = AuthService();
  //User user;
  Widget box = SizedBox(
    height: 20.0,
  );
  String name = "";
  List<String> groupName;
  List<String> groupId;

  @override
  void initState() {
    super.initState();
//  print("initttttttttttttttttttttt");
    // getData() async {
    //   print("uiddddddddddddddddddddddddd:         " + user.uid);
    //   DocumentSnapshot a =
    //       await Firestore.instance.collection('users').document(user.uid).get();
    //   setState(() {

    //     name = a.data["firstName"];
    //   });
    // }

    // getData();
  }

  Future<void> getGroups() async {
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('groups')
        .getDocuments();
    snap.documents.forEach((element) async {
      groupId.add(element.data['groupId']);
      groupName.add(element.data['groupName']);
    });
  }

  void getData() async {
    //   print("uiddddddddddddddddddddddddd:         " + widget.uid);
    DocumentSnapshot a =
        await Firestore.instance.collection('users').document(widget.uid).get();
    setState(() {
      name = a.data["firstName"];
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    // print("a");
    // print(widget.uid);
    getData();
    void _showSettingPannel() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
              child: SettingForm(),
            );
          });
    }

    // Firestore.instance.collection('users').document(user.uid).get().then(
    //     (DocumentSnapshot) =>
    //         name = DocumentSnapshot.data['firstName'].toString());

    // return StreamProvider<List<Recipe>>.value(
    //     value: DataBaseService(user.uid).recipe,
    //     child: Scaffold(
    //         backgroundColor: Colors.brown[50],
    //         appBar: AppBar(
    //           title: Text('cook book'),
    //           backgroundColor: Colors.brown[400],
    //           elevation: 0.0,
    //           actions: <Widget>[
    //             FlatButton.icon(
    //               icon: Icon(Icons.person),
    //               label: Text('log out'),
    //               onPressed: () async {
    //                 print("out");
    //                 print(user.uid);
    //                 await _auth.signOut();
    //                 print("done");
    //                 Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                         builder: (context) => LogInWrapper()));
    //               },
    //             ),
    //             FlatButton.icon(
    //               icon: Icon(Icons.settings),
    //               label: Text('setting'),
    //               onPressed: () => _showSettingPannel(),
    //             ),
    //             FlatButton.icon(
    //                 icon: Icon(Icons.add),
    //                 label: Text('plus'),
    //                 onPressed: () {
    //                   Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                           builder: (context) => PlusRecipe()));
    //                 })
    //           ],
    //         ),
    //         body: RecipeFolder(false)));
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: Text(
            'Cook Book',
            style: TextStyle(fontFamily: 'LogoFont'),
          ),
          backgroundColor: Colors.blueGrey[700],
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ListView(children: <Widget>[
              box,
              Text(
                // add the name of the user
                "Hello " + name + "!\n Select what you want to do:",
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 20,
                    color: Colors.blueGrey[800]),
                textAlign: TextAlign.center,
              ),
              box,
              FlatButton.icon(
                  color: Colors.blueGrey[400],
                  icon: Icon(
                    Icons.book,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Recipes Book',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipesBookPage(widget.uid)));
                  }),
              FlatButton.icon(
                  color: Colors.blueGrey[400],
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Add recipe',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PlusRecipe()));
                  }),
              FlatButton.icon(
                color: Colors.blueGrey[400],
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                label: Text(
                  'Setting',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _showSettingPannel(),
              ),
              FlatButton.icon(
                color: Colors.blueGrey[400],
                icon: Icon(Icons.person, color: Colors.white),
                label: Text('Log Out', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogInWrapper()));
                },
              ),
              FlatButton.icon(
                color: Colors.blueGrey[400],
                icon: Icon(Icons.plus_one, color: Colors.white),
                label: Text('mew group', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewGroup()));
                },
              ),
              FlatButton.icon(
                color: Colors.blueGrey[400],
                icon: Icon(Icons.plus_one, color: Colors.white),
                label:
                    Text('watch group', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupList(widget.uid)));
                },
              ),
            ])));
  }
}
