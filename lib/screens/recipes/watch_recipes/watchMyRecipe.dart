import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'watchRecipeBody.dart';
import '../edit_recipe/editRecipe.dart';
import '../../personal_screen/homeLogIn.dart';
import '../../groups/publishGroup2.dart';

// ignore: must_be_immutable
class WatchMyRecipe extends StatefulWidget {
  // true if the user like this recipe
  bool isLikeRecipe = false;
  // true if the user save this recipe
  bool isSaveRecipe = false;
  // user id (null if the user didn't login)
  String uid;
  // recipe parameters
  Recipe currentRecipe;
  List<IngredientsModel> ingredients = [];
  List<Stages> stages = [];
  Color levelColor;
  String levelString;
  // username and id that like current recipe
  Map<String, String> usersLikes;

  // constructor
  WatchMyRecipe(String _uid, Recipe _currentRecipe, Color _levelColor,
      String _levelString) {
    this.uid = _uid;
    this.currentRecipe = _currentRecipe;
    this.levelColor = _levelColor;
    this.levelString = _levelString;
  }

  @override
  _WatchMyRecipeState createState() => _WatchMyRecipeState();
}

class _WatchMyRecipeState extends State<WatchMyRecipe> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
            backgroundColor: appBarBackgroundColor,
            elevation: 0.0,
            title: Text(
              'Watch Recipe',
              style: TextStyle(fontFamily: 'Raleway'),
            ),
            actions: <Widget>[
              // publish icon
              publishIcon(),
              // edit icon
              editIcon(),
              // delete icon
              deleteIcon()
            ]),
        body: WatchRecipeBody(widget.currentRecipe, widget.ingredients,
            widget.stages, widget.levelColor, widget.levelString, widget.uid));
  }

  Future<void> _showPublishPanel() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: new BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: PublishGroup2(
                widget.uid, widget.currentRecipe.id, widget.currentRecipe)));
  }

  Future<void> delete() async {
    final db = Firestore.instance;
    if (widget.currentRecipe.publish != '') {
      DocumentSnapshot snap = await Firestore.instance
          .collection('publish recipe')
          .document(widget.currentRecipe.publish)
          .get();
      List group = snap.data['saveInGroup'] ?? [];
      List users = snap.data['saveUser'] ?? [];
      for (int i = 0; i < group.length; i++) {
        print(group[i]);
        QuerySnapshot snap2 = await Firestore.instance
            .collection('Group')
            .document(group[i])
            .collection('recipes')
            .getDocuments();
        snap2.documents.forEach((element) async {
          if (element.data['recipeId'] == widget.currentRecipe.id) {
            print("find");
            db
                .collection('Group')
                .document(group[i])
                .collection('recipes')
                .document(element.documentID)
                .delete();
          }
        });
      }
      for (int i = 0; i < users.length; i++) {
        QuerySnapshot snap2 = await Firestore.instance
            .collection('users')
            .document(users[i])
            .collection('saved recipe')
            .getDocuments();
        snap2.documents.forEach((element) async {
          if (element.data['recipeId'] == widget.currentRecipe.id) {
            db
                .collection('users')
                .document(users[i])
                .collection('saved recipe')
                .document(element.documentID)
                .delete();
          }
        });
      }
    }
    QuerySnapshot snap2 =
        await Firestore.instance.collection('Group').getDocuments();
    snap2.documents.forEach((element) async {
      QuerySnapshot snap3 = await Firestore.instance
          .collection('Group')
          .document(element.documentID)
          .collection('recipes')
          .getDocuments();
      snap3.documents.forEach((element2) {
        if (element2.data['recipeId'] == widget.currentRecipe.id) {
          db
              .collection('Group')
              .document(element.documentID)
              .collection('recipes')
              .document(element2.documentID)
              .delete();
        }
      });
    });
    if (widget.currentRecipe.publish != '') {
      db
          .collection('publish recipe')
          .document(widget.currentRecipe.publish)
          .delete();
    }
    db
        .collection('users')
        .document(widget.uid)
        .collection('recipes')
        .document(widget.currentRecipe.id)
        .delete();
  }

  Widget publishIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.share,
          color: Colors.white,
        ),
        label: Text(
          'Publish',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
        ),
        onPressed: () {
          _showPublishPanel();
        });
  }

  Widget editIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        label: Text(
          'Edit',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditRecipe(widget.currentRecipe,
                      widget.ingredients, widget.stages)));
        });
  }

  Widget deleteIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        label: Text(
          'Delete',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
        ),
        onPressed: () {
          delete();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeLogIn(widget.uid)));
        });
  }
}
