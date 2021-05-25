import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/directory.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/book_screen/changeDirectoryName.dart';
import 'package:recipes_app/screens/groups/changeNameGroup.dart';
import 'package:recipes_app/screens/recipes/recipeHeadLine.dart';
import 'package:recipes_app/services/groupFromDB.dart';
import 'package:recipes_app/services/userFromDB.dart';

import '../../config.dart';
import '../personal_screen/homeLogIn.dart';
import 'package:recipes_app/shared_screen/loading.dart';

// ignore: must_be_immutable
class DirectoryRecipesList extends StatefulWidget {
  Directory directory;
  List<Recipe> recipeList = [];
  List usersName = [];
  List userId = [];
  String uid;
  bool doneLoad = false;
  bool toDelete;
  String directoryToFo;

  DirectoryRecipesList(
      Directory _directory, String _uid, bool _toDelete, String directoryToFo) {
    this.directory = _directory;
    this.uid = _uid;
    this.toDelete = _toDelete;
    this.directoryToFo = directoryToFo;
  }

  @override
  _DirectoryRecipesListState createState() => _DirectoryRecipesListState();
}

class _DirectoryRecipesListState extends State<DirectoryRecipesList> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar(),
        drawerDragStartBehavior: DragStartBehavior.down,
        endDrawer: widget.toDelete ? leftMenu() : null,
        body: Column(
            children: (widget.directory.recipes.length == 0)
                ? <Widget>[box, noRecipesText()]
                : [
                    Expanded(
                      child: recipesList(),
                    )
                  ]));
  }

  Widget appBar() {
    return AppBar(
      title: Text(
        widget.directory.name,
        style: TextStyle(fontFamily: 'Raleway', color: appBarTextColor),
      ),
      backgroundColor: appBarBackgroundColor,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: appBarTextColor,
        onPressed: () => Navigator.pop(context, false),
      ),
    );
  }

  Widget noRecipesText() {
    return Text(
      "there is no recipes in this group - lets add some recipes...",
      style: TextStyle(
          fontFamily: 'Raleway', fontSize: 30, color: appBarTextColor),
      textAlign: TextAlign.center,
    );
  }

  Widget recipesList() {
    return ListView.builder(
      itemCount: widget.directory.recipes.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: EdgeInsets.only(right: 8, left: 8, bottom: 5, top: 5),
            child: Row(
              children: [
                Container(
                    width: widget.toDelete ? 330 : 395,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                        child: RecipeHeadLine(widget.directory.recipes[index],
                            false, widget.directoryToFo))),
                Visibility(
                  visible: widget.toDelete,
                  child: IconButton(
                      onPressed: () async {
                        await deleteFromDirectory(index);
                        setState(() {});
                      },
                      icon: Icon(Icons.delete)),
                )
              ],
            ));
      },
    );
  }

  Future<void> deleteFromDirectory(int index) async {
    DocumentSnapshot directory = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('Directory')
        .document(widget.directory.id)
        .get();

    List recipes = directory.data['Recipes'] ?? [];
    List copyRecipes = [];
    copyRecipes.addAll(recipes);
    copyRecipes.remove(widget.directory.recipes[index].publish);
    // widget.directory.recipesId.removeWhere(
    //     (element) => element == widget.directory.recipes[index].publish);
    widget.directory.recipes.removeAt(index);
    Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('Directory')
        .document(widget.directory.id)
        .updateData({'Recipes': copyRecipes});
  }

  Widget deleteButtom() {
    return Visibility(
      visible: widget.toDelete,
      child: ButtonTheme(
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
                "Delete Directory",
                style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
              ),
              onPressed: delete)),
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
            "Edit name",
            style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
          ),
          onPressed: () {
            editName();
          }),
    );
  }

  Widget leftMenu() {
    return Drawer(
      child: Container(
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
                editNameWidget()
              ]),
            ],
          ),
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
        accountName: Text(widget.directory.name,
            style: TextStyle(fontSize: 15, fontFamily: 'frik')));
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
                child: ChangeDirectoryName(widget.directory, widget.uid)))
        .then((value) => updateName(value));
  }

  void delete() async {
    await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('Directory')
        .document(widget.directory.id)
        .delete();
    Navigator.of(context).pop();
    Navigator.pop(context, "delete");
  }

  Future<void> updateName(var value) async {
    if (value != null) {
      if (value != widget.directory.name) {
        setState(() {
          widget.directory.name = value;
        });
        final db = Firestore.instance;
        // await GroupFromDB.updateGroupName(widget.groupId, value, widget.userId);
        db
            .collection('Group')
            .document(widget.directory.id)
            .updateData({'groupName': widget.directory.name});

        for (int i = 0; i < widget.userId.length; i++) {
          QuerySnapshot a = await Firestore.instance
              .collection('users')
              .document(widget.userId[i])
              .collection('groups')
              .getDocuments();
          a.documents.forEach((element) {
            if (element.data['groupId'] == widget.directory.id) {
              db
                  .collection('users')
                  .document(widget.userId[i])
                  .collection('groups')
                  .document(element.documentID)
                  .updateData({'groupName': widget.directory.name});
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

    if (value["b"] != widget.directory.name) {
      final db = Firestore.instance;
      setState(() {
        widget.directory.name = value["b"];
      });
      db
          .collection('Group')
          .document(widget.directory.id)
          .updateData({'groupName': widget.directory.name});

      for (int i = 0; i < widget.userId.length; i++) {
        QuerySnapshot a = await Firestore.instance
            .collection('users')
            .document(widget.userId[i])
            .collection('groups')
            .getDocuments();
        a.documents.forEach((element) {
          if (element.data['groupId'] == widget.directory.id) {
            db
                .collection('users')
                .document(widget.userId[i])
                .collection('groups')
                .document(element.documentID)
                .updateData({'groupName': widget.directory.name});
          }
        });
      }
    }
  }
}
