/// row with details about the recipe (int the group recipes list) ///

import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import '../../shared_screen/config.dart';
import '../recipes/watch_recipes/watchRecipeGroup.dart';
import 'package:recipes_app/services/fireStorageService.dart';

// ignore: must_be_immutable
class GroupRecipeHeadLine extends StatefulWidget {
  Recipe recipe;
  String groupId;
  String imagePath = "";
  Color circleColor;
  String level;
  String time = '';
  NetworkImage image;

  GroupRecipeHeadLine(Recipe r, String _groupId) {
    this.recipe = r;
    this.groupId = _groupId;
    imagePath = r.imagePath;
  }

  @override
  _GroupRecipeHeadLineState createState() => _GroupRecipeHeadLineState();
}

class _GroupRecipeHeadLineState extends State<GroupRecipeHeadLine> {
  void initState() {
    super.initState();
    setLevelColor();
    setTimeText();
  }

  @override
  Widget build(BuildContext context) {
    getImage(context);
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      child: InkWell(
        highlightColor: Colors.blueGrey,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WatchRecipeGroup(
                      widget.recipe, widget.groupId, widget.image)));
        },
        child: recipeRow(context),
      ),
    );
  }

  Widget recipeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            recipeImage(context),
            widthBox(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                recipeName(),
                heightBox(5),
              ],
            ),
          ],
        ),
        Column(
          children: <Widget>[
            recipeWriter(),
            heightBox(5),
            recipeLevel(),
            heightBox(5),
            recipeTime()
          ],
        ),
      ],
    );
  }

  Widget recipeImage(BuildContext context) {
    return CircleAvatar(
      backgroundImage:
          (widget.image == null) ? ExactAssetImage(noImagePath) : widget.image,
      radius: 35.0,
    );
  }

  Widget recipeName() {
    return Text(
      widget.recipe.name,
      style: TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Raleway'),
    );
  }

  Widget recipeWriter() {
    return Text(
      widget.recipe.writer,
      style: TextStyle(
          color: Colors.grey,
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Raleway'),
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

  setLevelColor() {
    switch (widget.recipe.level) {
      case 1:
        widget.circleColor = Colors.green[400];
        widget.level = 'easy';
        break;
      case 2:
        widget.circleColor = Colors.yellow[400];
        widget.level = 'medium';
        break;
      case 3:
        widget.circleColor = Colors.pink[400];
        widget.level = 'hard';
        break;
      case 0:
        widget.circleColor = Colors.grey[400];
        widget.level = 'easy';
        break;
    }
  }

  setTimeText() {
    switch (widget.recipe.time) {
      case 1:
        widget.time = 'Until half-hour';
        break;
      case 2:
        widget.time = 'Until hour';
        break;
      case 3:
        widget.time = 'Over an hour';
        break;
    }
  }

  Future<void> getImage(BuildContext context) async {
    if (widget.imagePath == "" || widget.image != null) {
      return;
    }
    await FireStorageService.loadFromStorage(
            context, "uploads/" + widget.imagePath)
        .then((downloadUrl) {
      if (downloadUrl != null) {
        setState(() {
          widget.image = NetworkImage(downloadUrl.toString());
        });
      }
    });
  }
}
