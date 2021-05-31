/// the home page - recipes by tags ///

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/shared_screen/config.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipes/recipesFolder.dart';
import 'package:recipes_app/services/dataBaseAllRecipe.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return StreamProvider<List<Recipe>>.value(
        value: DataBaseAllRecipes().allRecipe,
        child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text(
                'Cook Book',
                style: TextStyle(fontFamily: logoFont, color: Colors.white),
              ),
              backgroundColor: appBarBackgroundColor,
              elevation: 0.0,
            ),
            body: RecipeFolder(true)));
  }
}
