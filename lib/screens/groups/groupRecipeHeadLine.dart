import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import '../../config.dart';
import '../recipes/watch_recipes/watchRecipeGroup.dart';
import 'package:recipes_app/services/fireStorageService.dart';

// ignore: must_be_immutable
class GroupRecipeHeadLine extends StatelessWidget {
  Recipe recipe;
  Color circleColor;
  String level;
  String groupId;
  String time;
  String image = "";

  GroupRecipeHeadLine(Recipe r, String _groupId) {
    this.recipe = r;
    this.groupId = _groupId;
    image = r.imagePath;
    setLevelColor();
    setTimeText();
  }

  setLevelColor() {
    switch (recipe.level) {
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

  Future<Widget> getImage(BuildContext context) async {
    if (image == "") {
      return null;
    }
    Image m;
    await FireStorageService.loadFromStorage(context, "uploads/" + image)
        .then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });

    return m;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      child: InkWell(
        highlightColor: Colors.blueGrey,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WatchRecipeGroup(recipe, groupId)));
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
      child: FutureBuilder(
          future: getImage(context),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return Container(
                child: snapshot.data,
              );
            if (snapshot.connectionState == ConnectionState.waiting)
              return Container(
                  height: MediaQuery.of(context).size.height / 1.25,
                  width: MediaQuery.of(context).size.width / 1.25,
                  child: CircularProgressIndicator());
          }),
      radius: 35.0,
    );
  }

  Widget recipeName() {
    return Text(
      recipe.name,
      style: TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Raleway'),
    );
  }

  Widget recipeWriter() {
    return Text(
      recipe.writer,
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
        color: circleColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      alignment: Alignment.center,
      child: Text(
        level,
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
      time,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
