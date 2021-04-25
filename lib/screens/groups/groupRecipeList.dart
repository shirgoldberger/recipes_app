import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/groups/groupRecipeHeadLine.dart';
import 'ParticipentsWatch.dart';
import 'addParticipent.dart';
import '../personal_screen/homeLogIn.dart';
import 'package:recipes_app/shared_screen/loading.dart';

class GroupRecipeList extends StatefulWidget {
  GroupRecipeList(String _groupId, String _groupName, String _myUid) {
    this.groupId = _groupId;
    this.myUid = _myUid;
    this.groupName = _groupName;
  }
  String groupId;
  String groupName;
  List<Recipe> recipeList = [];
  List<Recipe> a = [];
  List usersName = [];
  List userId = [];
  String myUid;

  bool doneLoad = false;

  @override
  _GroupRecipeListState createState() => _GroupRecipeListState();
}

class _GroupRecipeListState extends State<GroupRecipeList> {
  void initState() {
    super.initState();
    if (!widget.doneLoad) {
      makeList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.doneLoad) {
      return Loading();
    } else {
      int _value = 4;
      print(widget.usersName);
      if (widget.a.length == 0) {
        return Scaffold(
            backgroundColor: Colors.blueGrey[50],
            appBar: AppBar(
                title: Text(
                  widget.groupName,
                  style: TextStyle(fontFamily: 'Raleway'),
                ),
                backgroundColor: Colors.blueGrey[700],
                elevation: 0.0,
                actions: <Widget>[
                  DropdownButton(
                      value: _value,
                      items: [
                        DropdownMenuItem(
                          child: Text('setting:'),
                          value: 4,
                        ),
                        DropdownMenuItem(
                          child: FlatButton.icon(
                              color: Colors.black,
                              icon: Icon(
                                Icons.people,
                                color: Colors.white,
                              ),
                              label: Text(
                                "people ",
                                style: TextStyle(
                                    fontFamily: 'Raleway', color: Colors.white),
                              ),
                              onPressed: () {
                                showParticipents();
                              }),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: FlatButton.icon(
                              color: Colors.black,
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              label: Text(
                                "add",
                                style: TextStyle(
                                    fontFamily: 'Raleway', color: Colors.white),
                              ),
                              onPressed: () {
                                addParticipents();
                              }),
                          value: 2,
                        ),
                        DropdownMenuItem(
                            child: FlatButton.icon(
                                color: Colors.black,
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "delete me",
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  delete();
                                }),
                            value: 3),
                      ],
                      onChanged: (value) {
                        setState(() {});
                      }),
                ]),
            body: Column(children: <Widget>[
              Text("thers is no recipes in this group - lets add some recipe.")
            ]));
      }

      return Scaffold(
          backgroundColor: Colors.blueGrey[50],
          appBar: AppBar(
            title: Text(
              widget.groupName,
              style: TextStyle(fontFamily: 'Raleway'),
            ),
            backgroundColor: Colors.blueGrey[700],
            elevation: 0.0,
            actions: <Widget>[
              DropdownButton(
                  value: _value,
                  items: [
                    DropdownMenuItem(
                      child: Text('setting:'),
                      value: 4,
                    ),
                    DropdownMenuItem(
                      child: FlatButton.icon(
                          color: Colors.black,
                          icon: Icon(
                            Icons.people,
                            color: Colors.white,
                          ),
                          label: Text(
                            "people ",
                            style: TextStyle(
                                fontFamily: 'Raleway', color: Colors.white),
                          ),
                          onPressed: () {
                            showParticipents();
                          }),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: FlatButton.icon(
                          color: Colors.black,
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: Text(
                            "add",
                            style: TextStyle(
                                fontFamily: 'Raleway', color: Colors.white),
                          ),
                          onPressed: () {
                            addParticipents();
                          }),
                      value: 2,
                    ),
                    DropdownMenuItem(
                        child: FlatButton.icon(
                            color: Colors.black,
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            label: Text(
                              "delete me",
                              style: TextStyle(
                                  fontFamily: 'Raleway', color: Colors.white),
                            ),
                            onPressed: () {
                              delete();
                            }),
                        value: 3),
                  ],
                  onChanged: (value) {
                    setState(() {});
                  }),
            ],
          ),
          body: Column(children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: widget.a.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.all(8),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0)),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0)),
                              child:
                                  //                       SizedBox(
                                  //   height: 20.0,
                                  // );
                                  GroupRecipeHeadLine(
                                      widget.a[index], widget.groupId))));

                  //return Folder(widget.list, widget.home);
                },
              ),
            )
          ]));
    }
  }

  Future<void> makeList() async {
    //get the participents in this group
    DocumentSnapshot snap2 = await Firestore.instance
        .collection('Group')
        .document(widget.groupId)
        .get();
    List user = snap2.data['users'] ?? [];
    widget.userId = user;
    for (int i = 0; i < user.length; i++) {
      DocumentSnapshot snap3 =
          await Firestore.instance.collection('users').document(user[i]).get();
      widget.usersName
          .add(snap3.data['firstName'] + " " + snap3.data['lastName']);
    }
    int i = 0;
    QuerySnapshot snap = await Firestore.instance
        .collection('Group')
        .document(widget.groupId)
        .collection('recipes')
        .getDocuments();

    if (snap.documents.length == 0) {
      setState(() {
        widget.doneLoad = true;
      });
      return;
    }
    String uid;
    String recipeId;
    Recipe r;
    snap.documents.forEach((element) async {
      uid = element.data['userId'] ?? '';
      recipeId = element.data['recipeId'] ?? '';

      DocumentSnapshot doc = await Firestore.instance
          .collection('users')
          .document(uid)
          .collection('recipes')
          .document(recipeId)
          .get();

      //check if in the user;

      String n = doc.data['name'] ?? '';

      String de = doc.data['description'] ?? '';
      String level = doc.data['level'] ?? 0;
      String time = doc.data['time'] ?? '0';
      int timeI = int.parse(time);
      String writer = doc.data['writer'] ?? '';
      String writerUid = doc.data['writerUid'] ?? '';
      String id = doc.data['recipeID'] ?? '';
      //
      String publish = doc.data['publishID'] ?? '';
      int levlelInt = int.parse(level);
      //tags
      var tags = doc.data['tags'];
      String tagString = tags.toString();
      List<String> l = [];
      if (tagString != "[]") {
        String tag = tagString.substring(1, tagString.length - 1);
        l = tag.split(',');
        for (int i = 0; i < l.length; i++) {
          if (l[i][0] == ' ') {
            l[i] = l[i].substring(1, l[i].length);
          }
        }
      }
      //notes
      var note = doc.data['tags'];
      String noteString = note.toString();
      List<String> nList = [];
      if (noteString != "[]") {
        String tag = noteString.substring(1, noteString.length - 1);
        nList = tag.split(',');
        for (int i = 0; i < nList.length; i++) {
          if (nList[i][0] == ' ') {
            nList[i] = nList[i].substring(1, nList[i].length);
          }
        }
      }

      r = Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI, true, id,
          publish, '');
      //Recipe a = Recipe("!", "1", [], 0, [], "", "", 1, true, "", "", "");
      //widget.a.add(a);

      widget.a.add(r);

      //widget.recipeList.add(a);

      i++;

      if ((i) == snap.documents.length) {
        setState(() {
          widget.doneLoad = true;
        });
      }
      // setState(() {
      //   widget.recipeList.add(r);

      // });
      // print("plus ");

      // i++;
      // print(i.toString() + " -----------------");
      // print(snap.documents.length);
      // if ((i) == snap.documents.length) {
      //   setState(() {
      //     print("true");
      //     print(widget.a);
      //     widget.doneLoad = true;
      //   });
      //widget.doneLoad = true;
    });
  }

  Future<void> showParticipents() async {
    //print(notes);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: new BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: ParticipentsWatch(widget.usersName)));
  }

  Future<void> addParticipents() async {
    //print(notes);
    showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: new BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  ),
                ),
                child: AddParticipent(
                    widget.userId, widget.groupId, widget.groupName)))
        .then((value) => cameBack(value));
  }

  Future<void> delete() async {
    // print("delete");
    DocumentSnapshot snap2 = await Firestore.instance
        .collection('Group')
        .document(widget.groupId)
        .get();
    List usersList = [];
    List user = snap2.data['users'] ?? '';
    usersList.addAll(user);
    usersList.remove(widget.myUid);
    final db = Firestore.instance;
    db
        .collection('Group')
        .document(widget.groupId)
        .updateData({'users': usersList});
    QuerySnapshot snap3 = await Firestore.instance
        .collection('users')
        .document(widget.myUid)
        .collection('groups')
        .getDocuments();

    snap3.documents.forEach((element) async {
      if (element.data['groupId'] == widget.groupId) {
        db
            .collection('users')
            .document(widget.myUid)
            .collection('groups')
            .document(element.documentID)
            .delete();
      }
    });

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomeLogIn(widget.myUid)));
  }

  Future<void> cameBack(var value) async {
    print("value");
    //  print(value);

    var a = value.toString();
    print(a);
    if (value["a"] != null) {
      if (widget.userId.toString() != value["a"].toString()) {
        setState(() {
          widget.userId = value["a"];
        });

        //if (widget.userId != value["a"]) {
        DocumentSnapshot snap3 = await Firestore.instance
            .collection('users')
            .document(widget.userId[widget.userId.length - 1])
            .get();
        setState(() {
          widget.usersName
              .add(snap3.data['firstName'] + " " + snap3.data['lastName']);
        });
      }
    }
    if (value["b"] != widget.groupName) {
      final db = Firestore.instance;
      setState(() {
        widget.groupName = value["b"];
      });
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
  }
}
