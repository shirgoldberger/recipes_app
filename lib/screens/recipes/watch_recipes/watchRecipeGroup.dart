import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stages.dart';
import 'package:recipes_app/screens/personal_screen/homeLogIn.dart';
import 'warchRecipeBody.dart';

//הסבר כללי לגבי העמוד הזה-
// העמוד מקבל מתכון ומציג אותו למשתמש כאשר הוא מחולק ל 3 מצבים:
// מצב ראשןן - במקרה ואנחנו צופים במתכון שאנחנו כתבנו - ניתן לערוך את המתכון, למחוק אותו ולפרסם אותו.
//  לכן אפשר רק למחוק אותו, נמחק רק אצלי, או להוסיף עליו הערות אישיות שלי. (עשינו לו save )  מצב שני - אנחנו צופים במתכון ששמרנו אותו
// מצב שלישי - צפיה במתכון מתוך העמוד הכללי - ניתן רק לשמור מתכון.
class WatchRecipeGroup extends StatefulWidget {
  WatchRecipeGroup(Recipe r, String _groupId) {
    this.current = r;
    this.groupId = _groupId;
    // print("watch recipe");
    // print(current.publish);
    // print(r.publish);
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
  IconData iconPublish = Icons.public;
  String publishString = "publish this recipe";
  String saveRecipe = '';
  IconData iconSave = Icons.favorite_border;
  String saveString = 'save';
  //bool publish = false;

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
    print("init state");
    // print(widget.current.publish);
    if (widget.current.publish == '') {
      widget.iconPublish = Icons.public;
      widget.publishString = "publish";
    } else {
      widget.iconPublish = Icons.public_off;
      widget.publishString = "un publish";
    }
    print(widget.uid);
    // if (widget.uid != null) {
    //   print("user:   " + widget.uid);
    //   Firestore.instance
    //       .collection("users")
    //       .document(widget.uid)
    //       .get()
    //       .then((doc) {
    //     if (doc.data['recipeID'] == widget.current.id) {
    //       print("save");
    //     } else {
    //       print("unsave");
    //     }
    //   });
    // }
  }

  void getuser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      widget.uid = user.uid;
      print(widget.uid);
      //print("user uid");
    });
    if (widget.uid != null) {
      // print("user:   " + widget.uid);
      QuerySnapshot snap = await Firestore.instance
          .collection("users")
          .document(widget.uid)
          .collection("saved recipe")
          .getDocuments();
      snap.documents.forEach((element) async {
        if (element.data['recipeID'] == widget.current.id) {
          widget.iconSave = Icons.favorite;
          widget.saveString = 'unsave';
          print("unsave");
        }
      });
      print(widget.saveString);

      //     .then((doc) {
      //   if (doc.data['recipeID'] == widget.current.id) {
      //     print("save");
      //   } else {
      //     print("unsave");
      //   }
      // });
    }
  }

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

    //מצב שני 2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
            backgroundColor: Colors.blueGrey[700],
            elevation: 0.0,
            title: Text(
              'watch this recipe',
              style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
            ),
            actions: <Widget>[
              FlatButton.icon(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label: Text(
                    'delete',
                    style:
                        TextStyle(fontFamily: 'Raleway', color: Colors.white),
                  ),
                  onPressed: () {
                    deleteFromGroupRecipe();
                    //go back
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => HomeLogIn()));
                  }),
              // FlatButton.icon(
              //     icon: Icon(
              //       Icons.note_add,
              //       color: Colors.white,
              //     ),
              //     label: Text(
              //       'add note',
              //       style:
              //           TextStyle(fontFamily: 'Raleway', color: Colors.white),
              //     ),
              //     onPressed: () {}),
            ]),
        body: WatchRecipeBody(widget.current, widget.ing, widget.stages,
            widget.levelColor, widget.levelString));
  }

  Future<void> makeList() async {
    if (!widget.done) {
      if (widget.current.saveInUser) {
        //final user = Provider.of<User>(context);
        String uid = widget.current.writerUid;
        // print('save in user');
        //print(uid);
        //print(widget.current.id.toString());
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
          // print(element1.data.toString());
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
          //print(element1.data.toString());
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

  void deleteFromGroupRecipe() async {
    print("delleeetetete");
    print(widget.groupId);
    final db = Firestore.instance;
    QuerySnapshot snap = await Firestore.instance
        .collection('Group')
        .document(widget.groupId)
        .collection('recipes')
        .getDocuments();
    snap.documents.forEach((element) async {
      String recipeIdfromSnap = element.data['recipeId'];
      print(recipeIdfromSnap);
      print(widget.current.id);
      if (recipeIdfromSnap == widget.current.id) {
        print("found");
        db
            .collection('Group')
            .document(widget.groupId)
            .collection('recipes')
            .document(element.documentID)
            .delete();
      }
    });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomeLogIn(widget.uid)));
  }
}