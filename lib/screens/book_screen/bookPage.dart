import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/directory.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/services/database.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import 'directoriesList.dart';
import 'directoryRecipesList.dart';
import 'newDirectory.dart';

// ignore: must_be_immutable
class RecipesBookPage extends StatefulWidget {
  static String tag = 'book-page';
  bool done = false;
  List<Recipe> savedRecipe = [];
  List<Recipe> myRecipe = [];
  List<Directory> directorys = [];
  int doneLoadSavedRecipe = 0;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey);
  String user;
  RecipesBookPage(String _user) {
    user = _user;
  }

  @override
  _RecipesBookPageState createState() => _RecipesBookPageState();
}

class _RecipesBookPageState extends State<RecipesBookPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.user == "") {
      return Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(),
          body: Column(
            children: [
              box,
              title(),
              box,
            ],
          ));
    } else {
      if (!widget.done) {
        getdirectory();
        return Loading();
      } else {
        // ignore: missing_required_param
        return StreamProvider<List<Recipe>>.value(
            value: DataBaseService(widget.user).recipe,
            child: Scaffold(
                backgroundColor: Colors.blueGrey[50],
                appBar: AppBar(
                  title: Text(
                    'My Book',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                    ),
                  ),
                  backgroundColor: appBarBackgroundColor,
                  actions: [addDirectory()],
                ),
                body: Column(
                  children: [
                    heightBox(10),
                    Row(
                      children: [
                        widthBox(10),
                        categoryButtom('lib/images/favorite.JPG',
                            widget.savedRecipe, "favorites"),
                        widthBox(10),
                        categoryButtom('lib/images/i_created.JPG',
                            widget.myRecipe, "I created"),
                      ],
                    ),
                    heightBox(10),
                    DirectoriesList(widget.directorys, widget.user)
                  ],
                )));
      }
    }
  }

  Widget categoryButtom(String image, List recipes, String name) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      borderRadius: BorderRadius.circular(5),
      highlightColor: Colors.blueGrey,
      child: Container(
          width: 190,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey[50],
            image: DecorationImage(
                image: ExactAssetImage(image), fit: BoxFit.cover),
          ),
          child: FlatButton(onPressed: () async {
            await loadSavedRecipe();
            print(recipes);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DirectoryRecipesList(
                        Directory(recipes: recipes, name: name), widget.user)));
          })),
    );
  }

  Widget appBar() {
    return AppBar(
      title: Text(
        'Cook Book',
        style: TextStyle(fontFamily: logoFont),
      ),
      backgroundColor: appBarBackgroundColor,
    );
  }

  Widget title() {
    return Text(
      'Hello!\n If you want to create recipes book, you need to log in or sign up first.',
      style:
          TextStyle(fontFamily: ralewayFont, fontSize: 20, color: titleColor),
      textAlign: TextAlign.center,
    );
  }

  void getdirectory() async {
    setState(() {
      widget.directorys = [];
    });
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.user)
        .collection('Directory')
        .getDocuments();

    snap.documents.forEach((element) async {
      String name = element.data['name'] ?? '';
      List recipes = element.data['Recipes'] ?? [];
      String id = element.documentID.toString();

      Directory d = Directory(id: id, name: name, recipesId: recipes);
      setState(() {
        widget.directorys.add(d);
      });
    });
    setState(() {
      widget.done = true;
    });
  }

  Future<void> loadSavedRecipe() async {
    setState(() {
      widget.savedRecipe = [];
      widget.myRecipe = [];
    });
    String uid;
    String recipeId;

    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.user)
        .collection('saved recipe')
        .getDocuments();

    if (snap.documents.length == 0) {
      setState(() {
        widget.doneLoadSavedRecipe = 2;
      });
    }
    int i = 0;
    for (int i = 0; i < snap.documents.length; i++) {
      uid = snap.documents[i].data['userID'] ?? '';
      recipeId = snap.documents[i].data['recipeID'] ?? '';
      print(i);

      Recipe r = await RecipeFromDB.getRecipeOfUser(uid, recipeId);

      bool check = false;
      for (int i = 0; i < widget.savedRecipe.length; i++) {
        if (widget.savedRecipe[i].id == r.id) {
          check = true;
        }
      }
      if (!check) {
        setState(() {
          widget.savedRecipe.add(r);
        });
      }
      i++;
      if ((i) == snap.documents.length) {
        setState(() {
          widget.doneLoadSavedRecipe++;
        });
      }
    }

    // QuerySnapshot snap2 = await Firestore.instance
    //     .collection('users')
    //     .document(widget.user)
    //     .collection('recipes')
    //     .getDocuments();
    // int j = 0;
    // snap.documents.forEach((element) async {
    //   j++;

    //   Recipe r = RecipeFromDB.convertSnapshotToRecipe(element);

    //   setState(() {
    //     widget.myRecipe.add(r);
    //   });
    //   if ((j) == snap2.documents.length) {
    //     setState(() {
    //       widget.doneLoadSavedRecipe++;
    //     });
    //   }
    // });
    // print("333");
    // print(widget.savedRecipe);
  }

  Widget addDirectory() {
    return FlatButton.icon(
      icon: Icon(Icons.create_new_folder, color: Colors.white),
      label: Text('Plus', style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NewDirectory(widget.user, widget.directorys)))
            .then((value) => getdirectory());
      },
    );
  }
}
