import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/shared_screen/config.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:recipes_app/screens/book_screen/saveInDirectory.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import 'watchRecipeBody.dart';
import '../../personal_screen/likesList.dart';
import '../../personal_screen/notesForm.dart';

// ignore: must_be_immutable
class WatchFavoriteRecipe extends StatefulWidget {
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
  String publishRecipeId;
  NetworkImage image;

  WatchFavoriteRecipe(
      String _uid,
      Recipe _currentRecipe,
      Color _levelColor,
      String _levelString,
      List<IngredientsModel> ing,
      List<Stages> sta,
      NetworkImage _image) {
    this.uid = _uid;
    this.currentRecipe = _currentRecipe;
    this.levelColor = _levelColor;
    this.levelString = _levelString;
    this.ingredients = ing;
    this.stages = sta;
    this.image = _image;
  }

  @override
  _WatchFavoriteRecipeState createState() => _WatchFavoriteRecipeState();
}

class _WatchFavoriteRecipeState extends State<WatchFavoriteRecipe> {
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
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
          Column(children: [delete(), saveIcon(), addNoteIcon()]),
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
    var a = await Firestore.instance
        .collection('publish recipe')
        .document(widget.currentRecipe.publish)
        .get();
    if (a == null) {}

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: new BoxDecoration(
              color: backgroundColor,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: LikesList(widget.currentRecipe)));
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

  Future<void> deleteFromSavedRecipe(
    String id,
  ) async {
    await RecipeFromDB.deleteFromFavoriteRecipe(
        widget.uid, widget.currentRecipe.writerUid, widget.currentRecipe.id);
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 3;
    });
  }

  Future<void> _showAlertDialogDelete(BuildContext context1) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "Are you sure you want to delete this recipe from favorites?\nThe recipe wiil delete from your directories too"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('yes- delete'),
              onPressed: () async {
                await RecipeFromDB.deleteFromFavoriteRecipe(widget.uid,
                    widget.currentRecipe.writerUid, widget.currentRecipe.id);
                int count = 0;
                Navigator.pop(context);
                Navigator.popUntil(context1, (route) {
                  return count++ == 3;
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

  _showAlertDialog() {
    // set up the buttons
    // ignore: deprecated_member_use
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("need to sign in"),
      content: Text(
          "you can not save this recipe - please first register or sign in to this app, do this in the personal page"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
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
            _showAlertDialog();
          }
        });
  }

  Widget showLikesIcon() {
    return TextButton(
        onPressed: () {
          if (widget.uid != null) {
            _showLikesList();
          } else {
            _showAlertDialog();
          }
        },
        child: Text(
          'Show Likes',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
        ));
  }

  Widget delete() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.delete,
        ),
        label: Text(
          'Delete From Saves',
          style: TextStyle(fontFamily: 'Raleway'),
        ),
        onPressed: () {
          _showAlertDialogDelete(context);
          // deleteFromSavedRecipe(widget.uid);
        });
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
            child: SaveInDirectory(widget.uid, widget.currentRecipe, false)));
  }

  Widget addNoteIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.note_add,
        ),
        label: Text(
          'add note',
          style: TextStyle(fontFamily: 'Raleway'),
        ),
        onPressed: () {
          _showNotesPanel(widget.uid);
        });
  }

  Future<void> _showNotesPanel(String id) async {
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(id)
        .collection('saved recipe')
        .getDocuments();
    for (int i = 0; i < snap.documents.length; i++) {
      String recipeIdfromSnap = snap.documents[i].data['recipeID'];
      if (recipeIdfromSnap == widget.currentRecipe.id) {
        List notes = snap.documents[i].data['notes'];

        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: new BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  ),
                ),
                child: NotesForm(notes, id, snap.documents[i].documentID,
                    widget.currentRecipe.id)));
      }
    }
  }
}
