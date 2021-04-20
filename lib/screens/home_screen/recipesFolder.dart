import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/main.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/home_screen/RecipeList.dart';
import 'package:recipes_app/screens/home_screen/recipeHeadLine.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import 'package:recipes_app/screens/home_screen/Folfer.dart';

import 'RecipeList.dart';

class RecipeFolder extends StatefulWidget {
  RecipeFolder(bool home) {
    this.home = home;
  }
  @override
  _RecipeFolderState createState() => _RecipeFolderState();
  bool home;
  List<Recipe> publisRecipe = [];
  List<Recipe> savedRecipe = [];
  bool doneLoadPublishRecipe = false;
  bool doneLoadSavedRecipe = false;
  bool doneGetUser = false;
  String uid;
}

class _RecipeFolderState extends State<RecipeFolder> {
  @override
  void initState() {
    super.initState();
    changeState();
  }

  void changeState() {
    widget.publisRecipe = [];
    widget.savedRecipe = [];
    widget.doneLoadPublishRecipe = false;
    widget.doneLoadSavedRecipe = false;
    if ((!widget.doneLoadPublishRecipe) && (!widget.doneLoadSavedRecipe)) {
      if (!widget.home) {
        widget.doneLoadPublishRecipe = true;
        getuser();
        if (widget.uid != null) {
          loadSavedRecipe();
        }
      } else {
        loadPublishRecipe();
      }
    }
  }

