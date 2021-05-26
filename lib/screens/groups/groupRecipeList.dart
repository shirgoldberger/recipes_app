import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/groups/changeNameGroup.dart';
import 'package:recipes_app/screens/groups/groupRecipeHeadLine.dart';
import 'package:recipes_app/services/groupFromDB.dart';
import 'package:recipes_app/services/userFromDB.dart';
import '../../config.dart';
import 'ParticipentsWatch.dart';
import 'addParticipent.dart';
import '../personal_screen/homeLogIn.dart';
import 'package:recipes_app/shared_screen/loading.dart';

// ignore: must_be_immutable
class GroupRecipeList extends StatefulWidget {
  String groupId;
  String groupName;
  List<Recipe> recipeList = [];
  List<Recipe> recipes = [];
  List usersName = [];
  List userId = [];
  String myUid;
  bool doneLoad = false;

  GroupRecipeList(String _groupId, String _groupName, String _myUid) {
    this.groupId = _groupId;
    this.myUid = _myUid;
    this.groupName = _groupName;
  }

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
      return Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(),
          drawerDragStartBehavior: DragStartBehavior.down,
          endDrawer: leftMenu(),
          body: Column(
              children: (widget.recipes.length == 0)
                  ? <Widget>[box, noRecipesText()]
                  : [
                      Expanded(
                        child: recipesList(),
                      )
                    ]));
    }
  }

  Widget appBar() {
    return AppBar(
      title: Text(
        widget.groupName,
        style: TextStyle(fontFamily: 'Raleway'),
      ),
      backgroundColor: appBarBackgroundColor,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context, widget.groupName),
      ),
    );
  }

  Widget noRecipesText() {
    return Text(
      "thers is no recipes in this group - lets add some recipes...",
      style: TextStyle(
          fontFamily: 'Raleway', fontSize: 30, color: Colors.blueGrey[800]),
      textAlign: TextAlign.center,
    );
  }

  Widget recipesList() {
    return ListView.builder(
      itemCount: widget.recipes.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: EdgeInsets.all(8),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: ClipRRect(
                    child: GroupRecipeHeadLine(
                        widget.recipes[index], widget.groupId))));
      },
    );
  }

  Widget deleteButtom() {
    return ButtonTheme(
        minWidth: 250.0,
        height: 50.0,
        // ignore: deprecated_member_use
        child: FlatButton.icon(
            color: subButtonColor,
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            label: Text(
              "delete me",
              style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
            ),
            onPressed: delete));
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
          color: subButtonColor,
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
          color: subButtonColor,
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
              heightBox(8),
              people(),
              heightBox(8),
              add(),
              heightBox(8),
              editNameWidget()
            ]),
          ],
        ),
      ),
    );
  }

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
    // get the participents in this group
    List user = await GroupFromDB.getUsersGroup(widget.groupId);
    widget.userId = user;
    for (int i = 0; i < user.length; i++) {
      String firstName = await UserFromDB.getUserFirstName(user[i]);
      String lastName = await UserFromDB.getUserLastName(user[i]);
      widget.usersName.add(firstName + " " + lastName);
    }
    widget.recipes.addAll(await GroupFromDB.getGroupRecipes(widget.groupId));
    setState(() {
      widget.doneLoad = true;
    });
  }

  Future<void> showParticipents() async {
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

  void delete() async {
    await GroupFromDB.deleteUserFromGroup(widget.myUid, widget.groupId);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomeLogIn(widget.myUid)));
  }

  Future<void> updateName(var value) async {
    if (value != null) {
      if (value != widget.groupName) {
        setState(() {
          widget.groupName = value;
        });
        final db = Firestore.instance;
        // await GroupFromDB.updateGroupName(widget.groupId, value, widget.userId);
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
        String firstName = await UserFromDB.getUserFirstName(
            widget.userId[widget.userId.length - 1]);
        String lastName = await UserFromDB.getUserLastName(
            widget.userId[widget.userId.length - 1]);
        setState(() {
          widget.usersName.add(firstName + " " + lastName);
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
