import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipes/recipeHeadLine.dart';
import 'package:recipes_app/shared_screen/loading.dart';

import '../config.dart';

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
                  // print('recipeList');
                  // print(widget.list[index]);
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
                                  widget.recipeList[index], true))));
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

    // print("check");
    // print(snap.documents.length);
    if (snap.documents.length == 0) {
      setState(() {
        widget.doneLoad = true;
      });
    }
    int i = 0;
    snap.documents.forEach((doc) async {
      String n = doc.data['name'] ?? '';
      String de = doc.data['description'] ?? '';
      String level = doc.data['level'] ?? 0;
      String time = doc.data['time'] ?? '0';
      int timeI = int.parse(time);
      String writer = doc.data['writer'] ?? '';
      String writerUid = doc.data['writerUid'] ?? '';
      String id = doc.data['recipeID'] ?? '';
      //
      String publish = doc.data['publishID'] ?? '';
      String path = doc.data['imagePath'] ?? '';
      int levlelInt = int.parse(level);
      //tags
      var tags = doc.data['tags'];
      String tagString = tags.toString();
      List<String> l = [];
      if (tagString != "[]") {
        String tag = tagString.substring(1, tagString.length - 1);
        l = tag.split(',');
        for (int i = 0; i < l.length; i++) {
          if (l[i][0] == ' ') {
            l[i] = l[i].substring(1, l[i].length);
          }
        }
      }
      //notes
      var note = doc.data['tags'];
      String noteString = note.toString();
      List<String> nList = [];
      if (noteString != "[]") {
        String tag = noteString.substring(1, noteString.length - 1);
        nList = tag.split(',');
        for (int i = 0; i < nList.length; i++) {
          if (nList[i][0] == ' ') {
            nList[i] = nList[i].substring(1, nList[i].length);
          }
        }
      }
      Recipe r = Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI,
          true, id, publish, path);
      // r.setId(id);
      // print(publish + "publish");
      //r.publishThisRecipe(publish);
      bool check = false;
      for (int i = 0; i < widget.recipeList.length; i++) {
        if (widget.recipeList[i].id == r.id) {
          check = true;
        }
      }
      if (!check) {
        widget.recipeList.add(r);
      }
      //wi

      // print(r.publish);
      i++;
      // print("i -     " + i.toString());
      //  print(snap.documents.length);
      // print(snap.documents.length);
      if ((i) == snap.documents.length) {
        setState(() {
          widget.doneLoad = true;
        });
      }
    });
  }
}