  void getuser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      widget.uid = user.uid;
      loadSavedRecipe();
      widget.doneGetUser = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //הסבר לגבי הרשימה של המתכונים -
    //אם אנחנו מגיעים מעמוד האישי של המשתמש יהיה כאן את כל רשימת המתכונים שלו,
    //אם אנחנו מגיעים מעמוד הבית יהיה כאן כל המתכונים שנמצאים בתיקית המתכונים בדאטה בייס,
    //לכן נצטרך להוסיף אליהם גם את רשימת המתכונים המפורסמים - מתיקית המתכונים המפורסמים.
    var recipeList = Provider.of<List<Recipe>>(context);
    //אם לא הגעת מעמוד הבית אין סיבה לטעון את כל המתכונים -
    // לכן מיד נשנה את הערך הבוליאני ל- נכון, ולא נקרא לפונקציה.
    if (!widget.doneLoadPublishRecipe) {
      return Loading();
    }
    if (widget.doneLoadPublishRecipe) {
      if (widget.publisRecipe != null) {
        recipeList = recipeList + widget.publisRecipe;
      }
      if (widget.doneLoadSavedRecipe) {
        recipeList = recipeList + widget.savedRecipe;
      }

      List<Recipe> fish = [];
      List<Recipe> other = [];
      List<Recipe> meet = [];
      List<Recipe> dairy = [];
      List<Recipe> desert = [];
      List<Recipe> childern = [];
      if (recipeList != null) {
        for (int i = 0; i < recipeList.length; i++) {
          if (recipeList[i].myTag.length == 0) {
            other.add(recipeList[i]);
          }
          for (int j = 0; j < recipeList[i].myTag.length; j++) {
            switch (recipeList[i].myTag[j]) {
              case "fish":
                fish.add(recipeList[i]);
                break;
              case "meat":
                meet.add(recipeList[i]);
                break;
              case "dairy":
                dairy.add(recipeList[i]);
                break;
              case "desert":
                desert.add(recipeList[i]);
                break;
              case "for children":
                childern.add(recipeList[i]);
                break;
              case "other":
                other.add(recipeList[i]);
                break;
              case "choose recipe tag":
                other.add(recipeList[i]);
                break;
            }
          }
        }
      }
      return Column(children: <Widget>[
        FlatButton.icon(
          color: Colors.blueGrey[400],
          icon: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          label: Text(
            'Refresh',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => {changeState()},
        ),
        // Folder(recipeList),
        //fish
        if (!fish.isEmpty)
          IconButton(
              icon: Icon(Icons.set_meal),
              iconSize: 50,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RecipeList(fish, "fish", widget.home)));
              }),
        //meat
        if (!meet.isEmpty)
          IconButton(
              icon: Icon(Icons.local_dining),
              iconSize: 50,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RecipeList(meet, "meat", widget.home)));
              }),
        //dairy
        if (!dairy.isEmpty)
          IconButton(
              icon: Icon(Icons.local_pizza),
              iconSize: 50,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RecipeList(dairy, "dairy", widget.home)));
              }),
        //desert
        if (!desert.isEmpty)
          IconButton(
              icon: Icon(Icons.cake),
              iconSize: 50,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RecipeList(desert, "desert", widget.home)));
              }),
        //for childern
        if (!childern.isEmpty)
          IconButton(
              icon: Icon(Icons.child_friendly_outlined),
              iconSize: 50,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RecipeList(childern, "childeren", widget.home)));
              }),
        //other
        if (!other.isEmpty)
          Container(
              width: 500,
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ExactAssetImage('lib/images/fish.jpg'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: FlatButton(onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RecipeList(other, "other", widget.home)));
              }))
      ]);
    }
  }

  Future<void> loadPublishRecipe() async {
    String uid;
    String recipeId;
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    widget.publisRecipe = [];
    // print("check");
    // print(snap.documents.length);
    if (snap.documents.length == 0) {
      setState(() {
        widget.doneLoadPublishRecipe = true;
      });
    }
    int i = 0;
    snap.documents.forEach((element) async {
      uid = element.data['userID'] ?? '';
      recipeId = element.data['recipeId'] ?? '';
      DocumentSnapshot doc = await Firestore.instance
          .collection('users')
          .document(uid)
          .collection('recipes')
          .document(recipeId)
          .get();
      String n = doc.data['name'] ?? '';
      String de = doc.data['description'] ?? '';
      String level = doc.data['level'] ?? 0;
      String time = doc.data['time'] ?? '0';
      int timeI = int.parse(time);
      String writer = doc.data['writer'] ?? '';
      String writerUid = doc.data['writerUid'] ?? '';
      String id = doc.data['recipeID'] ?? '';
      //
      String publish = doc.data['publishID'] ?? '';
      String path = doc.data['imagePath'] ?? '';
      int levlelInt = int.parse(level);
      //tags
      var tags = doc.data['tags'];
      String tagString = tags.toString();
      List<String> l = [];
      if (tagString != "[]") {
        String tag = tagString.substring(1, tagString.length - 1);
        l = tag.split(',');
        for (int i = 0; i < l.length; i++) {
          if (l[i][0] == ' ') {
            l[i] = l[i].substring(1, l[i].length);
          }
        }
      }
      //notes
      var note = doc.data['tags'];
      String noteString = note.toString();
      List<String> nList = [];
      if (noteString != "[]") {
        String tag = noteString.substring(1, noteString.length - 1);
        nList = tag.split(',');
        for (int i = 0; i < nList.length; i++) {
          if (nList[i][0] == ' ') {
            nList[i] = nList[i].substring(1, nList[i].length);
          }
        }
      }
      Recipe r = Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI,
          true, id, publish, path);
      // r.setId(id);
      // print(publish + "publish");
      //r.publishThisRecipe(publish);
      widget.publisRecipe.add(r);
      // print(r.publish);
      i++;
      print("i -     " + i.toString());
      print(snap.documents.length);
      // print(snap.documents.length);
      if ((i) == snap.documents.length) {
        setState(() {
          widget.doneLoadPublishRecipe = true;
        });
      }
    });
  }

  Future<void> loadSavedRecipe() async {
    String uid;
    String recipeId;
    bool saveInUser;
    Recipe r;
    //if(widget.uid!=null)
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('saved recipe')
        .getDocuments();
    widget.savedRecipe = [];
    print("check");
    print(widget.uid);
    print(snap.documents.length);
    if (snap.documents.length == 0) {
      setState(() {
        widget.doneLoadSavedRecipe = true;
      });
    }
    int i = 0;
    snap.documents.forEach((element) async {
      uid = element.data['userID'] ?? '';
      recipeId = element.data['recipeID'] ?? '';
      saveInUser = element.data['saveInUser'] ?? true;
      print(uid);
      print(recipeId);
      print(saveInUser);
      if (saveInUser) {
        DocumentSnapshot doc = await Firestore.instance
            .collection('users')
            .document(uid)
            .collection('recipes')
            .document(recipeId)
            .get();
        //check if in the user;
        // print(doc.data.length.toString() +
        //     "   .....................................");
        String n = doc.data['name'] ?? '';
        String de = doc.data['description'] ?? '';
        String level = doc.data['level'] ?? 0;
        String time = doc.data['time'] ?? '0';
        int timeI = int.parse(time);
        String writer = doc.data['writer'] ?? '';
        String writerUid = doc.data['writerUid'] ?? '';
        String id = doc.data['recipeID'] ?? '';
        //
        String publish = doc.data['publishID'] ?? '';
        String path = doc.data['imagePath'] ?? '';
        int levlelInt = int.parse(level);
        //tags
        var tags = doc.data['tags'];
        String tagString = tags.toString();
        List<String> l = [];
        if (tagString != "[]") {
          String tag = tagString.substring(1, tagString.length - 1);
          l = tag.split(',');
          for (int i = 0; i < l.length; i++) {
            if (l[i][0] == ' ') {
              l[i] = l[i].substring(1, l[i].length);
            }
          }
        }
        //notes
        var note = doc.data['tags'];
        String noteString = note.toString();
        List<String> nList = [];
        if (noteString != "[]") {
          String tag = noteString.substring(1, noteString.length - 1);
          nList = tag.split(',');
          for (int i = 0; i < nList.length; i++) {
            if (nList[i][0] == ' ') {
              nList[i] = nList[i].substring(1, nList[i].length);
            }
          }
        }
        print(n + "   " + de);
        r = Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI, true,
            id, publish, path);
      }
      //from recipe
      else {
        print("else" + recipeId);
        print(recipeId);
        DocumentSnapshot doc = await Firestore.instance
            .collection('recipes')
            .document(recipeId)
            .get();
        //check if in the user;
        print(doc.data.length.toString() +
            "   .....................................");
        String n = doc.data['name'] ?? '';
        String de = doc.data['description'] ?? '';
        String level = doc.data['level'] ?? 0;
        String time = doc.data['time'] ?? '0';
        int timeI = int.parse(time);
        String writer = doc.data['writer'] ?? '';
        String writerUid = doc.data['writerUid'] ?? '';
        String id = doc.data['recipeID'] ?? '';
        //
        String publish = doc.data['publishID'] ?? '';
        String path = doc.data['imagePath'] ?? '';
        int levlelInt = int.parse(level);
        //tags
        var tags = doc.data['tags'];
        String tagString = tags.toString();
        List<String> l = [];
        if (tagString != "[]") {
          String tag = tagString.substring(1, tagString.length - 1);
          l = tag.split(',');
          for (int i = 0; i < l.length; i++) {
            if (l[i][0] == ' ') {
              l[i] = l[i].substring(1, l[i].length);
            }
          }
        }
        //notes
        var note = doc.data['tags'];
        String noteString = note.toString();
        List<String> nList = [];
        if (noteString != "[]") {
          String tag = noteString.substring(1, noteString.length - 1);
          nList = tag.split(',');
          for (int i = 0; i < nList.length; i++) {
            if (nList[i][0] == ' ') {
              nList[i] = nList[i].substring(1, nList[i].length);
            }
          }
        }
        print(n + "   " + de);
        r = Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI, false,
            id, publish, path);
      }
      // r.setId(id);
      // print(publish + "publish");
      //r.publishThisRecipe(publish);
      widget.savedRecipe.add(r);
      print("plus ");
      // print(r.publish);
      i++;

      // print(snap.documents.length);
      if ((i) == snap.documents.length) {
        setState(() {
          widget.doneLoadSavedRecipe = true;
          print("done save");
        });
      }
    });
  }
}
