import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import '../recipes/watch_recipes/watchRecipeGroup.dart';
import 'package:recipes_app/services/fireStorageService.dart';

class GroupRecipeHeadLine extends StatelessWidget {
  Recipe recipe;
  Color circleColor;
  String level;
  String groupId;

  String image = "";
  GroupRecipeHeadLine(Recipe r, String _groupId) {
    this.recipe = r;
    this.groupId = _groupId;

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
    // print("head line");
    // print(r.publish);
  }
  Future<Widget> _getImage(BuildContext context, String image) async {
    print("imageeeeeeeeeeeeeeeeeeeee " + image);
    if (image == "") {
      return null;
    }
    image = "uploads/" + image;
    Image m;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      print("downloadUrl:" + downloadUrl.toString());
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  child: FutureBuilder(
                      future: _getImage(context, image),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done)
                          return Container(
                            // height: MediaQuery.of(context).size.height / 1.25,
                            // width: MediaQuery.of(context).size.width / 1.25,
                            child: snapshot.data,
                          );

                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Container(
                              height: MediaQuery.of(context).size.height / 1.25,
                              width: MediaQuery.of(context).size.width / 1.25,
                              child: CircularProgressIndicator());
                      }),
                  radius: 35.0,
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
