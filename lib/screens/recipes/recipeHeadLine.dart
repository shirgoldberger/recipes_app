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
  String time;
  bool home;
  Color colorName = Colors.blue;
  String imagePath = "";
  NetworkImage image;
  String directory;
  RecipeHeadLine(Recipe _recipe, bool home, String directory) {
    this.recipe = _recipe;
    this.home = home;
    imagePath = recipe.imagePath;
    this.directory = directory;
    setLevelColor();
    setTimeText();
  }

  setLevelColor() {
    switch (recipe.level) {
      case 1:
        circleColor = Colors.green[400];
        level = 'Easy';
        break;
      case 2:
        circleColor = Colors.yellow[400];
        level = 'Medium';
        break;
      case 3:
        circleColor = Colors.pink[400];
        level = 'Hard';
        break;
      case 0:
        circleColor = Colors.grey[400];
        level = 'Easy';
        break;
    }
  }

  setTimeText() {
    switch (recipe.time) {
      case 1:
        time = 'Until half-hour';
        break;
      case 2:
        time = 'Until hour';
        break;
      case 3:
        time = 'Over an hour';
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
    _getImage(context);
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        borderRadius: BorderRadius.circular(5),
        highlightColor: Colors.blueGrey[100],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WatchRecipe(widget.recipe, widget.home,
                      widget.image, widget.directory)));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 10.0),
                // image
                CircleAvatar(
                  backgroundImage: (widget.image == null)
                      ? ExactAssetImage(noImagePath)
                      : widget.image,
                  radius: 35.0,
                ),
                SizedBox(width: 20.0),
                // name
                recipeName(),
              ],
            ),
            Column(
              children: <Widget>[
                recipeWriter(),
                SizedBox(height: 5.0),
                // level
                recipeLevel(),
                heightBox(5),
                recipeTime()
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _getImage(BuildContext context) async {
    if (widget.imagePath == "" || widget.image != null) {
      return;
    }
    String downloadUrl = await FireStorageService.loadFromStorage(
        context, "uploads/" + widget.imagePath);
    setState(() {
      widget.image = NetworkImage(downloadUrl);
    });
  }

  Widget recipeName() {
    return Text(
      widget.recipe.name == "" ? "This recipe has no name" : widget.recipe.name,
      style: TextStyle(
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

  Widget recipeTime() {
    return Text(
      widget.time,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
