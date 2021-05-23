import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:recipes_app/screens/groups/publishGroup2.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import 'watchRecipeBody.dart';
import '../edit_recipe/editRecipe.dart';

import '../../../services/recipeFromDB.dart';

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
  bool done = false;
  String levelString;
  // username and id that like current recipe
  Map<String, String> usersLikes;

  // constructor
  WatchMyRecipe(String _uid, Recipe _currentRecipe, Color _levelColor,
      String _levelString, List<IngredientsModel> _ing, List<Stages> _stages) {
    this.uid = _uid;
    this.currentRecipe = _currentRecipe;
    this.levelColor = _levelColor;
    this.levelString = _levelString;
    this.ingredients = _ing;
    this.stages = _stages;
  }

  @override
  _WatchMyRecipeState createState() => _WatchMyRecipeState();
}

class _WatchMyRecipeState extends State<WatchMyRecipe> {
  @override
  void initState() {
    super.initState();
    print("watch my recipe");
    // makeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: appBarBackgroundColor,
          elevation: 0.0,
          title: Text(
            'Watch Recipe',
            style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
          ),
        ),
        endDrawer: leftMenu(),
        body: WatchRecipeBody(widget.currentRecipe, widget.ingredients,
            widget.stages, widget.levelColor, widget.levelString, widget.uid));
  }

  Widget leftMenu() {
    return Container(
      color: backgroundColor,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ListView(
        children: <Widget>[
          drawerTitle(),
          Column(children: [
            publishIcon(),
            // edit icon
            editIcon(),
            // delete icon
            deleteIcon()
          ]),
        ],
      ),
    );
  }

  Widget drawerTitle() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: appBarBackgroundColor,
      ),
      arrowColor: appBarBackgroundColor,
      accountName: Text('Options:'),
    );
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
    await RecipeFromDB.deleteRecipe(
        widget.currentRecipe.publish, widget.currentRecipe.id, widget.uid);
    // final db = Firestore.instance;
    // if (widget.currentRecipe.publish != '') {
    //   DocumentSnapshot snap = await Firestore.instance
    //       .collection('publish recipe')
    //       .document(widget.currentRecipe.publish)
    //       .get();
    //   List group = snap.data['saveInGroup'] ?? [];
    //   List users = snap.data['saveUser'] ?? [];
    //   for (int i = 0; i < group.length; i++) {
    //     QuerySnapshot snap2 = await Firestore.instance
    //         .collection('Group')
    //         .document(group[i])
    //         .collection('recipes')
    //         .getDocuments();
    //     snap2.documents.forEach((element) async {
    //       if (element.data['recipeId'] == widget.currentRecipe.id) {
    //         db
    //             .collection('Group')
    //             .document(group[i])
    //             .collection('recipes')
    //             .document(element.documentID)
    //             .delete();
    //       }
    //     });
    //   }
    //   for (int i = 0; i < users.length; i++) {
    //     QuerySnapshot snap2 = await Firestore.instance
    //         .collection('users')
    //         .document(users[i])
    //         .collection('saved recipe')
    //         .getDocuments();
    //     snap2.documents.forEach((element) async {
    //       if (element.data['recipeId'] == widget.currentRecipe.id) {
    //         db
    //             .collection('users')
    //             .document(users[i])
    //             .collection('saved recipe')
    //             .document(element.documentID)
    //             .delete();
    //       }
    //     });
    //   }
    // }
    // QuerySnapshot snap2 =
    //     await Firestore.instance.collection('Group').getDocuments();
    // snap2.documents.forEach((element) async {
    //   QuerySnapshot snap3 = await Firestore.instance
    //       .collection('Group')
    //       .document(element.documentID)
    //       .collection('recipes')
    //       .getDocuments();
    //   snap3.documents.forEach((element2) {
    //     if (element2.data['recipeId'] == widget.currentRecipe.id) {
    //       db
    //           .collection('Group')
    //           .document(element.documentID)
    //           .collection('recipes')
    //           .document(element2.documentID)
    //           .delete();
    //     }
    //   });
    // });
    // if (widget.currentRecipe.publish != '') {
    //   db
    //       .collection('publish recipe')
    //       .document(widget.currentRecipe.publish)
    //       .delete();
    // }
    // db
    //     .collection('users')
    //     .document(widget.uid)
    //     .collection('recipes')
    //     .document(widget.currentRecipe.id)
    //     .delete();
  }

  Widget publishIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.share,
          color: Colors.black,
        ),
        label: Text(
          'Publish',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
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
          color: Colors.black,
        ),
        label: Text(
          'Edit',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditRecipe(
                      widget.uid,
                      widget.currentRecipe,
                      widget.stages,
                      widget.ingredients,
                      widget.levelString,
                      widget.levelColor))).then((value) => updateRecipe(value));
        });
  }

  void updateRecipe(var r) {
    if (r != null) {
      setState(() {
        widget.currentRecipe = r;
        widget.ingredients = r.ingredients;
        widget.stages = r.stages;
      });
    }
  }

  Widget deleteIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.delete,
          color: Colors.black,
        ),
        label: Text('Delete',
            style: TextStyle(fontFamily: 'Raleway', color: Colors.black)),
        onPressed: () {
          delete();
          int count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 3;
          });
        });
  }
}
