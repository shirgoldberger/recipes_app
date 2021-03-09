import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/main.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screen/home_screen/RecipeList.dart';
import 'package:recipes_app/screen/home_screen/recipeHeadLine.dart';
import 'package:recipes_app/shared_screen/loading.dart';

class RecipeFolder extends StatefulWidget {
  RecipeFolder(bool home) {
    this.home = home;
  }
  @override
  _RecipeFolderState createState() => _RecipeFolderState();
  bool home;
  List<Recipe> publisRecipe = [];
  bool doneLoadPublishRecipe = false;
}

class _RecipeFolderState extends State<RecipeFolder> {
  @override
  void initState() {
    super.initState();
    if (!widget.home) {
      widget.doneLoadPublishRecipe = true;
    } else {
      loadPublishRecipe();
    }
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
      recipeList = recipeList + widget.publisRecipe;

      int i;
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
        Text('data'),
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
          IconButton(
              icon: Icon(Icons.sentiment_neutral),
              iconSize: 50,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RecipeList(other, "other", widget.home)));
              }),
      ]);
    }
  }

  Future<void> loadPublishRecipe() async {
    String uid;
    String recipeId;
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    print("check");
    print(snap.documents.length);
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

      Recipe r =
          Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI, true);
      r.setId(uid);

      widget.publisRecipe.add(r);
      i++;

      if ((i + 1) == snap.documents.length) {
        setState(() {
          widget.doneLoadPublishRecipe = true;
        });
      }
    });
  }

  Future<Recipe> getRecipe(String uid, String recipeId) async {
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

    Recipe r =
        Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI, true);
    return r;
  }
}
