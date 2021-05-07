import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import '../../../config.dart';

// ignore: must_be_immutable
class FinishCreateRecipe extends StatefulWidget {
  String username;
  String uid;
  String name;
  String description;
  String imagePath;
  List<IngredientsModel> ingredients;
  List<Stages> stages;
  List<String> tags;
  int level;
  int time;
  List<String> notes;
  Recipe recipe;
  FinishCreateRecipe(
      String _username,
      String _uid,
      String _name,
      String _description,
      String _imagePath,
      List<IngredientsModel> _ingredients,
      List<Stages> _stages,
      List<String> _tags,
      int _level,
      int _time,
      List<String> _notes) {
    username = _username;
    uid = _uid;
    name = _name;
    description = _description;
    imagePath = _imagePath;
    ingredients = _ingredients;
    stages = _stages;
    tags = _tags;
    level = _level;
    time = _time;
    notes = _notes;
  }
  @override
  _FinishCreateRecipeState createState() => _FinishCreateRecipeState();
}

class _FinishCreateRecipeState extends State<FinishCreateRecipe> {
  bool cancel = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        box,
        box,
        title(),
        box,
        Row(children: [
          SizedBox(
            width: 100,
          ),
          noButton(),
          SizedBox(
            width: 20,
          ),
          yesButton(),
        ]),
        heightBox(350),
        previousLevelButton()
      ]),
    );
  }

  Widget title() {
    return Text(
      "Are you sure you want to save this recipe?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 25, fontFamily: 'Raleway'),
    );
  }

  Widget yesButton() {
    // ignore: deprecated_member_use
    return RaisedButton(
        child: Text(
          'Yes',
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {
          saveThisRecipe();
          int count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 9;
          });
        });
  }

  Widget noButton() {
    // ignore: deprecated_member_use
    return RaisedButton(
        child: Text(
          'No',
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () async {
          await _showAlertDialog(
              "If you exit now, all the recipe you created will be deleted");
          if (cancel) {
            int count = 0;
            Navigator.popUntil(context, (route) {
              return count++ == 9;
            });
          }
        });
  }

  Widget previousLevelButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
      tooltip: 'previous',
      child: Icon(Icons.navigate_before),
    );
  }

  void saveThisRecipe() async {
    Recipe recipe = Recipe(
        widget.name,
        widget.description,
        widget.tags,
        widget.level,
        widget.notes,
        widget.username,
        widget.uid,
        widget.time,
        true,
        '',
        '',
        widget.imagePath);
    recipe.ingredients = widget.ingredients;
    recipe.stages = widget.stages;
    RecipeFromDB.insertNewRecipe(recipe);
  }

  Future<void> _showAlertDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Back'),
              onPressed: () {
                cancel = false;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                cancel = true;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
