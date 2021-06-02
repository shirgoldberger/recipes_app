import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/services/groupFromDB.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import '../../shared_screen/config.dart';

// ignore: must_be_immutable
class PublishGroup extends StatefulWidget {
  String uid;
  String recipeId;
  List<String> groupName = [];
  List<String> groupId = [];
  List<bool> isCheck = [];
  List<String> publish = [];
  bool doneLoad = false;
  bool check = false;
  List<Color> colors = [];
  Map<String, bool> map = {};
  Recipe recipe;
  IconData iconPublish = Icons.public;
  String stringPublish;
  Color colorPublish;

  PublishGroup(String _uid, String _recipeId, Recipe _recipe) {
    this.uid = _uid;
    this.recipeId = _recipeId;
    this.recipe = _recipe;
  }

  @override
  _PublishGroupState createState() => _PublishGroupState();
}

class _PublishGroupState extends State<PublishGroup> {
  @override
  Widget build(BuildContext context) {
    if (!widget.doneLoad) {
      getGroups();
      return Loading();
    } else {
      return Column(children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 20.0)),
        title(),
        box,
        publishEveryone(),
        groupsList()
      ]);
    }
  }

  Widget title() {
    return Text(
      'Choose where to publish your recipe:',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontFamily: 'Raleway',
          fontSize: 18),
    );
  }

  Widget groupsList() {
    return Expanded(
        child: ListView.builder(
            padding: EdgeInsets.only(left: 5, right: 5),
            itemCount: widget.map.length,
            itemBuilder: (context, index) {
              return publishInGroupWidget(index);
            }));
  }

  Widget publishInGroupWidget(int index) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        // ignore: deprecated_member_use
        child: FlatButton.icon(
          color: widget.map.values.elementAt(index)
              ? Colors.grey[350]
              : Colors.blueGrey,
          icon: Icon(
              widget.map.values.elementAt(index)
                  ? Icons.public_off
                  : Icons.public,
              color: Colors.white),
          label: Text(
            widget.map.values.elementAt(index)
                ? "Un publish in " + widget.map.keys.elementAt(index)
                : "Publish in " + widget.map.keys.elementAt(index),
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'DescriptionFont',
                fontSize: 15,
                fontWeight: FontWeight.w300),
          ),
          onPressed: () async {
            BuildContext dialogContext;
            if (widget.map.values.elementAt(index)) {
              setState(() {
                widget.isCheck[index] = false;
                widget.colors[index] = Colors.blueGrey;
                widget.map
                    .update(widget.map.keys.elementAt(index), (value) => false);
              });
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  dialogContext = context;
                  return WillPopScope(
                      onWillPop: () async => false,
                      child: AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          backgroundColor: Colors.black87,
                          content: loadingIndicator()));
                },
              );
              await unPublishGroup(index);
              Navigator.pop(dialogContext);
            } else {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  dialogContext = context;
                  return WillPopScope(
                      onWillPop: () async => false,
                      child: AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          backgroundColor: Colors.black87,
                          content: loadingIndicator()));
                },
              );
              await publishInGroup(index);
              Navigator.pop(dialogContext);
              setState(() {
                widget.isCheck[index] = true;
                widget.colors[index] = Colors.grey;
                widget.map
                    .update(widget.map.keys.elementAt(index), (value) => true);
              });
            }
          },
        ));
  }

  Widget publishEveryone() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // ignore: deprecated_member_use

      child: SizedBox(
        width: 400,
        // ignore: deprecated_member_use
        child: RaisedButton.icon(
            color: widget.colorPublish,
            icon: Icon(widget.iconPublish, color: Colors.white),
            label: Text(
              widget.stringPublish,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'DescriptionFont',
                  fontSize: 15),
            ),
            onPressed: () async {
              if (widget.recipe.publish == '') {
                BuildContext dialogContext;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    dialogContext = context;
                    return WillPopScope(
                        onWillPop: () async => false,
                        child: AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            backgroundColor: Colors.black87,
                            content: loadingIndicator()));
                  },
                );
                await publishRecipe();
                if (dialogContext != null) {
                  Navigator.pop(dialogContext);
                }
                setState(() {
                  widget.iconPublish = Icons.public_off;
                  widget.stringPublish = "Un publish the recipe to everyone";
                  widget.colorPublish = Colors.grey[350];
                });
              } else {
                BuildContext dialogContext;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    dialogContext = context;
                    return WillPopScope(
                        onWillPop: () async => false,
                        child: AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            backgroundColor: Colors.black87,
                            content: loadingIndicator()));
                  },
                );
                await unPublishRecipe();
                if (dialogContext != null) {
                  Navigator.pop(dialogContext);
                }
                setState(() {
                  widget.iconPublish = Icons.public;
                  widget.stringPublish = "Publish the recipe to everyone";
                  widget.colorPublish = Colors.blueGrey;
                });
              }
            }),
      ),
    );
  }

  Future<void> publishInGroup(int index) async {
    final db = Firestore.instance;
    await db
        .collection('Group')
        .document(widget.groupId[index])
        .collection('recipes')
        .add({'userId': widget.uid, 'recipeId': widget.recipeId, 'likes': []});
  }

  Future<void> unPublishGroup(int index) async {
    await GroupFromDB.unPublishInGroup(widget.groupId[index], widget.recipeId);
    setState(() {
      widget.isCheck[index] = false;
      widget.colors[index] = Colors.blueGrey;
    });
  }

  Future<void> publishRecipe() async {
    final db = Firestore.instance;
    Map<String, dynamic> publishRecipe = {
      'recipeId': widget.recipeId,
      'userID': widget.uid,
      'likes': []
    };
    //save this recipe in the publish folder
    var currentRecipe =
        await db.collection('publish recipe').add(publishRecipe);
    String idPublish = currentRecipe.documentID;
    //save where he is publish
    widget.recipe.publishThisRecipe(idPublish);
    //update in the database
    db
        .collection('users')
        .document(widget.uid)
        .collection('recipes')
        .document(widget.recipeId)
        .updateData(widget.recipe.toJson());
    var tags =
        await db.collection('tags').document('xt0XXXOLgprfkO3QiANs').get();

    for (int i = 0; i < widget.recipe.tags.length; i++) {
      List tag = tags.data[widget.recipe.tags[i]];
      List copyTag = [];
      copyTag.addAll(tag);
      copyTag.add(idPublish);
      db
          .collection('tags')
          .document('xt0XXXOLgprfkO3QiANs')
          .updateData({widget.recipe.tags[i]: copyTag});
    }
  }

  Future<void> unPublishRecipe() async {
    final db = Firestore.instance;
    var tags =
        await db.collection('tags').document('xt0XXXOLgprfkO3QiANs').get();
    for (int i = 0; i < widget.recipe.tags.length; i++) {
      List tag = tags.data[widget.recipe.tags[i]];
      List copyTag = [];
      copyTag.addAll(tag);
      copyTag.remove(widget.recipe.publish);
      db
          .collection('tags')
          .document('xt0XXXOLgprfkO3QiANs')
          .updateData({widget.recipe.tags[i]: copyTag});
    }

    QuerySnapshot users =
        await Firestore.instance.collection('users').getDocuments();
    for (int i = 0; i < users.documents.length; i++) {
      List likes = users.documents[i].data['likes'] ?? [];
      List copy = [];
      copy.addAll(likes);
      if (copy.contains(widget.recipe.publish)) {
        copy.remove(widget.recipe.publish);
      }
      db
          .collection('users')
          .document(users.documents[i].documentID)
          .updateData({'likes': copy});
    }
    DocumentSnapshot publishRecipe = await db
        .collection('publish recipe')
        .document(widget.recipe.publish)
        .get();
    List userSave = publishRecipe.data['saveUser'] ?? [];
    RecipeFromDB.deleteRecipeFromAllUsers(
        userSave, widget.recipe.id, widget.recipe.writerUid);

    await db
        .collection('publish recipe')
        .document(widget.recipe.publish)
        .delete();
    widget.recipe.publishThisRecipe('');

    await db
        .collection('users')
        .document(widget.uid)
        .collection('recipes')
        .document(widget.recipeId)
        .updateData(widget.recipe.toJson());
  }

  Future<void> getGroups() async {
    if (widget.recipe.publish == '') {
      widget.iconPublish = Icons.public;
      widget.stringPublish = "Publish the recipe to everyone";

      widget.colorPublish = Colors.blueGrey;
    } else {
      widget.iconPublish = Icons.public_off;
      widget.stringPublish = "Un publish the recipe to everyone";
      widget.colorPublish = Colors.grey[350];
    }

    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('groups')
        .getDocuments();
    snap.documents.forEach((element) async {
      setState(() {
        widget.groupId.add(element.data['groupId']);
        widget.groupName.add(element.data['groupName']);
        widget.map.addAll({element.data['groupName']: false});
        widget.isCheck.add(false);
        widget.colors.add(Colors.blueGrey);
      });

      QuerySnapshot snap2 = await Firestore.instance
          .collection('Group')
          .document(element.data['groupId'])
          .collection('recipes')
          .getDocuments();

      if (snap2.documents.length != 0) {
        snap2.documents.forEach((element2) async {
          if (element2.data['recipeId'] == widget.recipeId) {
            setState(() {
              widget.map.update(element.data['groupName'], (value) => true);
              widget.publish.add(element.data['groupName']);
            });
          }
        });
      }
    });

    setState(() {
      widget.doneLoad = true;
    });
  }
}
