import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/groups/changeNameGroup.dart';
import 'package:recipes_app/screens/groups/groupRecipeHeadLine.dart';
import '../../config.dart';
import 'ParticipentsWatch.dart';
import 'addParticipent.dart';
import '../personal_screen/homeLogIn.dart';
import 'package:recipes_app/shared_screen/loading.dart';

// ignore: must_be_immutable
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
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context, false),
                ),
                actions: <Widget>[]),
            drawerDragStartBehavior: DragStartBehavior.down,
            drawerScrimColor: Colors.blueGrey[200],
            endDrawer: leftMenu(),
            body: Column(children: <Widget>[
              box,
              Text(
                "thers is no recipes in this group - lets add some recipes...",
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 30,
                    color: Colors.blueGrey[800]),
                textAlign: TextAlign.center,
              )
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
            actions: <Widget>[],
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
          ),
          drawerDragStartBehavior: DragStartBehavior.down,
          drawerScrimColor: Colors.blueGrey[200],
          endDrawer: leftMenu(),
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

  Widget deleteButtom() {
    return ButtonTheme(
      minWidth: 200.0,
      height: 50.0,
      // ignore: deprecated_member_use
      child: FlatButton.icon(
          color: Colors.blueGrey[300],
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          label: Text(
            "delete me",
            style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
          ),
          onPressed: () {
            delete();
          }),
    );
  }

  Widget people() {
    return ButtonTheme(
      minWidth: 200.0,
      height: 50.0,
      // ignore: deprecated_member_use
      child: FlatButton.icon(
          color: Colors.blueGrey[300],
          icon: Icon(
            Icons.people,
            color: Colors.white,
          ),
          label: Text(
            "people ",
            style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
          ),
          onPressed: () {
            showParticipents();
          }),
    );
  }

  Widget add() {
    return ButtonTheme(
      minWidth: 200.0,
      height: 50.0,
      // ignore: deprecated_member_use
      child: FlatButton.icon(
          color: Colors.blueGrey[300],
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: Text(
            "add",
            style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
          ),
          onPressed: () {
            addParticipents();
          }),
    );
  }

  Widget editNameWidget() {
    return ButtonTheme(
      minWidth: 200.0,
      height: 50.0,
      // ignore: deprecated_member_use
      child: FlatButton.icon(
          color: Colors.blueGrey[300],
          icon: Icon(
            Icons.text_fields,
            color: Colors.white,
          ),
          label: Text(
            "edit name",
            style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
          ),
          onPressed: () {
            editName();
          }),
    );
  }

  Widget leftMenu() {
    return Container(
      color: appBarBackgroundColor,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            profileDetails(),
            Column(children: [
              box,
              deleteButtom(),
              boxSize,
              people(),
              boxSize,
              add(),
              boxSize,
              editNameWidget()
            ]),
          ],
        ),
      ),
    );
  }

  Widget boxSize = SizedBox(
    height: 8.0,
  );
  Widget profileDetails() {
    // ignore: missing_required_param
    return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: appBarBackgroundColor,
        ),
        arrowColor: appBarBackgroundColor,
        accountName: Text(widget.groupName,
            style: TextStyle(fontSize: 15, fontFamily: 'frik')));
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

  Future<void> editName() async {
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
                child: ChangeNameGroup(
                    widget.userId, widget.groupId, widget.groupName)))
        .then((value) => updateName(value));
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
    if (usersList.length == 0) {
      //print("empty group");
      db.collection('Group').document(widget.groupId).delete();
    }
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

  Future<void> updateName(var value) async {
    if (value != null) {
      if (value != widget.groupName) {
        final db = Firestore.instance;
        setState(() {
          widget.groupName = value;
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

  Future<void> cameBack(var value) async {
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
