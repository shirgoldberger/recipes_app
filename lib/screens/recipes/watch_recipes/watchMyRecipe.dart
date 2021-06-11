import 'package:flutter/material.dart';
import 'package:recipes_app/shared_screen/config.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:recipes_app/screens/book_screen/saveInDirectory.dart';
import 'package:recipes_app/screens/groups/publishGroup.dart';
import 'watchRecipeBody.dart';
import '../edit_recipe/editRecipe.dart';
import '../../../services/recipeFromDB.dart';

// ignore: must_be_immutable
class WatchMyRecipe extends StatefulWidget {
  // true if the user like this recipe
  bool isLikeRecipe = false;
  // true if the user save this recipe
  bool isSaveRecipe = false;
  // user id (null if the user didn't login)
  String uid;
  // recipe parameters
  Recipe currentRecipe;
  List<IngredientsModel> ingredients = [];
  List<Stages> stages = [];
  Color levelColor;
  bool done = false;
  String levelString;
  // username and id that like current recipe
  Map<String, String> usersLikes;
  NetworkImage image;
  String imagePath;
  WatchMyRecipe(
      String _uid,
      Recipe _currentRecipe,
      Color _levelColor,
      String _levelString,
      List<IngredientsModel> _ing,
      List<Stages> _stages,
      NetworkImage _image) {
    this.uid = _uid;
    this.currentRecipe = _currentRecipe;
    this.levelColor = _levelColor;
    this.levelString = _levelString;
    this.ingredients = _ing;
    this.stages = _stages;
    this.image = _image;
    this.imagePath = currentRecipe.imagePath;
  }

  @override
  _WatchMyRecipeState createState() => _WatchMyRecipeState();
}

class _WatchMyRecipeState extends State<WatchMyRecipe> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, {
              "name": widget.currentRecipe.name,
              "writer": widget.currentRecipe.writer,
              "level": widget.currentRecipe.level,
              "time": widget.currentRecipe.time,
              "image": widget.image,
              "imagePath": widget.imagePath
            }),
          ),
          backgroundColor: appBarBackgroundColor,
          elevation: 0.0,
          title: Text(
            'Watch Recipe',
            style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
          ),
        ),
        endDrawer: leftMenu(),
        body: WatchRecipeBody(
            widget.currentRecipe,
            widget.ingredients,
            widget.stages,
            widget.levelColor,
            widget.levelString,
            widget.uid,
            widget.image));
  }

  Widget leftMenu() {
    return Container(
      color: backgroundColor,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ListView(
        children: <Widget>[
          drawerTitle(),
          Column(children: [
            publishIcon(),
            // edit icon
            editIcon(),
            // delete icon
            deleteIcon(),
            saveIcon(),
          ]),
        ],
      ),
    );
  }

  Widget drawerTitle() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: appBarBackgroundColor,
      ),
      arrowColor: appBarBackgroundColor,
      accountName: Text('Options:'),
    );
  }

  Future<void> _showPublishPanel() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: new BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: PublishGroup(
                widget.uid, widget.currentRecipe.id, widget.currentRecipe)));
  }

  Future<void> delete() async {
    await RecipeFromDB.deleteRecipe(
        widget.currentRecipe.publish,
        widget.currentRecipe.id,
        widget.uid,
        widget.currentRecipe.tags,
        widget.currentRecipe.writerUid);
  }

  Widget publishIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.share,
          color: Colors.black,
        ),
        label: Text(
          'Publish',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
        onPressed: () {
          _showPublishPanel();
        });
  }

  Widget editIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.edit,
          color: Colors.black,
        ),
        label: Text(
          'Edit',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditRecipe(
                      widget.uid,
                      widget.currentRecipe,
                      widget.stages,
                      widget.ingredients,
                      widget.levelString,
                      widget.levelColor,
                      widget.image))).then((value) => updateRecipe(value));
        });
  }

  void updateRecipe(var r) {
    if (r != null) {
      setState(() {
        widget.currentRecipe = r["recipe"];
        widget.ingredients = r["recipe"].ingredients;
        widget.stages = r["recipe"].stages;
        widget.image = r["image"];
        widget.imagePath = r["imagePath"];
      });
      switch (widget.currentRecipe.level) {
        case 1:
          widget.levelColor = Colors.green[400];
          widget.levelString = 'Easy';
          break;
        case 2:
          widget.levelColor = Colors.yellow[400];
          widget.levelString = 'Medium';
          break;
        case 3:
          widget.levelColor = Colors.pink[400];
          widget.levelString = 'Hard';
          break;
        case 0:
          widget.levelColor = Colors.grey[400];
          widget.levelString = 'Easy';
          break;
      }
    }
  }

  Future<void> _showAlertDialog(BuildContext context1) async {
    BuildContext dialogContext;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return AlertDialog(
          title: Text('Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'You\'re sure you want to delete your recipe permanently ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('yes- delete'),
              onPressed: () async {
                delete();
                int count = 0;
                Navigator.pop(dialogContext);
                Navigator.of(context1).pop();
                Navigator.popUntil(context1, (route) {
                  return count++ == 2;
                });
              },
            ),
            TextButton(
              child: Text('no- go back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget saveIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        label: Text(
          widget.isSaveRecipe ? 'Unsave' : 'Save to directory',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
        onPressed: () {
          if (widget.uid != null) {
            _showSavedGroup();
          }
        });
  }

  Future<void> _showSavedGroup() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: new BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: SaveInDirectory(
                widget.uid, widget.currentRecipe, true, false)));
  }

  Widget deleteIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.delete,
          color: Colors.black,
        ),
        label: Text('Delete',
            style: TextStyle(fontFamily: 'Raleway', color: Colors.black)),
        onPressed: () {
          _showAlertDialog(context);
        });
  }
}
