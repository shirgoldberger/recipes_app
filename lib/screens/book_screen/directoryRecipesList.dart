import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/directory.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/book_screen/changeDirectoryName.dart';
import 'package:recipes_app/screens/recipes/recipeHeadLine.dart';
import 'package:recipes_app/services/userFromDB.dart';
import '../../shared_screen/config.dart';

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
        style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
      ),
      backgroundColor: appBarBackgroundColor,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        color: appBarTextColor,
        onPressed: () => Navigator.pop(context, widget.directory.name),
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
                    width: 395,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                        child: RecipeHeadLine(widget.directory.recipes[index],
                            false, widget.directoryToFo))),
              ],
            ));
      },
    );
  }

  Widget deleteButtom() {
    return Visibility(
      visible: widget.toDelete,
      child: ButtonTheme(
          minWidth: 200.0,
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
              onPressed: () => _showAlertDialog(context))),
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
        width: MediaQuery.of(context).size.width * 0.3,
        child: Drawer(
          child: ListView(
            children: <Widget>[
              directoreName(),
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

  Widget directoreName() {
    // ignore: missing_required_param
    return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: appBarBackgroundColor,
        ),
        arrowColor: appBarBackgroundColor,
        accountName: Text(widget.directory.name + " Directory",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontFamily: 'Raleway')));
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
    UserFromDB.deleteDirectory(widget.uid, widget.directory.id);
    Navigator.of(context).pop();
    // Navigator.pop(context, "delete");
  }

  Future<void> _showAlertDialog(BuildContext context1) async {
    BuildContext dialogContenst;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContenst = context;
        return AlertDialog(
          title: Text('Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this directory?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('yes- delete'),
              onPressed: () async {
                delete();
                Navigator.pop(dialogContenst);
                Navigator.pop(context1, "delete");
              },
            ),
            TextButton(
              child: Text('no- go back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateName(var value) async {
    if (value != null) {
      if (value != widget.directory.name) {
        setState(() {
          widget.directory.name = value;
        });
        UserFromDB.changeDirectoryName(
            widget.uid, widget.directory.id, widget.directory.name);
      }
    }
  }
}
