import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:recipes_app/screens/recipes/watch_recipes/watchFavoriteRecipe.dart';
import 'watchMyRecipe.dart';
import 'watchPublishRecipe.dart';
import 'watchDirectoryRecipe.dart';
import 'package:recipes_app/shared_screen/loading.dart';

//הסבר כללי לגבי העמוד הזה-
// העמוד מקבל מתכון ומציג אותו למשתמש כאשר הוא מחולק ל 3 מצבים:
// מצב ראשןן - במקרה ואנחנו צופים במתכון שאנחנו כתבנו - ניתן לערוך את המתכון, למחוק אותו ולפרסם אותו.
//  לכן אפשר רק למחוק אותו, נמחק רק אצלי, או להוסיף עליו הערות אישיות שלי. (עשינו לו save )  מצב שני - אנחנו צופים במתכון ששמרנו אותו
// מצב שלישי - צפיה במתכון מתוך העמוד הכללי - ניתן רק לשמור מתכון.
// ignore: must_be_immutable
class WatchRecipe extends StatefulWidget {
  WatchRecipe(Recipe r, bool home, NetworkImage _image, String _directory) {
    this.current = r;
    this.home = home;
    this.image = _image;
    this.directory = _directory;
  }

  bool home;
  String directory;
  NetworkImage image;
  List<IngredientsModel> ing = [];
  List<Stages> stages = [];
  Recipe current;
  bool done = false;
  int count = 0;
  String tags = '';
  Color levelColor;
  String levelString = '';
  Color timeColor;
  String timeString = '';
  String uid;

  @override
  _WatchRecipeState createState() => _WatchRecipeState();
}

class _WatchRecipeState extends State<WatchRecipe> {
  var i;
  @override
  initState() {
    super.initState();
    getuser();
    makeList();
  }

  void getuser() async {
    if (widget.uid != null) {
      return;
    }
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    if (user != null) {
      setState(() {
        widget.uid = user.uid;
      });
    }
  }

  changeState() async {
    await getuser();
    await makeList();
    setLevels();
  }

  @override
  Widget build(BuildContext context) {
    setLevels();
    if (!widget.done) {
      //  getuser();
      // changeState();
      return Loading();
    } else {
      if (widget.home) {
        // 3
        return WatchPublishRecipe(widget.uid, widget.current, widget.levelColor,
            widget.levelString, widget.ing, widget.stages, widget.image);
      } else {
        if (widget.uid == widget.current.writerUid) {
          // 1
          return WatchMyRecipe(widget.uid, widget.current, widget.levelColor,
              widget.levelString, widget.ing, widget.stages, widget.image);
        } else {
          // 2
          if (widget.directory == "favorite") {
            return WatchFavoriteRecipe(
                widget.uid,
                widget.current,
                widget.levelColor,
                widget.levelString,
                widget.ing,
                widget.stages,
                widget.image);
          }
          return WatchSaveRecipe(
              widget.uid,
              widget.current,
              widget.levelColor,
              widget.levelString,
              widget.ing,
              widget.stages,
              widget.image,
              widget.directory);
        }
      }
    }
  }

  setLevels() {
    if (widget.current.level == 1) {
      widget.levelColor = Colors.green[900];
      widget.levelString = "Easy";
    }
    if (widget.current.level == 2) {
      widget.levelColor = Colors.red[900];
      widget.levelString = "Medium";
    }
    if (widget.current.level == 3) {
      widget.levelColor = Colors.blue[900];
      widget.levelString = "Hard";
    }
  }

  setTimes() {
    switch (widget.current.time) {
      case 1:
        widget.timeString = 'Until half-hour';
        // widget.timeColor = Colors.
        break;
      case 2:
        widget.timeString = 'Until hour';
        break;
      case 3:
        widget.timeString = 'Over an hour';
        break;
    }
  }

  Future<void> makeList() async {
    if (!widget.done) {
      setState(() {
        widget.ing = [];
        widget.stages = [];
      });
      if (widget.current.saveInUser) {
        String uid = widget.current.writerUid;

        QuerySnapshot snap = await Firestore.instance
            .collection('users')
            .document(uid)
            .collection('recipes')
            .document(widget.current.id.toString())
            .collection('ingredients')
            .getDocuments();
        for (int j = 0; j < snap.documents.length; j++) {
          var i = snap.documents[j].data['count'] ?? 0.0;

          setState(() {
            widget.ing.add(IngredientsModel.antherConstactor(
                snap.documents[j].data['name'] ?? '',
                i.toDouble(),
                snap.documents[j].data['unit'] ?? '',
                snap.documents[j].data['index'] ?? 0));
          });
        }
        QuerySnapshot snap2 = await Firestore.instance
            .collection('users')
            .document(uid)
            .collection('recipes')
            .document(widget.current.id.toString())
            .collection('stages')
            .getDocuments();
        for (int i = 0; i < snap2.documents.length; i++) {
          setState(() {
            widget.stages.add(Stages.antheeConstractor(
                snap2.documents[i].data['stage'] ?? '',
                snap2.documents[i].data['number'] ?? ''));
          });
        }
      }
      setState(() {
        widget.done = true;
      });
    }
  }
}
