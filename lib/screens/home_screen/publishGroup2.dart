import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/shared_screen/loading.dart';

class PublishGroup2 extends StatefulWidget {
  PublishGroup2(String _uid, String _recipeId, Recipe _recipe) {
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
  IconData iconPublish = Icons.public;
  String stringPublish;
  Color colorPublish;
  @override
  _PublishGroup2State createState() => _PublishGroup2State();
}

class _PublishGroup2State extends State<PublishGroup2> {
  // void convertToCheck() {
  //   widget.groupName2 = widget.groupName;
  //   print("convert to shack");
  //   for (int i = 0; i < widget.publish.length; i++) {
  //     for (int j = 0; j < widget.groupName.length; j++) {
  //       if (widget.groupName[j] == widget.publish[i]) {
  //         setState(() {
  //           widget.isCheck[j] = !widget.isCheck[j];
  //           widget.colors[j] = Colors.grey;
  //         });
  //       }
  //     }
  //   }
  //   print("check list");
  //   print(widget.isCheck);
  //   setState(() {
  //     widget.check = true;
  //   });
  // }

  Future<void> getGroups() async {
    if (widget.recipe.publish == '') {
      widget.iconPublish = Icons.public;
      widget.stringPublish = "publish";

      widget.colorPublish = Colors.blueGrey[600];
    } else {
      widget.iconPublish = Icons.public_off;
      widget.stringPublish = "un publish";
      widget.colorPublish = Colors.grey[300];
    }

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
    if (!widget.doneLoad) {
      getGroups();

      return Loading();
    } else {
      return Column(children: <Widget>[
        new Padding(padding: EdgeInsets.only(top: 20.0)),
        new Text(
          'choose where to publish yuor recipe:',
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
                color: widget.colorPublish,
                icon: Icon(widget.iconPublish, color: Colors.white),
                label: Text(widget.stringPublish,
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (widget.recipe.publish == '') {
                    // print("if");
                    setState(() {
                      widget.iconPublish = Icons.public_off;
                      widget.stringPublish = "un publish";
                      widget.colorPublish = Colors.grey[300];
                      publishRecipe();
                    });
                    // publishRecipe();
                  } else {
                    //print("else");
                    setState(() {
                      unPublishRecipe();
                      widget.iconPublish = Icons.public;
                      widget.stringPublish = "publish this recipe";
                      widget.colorPublish = Colors.blueGrey[600];
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
                                ? Icons.public_off
                                : Icons.public,
                            color: Colors.white),
                        label: Text(
                            widget.map.values.elementAt(index)
                                ? "unpublish in " +
                                    widget.map.keys.elementAt(index)
                                : "publish in " +
                                    widget.map.keys.elementAt(index),
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          print("press");
                          print(widget.isCheck[index]);
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
    var currentRecipe = await db
        .collection('Group')
        .document(widget.groupId[index])
        .collection('recipes')
        .add({'userId': widget.uid, 'recipeId': widget.recipeId});
  }

  Future<void> unPublishGroup(int index) async {
    print("1");
    setState(() {
      widget.isCheck[index] = false;
      widget.colors[index] = Colors.blueGrey[400];
      print("2");
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
  }

  Future<void> publishRecipe() async {
    final user = Provider.of<User>(context);
    final db = Firestore.instance;
    Map<String, dynamic> publishRecipe = {
      'recipeId': widget.recipeId,
      'userID': user.uid
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
        .document(user.uid)
        .collection('recipes')
        .document(widget.recipeId)
        .updateData(widget.recipe.toJson());
  }

  void unPublishRecipe() {
    final user = Provider.of<User>(context);
    final db = Firestore.instance;
    db.collection('publish recipe').document(widget.recipe.publish).delete();
    widget.recipe.publishThisRecipe('');

    db
        .collection('users')
        .document(user.uid)
        .collection('recipes')
        .document(widget.recipeId)
        .updateData(widget.recipe.toJson());
  }
}
