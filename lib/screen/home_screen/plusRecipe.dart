import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import 'package:provider/provider.dart';

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
  bool loading = false;
  //text field state
  String recipe_name = '';
  String recipe_description = '';

  @override
  Widget build(BuildContext context) {
    final db = Firestore.instance;
    final user = Provider.of<User>(context);
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('add new recipe'),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Recipe name',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.brown[600], width: 2.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.brown[600], width: 2.0)),
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
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.brown[600], width: 2.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.brown[600], width: 2.0)),
                      ),
                      obscureText: true,
                      validator: (val) => val.length < 6
                          ? 'Enter a description eith 6 letter at least'
                          : null,
                      onChanged: (val) {
                        setState(() => recipe_description = val);
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                        color: Colors.pink[300],
                        child: Text(
                          'save tis recipe',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          Recipe recipe =
                              Recipe(recipe_name, recipe_description);
                          await db
                              .collection('users')
                              .document(user.uid)
                              .collection('recipes')
                              .add(recipe.toJson());
                        }),
                  ],
                ),
              ),
            ));
  }
}
