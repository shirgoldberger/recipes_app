import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screen/home_screen/watchRecipe.dart';

class RecipeHeadLine extends StatelessWidget {
  Recipe recipe;
  RecipeHeadLine(Recipe r) {
    this.recipe = r;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8),
        child: InkWell(
          onTap: () {
            print("Card Clicked");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WatchRecipe(recipe)));
          },
          child: new Card(
            margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.brown[800],
              ),
              title: Text(recipe.name),
              subtitle: Text(recipe.id),
            ),
          ),
        ));
  }
}
