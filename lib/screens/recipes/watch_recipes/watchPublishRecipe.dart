import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stages.dart';
import '../../groups/saveGroup.dart';
import 'warchRecipeBody.dart';
import '../../personal_screen/likesList.dart';

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
  String levelString;
  // username and id that like current recipe
  Map<String, String> usersLikes = {};
  //
  String publishRecipeId;
  bool doneLoadLikeList = false;

  // constructor
  WatchPublishRecipe(String _uid, Recipe _currentRecipe, Color _levelColor,
      String _levelString) {
    this.uid = _uid;
    this.currentRecipe = _currentRecipe;
    this.levelColor = _levelColor;
    this.levelString = _levelString;
  }

  @override
  _WatchPublishRecipeState createState() => _WatchPublishRecipeState();
}

class _WatchPublishRecipeState extends State<WatchPublishRecipe> {
  @override
  void initState() {
    super.initState();
    getuser();
    initLikeIcon();
  }

  void getuser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      widget.uid = user.uid;
    });
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
            actions: <Widget>[
              // like icon
              likeIcon(),
              // show likes button
              showLikesIcon(),
              // save icon
              saveIcon(),
            ]),
        body: WatchRecipeBody(widget.currentRecipe, widget.ingredients,
            widget.stages, widget.levelColor, widget.levelString));
  }

  initLikeIcon() async {
    var publishRecipes =
        await Firestore.instance.collection('publish recipe').getDocuments();
    publishRecipes.documents.forEach((element) async {
      // the current publish recipe
      if (element.data['recipeId'] == widget.currentRecipe.id) {
        widget.publishRecipeId = element.documentID.toString();
        DocumentSnapshot currentUser = await Firestore.instance
            .collection("users")
            .document(widget.uid)
            .get();
        List userLikes = currentUser.data['likes'] ?? [];
        if (userLikes.contains(widget.publishRecipeId)) {
          setState(() {
            widget.isLikeRecipe = true;
          });
        }
      }
    });
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
            child: SaveGroup(
                widget.uid, widget.currentRecipe.id, widget.currentRecipe)));
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
    String id;
    final db = Firestore.instance;
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) async {
      if (element.data['recipeId'] == widget.currentRecipe.id) {
        id = element.documentID.toString();
        // go to specific publish recipe
        var currentRecipe2 =
            await db.collection('publish recipe').document(id).get();
        DocumentSnapshot currentUser = await Firestore.instance
            .collection('users')
            .document(widget.uid.toString())
            .get();
        List likes = [];
        List loadList = currentUser.data['likes'] ?? [];
        likes.addAll(loadList);
        likes.add(id);
        db
            .collection('users')
            .document(widget.uid.toString())
            .updateData({'likes': likes});
        likes = [];
        loadList = currentRecipe2.data['likes'] ?? [];
        likes.addAll(loadList);
        likes.add(widget.uid.toString());
        db
            .collection('publish recipe')
            .document(id)
            .updateData({'likes': likes});
        setState(() {
          widget.isLikeRecipe = !widget.isLikeRecipe;
          // add to likes list
          widget.usersLikes[currentUser.data['Email']] =
              currentUser.documentID.toString();
        });
      }
    });
  }

  Future<void> unlike() async {
    String id;
    final db = Firestore.instance;
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) async {
      if (element.data['recipeId'] == widget.currentRecipe.id) {
        id = element.documentID.toString();
        // go to specific publish recipe
        var currentRecipe2 =
            await db.collection('publish recipe').document(id).get();
        DocumentSnapshot currentUser = await Firestore.instance
            .collection('users')
            .document(widget.uid.toString())
            .get();
        List likes = [];
        List loadList = currentUser.data['likes'] ?? [];
        likes.addAll(loadList);
        likes.remove(id);
        db
            .collection('users')
            .document(widget.uid.toString())
            .updateData({'likes': likes});
        likes = [];
        loadList = currentRecipe2.data['likes'] ?? [];
        likes.addAll(loadList);
        likes.remove(widget.uid.toString());
        db
            .collection('publish recipe')
            .document(id)
            .updateData({'likes': likes});
        setState(() {
          widget.isLikeRecipe = !widget.isLikeRecipe;
          // remove from likes list
          widget.usersLikes.remove([currentUser.data['Email']]);
        });
      }
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
            _showAlertDialog('you can not save this recipe - ' +
                'please first register or sign in to this app, do this in the personal page');
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
    return FlatButton.icon(
        icon: Icon(
          widget.isSaveRecipe ? Icons.favorite : Icons.favorite_border,
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
                  'you can not save this recipe - becouse you wroye it!');
            }
          } else {
            _showAlertDialog(
                'you can not save this recipe - please first register or sign in to this app, do this in the personal page');
          }
        });
  }
}
