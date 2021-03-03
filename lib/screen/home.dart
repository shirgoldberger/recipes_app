import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/userInformation.dart';
import 'package:recipes_app/screen/Setting_form.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screen/home_screen/RecipeList.dart';
import 'package:recipes_app/screen/home_screen/logIn/log_in_wrapper.dart';
import 'package:recipes_app/screen/home_screen/plusRecipe.dart';
import 'package:recipes_app/screen/home_screen/recipesFolder.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/services/dataBaseAllRecipe.dart';
import 'package:recipes_app/services/database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final db = Firestore.instance;
  final AuthService _auth = AuthService();

  User user;
  // HomeLogIn(User u) {
  //   user = u;
  // }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Recipe>>.value(
        value: DataBaseAllRecipes().allRecipe,
        child: Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              title: Text('cook book'),
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              actions: <Widget>[],
            ),
            body: RecipeFolder()));
  }
}
