import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';

import 'package:recipes_app/screens/home_screen/watchRecipe.dart';
import 'package:recipes_app/screens/home_screen/watchRecipe2.dart';
import 'package:recipes_app/services/fireStorageService.dart';

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
  }
  @override
  _RecipeHeadLineState createState() => _RecipeHeadLineState();
}

class _RecipeHeadLineState extends State<RecipeHeadLine> {
  @override
  Widget build(BuildContext context) {
    _getImage(context, widget.image);
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      child: InkWell(
        highlightColor: Colors.blueGrey,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WatchRecipe2(widget.recipe, widget.home)));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                // image
                CircleAvatar(
                  backgroundImage: (widget.image == "")
                      ? ExactAssetImage('lib/images/no_image.jpg')
                      : NetworkImage(widget.image),
                  radius: 35.0,
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // name
                    Text(
                      widget.recipe.name == ""
                          ? "This recipe has no name"
                          : widget.recipe.name,
                      style: TextStyle(
                        color: widget.colorName,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      // description
                      child: Text(
                        widget.recipe.description == ""
                            ? "This recipe has no description"
                            : widget.recipe.description,
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
                  widget.recipe.writer,
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
                )
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
}
