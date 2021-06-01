import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:recipes_app/screens/recipes/watch_recipes/watchRecipeBody.dart';
import 'package:recipes_app/shared_screen/loading.dart';

// ignore: must_be_immutable
class WatchRecipeGroup extends StatefulWidget {
  WatchRecipeGroup(Recipe r, String _groupId, NetworkImage _image) {
    this.current = r;
    this.groupId = _groupId;
    this.image = _image;
  }

  String groupId;
  bool home;
  List<IngredientsModel> ing = [];
  List<Stages> stages = [];
  Recipe current;
  bool done = false;
  int count = 0;
  String tags = '';
  final db = Firestore.instance;
  Color levelColor;
  String levelString = '';
  var uid;
  String saveRecipe = '';
  IconData iconSave = Icons.favorite_border;
  String saveString = 'save';
  NetworkImage image;

  @override
  @override
  _WatchRecipeGroupState createState() => _WatchRecipeGroupState();
}

class _WatchRecipeGroupState extends State<WatchRecipeGroup> {
  var i;
  @override
  void initState() {
    super.initState();
    getuser();
    makeList();
  }

  void getuser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      widget.uid = user.uid;
    });
    if (widget.uid != null) {
      QuerySnapshot snap = await Firestore.instance
          .collection("users")
          .document(widget.uid)
          .collection("saved recipe")
          .getDocuments();
      snap.documents.forEach((element) async {
        if (element.data['recipeID'] == widget.current.id) {
          widget.iconSave = Icons.favorite;
          widget.saveString = 'unsave';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.done) {
      return Loading();
    } else {
      if (widget.current.level == 1) {
        widget.levelColor = Colors.green[900];
        widget.levelString = "easy";
      }
      if (widget.current.level == 2) {
        widget.levelColor = Colors.red[900];
        widget.levelString = "nedium";
      }
      if (widget.current.level == 3) {
        widget.levelColor = Colors.blue[900];
        widget.levelString = "hard";
      }
      return Scaffold(
          backgroundColor: Colors.blueGrey[50],
          appBar: AppBar(
              backgroundColor: Colors.blueGrey[700],
              elevation: 0.0,
              title: Text(
                'watch Recipe',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Raleway', color: Colors.white, fontSize: 20),
              ),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton.icon(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Delete\nfrom group',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.white,
                          fontSize: 10),
                    ),
                    onPressed: () {
                      _showAlertDialog(context);
                    }),
              ]),
          body: WatchRecipeBody(widget.current, widget.ing, widget.stages,
              widget.levelColor, widget.levelString, widget.uid, widget.image));
    }
  }

  Future<void> _showAlertDialog(BuildContext context1) async {
    BuildContext dialogContenst;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContenst = context;
        return AlertDialog(
          title: Text('Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this recipe from group?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('yes- delete'),
              onPressed: () async {
                deleteFromGroupRecipe();
                int count = 0;
                Navigator.pop(dialogContenst);
                Navigator.of(context1).pop();
                Navigator.popUntil(context1, (route) {
                  return count++ == 1;
                });
              },
            ),
            TextButton(
              child: Text('no- go back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> makeList() async {
    if (!widget.done) {
      if (widget.current.saveInUser) {
        String uid = widget.current.writerUid;
        QuerySnapshot snap = await Firestore.instance
            .collection('users')
            .document(uid)
            .collection('recipes')
            .document(widget.current.id.toString())
            .collection('ingredients')
            .getDocuments();
        snap.documents.forEach((element) {
          var count = element.data['count'] ?? 0;
          setState(() {
            widget.ing.add(IngredientsModel.antherConstactor(
                element.data['name'] ?? '',
                count.toDouble(),
                element.data['unit'] ?? '',
                element.data['index'] ?? 0));
          });
        });
        QuerySnapshot snap2 = await Firestore.instance
            .collection('users')
            .document(uid)
            .collection('recipes')
            .document(widget.current.id.toString())
            .collection('stages')
            .getDocuments();
        snap2.documents.forEach((element1) {
          setState(() {
            widget.stages.add(Stages.antheeConstractor(
                element1.data['stage'] ?? '', element1.data['number'] ?? ''));
          });
        });
      } else {
        QuerySnapshot snap = await Firestore.instance
            .collection('recipes')
            .document(widget.current.id)
            .collection('ingredients')
            .getDocuments();
        snap.documents.forEach((element) {
          var count = element.data['count'] ?? 0;
          setState(() {
            widget.ing.add(IngredientsModel.antherConstactor(
                element.data['name'] ?? '',
                count.toDouble(),
                element.data['unit'] ?? '',
                element.data['index'] ?? 0));
          });
        });
        QuerySnapshot snap2 = await Firestore.instance
            .collection('recipes')
            .document(widget.current.id)
            .collection('stages')
            .getDocuments();
        snap2.documents.forEach((element1) {
          setState(() {
            widget.stages.add(Stages.antheeConstractor(
                element1.data['stage'] ?? '', element1.data['number'] ?? ''));
          });
        });
      }
      setState(() {
        widget.done = true;
      });
    }
  }

  void deleteFromGroupRecipe() async {
    final db = Firestore.instance;
    QuerySnapshot snap = await Firestore.instance
        .collection('Group')
        .document(widget.groupId)
        .collection('recipes')
        .getDocuments();
    snap.documents.forEach((element) async {
      String recipeIdfromSnap = element.data['recipeId'];

      if (recipeIdfromSnap == widget.current.id) {
        db
            .collection('Group')
            .document(widget.groupId)
            .collection('recipes')
            .document(element.documentID)
            .delete();
      }
    });
  }
}
