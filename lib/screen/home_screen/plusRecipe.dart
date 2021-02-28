import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screen/home_screen/ListIngredients.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screen/home_screen/ingredients.dart';
import 'package:recipes_app/models/ingresients.dart';

class PlusRecipe extends StatefulWidget {
  final db = Firestore.instance;
  final Function toggleView;
  PlusRecipe({this.toggleView});
  @override
  _PlusRecipeState createState() => _PlusRecipeState();
}

class _PlusRecipeState extends State<PlusRecipe> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  List<IngredientsModel> ingredientsList = [];
  bool loading = false;
  //text field state
  String recipe_name = '';
  String recipe_description = '';
  int count = 0;
  List<IngredientsModel> ingredients = [];

  @override
  Widget build(BuildContext context) {
    final db = Firestore.instance;
    final user = Provider.of<User>(context);
    if (loading) {
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
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.save),
                      label: Text('save this recipe'),
                      onPressed: () async {
                        Recipe recipe = Recipe(recipe_name, recipe_description);
                        var currentRecipe = await db
                            .collection('users')
                            .document(user.uid)
                            .collection('recipes')
                            .add(recipe.toJson());
                        print(user.uid);
                        print(currentRecipe.documentID.toString());
                        String id = currentRecipe.documentID.toString();
                        for (int i = 0; i < ingredients.length; i++) {
                          await db
                              .collection('users')
                              .document(user.uid)
                              .collection('recipes')
                              .document(id)
                              .collection('ingredients')
                              .add(ingredients[i].toJson());
                        }
                      },
                    ),
                  ]),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Flexible(
                          child: ListView(
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Recipe name',
                            ),
                            validator: (val) =>
                                val.isEmpty ? 'Enter a recipe name' : null,
                            onChanged: (val) {
                              setState(() => recipe_name = val);
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Description',
                            ),
                            validator: (val) => val.length < 6
                                ? 'Enter a description eith 6 letter at least'
                                : null,
                            onChanged: (val) {
                              setState(() => recipe_description = val);
                            },
                          ),
                          Row(children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                  height: 37.0,
                                  child: Text(
                                      "push on the + to add more Ingredients")),
                            ),
                            FloatingActionButton(
                              heroTag: "btn2",
                              child: Icon(Icons.add),
                              onPressed: addIng,
                              foregroundColor: Colors.white,
                            ),
                          ]),
                          Container(
                            child: Column(
                              children: [
                                ingredients.length <= 0
                                    ? Text(
                                        'there is no Ingredients in this recipe')
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        addAutomaticKeepAlives: true,
                                        itemCount: ingredients.length,
                                        itemBuilder:
                                            (_, i) => Row(children: <Widget>[
                                                  Expanded(
                                                      child: SizedBox(
                                                          height: 37.0,
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Ingredient',
                                                            ),
                                                            validator: (val) =>
                                                                val.length < 2
                                                                    ? 'Enter a description eith 2 letter at least'
                                                                    : null,
                                                            onChanged: (val) {
                                                              setState(() =>
                                                                  ingredients[i]
                                                                          .name =
                                                                      val);
                                                            },
                                                          ))),
                                                  Expanded(
                                                      child: SizedBox(
                                                          height: 37.0,
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'amount',
                                                            ),
                                                            validator: (val) =>
                                                                val.length < 6
                                                                    ? 'Enter a description eith 6 letter at least'
                                                                    : null,
                                                            onChanged: (val) {
                                                              setState(() =>
                                                                  ingredients[i]
                                                                          .count =
                                                                      int.parse(
                                                                          val));
                                                            },
                                                          ))),
                                                  Expanded(
                                                      child: SizedBox(
                                                          height: 37.0,
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              hintText: 'unit',
                                                            ),
                                                            validator: (val) =>
                                                                val.length < 6
                                                                    ? 'Enter a description eith 6 letter at least'
                                                                    : null,
                                                            onChanged: (val) {
                                                              setState(() =>
                                                                  ingredients[i]
                                                                          .unit =
                                                                      val);
                                                            },
                                                          ))),
                                                ])),
                              ],
                            ),
                          ),
                        ],
                      ))
                    ])),
              ),
            )),
      );
    }
  }

  void onDelete(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  void addIng() {
    setState(() {
      ingredients.add(IngredientsModel());
    });
  }

  void onSave() {}
}