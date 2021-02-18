import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screen/home_screen/recipeHeadLine.dart';

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<List<Recipe>>(context);

    return ListView.builder(
      itemCount: recipe.length,
      itemBuilder: (context, index) {
        return RecipeHeadLine(recipe[index]);
      },
    );

    return Container();
  }
}
