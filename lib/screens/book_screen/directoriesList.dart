import 'package:flutter/material.dart';
import 'package:recipes_app/models/directory.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/services/recipeFromDB.dart';

import 'directoryRecipesList.dart';

// ignore: must_be_immutable
class DirectoriesList extends StatefulWidget {
  String uid;
  List<Directory> directories = [];
  bool doneLoad = false;

  DirectoriesList(List<Directory> _directories, String _uid) {
    this.uid = _uid;
    this.directories = _directories;
  }

  @override
  _DirectoriesListState createState() => _DirectoriesListState();
}

class _DirectoriesListState extends State<DirectoriesList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.directories.length > 0 ? directoriesList() : emptyMessage(),
    );
  }

  Widget directoriesList() {
    return ListView.builder(
        padding: EdgeInsets.only(left: 6.0, right: 6.0),
        itemCount: widget.directories.length,
        itemBuilder: (context, index) {
          return directoryTitle(index);
        });
  }

  Widget directoryTitle(int index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.indigo[100],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.white)),
        onPressed: () async {
          getDirectoryRecipes(index);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DirectoryRecipesList(
                      widget.directories[index], widget.uid))).then((value) {
            if (value == "delete") {
              setState(() {
                widget.directories.removeAt(index);
              });
            }
          });
        },
        padding: EdgeInsets.all(15.0),
        textColor: Colors.white,
        child: directoryName(index),
      ),
    );
  }

  void getDirectoryRecipes(int index) async {
    List<Recipe> recipes = await RecipeFromDB.getDirectoryRecipesList(
        widget.uid, widget.directories[index].id);
    widget.directories[index].initRecipes(recipes);
  }

  Widget emptyMessage() {
    return Text("You dont have any directories.\nLets create a new one!",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25, fontFamily: 'Raleway'));
  }

  Widget directoryName(int index) {
    return Text(widget.directories[index].name,
        style: TextStyle(
            fontSize: 25, fontFamily: 'Raleway', color: Colors.indigo[600]));
  }
}
