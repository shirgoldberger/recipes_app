import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/home_screen/recipesFolder.dart';
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
    //inputData();
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
            body: RecipeFolder(true)));
  }
}
