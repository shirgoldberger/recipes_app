import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/shared_screen/loading.dart';

// ignore: must_be_immutable
class SaveGroup extends StatefulWidget {
  String uid;
  String recipeId;
  List<String> groupName = [];
  List<String> groupName2 = [];
  List<String> groupId = [];
  List<bool> isCheck = [];
  List<String> publish = [];
  bool doneLoad = false;
  bool check = false;
  List<Color> colors = [];
  Map<String, bool> map = {};
  Recipe recipe;
  Color saveColor = Colors.blueGrey[600];
  IconData iconSave = Icons.favorite_border;
  String saveString = 'save for yourself';

  SaveGroup(String _uid, String _recipeId, Recipe _recipe) {
    this.uid = _uid;
    this.recipeId = _recipeId;
    this.recipe = _recipe;
  }

  @override
  _SaveGroupState createState() => _SaveGroupState();
}

class _SaveGroupState extends State<SaveGroup> {
  Future<void> getGroups() async {
    QuerySnapshot snap3 = await Firestore.instance
        .collection("users")
        .document(widget.uid)
        .collection("saved recipe")
        .getDocuments();
    snap3.documents.forEach((element) async {
      if (element.data['recipeID'] == widget.recipe.id) {
        widget.iconSave = Icons.favorite;
        widget.saveString = 'un save for yourself';
        widget.saveColor = Colors.grey[300];
      }
    });

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
      return Column(children: <Widget>[
        new Padding(padding: EdgeInsets.only(top: 20.0)),
        new Text(
          'choose where to save this recipe:',
          style: new TextStyle(
              color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w700),
        ),
        ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
            // ignore: deprecated_member_use
            child: FlatButton.icon(
                color: widget.saveColor,
                icon: Icon(widget.iconSave, color: Colors.white),
                label: Text(widget.saveString,
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (widget.saveString == 'save for yourself') {
                    setState(() {
                      widget.iconSave = Icons.favorite;
                      widget.saveString = "un save for yourself";
                      widget.saveColor = Colors.grey[300];
                      saveRecipe();
                    });
                  } else {
                    setState(() {
                      unSaveRecipe();

                      widget.iconSave = Icons.favorite_border;
                      widget.saveString = "save for yourself";
                      widget.saveColor = Colors.blueGrey[600];
                    });
                  }
                })),
        Expanded(
            child: ListView.builder(
                itemCount: widget.map.length,
                itemBuilder: (context, index) {
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
                                ? Icons.favorite_border
                                : Icons.favorite,
                            color: Colors.white),
                        label: Text(
                            widget.map.values.elementAt(index)
                                ? "un save in " +
                                    widget.map.keys.elementAt(index)
                                : "save in " + widget.map.keys.elementAt(index),
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (widget.map.values.elementAt(index)) {
                            setState(() {
                              widget.isCheck[index] = false;
                              widget.colors[index] = Colors.blueGrey[400];
                              widget.map.update(
                                  widget.map.keys.elementAt(index),
                                  (value) => false);
                            });
                            unPublishGroup(index);
                          } else {
                            publishInGroup(index);
                            setState(() {
                              widget.isCheck[index] = true;
                              widget.colors[index] = Colors.grey;
                              widget.map.update(
                                  widget.map.keys.elementAt(index),
                                  (value) => true);
                            });
                          }
                        },
                      ));
                }))
      ]);
    }
  }

  void publishInGroup(int index) async {
    final db = Firestore.instance;
    await db
        .collection('Group')
        .document(widget.groupId[index])
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
        publishGroup.add(widget.groupId[index]);
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
        publishGroup.remove(widget.groupId[index]);
        db
            .collection('publish recipe')
            .document(id)
            .updateData({'saveInGroup': publishGroup});
      }
    });
  }

  void saveRecipe() async {
    final db = Firestore.instance;

    db.collection('users').document(widget.uid).collection('saved recipe').add({
      'saveInUser': widget.recipe.saveInUser,
      'recipeID': widget.recipe.id,
      'userID': widget.recipe.writerUid
    });

    String id;
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) async {
      if (element.data['recipeId'] == widget.recipe.id) {
        id = element.documentID;
        var currentRecipe2 =
            await db.collection('publish recipe').document(id).get();
        List publishGroup = [];
        List loadList = currentRecipe2.data['saveUser'] ?? [];
        publishGroup.addAll(loadList);
        publishGroup.add(widget.uid);
        db
            .collection('publish recipe')
            .document(id)
            .updateData({'saveUser': publishGroup});
      }
    });
  }

  Future<void> unSaveRecipe() async {
    final db = Firestore.instance;
    QuerySnapshot allDocuments = await db
        .collection('users')
        .document(widget.uid)
        .collection('saved recipe')
        .getDocuments();
    String delete;
    allDocuments.documents.forEach((doc) {
      if (doc.data['recipeID'] == widget.recipe.id) {
        delete = doc.documentID.toString();
      }
      db
          .collection('users')
          .document(widget.uid)
          .collection('saved recipe')
          .document(delete)
          .delete();
    });

    String id;
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) async {
      if (element.data['recipeId'] == widget.recipe.id) {
        id = element.documentID;
        var currentRecipe2 =
            await db.collection('publish recipe').document(id).get();
        List publishGroup = [];
        List loadList = currentRecipe2.data['saveUser'] ?? [];
        publishGroup.addAll(loadList);
        publishGroup.remove(widget.uid);
        db
            .collection('publish recipe')
            .document(id)
            .updateData({'saveUser': publishGroup});
      }
    });
  }
}
