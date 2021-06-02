import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/services/userFromDB.dart';
import 'package:recipes_app/shared_screen/config.dart';
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
  bool done = false;
  List<Recipe> savedRecipe = [];
  List<Recipe> myRecipe = [];
  List<Directory> directorys = [];
  int doneLoadSavedRecipe = 0;
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
    // no user connected
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
                    'My Cook Book',
                    style: TextStyle(
                        fontFamily: logoFont, color: Colors.grey[700]),
                  ),
                  backgroundColor: Colors.blueGrey[50],
                  actions: [addDirectory()],
                ),
                body: Column(
                  children: [
                    heightBox(10),
                    Row(
                      children: [
                        widthBox(10),
                        categoryButtomFavorite(
                            'lib/images/favorite.JPG', "favorites"),
                        widthBox(10),
                        categoryButtomICreate(
                            'lib/images/i_created.JPG', "My Recipes"),
                      ],
                    ),
                    heightBox(10),
                    titleDirectory(),
                    heightBox(10),
                    DirectoriesList(widget.directorys, widget.user)
                  ],
                )));
      }
    }
  }

  Widget titleDirectory() {
    return Text(
        // add the name of the user
        "Your Directories:",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w900,
            fontFamily: 'Raleway',
            fontSize: 25));
  }

  Widget categoryButtomFavorite(String image, String name) {
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
          // ignore: missing_required_param
          child: FlatButton(onPressed: () async {
            BuildContext dialogContext;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                dialogContext = context;
                return WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        backgroundColor: Colors.black87,
                        content: loadingIndicator()));
              },
            );
            await loadSavedRecipe();
            Navigator.pop(dialogContext);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DirectoryRecipesList(
                        Directory(
                          recipes: widget.savedRecipe,
                          name: name,
                        ),
                        widget.user,
                        false,
                        "favorite")));
          })),
    );
  }

  Widget categoryButtomICreate(String image, String name) {
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
          // ignore: deprecated_member_use
          child: FlatButton(onPressed: () async {
            BuildContext dialogContext;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                dialogContext = context;
                return WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        backgroundColor: Colors.black87,
                        content: loadingIndicator()));
              },
            );
            await loadCreatesdRecipe();
            if (dialogContext != null) {
              Navigator.pop(dialogContext);
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DirectoryRecipesList(
                        Directory(
                            recipes: widget.myRecipe, name: name, id: '0'),
                        widget.user,
                        false,
                        "")));
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
    BuildContext context1 = context;
    try {
      widget.directorys = [];
      QuerySnapshot directories =
          await UserFromDB.getUserDirectories(widget.user);

      for (int i = 0; i < directories.documents.length; i++) {
        String name = directories.documents[i].data['name'] ?? '';
        Map<dynamic, dynamic> recipes =
            directories.documents[i].data['Recipes'] ?? {};
        String id = directories.documents[i].documentID.toString();

        Directory d = Directory(id: id, name: name, recipesId: recipes);
        setState(() {
          widget.directorys.add(d);
        });
      }
      setState(() {
        widget.done = true;
      });
    } catch (e) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Something wrong.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Phoenix.rebirth(context1);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> loadSavedRecipe() async {
    BuildContext context1 = context;
    try {
      setState(() {
        widget.savedRecipe = [];
      });
      String uid;
      String recipeId;

      QuerySnapshot savedRecipes =
          await UserFromDB.getUserSavedRecipes(widget.user);

      if (savedRecipes.documents.length == 0) {
        setState(() {
          widget.doneLoadSavedRecipe = 2;
        });
      }
      for (int i = 0; i < savedRecipes.documents.length; i++) {
        uid = savedRecipes.documents[i].data['userID'] ?? '';
        recipeId = savedRecipes.documents[i].data['recipeID'] ?? '';
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
        if ((i) == savedRecipes.documents.length) {
          setState(() {
            widget.doneLoadSavedRecipe++;
          });
        }
      }
    } catch (e) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Something wrong.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Phoenix.rebirth(context1);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget addDirectory() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
      icon: Icon(Icons.create_new_folder, color: Colors.grey[700]),
      label: Text('Plus', style: TextStyle(color: Colors.grey[700])),
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

  Future<void> loadCreatesdRecipe() async {
    BuildContext context1 = context;
    try {
      setState(() {
        widget.myRecipe = [];
      });
      QuerySnapshot recipes = await UserFromDB.getUserRecipes(widget.user);
      for (int i = 0; i < recipes.documents.length; i++) {
        Recipe r = RecipeFromDB.convertSnapshotToRecipe(recipes.documents[i]);
        setState(() {
          widget.myRecipe.add(r);
        });
      }
    } catch (e) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Something wrong.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Phoenix.rebirth(context1);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
