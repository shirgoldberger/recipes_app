import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'watchRecipeBody.dart';
import '../../personal_screen/likesList.dart';
import '../../personal_screen/notesForm.dart';

// ignore: must_be_immutable
class WatchSaveRecipe extends StatefulWidget {
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
  // constructor
  WatchSaveRecipe(String _uid, Recipe _currentRecipe, Color _levelColor,
      String _levelString) {
    this.uid = _uid;
    this.currentRecipe = _currentRecipe;
    this.levelColor = _levelColor;
    this.levelString = _levelString;
  }

  @override
  _WatchSaveRecipeState createState() => _WatchSaveRecipeState();
}

class _WatchSaveRecipeState extends State<WatchSaveRecipe> {
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
            backgroundColor: appBarBackgroundColor,
            elevation: 0.0,
            title: Text(
              'Watch Recipe',
              style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
            ),
            actions: <Widget>[
              // like icon
              likeIcon(),
              // show likes button
              showLikesIcon(),
              // delete button
              deleteFromSaveIcon(),
              // add note icon
              addNoteIcon(),
            ]),
        body: WatchRecipeBody(widget.currentRecipe, widget.ingredients,
            widget.stages, widget.levelColor, widget.levelString, widget.uid));
  }

  void initLikeIcon() async {
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
              color: backgroundColor,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: LikesList(widget.currentRecipe)));
  }

  // Future<void> _showSavedGroupPanel() async {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       backgroundColor: Colors.transparent,
  //       builder: (context) => Container(
  //           height: MediaQuery.of(context).size.height * 0.75,
  //           decoration: new BoxDecoration(
  //             color: Colors.blueGrey[50],
  //             borderRadius: new BorderRadius.only(
  //               topLeft: const Radius.circular(25.0),
  //               topRight: const Radius.circular(25.0),
  //             ),
  //           ),
  //           child: SaveGroup(
  //               widget.uid, widget.currentRecipe.id, widget.currentRecipe)));
  // }

  Future<void> _showNotesPanel(String id) async {
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(id)
        .collection('saved recipe')
        .getDocuments();
    snap.documents.forEach((element) async {
      String recipeIdfromSnap = element.data['recipeID'];
      if (recipeIdfromSnap == widget.currentRecipe.id) {
        List notes = element.data['notes'];
        //print(notes);
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
                child: NotesForm(
                    notes, id, element.documentID, widget.currentRecipe.id)));
      }
    });
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
    // final user = Provider.of<User>(context);
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) async {
      //id = element.documentID;
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
          widget.usersLikes.remove(currentUser.data['Email']);
        });
      }
    });
  }

  Future<void> deleteFromSavedRecipe(
    String id,
  ) async {
    final db = Firestore.instance;
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(id)
        .collection('saved recipe')
        .getDocuments();
    snap.documents.forEach((element) async {
      String recipeIdfromSnap = element.data['recipeID'];
      if (recipeIdfromSnap == widget.currentRecipe.id) {
        db
            .collection('users')
            .document(id)
            .collection('saved recipe')
            .document(element.documentID)
            .delete();
      }
    });
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 2;
    });
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

  Widget deleteFromSaveIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        label: Text(
          'Delete From Saves',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
        ),
        onPressed: () {
          deleteFromSavedRecipe(widget.uid);
        });
  }

  Widget addNoteIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.note_add,
          color: Colors.white,
        ),
        label: Text(
          'add note',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
        ),
        onPressed: () {
          _showNotesPanel(widget.uid);
        });
  }
}
