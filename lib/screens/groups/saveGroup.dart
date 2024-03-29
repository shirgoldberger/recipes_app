import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/services/groupFromDB.dart';
import 'package:recipes_app/shared_screen/config.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/book_screen/saveInDirectory.dart';
import 'package:recipes_app/shared_screen/loading.dart';

// ignore: must_be_immutable
class SaveGroup extends StatefulWidget {
  String uid;
  String recipeId;
  List<bool> isCheck = [];
  List<String> publish = [];
  bool doneLoad = false;
  bool check = false;
  List<Color> colors = [];
  Map<Pair, bool> map = {};
  Recipe recipe;
  IconData iconSave = Icons.favorite_border;
  String saveString = "";
  bool isMyRecipe;
  SaveGroup(String _uid, String _recipeId, Recipe _recipe, bool _isMyRecipe) {
    this.uid = _uid;
    this.recipeId = _recipeId;
    this.recipe = _recipe;
    this.isMyRecipe = _isMyRecipe;
  }

  @override
  _SaveGroupState createState() => _SaveGroupState();
}

class Pair<T1, T2> {
  final String groupId;
  final String groupName;

  Pair(this.groupId, this.groupName);
}

class _SaveGroupState extends State<SaveGroup> {
  @override
  Widget build(BuildContext context) {
    if (!widget.doneLoad) {
      getGroups();
      return Loading();
    } else {
      return Column(children: <Widget>[
        new Padding(padding: EdgeInsets.only(top: 20.0)),
        saveToYourself(),
        heightBox(20),
        title(),
        heightBox(20),
        groupsList()
      ]);
    }
  }

  Widget title() {
    return Text(
      'Choose group to save this recipe:',
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
              return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  // ignore: deprecated_member_use
                  child: FlatButton.icon(
                    color: widget.map.values.elementAt(index)
                        ? Colors.grey[300]
                        : Colors.blueGrey[600],
                    icon: Icon(
                        widget.map.values.elementAt(index)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white),
                    label: saveOrUnsave(index),
                    onPressed: () => pressedOnGroup(index),
                  ));
            }));
  }

  Widget saveOrUnsave(int index) {
    return Text(
        widget.map.values.elementAt(index)
            ? "Un save in " + widget.map.keys.elementAt(index).groupName
            : "Save in " + widget.map.keys.elementAt(index).groupName,
        style: TextStyle(color: Colors.white, fontFamily: 'DescriptionFont'));
  }

  Widget saveToYourself() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        // ignore: deprecated_member_use
        child: FlatButton.icon(
            color: mainButtonColor,
            icon: Icon(widget.iconSave, color: Colors.white),
            label: Text('Save to yourself & Choose directory',
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              saveRecipe();
            }));
  }

  void pressedOnGroup(int index) {
    if (widget.map.values.elementAt(index)) {
      setState(() {
        widget.isCheck[index] = false;
        widget.colors[index] = Colors.blueGrey[400];
        widget.map.update(widget.map.keys.elementAt(index), (value) => false);
      });
      unPublishGroup(index);
    } else {
      publishInGroup(index);
      setState(() {
        widget.isCheck[index] = true;
        widget.colors[index] = Colors.grey;
        widget.map.update(widget.map.keys.elementAt(index), (value) => true);
      });
    }
  }

  void publishInGroup(int index) async {
    final db = Firestore.instance;
    QuerySnapshot recipes = await db
        .collection('Group')
        .document(widget.map.keys.elementAt(index).groupId)
        .collection('recipes')
        .getDocuments();
    for (int i = 0; i < recipes.documents.length; i++) {
      String id = recipes.documents[i].data['recipeId'];
      if (id == widget.recipeId) {
        return;
      }
    }
    await db
        .collection('Group')
        .document(widget.map.keys.elementAt(index).groupId)
        .collection('recipes')
        .add({'userId': widget.recipe.writerUid, 'recipeId': widget.recipeId});
    String id;
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) async {
      if (element.data['recipeId'] == widget.recipe.id) {
        id = element.documentID;
        var currentRecipe2 =
            await db.collection('publish recipe').document(id).get();
        List publishGroup = [];
        List loadList = currentRecipe2.data['saveInGroup'] ?? [];
        publishGroup.addAll(loadList);
        publishGroup.add(widget.map.keys.elementAt(index).groupId);
        db
            .collection('publish recipe')
            .document(id)
            .updateData({'saveInGroup': publishGroup});
      }
    });
  }

  Future<void> unPublishGroup(int index) async {
    final db = Firestore.instance;

    QuerySnapshot snap = await Firestore.instance
        .collection('Group')
        .document(widget.map.keys.elementAt(index).groupId)
        .collection('recipes')
        .getDocuments();
    snap.documents.forEach((element) async {
      if (element.data['recipeId'] == widget.recipeId) {
        db
            .collection('Group')
            .document(widget.map.keys.elementAt(index).groupId)
            .collection('recipes')
            .document(element.documentID)
            .delete();
      }
    });
    String id;
    QuerySnapshot snap2 =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap2.documents.forEach((element) async {
      if (element.data['recipeId'] == widget.recipe.id) {
        id = element.documentID;
        var currentRecipe2 =
            await db.collection('publish recipe').document(id).get();
        List publishGroup = [];
        List loadList = currentRecipe2.data['saveInGroup'] ?? [];
        publishGroup.addAll(loadList);
        publishGroup.remove(widget.map.keys.elementAt(index).groupId);
        db
            .collection('publish recipe')
            .document(id)
            .updateData({'saveInGroup': publishGroup});
      }
    });
  }

  Future<void> _showSavedGroup() async {
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
            child: SaveInDirectory(
                widget.uid, widget.recipe, widget.isMyRecipe, true)));
  }

  void saveRecipe() async {
    _showSavedGroup();
  }

  Future<void> getGroups() async {
    QuerySnapshot snap = await GroupFromDB.getUserGroups(widget.uid);
    for (int i = 0; i < snap.documents.length; i++) {
      Pair p = Pair(snap.documents[i].data['groupId'],
          snap.documents[i].data['groupName']);
      widget.map.addAll({p: false});
      widget.isCheck.add(false);
      widget.colors.add(Colors.blueGrey[400]);
      String id = snap.documents[i].data['groupId'] ?? "";
      QuerySnapshot snap2 = await Firestore.instance
          .collection('Group')
          .document(id)
          .collection('recipes')
          .getDocuments();
      if (snap2.documents.length != 0) {
        snap2.documents.forEach((element2) async {
          if (element2.data['recipeId'] == widget.recipeId) {
            widget.map.update(p, (value) => true);
            widget.publish.add(snap.documents[i].data['groupName']);
          }
        });
      }
    }
    setState(() {
      widget.doneLoad = true;
    });
  }
}
