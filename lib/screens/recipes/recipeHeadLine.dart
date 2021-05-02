import 'package:flutter/material.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/recipe.dart';
import 'watch_recipes/watchRecipe.dart';
import 'package:recipes_app/services/fireStorageService.dart';

// ignore: must_be_immutable
class RecipeHeadLine extends StatefulWidget {
  Recipe recipe;
  Color circleColor;
  String level;
  bool home;
  Color colorName = Colors.blue;
  String image = "";
  RecipeHeadLine(Recipe r, bool home) {
    this.recipe = r;
    this.home = home;
    image = r.imagePath;
    switch (r.level) {
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
        circleColor = Colors.green[400];
        level = 'easy';
        break;
    }
  }
  @override
  _RecipeHeadLineState createState() => _RecipeHeadLineState();
}

class _RecipeHeadLineState extends State<RecipeHeadLine> {
  @override
  void didUpdateWidget(RecipeHeadLine oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _getImage(context, widget.image);
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        borderRadius: BorderRadius.circular(5),
        highlightColor: Colors.blueGrey[100],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WatchRecipe(widget.recipe, widget.home)));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                // image
                CircleAvatar(
                  backgroundImage: (widget.image == "")
                      ? ExactAssetImage(noImagePath)
                      : NetworkImage(widget.image),
                  radius: 35.0,
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // name
                    recipeName(),
                    SizedBox(height: 5.0),
                    Container(
                      // description
                      child: recipeWriter(),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                // writer

                SizedBox(height: 5.0),
                // level
                recipeLevel()
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _getImage(BuildContext context, String image) async {
    if (image == "") {
      setState(() {
        widget.image = "";
      });
      return null;
    }
    image = "uploads/" + image;
    String downloadUrl =
        await FireStorageService.loadFromStorage(context, image);
    setState(() {
      widget.image = downloadUrl;
    });
  }

  Widget recipeName() {
    return Text(
      widget.recipe.name == "" ? "This recipe has no name" : widget.recipe.name,
      style: TextStyle(
        color: widget.colorName,
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget recipeDescription() {
    return Text(
      widget.recipe.description == ""
          ? "This recipe has no description"
          : widget.recipe.description,
      style: TextStyle(
        color: Colors.blueGrey,
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget recipeWriter() {
    return Text(
      widget.recipe.writer,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget recipeLevel() {
    return Container(
      width: 80.0,
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
