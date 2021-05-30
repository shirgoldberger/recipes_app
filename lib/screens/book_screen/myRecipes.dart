import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/directory.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipes/recipeHeadLine.dart';
import '../../shared_screen/config.dart';

// ignore: must_be_immutable
class MyRecipes extends StatefulWidget {
  Directory directory;
  List<Recipe> recipeList = [];
  List usersName = [];
  List userId = [];
  String uid;
  bool doneLoad = false;
  bool toDelete;
  String directoryToFo;

  MyRecipes(
      Directory _directory, String _uid, bool _toDelete, String directoryToFo) {
    this.directory = _directory;
    this.uid = _uid;
    this.toDelete = _toDelete;
    this.directoryToFo = directoryToFo;
  }

  @override
  _MyRecipesState createState() => _MyRecipesState();
}

class _MyRecipesState extends State<MyRecipes> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.directory.recipes = Provider.of<List<Recipe>>(context) ?? [];
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar(),
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
      "You didn't create recipes yet - lets add some recipes...",
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
}
