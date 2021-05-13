import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/shared_screen/loading.dart';

import '../../config.dart';

// ignore: must_be_immutable
class PublishGroup2 extends StatefulWidget {
  String uid;
  String recipeId;
  List<String> groupName = [];
  // List<String> groupName2 = [];
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
  bool donePublish = true;

  PublishGroup2(String _uid, String _recipeId, Recipe _recipe) {
    this.uid = _uid;
    this.recipeId = _recipeId;
    this.recipe = _recipe;
  }

  @override
  _PublishGroup2State createState() => _PublishGroup2State();
}

class _PublishGroup2State extends State<PublishGroup2> {
  Future<void> getGroups() async {
    if (widget.recipe.publish == '') {
      widget.iconPublish = Icons.public;
      widget.stringPublish = "Publish the recipe to everyone";

      widget.colorPublish = Colors.blueGrey[600];
    } else {
      widget.iconPublish = Icons.public_off;
      widget.stringPublish = "Un publish the recipe to everyone";
      widget.colorPublish = Colors.grey[300];
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
        widget.colors.add(Colors.blueGrey[400]);
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

  @override
  Widget build(BuildContext context) {
    if (!widget.doneLoad) {
      getGroups();

      return Loading();
    } else {
      if (!widget.donePublish) {
        return Loading();
      } else {
        return Column(children: <Widget>[
          new Padding(padding: EdgeInsets.only(top: 20.0)),
          new Text(
            'choose where to publish yuor recipe:',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Raleway',
                fontSize: 35),
          ),
          box,
          publishEveyoume(),
          Expanded(
              child: ListView.builder(
                  itemCount: widget.map.length,
                  itemBuilder: (context, index) {
                    return publishInGroupWidget(index);
                  }))
        ]);
      }
    }
  }

  Widget publishInGroupWidget(int index) {
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0)),
        // ignore: deprecated_member_use
        child: FlatButton.icon(
          color: widget.map.values.elementAt(index)
              ? Colors.grey[300]
              : Colors.blueGrey[600],
          icon: Icon(
              widget.map.values.elementAt(index)
                  ? Icons.public_off
                  : Icons.public,
              color: Colors.white),
          label: Text(
            widget.map.values.elementAt(index)
                ? "unpublish in " + widget.map.keys.elementAt(index)
                : "publish in " + widget.map.keys.elementAt(index),
            style: TextStyle(
                color: Colors.white,
                //fontWeight: FontWeight.w900,
                // fontStyle: FontStyle.italic,
                fontFamily: 'Raleway',
                fontSize: 20),
          ),
          onPressed: () {
            if (widget.map.values.elementAt(index)) {
              setState(() {
                widget.donePublish = false;
                widget.isCheck[index] = false;
                widget.colors[index] = Colors.blueGrey[400];
                widget.map
                    .update(widget.map.keys.elementAt(index), (value) => false);
              });
              unPublishGroup(index);
            } else {
              setState(() {
                widget.donePublish = false;
              });
              publishInGroup(index);
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

  Widget publishEveyoume() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0)),
      // ignore: deprecated_member_use

      child: SizedBox(
        width: double.infinity,
        child: RaisedButton.icon(
            color: widget.colorPublish,
            icon: Icon(widget.iconPublish, color: Colors.white),
            label: Text(
              widget.stringPublish,
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Raleway', fontSize: 20),
            ),
            onPressed: () {
              if (widget.recipe.publish == '') {
                setState(() {
                  widget.iconPublish = Icons.public_off;
                  widget.stringPublish = " Un publish the recipe to everyone";
                  widget.colorPublish = Colors.grey[300];
                  widget.donePublish = false;
                  publishRecipe();
                });
              } else {
                setState(() {
                  widget.donePublish = false;
                  unPublishRecipe();
                  widget.iconPublish = Icons.public;
                  widget.stringPublish = "Publish the recipe to everyone";
                  widget.colorPublish = Colors.blueGrey[600];
                });
              }
            }),
      ),
    );
  }

  void publishInGroup(int index) async {
    final db = Firestore.instance;
    await db
        .collection('Group')
        .document(widget.groupId[index])
        .collection('recipes')
        .add({'userId': widget.uid, 'recipeId': widget.recipeId, 'likes': []});
    setState(() {
      widget.donePublish = true;
    });
  }

  Future<void> unPublishGroup(int index) async {
    setState(() {
      widget.isCheck[index] = false;
      widget.colors[index] = Colors.blueGrey[400];
    });

    final db = Firestore.instance;

    QuerySnapshot snap = await Firestore.instance
        .collection('Group')
        .document(widget.groupId[index])
        .collection('recipes')
        .getDocuments();
    snap.documents.forEach((element) async {
      if (element.data['recipeId'] == widget.recipeId) {
        db
            .collection('Group')
            .document(widget.groupId[index])
            .collection('recipes')
            .document(element.documentID)
            .delete();
      }
    });
    setState(() {
      widget.donePublish = true;
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
    setState(() {
      widget.donePublish = true;
    });
  }

  void unPublishRecipe() {
    final db = Firestore.instance;
    db.collection('publish recipe').document(widget.recipe.publish).delete();
    widget.recipe.publishThisRecipe('');

    db
        .collection('users')
        .document(widget.uid)
        .collection('recipes')
        .document(widget.recipeId)
        .updateData(widget.recipe.toJson());
    setState(() {
      widget.donePublish = true;
    });
  }
}
