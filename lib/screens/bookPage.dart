import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/directory.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/newDirectory.dart';
import 'package:recipes_app/screens/personal_screen/logIn/register.dart';
import 'package:recipes_app/screens/recipes/recipesFolder.dart';
import 'package:recipes_app/services/database.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import '../main.dart';

// ignore: must_be_immutable
class RecipesBookPage extends StatefulWidget {
  static String tag = 'book-page';
  bool done = false;
  List<Directory> directorys = [];
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
    if (!widget.done) {
      getdirectory();
      return Loading();
    } else {
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
                  backgroundColor: Colors.blueGrey[700],
                  elevation: 0.0,
                  actions: <Widget>[],
                ),
                body: Column(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.focused))
                            return Colors.red;
                          return null; // Defer to the widget's default.
                        }),
                      ),
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NewDirectory(widget.user)))
                            .then((value) => getdirectory());
                      },
                      child: Text('TextButton'),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            top: 1, bottom: 1, left: 5, right: 5),
                        itemCount: widget.directorys.length,
                        itemBuilder: (context, index) {
                          return Text(widget.directorys[index].name);
                        })
                  ],
                )));
      }
    }
  }

  Widget appBar() {
    return AppBar(
      title: Text(
        'Cook Book',
        style: TextStyle(fontFamily: logoFont),
      ),
      backgroundColor: appBarBackgroundColor,
      elevation: 0.0,
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

  getdirectory() async {
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
      print(name);
      print(recipes);
      Directory d = Directory(name: name, recipes: recipes);
      setState(() {
        widget.directorys.add(d);
      });
    });
    setState(() {
      widget.done = true;
    });
  }
}
