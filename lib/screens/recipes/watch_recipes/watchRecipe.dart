import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'watchMyRecipe.dart';
import 'watchPublishRecipe.dart';
import 'watchSaveRecipe.dart';
import 'package:recipes_app/shared_screen/loading.dart';

//הסבר כללי לגבי העמוד הזה-
// העמוד מקבל מתכון ומציג אותו למשתמש כאשר הוא מחולק ל 3 מצבים:
// מצב ראשןן - במקרה ואנחנו צופים במתכון שאנחנו כתבנו - ניתן לערוך את המתכון, למחוק אותו ולפרסם אותו.
//  לכן אפשר רק למחוק אותו, נמחק רק אצלי, או להוסיף עליו הערות אישיות שלי. (עשינו לו save )  מצב שני - אנחנו צופים במתכון ששמרנו אותו
// מצב שלישי - צפיה במתכון מתוך העמוד הכללי - ניתן רק לשמור מתכון.
// ignore: must_be_immutable
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
  Color levelColor;
  String levelString = '';
  var uid;

  @override
  _WatchRecipeState createState() => _WatchRecipeState();
}

class _WatchRecipeState extends State<WatchRecipe> {
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
    if (user != null) {
      setState(() {
        widget.uid = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setLevels();
    if (!widget.done) {
      return Loading();
    } else {
      if (widget.home) {
        // 3
        return WatchPublishRecipe(
            widget.uid, widget.current, widget.levelColor, widget.levelString);
      } else {
        if (widget.uid == widget.current.writerUid) {
          // 1
          return WatchMyRecipe(widget.uid, widget.current, widget.levelColor,
              widget.levelString);
        } else {
          // 2
          return WatchSaveRecipe(widget.uid, widget.current, widget.levelColor,
              widget.levelString);
        }
      }
    }
  }

  setLevels() {
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
          setState(() {
            widget.ing.add(IngredientsModel.antherConstactor(
                element.data['name'] ?? '',
                element.data['count'] ?? 0,
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
          setState(() {
            widget.ing.add(IngredientsModel.antherConstactor(
                element.data['name'] ?? '',
                element.data['count'] ?? 0,
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
}
