import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/directory.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/shared_screen/loading.dart';

// ignore: must_be_immutable
class SaveInDirectory extends StatefulWidget {
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
  List<Directory> directorys = [];
  bool isMyRecipe;

  SaveInDirectory(String _uid, Recipe _recipe, bool _isMyRecipe) {
    this.uid = _uid;
    this.recipe = _recipe;
    this.isMyRecipe = _isMyRecipe;
  }

  @override
  _SaveInDirectoryState createState() => _SaveInDirectoryState();
}

class _SaveInDirectoryState extends State<SaveInDirectory> {
  getGroups() async {
    setState(() {
      widget.directorys = [];
      widget.isCheck = [];
      widget.colors = [];
    });
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('Directory')
        .getDocuments();

    snap.documents.forEach((element) async {
      String name = element.data['name'] ?? '';
      Map<dynamic, dynamic> recipes = element.data['Recipes'] ?? {};
      Directory d = Directory(name: name, recipesId: recipes);
      setState(() {
        widget.directorys.add(d);
      });
      if (recipes.keys.contains(widget.recipe.writerUid)) {
        setState(() {
          widget.isCheck.add(true);
          widget.colors.add(Colors.grey[400]);
        });
      } else {
        setState(() {
          widget.isCheck.add(false);
          widget.colors.add(Colors.blueGrey[400]);
        });
      }
    });
    setState(() {
      widget.doneLoad = true;
    });
  }

  initFavotite() async {
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('saved recipe')
        .getDocuments();
    snap.documents.forEach((element) async {
      String recipe = element.data['recipeID'];
      String user = element.data['userID'];
      if ((recipe == widget.recipe.id) && (user == widget.recipe.writerUid)) {
        setState(() {
          widget.iconSave = Icons.favorite;
          widget.saveColor = Colors.grey[300];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.doneLoad) {
      getGroups();
      initFavotite();
      if (!widget.isMyRecipe) {
        saveRecipe();
      }
      return Loading();
    } else {
      return Column(children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 20.0)),
        Text(
          'Choose in which directory\nsave this recipe:',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w700),
        ),
        heightBox(10),
        Text(
          'This recipe will save automatically in your favorites group',
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: Colors.green,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'DescriptionFont',
          ),
        ),
        heightBox(20),
        Expanded(
            child: ListView.builder(
                itemCount: widget.directorys.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      // ignore: deprecated_member_use
                      child: FlatButton.icon(
                          color: widget.isCheck[index]
                              ? Colors.grey[300]
                              : Colors.blueGrey[600],
                          icon: Icon(
                              widget.isCheck[index]
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.white),
                          label: Text(
                              widget.isCheck[index]
                                  ? "un save in " +
                                      widget.directorys[index].name
                                  : "save in " + widget.directorys[index].name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'DescriptionFont')),
                          onPressed: () {
                            if (widget.isCheck[index]) {
                              unSaveInDirectory(index);
                              setState(() {
                                widget.isCheck[index] = false;
                                widget.colors[index] = Colors.blueGrey[400];
                              });
                            } else {
                              saveInDirectory(index);
                              setState(() {
                                widget.isCheck[index] = true;
                                widget.colors[index] = Colors.grey[400];
                              });
                            }
                            //   if (widget.map.values.elementAt(index)) {
                            //     setState(() {
                            //       widget.isCheck[index] = false;
                            //       widget.colors[index] = Colors.blueGrey[400];
                            //       widget.map.update(
                            //           widget.map.keys.elementAt(index),
                            //           (value) => false);
                            //     });
                            //     unPublishGroup(index);
                            //   } else {
                            //     publishInGroup(index);
                            //     setState(() {
                            //       widget.isCheck[index] = true;
                            //       widget.colors[index] = Colors.grey;
                            //       widget.map.update(
                            //           widget.map.keys.elementAt(index),
                            //           (value) => true);
                            //     });
                            //   }
                            // },
                          }));
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
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('saved recipe')
        .getDocuments();
    bool found = false;
    for (int i = 0; i < snap.documents.length; i++) {
      String recipeId = snap.documents[i].data['recipeID'];
      String userID = snap.documents[i].data['userID'];
      if ((recipeId == widget.recipe.id) &&
          (userID == widget.recipe.writerUid)) {
        found = true;
      }
    }
    if (!found) {
      final db = Firestore.instance;

      db
          .collection('users')
          .document(widget.uid)
          .collection('saved recipe')
          .add({
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

  Future<void> saveInDirectory(int index) async {
    bool found = false;
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('Directory')
        .getDocuments();
    snap.documents.forEach((element) async {
      String name = element.data['name'];
      if (name == widget.directorys[index].name) {
        Map<dynamic, dynamic> recipes = element.data['Recipes'] ?? {};
        Map<dynamic, dynamic> copyRecipes =
            new Map<String, String>.from(recipes);
        copyRecipes[widget.recipe.id] = widget.recipe.writerUid;
        Firestore.instance
            .collection('users')
            .document(widget.uid)
            .collection('Directory')
            .document(element.documentID)
            .updateData({'Recipes': copyRecipes});
        found = true;
      }
    });
    if (!found) {
      getGroups();
      _showAlertDialogError('Something worng. this directory maybe deleted');
    }
  }

  Future<void> _showAlertDialogError(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> unSaveInDirectory(int index) async {
    bool found = false;
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('Directory')
        .getDocuments();
    snap.documents.forEach((element) async {
      String name = element.data['name'];
      if (name == widget.directorys[index].name) {
        found = true;
        Map<dynamic, dynamic> recipes = element.data['Recipes'] ?? {};
        Map<String, String> copyRecipes = new Map<String, String>.from(recipes);
        copyRecipes.remove(widget.recipe.id);

        Firestore.instance
            .collection('users')
            .document(widget.uid)
            .collection('Directory')
            .document(element.documentID)
            .updateData({'Recipes': copyRecipes});
      }
    });
    if (!found) {
      getGroups();
      _showAlertDialogError('Something worng. this directory maybe deleted');
    }
  }
}
