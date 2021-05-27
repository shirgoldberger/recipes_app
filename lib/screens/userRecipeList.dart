import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipes/recipeHeadLine.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import 'package:recipes_app/shared_screen/loading.dart';

import '../shared_screen/config.dart';

class UserRecipeList extends StatefulWidget {
  UserRecipeList(String _uid) {
    this.uid = _uid;
  }
  String uid;
  List<Recipe> recipeList = [];
  bool doneLoad = false;
  @override
  _UserRecipeListState createState() => _UserRecipeListState();
}

class _UserRecipeListState extends State<UserRecipeList> {
  @override
  void initState() {
    // TODO: implement initState
    getRecipeList();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.doneLoad) {
      return Loading();
    } else {
      return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              " recipes:",
              style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
            ),
            backgroundColor: appBarBackgroundColor,
            elevation: 0.0,
            actions: <Widget>[],
          ),
          body: Column(children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 15.0)),
            Text(
              "num of results: " + widget.recipeList.length.toString(),
              style: TextStyle(
                  fontFamily: 'Raleway', color: Colors.black, fontSize: 15),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
                itemCount: widget.recipeList.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.all(8),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0)),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0)),
                              child: RecipeHeadLine(
                                  widget.recipeList[index], true, ""))));
                },
              ),
            )
          ]));
    }
  }

  Future<void> getRecipeList() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();

    String uid;
    String recipeId;
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('recipes')
        .getDocuments();

    if (snap.documents.length == 0) {
      setState(() {
        widget.doneLoad = true;
      });
    }
    for (int i = 0; i < snap.documents.length; i++) {
      String publishId = snap.documents[i].data['publishID'] ?? "";
      if (publishId == "") {
        continue;
      }
      Recipe r = RecipeFromDB.convertSnapshotToRecipe(snap.documents[i]);

      bool check = false;
      for (int j = 0; j < widget.recipeList.length; j++) {
        if (widget.recipeList[j].id == r.id) {
          check = true;
        }
      }
      if (!check) {
        widget.recipeList.add(r);
      }
    }
    setState(() {
      widget.doneLoad = true;
    });
  }
}
