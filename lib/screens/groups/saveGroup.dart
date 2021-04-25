import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/shared_screen/loading.dart';

class SaveGroup extends StatefulWidget {
  SaveGroup(String _uid, String _recipeId, Recipe _recipe) {
    this.uid = _uid;
    this.recipeId = _recipeId;
    this.recipe = _recipe;
  }
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
  // String stringPublish = '';
  // Color colorPublish;
  IconData iconSave = Icons.favorite_border;
  String saveString = 'save for yourself';
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

    // print(getGroups());
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

      //  print("b");
      // print(widget.groupName);

      QuerySnapshot snap2 = await Firestore.instance
          .collection('Group')
          .document(element.data['groupId'])
          .collection('recipes')
          .getDocuments();
      //    print(element.data['groupId']);
      //  print(snap2.documents.length);
      if (snap2.documents.length != 0) {
        snap2.documents.forEach((element2) async {
          if (element2.data['recipeId'] == widget.recipeId) {
            //  print('sucses');
            setState(() {
              // widget.colors[]
              widget.map.update(element.data['groupName'], (value) => true);
              widget.publish.add(element.data['groupName']);
            });
            //widget.publish.add(element.data['groupName']);
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
    //print("thi is sisiisis");
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
            child: FlatButton.icon(
                color: widget.saveColor,
                icon: Icon(widget.iconSave, color: Colors.white),
                label: Text(widget.saveString,
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (widget.saveString == 'save for yourself') {
                    // print("if");
                    setState(() {
                      widget.iconSave = Icons.favorite;
                      widget.saveString = "un save for yourself";
                      widget.saveColor = Colors.grey[300];
                      saveRecipe();
                      // publishRecipe();
                    });
                    // publishRecipe();
                  } else {
                    //print("else");
                    setState(() {
                      unSaveRecipe();
                      //unPublishRecipe();
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
                          // print("press");
                          // print(widget.isCheck[index]);
                          if (widget.map.values.elementAt(index)) {
                            setState(() {
                              print("set state");
                              widget.isCheck[index] = false;
                              widget.colors[index] = Colors.blueGrey[400];
                              widget.map.update(
                                  widget.map.keys.elementAt(index),
                                  (value) => false);
                            });
                            unPublishGroup(index);
                          } else {
                            print("else");
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
    print("noa");
    print(widget.recipe.writerUid);
    final db = Firestore.instance;
    var currentRecipe = await db
        .collection('Group')
        .document(widget.groupId[index])
        .collection('recipes')
        .add({'userId': widget.recipe.writerUid, 'recipeId': widget.recipeId});
    String id;
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) async {
      //id = element.documentID;
      if (element.data['recipeId'] == widget.recipe.id) {
        id = element.documentID;
        var currentRecipe2 =
            await db.collection('publish recipe').document(id).get();
        print(currentRecipe2.data['recipeId']);
        List publishGroup = [];
        List loadList = currentRecipe2.data['saveInGroup'] ?? [];
        publishGroup.addAll(loadList);
        print(publishGroup);
        publishGroup.add(widget.groupId[index]);
        print(publishGroup);
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
      //id = element.documentID;
      if (element.data['recipeId'] == widget.recipe.id) {
        id = element.documentID;
        var currentRecipe2 =
            await db.collection('publish recipe').document(id).get();
        print(currentRecipe2.data['recipeId']);
        List publishGroup = [];
        List loadList = currentRecipe2.data['saveInGroup'] ?? [];
        publishGroup.addAll(loadList);
        //  print(publishGroup);
        publishGroup.remove(widget.groupId[index]);
        // print(publishGroup);
        db
            .collection('publish recipe')
            .document(id)
            .updateData({'saveInGroup': publishGroup});
      }
    });
  }

  void saveRecipe() async {
    print(widget.uid);
    print(widget.recipeId);
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
      //id = element.documentID;
      if (element.data['recipeId'] == widget.recipe.id) {
        id = element.documentID;
        var currentRecipe2 =
            await db.collection('publish recipe').document(id).get();
        print(currentRecipe2.data['recipeId']);
        List publishGroup = [];
        List loadList = currentRecipe2.data['saveUser'] ?? [];
        publishGroup.addAll(loadList);
        print(publishGroup);
        publishGroup.add(widget.uid);
        print(publishGroup);
        db
            .collection('publish recipe')
            .document(id)
            .updateData({'saveUser': publishGroup});
      }
    });
  }

  Future<void> unSaveRecipe() async {
    print("unSave");
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
      //id = element.documentID;
      if (element.data['recipeId'] == widget.recipe.id) {
        id = element.documentID;
        var currentRecipe2 =
            await db.collection('publish recipe').document(id).get();
        print(currentRecipe2.data['recipeId']);
        List publishGroup = [];
        List loadList = currentRecipe2.data['saveUser'] ?? [];
        publishGroup.addAll(loadList);
        print(publishGroup);
        publishGroup.remove(widget.uid);
        print(publishGroup);
        db
            .collection('publish recipe')
            .document(id)
            .updateData({'saveUser': publishGroup});
      }
    });
  }
}

// Future<void> publishRecipe() async {
//   final user = Provider.of<User>(context);
//   final db = Firestore.instance;
//   Map<String, dynamic> publishRecipe = {
//     'recipeId': widget.recipeId,
//     'userID': user.uid
//   };
//   //save this recipe in the publish folder
//   var currentRecipe =
//       await db.collection('publish recipe').add(publishRecipe);
//   String idPublish = currentRecipe.documentID;
//   //save where he is publish
//   widget.recipe.publishThisRecipe(idPublish);
//   //update in the database
//   db
//       .collection('users')
//       .document(user.uid)
//       .collection('recipes')
//       .document(widget.recipeId)
//       .updateData(widget.recipe.toJson());
// }

// void unPublishRecipe() {
//   final user = Provider.of<User>(context);
//   final db = Firestore.instance;
//   db.collection('publish recipe').document(widget.recipe.publish).delete();
//   widget.recipe.publishThisRecipe('');

//   db
//       .collection('users')
//       .document(user.uid)
//       .collection('recipes')
//       .document(widget.recipeId)
//       .updateData(widget.recipe.toJson());
// }
