import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import 'package:recipes_app/shared_screen/config.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:recipes_app/screens/recipes/watch_recipes/watchRecipeBody.dart';
import '../../groups/saveGroup.dart';
import '../../personal_screen/likesList.dart';

// ignore: must_be_immutable
class WatchPublishRecipe extends StatefulWidget {
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
  Map<String, String> usersLikes = {};

  String publishRecipeId;
  bool doneLoadLikeList = false;

  NetworkImage image;

  // constructor
  WatchPublishRecipe(
      String _uid,
      Recipe _currentRecipe,
      Color _levelColor,
      String _levelString,
      List<IngredientsModel> _ingredients,
      List<Stages> _stages,
      NetworkImage _image) {
    this.uid = _uid;
    this.currentRecipe = _currentRecipe;
    this.levelColor = _levelColor;
    this.levelString = _levelString;
    this.ingredients = _ingredients;
    this.stages = _stages;
    this.image = _image;
  }

  @override
  _WatchPublishRecipeState createState() => _WatchPublishRecipeState();
}

class _WatchPublishRecipeState extends State<WatchPublishRecipe> {
  @override
  void initState() {
    super.initState();
    getuser();
    if (widget.uid != null) {
      initLikeIcon();
    }
  }

  void getuser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    if (user != null) {
      setState(() {
        widget.uid = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
            elevation: 0.0,
            title: Text(
              'Watch Recipe',
              style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
            ),
            backgroundColor: appBarBackgroundColor,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            actions: <Widget>[
              saveIcon(),
            ]),
        body: WatchRecipeBody(
            widget.currentRecipe,
            widget.ingredients,
            widget.stages,
            widget.levelColor,
            widget.levelString,
            widget.uid,
            widget.image));
  }

  void initLikeIcon() async {
    List likes =
        await RecipeFromDB.getLikesPublishRecipe(widget.currentRecipe.publish);
    if (likes.contains(widget.uid)) {
      setState(() {
        widget.isLikeRecipe = true;
      });
    }
  }

  Future<void> _showLikesList() async {
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
            child: LikesList(widget.currentRecipe)));
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
            child: SaveGroup(widget.uid, widget.currentRecipe.id,
                widget.currentRecipe, false)));
  }

  Future<void> _pressLikeRecipe() async {
    if (widget.uid == null) {
      return;
    }
    if (widget.isLikeRecipe) {
      unlike();
    } else {
      like();
    }
  }

  Future<void> like() async {
    String email =
        await RecipeFromDB.like(widget.currentRecipe.publish, widget.uid);
    setState(() {
      widget.isLikeRecipe = !widget.isLikeRecipe;
      // add to likes list
      widget.usersLikes[email] = widget.uid;
    });
  }

  Future<void> unlike() async {
    String email =
        await RecipeFromDB.like(widget.currentRecipe.publish, widget.uid);
    setState(() {
      widget.isLikeRecipe = !widget.isLikeRecipe;
      // remove from likes list
      widget.usersLikes.remove(email);
    });
  }

  Future<void> _showAlertDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget likeIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          widget.isLikeRecipe ? Icons.thumb_up : Icons.thumb_up_outlined,
          color: Colors.blue[900],
        ),
        label: Text(
          widget.isLikeRecipe ? 'Unlike' : 'Like',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.redAccent),
        ),
        onPressed: () {
          if (widget.uid != null) {
            _pressLikeRecipe();
          } else {
            _showAlertDialog('You can not save this recipe - ' +
                'please first register or sign in to the app and try again');
          }
        });
  }

  Widget showLikesIcon() {
    return TextButton(
        onPressed: () {
          _showLikesList();
        },
        child: Text(
          'Show Likes',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
        ));
  }

  Widget saveIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        label: Text(
          widget.isSaveRecipe ? 'Unsave' : 'Save',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
        ),
        onPressed: () {
          if (widget.uid != null) {
            if (widget.uid != widget.currentRecipe.writerUid) {
              _showSavedGroup();
            } else {
              _showAlertDialog(
                  'You can not save this recipe because you wrote it!');
            }
          } else {
            _showAlertDialog(
                'you can not save this recipe - please first register or sign in to the app and try again');
          }
        });
  }
}
