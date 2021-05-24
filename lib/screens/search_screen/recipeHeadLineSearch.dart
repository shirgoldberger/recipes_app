import 'package:flutter/material.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipes/watch_recipes/watchRecipe.dart';
import 'package:recipes_app/services/fireStorageService.dart';

// ignore: must_be_immutable
class RecipeHeadLineSearch extends StatefulWidget {
  Recipe recipe;
  Color circleColor;
  String level;
  bool home;
  Color colorName = Colors.blueGrey[700];
  NetworkImage image;
  String imagePath = "";
  RecipeHeadLineSearch(Recipe r, bool home) {
    this.recipe = r;
    this.home = home;
    imagePath = r.imagePath;
    switch (r.time) {
      case 1:
        circleColor = Colors.green[400];
        level = 'Easy';
        break;
      case 2:
        circleColor = Colors.yellow[400];
        level = 'Medium';
        break;
      case 3:
        circleColor = Colors.red[400];
        level = 'Hard';
        break;
      case 0:
        circleColor = Colors.grey[400];
        level = 'Easy';
        break;
    }
  }
  @override
  _RecipeHeadLineSearchState createState() => _RecipeHeadLineSearchState();
}

class _RecipeHeadLineSearchState extends State<RecipeHeadLineSearch> {
  @override
  Widget build(BuildContext context) {
    _getImage(context);
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        borderRadius: BorderRadius.circular(5),
        highlightColor: Colors.blueGrey,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WatchRecipe(widget.recipe, widget.home, widget.image)));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                // image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  child: Image(
                    height: 135,
                    image: (widget.image == null)
                        ? ExactAssetImage(noImagePath)
                        : widget.image,
                  ),
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // name
                    recipeName(),
                    //SizedBox(height: 5.0),
                    Container(
                        // description

                        ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _getImage(BuildContext context) async {
    if (widget.imagePath == "") {
      return null;
    }
    String image = "uploads/" + widget.imagePath;
    String downloadUrl =
        await FireStorageService.loadFromStorage(context, image);
    setState(() {
      widget.image = NetworkImage(downloadUrl);
    });
  }

  Widget recipeName() {
    return Text(
      widget.recipe.name + " / " + widget.recipe.writer,
      style: TextStyle(
        color: widget.colorName,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Raleway',
      ),
    );
  }

  Widget recipeLevel() {
    return Container(
      width: 60.0,
      height: 20.0,
      decoration: BoxDecoration(
        color: widget.circleColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      alignment: Alignment.center,
      child: Text(
        widget.level,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
