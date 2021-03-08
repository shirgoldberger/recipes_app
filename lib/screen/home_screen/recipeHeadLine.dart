import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';

import 'package:recipes_app/screen/home_screen/watchRecipe.dart';

class RecipeHeadLine extends StatelessWidget {
  Recipe recipe;
  Color circleColor;
  bool home;
  RecipeHeadLine(Recipe r, bool home) {
    this.recipe = r;
    this.home = home;
    switch (r.time) {
      case 1:
        circleColor = Colors.green[400];
        break;
      case 2:
        circleColor = Colors.yellow[400];
        break;
      case 3:
        circleColor = Colors.pink[400];
        break;
      case 0:
        circleColor = Colors.grey[400];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8),
        child: InkWell(
            onTap: () {
              print("Card Clicked");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WatchRecipe(recipe, home)));
            },
            child: new Card(
              margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: circleColor,
                ),
                title: Text(recipe.name),
                subtitle: Text(recipe.id),
              ),
            )));
  }
}
