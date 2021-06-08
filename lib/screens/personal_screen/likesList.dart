// list of the users who liked the recipe ///

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/services/userFromDB.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import '../../shared_screen/config.dart';

// ignore: must_be_immutable
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
  void initState() {
    super.initState();
    getLikesList();
  }

  @override
  Widget build(BuildContext context) {
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

  Future<void> getLikesList() async {
    List likes;
    final db = Firestore.instance;
    var publishRecipe = await db
        .collection(publishCollectionName)
        .document(widget.currentRecipe.publish)
        .get();
    // take likes
    likes = publishRecipe.data['likes'] ?? [];
    // take all usernames
    for (String userId in likes) {
      String email = await UserFromDB.getUserEmail(userId);
      widget.usersLikes[email] = userId;
    }
    setState(() {
      widget.doneLoadLikeList = true;
    });
  }
}
