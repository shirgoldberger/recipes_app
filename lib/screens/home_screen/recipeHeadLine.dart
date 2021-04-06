import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';

import 'package:recipes_app/screens/home_screen/watchRecipe.dart';

class RecipeHeadLine extends StatelessWidget {
  Recipe recipe;
  Color circleColor;
  String level;
  bool home;
  RecipeHeadLine(Recipe r, bool home) {
    this.recipe = r;
    this.home = home;
    switch (r.time) {
      case 1:
        circleColor = Colors.green[400];
        level = 'easy';
        break;
      case 2:
        circleColor = Colors.yellow[400];
        level = 'medium';
        break;
      case 3:
        circleColor = Colors.pink[400];
        level = 'hard';
        break;
      case 0:
        circleColor = Colors.grey[400];
        level = 'easy';
        break;
    }
    // print("head line");
    // print(r.publish);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      child: InkWell(
        // splashColor: Colors.yellow,
        // highlightColor: Colors.blue,
        onTap: () {
          //("Card Clicked");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WatchRecipe(recipe, home)));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 35.0,
                  backgroundImage: AssetImage('lib/images/chef.png'),
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      recipe.name,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        recipe.description,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  recipe.writer,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  width: 80.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: circleColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  // hard();
                  alignment: Alignment.center,
                  child: Text(
                    level,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
