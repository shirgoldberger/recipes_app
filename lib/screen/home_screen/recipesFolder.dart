import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screen/home_screen/RecipeList.dart';
import 'package:recipes_app/screen/home_screen/recipeHeadLine.dart';

class RecipeFolder extends StatefulWidget {
  @override
  _RecipeFolderState createState() => _RecipeFolderState();
}

class _RecipeFolderState extends State<RecipeFolder> {
  @override
  Widget build(BuildContext context) {
    final recipeList = Provider.of<List<Recipe>>(context);
    int i;
    List<Recipe> fish = [];
    List<Recipe> other = [];
    List<Recipe> meet = [];
    List<Recipe> dairy = [];
    List<Recipe> desert = [];
    List<Recipe> choose = [];
    List<Recipe> childern = [];
    for (int i = 0; i < recipeList.length; i++) {
      if (recipeList[i].myTag.length == 0) {
        other.add(recipeList[i]);
      }
      for (int j = 0; j < recipeList[i].myTag.length; j++) {
        switch (recipeList[i].myTag[j]) {
          case "fish":
            fish.add(recipeList[i]);
            break;
          case "meat":
            meet.add(recipeList[i]);
            break;
          case "dairy":
            dairy.add(recipeList[i]);
            break;
          case "desert":
            desert.add(recipeList[i]);
            break;
          case "for children":
            childern.add(recipeList[i]);
            break;
          case "other":
            other.add(recipeList[i]);
            break;
          case "choose recipe tag":
            other.add(recipeList[i]);
            break;
        }
      }
    }
    print(fish);
    print(meet);
    print(desert);
    return Column(children: <Widget>[
      Text('data'),
      //fish
      if (!fish.isEmpty)
        IconButton(
            icon: Icon(Icons.set_meal),
            iconSize: 50,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeList(fish, "fish")));
            }),
      //meat
      if (!meet.isEmpty)
        IconButton(
            icon: Icon(Icons.local_dining),
            iconSize: 50,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeList(meet, "meat")));
            }),
      //dairy
      if (!dairy.isEmpty)
        IconButton(
            icon: Icon(Icons.local_pizza),
            iconSize: 50,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeList(dairy, "dairy")));
            }),
      //desert
      if (!desert.isEmpty)
        IconButton(
            icon: Icon(Icons.cake),
            iconSize: 50,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeList(desert, "desert")));
            }),
      //for childern
      if (!childern.isEmpty)
        IconButton(
            icon: Icon(Icons.child_friendly_outlined),
            iconSize: 50,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeList(childern, "childeren")));
            }),
      //other
      if (!other.isEmpty)
        IconButton(
            icon: Icon(Icons.sentiment_neutral),
            iconSize: 50,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeList(other, "other")));
            }),
    ]);

    return Container();
  }
}
