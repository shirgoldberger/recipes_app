import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stages.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screen/home_screen/editRecipe.dart';
import 'package:recipes_app/screen/home_screen/homeLogIn.dart';
import 'package:recipes_app/screen/home_screen/ingredients.dart';
import 'package:recipes_app/screen/home_screen/warchRecipeBody.dart';
import 'package:recipes_app/shared_screen/loading.dart';

class WatchRecipe extends StatefulWidget {
  WatchRecipe(Recipe r, bool home) {
    this.current = r;
    this.home = home;
  }
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
  bool publish = false;

  @override
  _WatchRecipeState createState() => _WatchRecipeState();
}

class _WatchRecipeState extends State<WatchRecipe> {
  var i;

  @override
  Widget build(BuildContext context) {
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
    //if we came from home screen
    makeList();
    if (widget.home) {
      final FirebaseAuth auth = FirebaseAuth.instance;

      void getuser() async {
        final FirebaseUser user = await auth.currentUser();
        setState(() {
          widget.uid = user.uid;
        });
      }

      showAlertDialog() {
        // set up the buttons
        Widget cancelButton = FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        );

        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Text("need to sign in"),
          content: Text(
              "you can not save this recipe - please first register or sign in to this app, do this in the personal page"),
          actions: [
            cancelButton,
          ],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }

      getuser();
      if (!widget.done) {
        return Loading();
      } else {
        return Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
                backgroundColor: Colors.brown[400],
                elevation: 0.0,
                title: Text('watch this recipe'),
                actions: <Widget>[
                  FlatButton.icon(
                      icon: Icon(Icons.save),
                      label: Text('save this recipe'),
                      onPressed: () {
                        if (widget.uid != null) {
                          plusRecipe();
                        } else {
                          showAlertDialog();
                        }
                      })
                ]),
            body: WatchRecipeBody(widget.current, widget.ing, widget.stages,
                widget.levelColor, widget.levelString));
      }
    }
    //if we come from personal page
    if (!widget.home) {
      final user = Provider.of<User>(context);
      final db = Firestore.instance;
      if (!widget.done) {
        return Loading();
      } else {
        return Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
                backgroundColor: Colors.brown[400],
                elevation: 0.0,
                title: Text('watch this recipe'),
                actions: <Widget>[
                  FlatButton.icon(
                      icon: Icon(Icons.edit),
                      label: Text('edit'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditRecipe(widget.current,
                                    widget.ing, widget.stages)));
                      }),
                  FlatButton.icon(
                      icon: Icon(Icons.public),
                      label: Text('publish this recipe'),
                      onPressed: () {
                        //only id its not publish - publish (only once)
                        if (!widget.publish) {
                          publishRecipe();
                        }
                      }),
                  FlatButton.icon(
                      icon: Icon(Icons.delete),
                      label: Text('delete'),
                      onPressed: () {
                        db
                            .collection('users')
                            .document(user.uid)
                            .collection('recipes')
                            .document(widget.current.id)
                            .delete();
                        //go back
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeLogIn()));
                      })
                ]),
            body: WatchRecipeBody(widget.current, widget.ing, widget.stages,
                widget.levelColor, widget.levelString));
      }
    }
  }

  Future<void> makeList() async {
    if (!widget.done) {
      if (widget.current.saveInUser) {
        //final user = Provider.of<User>(context);
        String uid = widget.current.writerUid;
        QuerySnapshot snap = await Firestore.instance
            .collection('users')
            .document(uid)
            .collection('recipes')
            .document(widget.current.id.toString())
            .collection('ingredients')
            .getDocuments();
        snap.documents.forEach((element) {
          setState(() {
            widget.ing.add(IngredientsModel.antherConstactor(
                element.data['name'] ?? '',
                element.data['count'] ?? 0,
                element.data['unit'] ?? ''));
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
          print(element1.data.toString());
          setState(() {
            widget.stages
                .add(Stages.antheeConstractor(element1.data['stage'] ?? ''));
          });
        });
      } else {
        QuerySnapshot snap = await Firestore.instance
            .collection('recipes')
            .document(widget.current.id)
            .collection('ingredients')
            .getDocuments();
        snap.documents.forEach((element) {
          setState(() {
            widget.ing.add(IngredientsModel.antherConstactor(
                element.data['name'] ?? '',
                element.data['count'] ?? 0,
                element.data['unit'] ?? ''));
          });
        });
        QuerySnapshot snap2 = await Firestore.instance
            .collection('recipes')
            .document(widget.current.id)
            .collection('stages')
            .getDocuments();
        snap2.documents.forEach((element1) {
          print(element1.data.toString());
          setState(() {
            widget.stages
                .add(Stages.antheeConstractor(element1.data['stage'] ?? ''));
          });
        });
      }

      setState(() {
        widget.done = true;
      });
    }
  }

  void plusRecipe() async {
    final db = Firestore.instance;
    Recipe recipe = widget.current;
    var currentRecipe = await db
        .collection('users')
        .document(widget.uid)
        .collection('recipes')
        .add(recipe.toJson());
    print(currentRecipe.documentID.toString());
    String id = currentRecipe.documentID.toString();
    for (int i = 0; i < widget.ing.length; i++) {
      await db
          .collection('users')
          .document(widget.uid)
          .collection('recipes')
          .document(id)
          .collection('ingredients')
          .add(widget.ing[i].toJson());
    }
    for (int i = 0; i < widget.stages.length; i++) {
      await db
          .collection('users')
          .document(widget.uid)
          .collection('recipes')
          .document(id)
          .collection('stages')
          .add(widget.stages[i].toJson(i));
    }
  }

  Future<void> publishRecipe() async {
    final user = Provider.of<User>(context);
    final db = Firestore.instance;
    Map<String, dynamic> publishRecipe = {
      'recipeId': widget.current.id,
      'userID': user.uid
    };
    var currentRecipe =
        await db.collection('publish recipe').add(publishRecipe);
    setState(() {
      widget.publish = true;
    });
  }
}
