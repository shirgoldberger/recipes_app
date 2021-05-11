import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipes/recipesFolder.dart';
import 'package:recipes_app/services/dataBaseAllRecipe.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final db = Firestore.instance;
  //final AuthService _auth = AuthService();
  //var user;

  // final FirebaseAuth auth = FirebaseAuth.instance;

  // void inputData() async {
  //   final FirebaseUser user = await auth.currentUser();
  //   final uid = user.uid;
  //   print("///////////////////////////");
  //   print(uid);
  //   // here you write the codes to input the data into firestore
  // }

  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return StreamProvider<List<Recipe>>.value(
        value: DataBaseAllRecipes().allRecipe,
        child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text(
                'cook book',
                style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
              ),
              backgroundColor: appBarBackgroundColor,
              elevation: 0.0,
            ),
            body: RecipeFolder(true)));
  }
}
