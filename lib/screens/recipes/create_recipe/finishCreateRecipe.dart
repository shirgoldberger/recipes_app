import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:recipes_app/models/user.dart';
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
          yesButton(),
          SizedBox(
            width: 20,
          ),
          noButton()
        ])
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

  void saveThisRecipe() async {
    final db = Firestore.instance;
    final user = Provider.of<User>(context);

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
    var currentRecipe = await db
        .collection('users')
        .document(user.uid)
        .collection('recipes')
        .add(recipe.toJson());
    //set the new id to data base

    String id = currentRecipe.documentID.toString();
    recipe.setId(id);
    await db
        .collection('users')
        .document(user.uid)
        .collection('recipes')
        .document(id)
        .updateData({'recipeID': id});

    for (int i = 0; i < widget.ingredients.length; i++) {
      await db
          .collection('users')
          .document(user.uid)
          .collection('recipes')
          .document(id)
          .collection('ingredients')
          .add(widget.ingredients[i].toJson());
    }
    for (int i = 0; i < widget.stages.length; i++) {
      await db
          .collection('users')
          .document(user.uid)
          .collection('recipes')
          .document(id)
          .collection('stages')
          .add(widget.stages[i].toJson(i));
    }
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
              child: Text('Ok'),
              onPressed: () {
                cancel = true;
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Back'),
              onPressed: () {
                cancel = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
