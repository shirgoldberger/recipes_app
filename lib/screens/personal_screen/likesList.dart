import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/shared_screen/loading.dart';

class LikesList extends StatefulWidget {
  Map<String, String> usersLikes = {};
  bool doneLoadLikeList = false;
  Recipe currentRecipe;
  LikesList(Recipe _currentRecipe) {
    currentRecipe = _currentRecipe;
  }
  @override
  _LikesListState createState() => _LikesListState();
}

class _LikesListState extends State<LikesList> {
  @override
  Widget build(BuildContext context) {
    _getLikesList();
    if (!widget.doneLoadLikeList) {
      return Loading();
    } else {
      return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: widget.usersLikes.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            child: Center(child: Text(widget.usersLikes.keys.elementAt(index))),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    }
  }

  Future<void> _getLikesList() async {
    List likes;
    final db = Firestore.instance;
    var publishRecipes = await db.collection('publish recipe').getDocuments();
    publishRecipes.documents.forEach((element) async {
      // the current recipe
      if (element.data['recipeId'] == widget.currentRecipe.id) {
        var recipe = await db
            .collection('publish recipe')
            .document(element.documentID.toString())
            .get();
        // take likes
        likes = recipe.data['likes'] ?? [];
        // take all usernames
        for (String userId in likes) {
          DocumentSnapshot currentUser = await Firestore.instance
              .collection("users")
              .document(userId)
              .get();
          setState(() {
            widget.usersLikes[currentUser.data['Email']] = userId;
            widget.doneLoadLikeList = true;
          });
        }
      }
    });
    setState(() {
      widget.doneLoadLikeList = true;
    });
  }
}
