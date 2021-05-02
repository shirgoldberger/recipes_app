import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipes/recipeList.dart';
import 'package:recipes_app/shared_screen/loading.dart';

import 'recipeList.dart';

class RecipeFolder extends StatefulWidget {
  RecipeFolder(bool home) {
    this.home = home;
  }

  @override
  _RecipeFolderDynamicState createState() => _RecipeFolderDynamicState();
  bool home;
  List<Recipe> publisRecipe = [];
  List<Recipe> savedRecipe = [];
  bool doneLoadPublishRecipe = false;
  bool doneLoadSavedRecipe = false;
  bool doneGetUser = false;
  String uid;
}

class _RecipeFolderDynamicState extends State<RecipeFolder> {
  @override
  void didUpdateWidget(RecipeFolder oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    changeState();
  }

  Future<void> changeState() async {
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
    // @override
    // void initState() {
    //   super.initState();
    //   if (!widget.home) {
    //     print("iinniitt");
    //     widget.doneLoadPublishRecipe = true;
    //     getuser();
    //     loadSavedRecipe();
    //   } else {
    //     loadPublishRecipe();
    //   }
    // }
    //הסבר לגבי הרשימה של המתכונים -
    //אם אנחנו מגיעים מעמוד האישי של המשתמש יהיה כאן את כל רשימת המתכונים שלו,
    //אם אנחנו מגיעים מעמוד הבית יהיה כאן כל המתכונים שנמצאים בתיקית המתכונים בדאטה בייס,
    //לכן נצטרך להוסיף אליהם גם את רשימת המתכונים המפורסמים - מתיקית המתכונים המפורסמים.
    var recipeList = Provider.of<List<Recipe>>(context) ?? [];
    //אם לא הגעת מעמוד הבית אין סיבה לטעון את כל המתכונים -
    // לכן מיד נשנה את הערך הבוליאני ל- נכון, ולא נקרא לפונקציה.
    // widget.publisRecipe = [];
    // widget.savedRecipe = [];

    // if ((!widget.doneLoadPublishRecipe) && (!widget.doneLoadSavedRecipe)) {
    //   if (!widget.home) {
    //     print("iinniitt");
    //     widget.doneLoadPublishRecipe = true;
    //     getuser();
    //     print("if");
    //     if (widget.uid != null) {
    //       loadSavedRecipe();
    //     }
    //   } else {
    //     loadPublishRecipe();
    //   }
    //   print("aaaaaaaaaaaaaaaaaaaaa");
    // }
    if (!widget.doneLoadPublishRecipe) {
      return Loading();
    }

    if (widget.doneLoadPublishRecipe) {
      if (widget.publisRecipe != null) {
        recipeList = recipeList + widget.publisRecipe;
      }
      if (widget.doneLoadSavedRecipe) {
        recipeList = recipeList + widget.savedRecipe;
        // print("plus   " + recipeList.length.toString());
      }

      //print("aaaaaaaaaaaaaaaaaaaaa");
      int i;
      List<Recipe> fish = [];
      List<Recipe> other = [];
      List<Recipe> meet = [];
      List<Recipe> dairy = [];
      List<Recipe> desert = [];
      List<Recipe> childern = [];
      List<Recipe> vegetarian = [];
      List<Recipe> glutenfree = [];
      List<Recipe> withoutsugar = [];
      List<Recipe> vegan = [];
      List<Recipe> withoutmilk = [];
      List<Recipe> noeggs = [];
      List<Recipe> kosher = [];
      List<Recipe> baking = [];
      List<Recipe> cakesandcookies = [];

      List<Recipe> foodtoppings = [];
      List<Recipe> salads = [];
      List<Recipe> soups = [];
      List<Recipe> pasta = [];
      List<Recipe> nocarbs = [];
      List<Recipe> spreads = [];
      final db = Firestore.instance;
      Map<String, List> mapCat = {};
      if (recipeList != null) {
        for (int i = 0; i < recipeList.length; i++) {
          if (recipeList[i].tags.length == 0) {
            other.add(recipeList[i]);
          }
          for (int j = 0; j < recipeList[i].tags.length; j++) {
            switch (recipeList[i].tags[j]) {
              case "fish":
                fish.add(recipeList[i]);
                mapCat['fish'] = fish;
                break;
              case "meat":
                meet.add(recipeList[i]);
                mapCat['meat'] = meet;
                break;
              case "dairy":
                dairy.add(recipeList[i]);
                mapCat['dairy'] = dairy;
                break;
              case "desert":
                desert.add(recipeList[i]);
                mapCat['desert'] = desert;
                break;
              case "for children":
                childern.add(recipeList[i]);
                mapCat['for children'] = childern;
                break;
              case "other":
                other.add(recipeList[i]);
                mapCat['other'] = other;
                break;
              case "choose recipe tag":
                other.add(recipeList[i]);
                mapCat['other'] = other;
                break;
              case "vegetarian":
                vegetarian.add(recipeList[i]);
                mapCat['vegetarian'] = vegetarian;
                break;
              case "Gluten free":
                glutenfree.add(recipeList[i]);
                mapCat['Gluten free'] = glutenfree;
                break;
              case "without sugar":
                withoutsugar.add(recipeList[i]);
                mapCat['without sugar'] = withoutsugar;
                break;
              case "vegan":
                vegan.add(recipeList[i]);
                mapCat['vegan'] = vegan;
                break;
              case "Without milk":
                withoutmilk.add(recipeList[i]);
                mapCat['Without milk'] = withoutmilk;
                break;
              case "No eggs":
                noeggs.add(recipeList[i]);
                mapCat['No eggs'] = noeggs;
                break;
              case "baking":
                baking.add(recipeList[i]);
                mapCat['baking'] = baking;
                break;
              case "kosher":
                kosher.add(recipeList[i]);
                mapCat['kosher'] = kosher;
                break;
              case "cakes and cookies":
                cakesandcookies.add(recipeList[i]);
                mapCat['cakes and cookies'] = cakesandcookies;
                break;
              case "Food toppings":
                foodtoppings.add(recipeList[i]);
                mapCat['Food toppings'] = foodtoppings;
                break;
              case "Salads":
                salads.add(recipeList[i]);
                mapCat['Salads'] = salads;
                break;
              case "Soups":
                soups.add(recipeList[i]);
                mapCat['Soups'] = soups;
                break;
              case "Pasta":
                pasta.add(recipeList[i]);
                mapCat['Pasta'] = pasta;
                break;
              case "No carbs":
                nocarbs.add(recipeList[i]);
                mapCat['No carbs'] = nocarbs;
                break;
              case "Spreads":
                spreads.add(recipeList[i]);
                mapCat['Spreads'] = spreads;
                break;
            }
          }
        }
      }
      Future<bool> refresh() async {
        await Future.delayed(Duration(seconds: 3));
        changeState();
        return true;
      }

      Widget categoryButtom(String cat, List listCat) {
        return InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          borderRadius: BorderRadius.circular(5),
          highlightColor: Colors.blueGrey,
          child: Container(
              width: 50,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                //borderRadius: new BorderRadius.circular(30),
                // borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: ExactAssetImage('lib/images/' + cat + ".JPG"),
                    fit: BoxFit.cover),
              ),
              child: FlatButton(onPressed: () async {
                if (widget.uid != null) {
                  DocumentSnapshot snap = await Firestore.instance
                      .collection("users")
                      .document(widget.uid)
                      .get();
                  Map<dynamic, dynamic> tagsCount = snap.data['tags'];
                  print("before pushhhhhhhhhhhhhhhhhh");
                  print(cat);
                  int count = tagsCount[cat];
                  print(count);
                  print(tagsCount);
                  if (count == null) {
                    count = 0;
                  }
                  count++;
                  tagsCount[cat] = count;
                  db
                      .collection('users')
                      .document(widget.uid)
                      .updateData({'tags': tagsCount});
                }
                //print("pushhhhhhhhhhhhhhhhhh");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RecipeList(mapCat, cat, widget.home)));
              })),
        );
      }

      return ListView(shrinkWrap: true, primary: false, children: <Widget>[
        // FlatButton.icon(
        //   color: Colors.blueGrey[400],
        //   icon: Icon(
        //     Icons.refresh,
        //     color: Colors.white,
        //   ),
        //   label: Text(
        //     'Refresh',
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   onPressed: () => {changeState()},
        // ),
        // Folder(recipeList),
        //fish
        SizedBox(
          height: 10.0,
        ),
        RefreshIndicator(
          color: Colors.blue,
          onRefresh: refresh,
          child: Container(
            height: 500,
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(mapCat.length, (index) {
                return Container(
                    height: 500,
                    width: 500,
                    child: Card(
                        shape: RoundedRectangleBorder(side: BorderSide.none),
                        child: categoryButtom(mapCat.keys.elementAt(index),
                            mapCat.values.elementAt(index))));
              }),
            ),
          ),
        )
      ]);
    }
  }

  Future<void> loadPublishRecipe() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    if (user != null) {
      setState(() {
        widget.uid = user.uid;
        // print("set statae user");
      });
    }
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
      // print("i -     " + i.toString());
      //  print(snap.documents.length);
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
    //   print("check");
    //   print(widget.uid);
    //   print(snap.documents.length);
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
      //   print(uid);
      //   print(recipeId);
      //  print(saveInUser);
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
        //   print(n + "   " + de);
        r = Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI, true,
            id, publish, path);
      }
      //from recipe
      else {
        //   print("else" + recipeId);
        //  print(recipeId);
        DocumentSnapshot doc = await Firestore.instance
            .collection('recipes')
            .document(recipeId)
            .get();
        //check if in the user;
        //   print(doc.data.length.toString() +
        //      "   .....................................");
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
        //   print(n + "   " + de);
        r = Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI, false,
            id, publish, path);
      }
      // r.setId(id);
      // print(publish + "publish");
      //r.publishThisRecipe(publish);
      widget.savedRecipe.add(r);
      //  print("plus ");
      // print(r.publish);
      i++;

      // print(snap.documents.length);
      if ((i) == snap.documents.length) {
        setState(() {
          widget.doneLoadSavedRecipe = true;
          //      print("done save");
        });
      }
    });
  }
}
