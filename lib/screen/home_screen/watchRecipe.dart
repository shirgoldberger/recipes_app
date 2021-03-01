import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screen/home_screen/ingredients.dart';
import 'package:recipes_app/shared_screen/loading.dart';

class WatchRecipe extends StatefulWidget {
  WatchRecipe(Recipe r) {
    this.current = r;
  }
  List<IngredientsModel> ing = [];
  Recipe current;
  bool done = false;
  int count = 0;
  @override
  _WatchRecipeState createState() => _WatchRecipeState();
}

class _WatchRecipeState extends State<WatchRecipe> {
  var i;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    makeList();
    if (!widget.done) {
      return Loading();
    } else {
      return Container(
          height: 100,
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Scaffold(
                  backgroundColor: Colors.brown[100],
                  appBar: AppBar(
                    backgroundColor: Colors.brown[400],
                    elevation: 0.0,
                    title: Text('add new recipe'),
                  ),
                  body: Container(
                      child: new Column(children: [
                    Center(
                      child: new Text(
                        widget.current.name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.brown[900],
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                            fontSize: 40),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 15.0)),
                    new Text(
                      widget.current.description,
                      style: TextStyle(
                          color: Colors.brown[900],
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                          fontSize: 30),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 15.0)),
                    new Text(
                      'ingredients for the recipe:',
                      style: new TextStyle(color: Colors.brown, fontSize: 25.0),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10.0)),
                    Column(
                      children: <Widget>[
                        for (var i = 0; i < widget.ing.length; i++)
                          Text(
                            (i + 1).toString() +
                                "." +
                                "  " +
                                widget.ing[i].count.toString() +
                                " " +
                                widget.ing[i].unit.toString() +
                                " " +
                                widget.ing[i].name.toString(),
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                color: Colors.brown, fontSize: 25.0),
                          ),
                      ],
                    )
                  ])))));
    }
  }

  void a() {}

  Future<void> makeList() async {
    if (!widget.done) {
      final user = Provider.of<User>(context);
      List<IngredientsModel> ingredients = [];
      QuerySnapshot snap = await Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('recipes')
          .document(widget.current.id.toString())
          .collection('ingredients')
          .getDocuments();
      snap.documents.forEach((element) {
        print(element.data.toString());
        setState(() {
          widget.ing.add(IngredientsModel.antherConstactor(
              element.data['name'] ?? '',
              element.data['count'] ?? 0,
              element.data['unit'] ?? ''));
        });
      });

      setState(() {
        widget.done = true;
      });
    }
  }
}
