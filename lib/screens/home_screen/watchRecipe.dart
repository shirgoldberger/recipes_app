import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stages.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screens/home_screen/editRecipe.dart';
import 'package:recipes_app/screens/home_screen/homeLogIn.dart';
import 'package:recipes_app/screens/home_screen/notesForm.dart';
import 'package:recipes_app/screens/home_screen/publishGroup2.dart';
import 'package:recipes_app/screens/home_screen/saveGroup.dart';
import 'package:recipes_app/screens/home_screen/warchRecipeBody.dart';
import 'package:recipes_app/shared_screen/loading.dart';

//הסבר כללי לגבי העמוד הזה-
// העמוד מקבל מתכון ומציג אותו למשתמש כאשר הוא מחולק ל 3 מצבים:
// מצב ראשןן - במקרה ואנחנו צופים במתכון שאנחנו כתבנו - ניתן לערוך את המתכון, למחוק אותו ולפרסם אותו.
//  לכן אפשר רק למחוק אותו, נמחק רק אצלי, או להוסיף עליו הערות אישיות שלי. (עשינו לו save )  מצב שני - אנחנו צופים במתכון ששמרנו אותו
// מצב שלישי - צפיה במתכון מתוך העמוד הכללי - ניתן רק לשמור מתכון.
class WatchRecipe extends StatefulWidget {
  WatchRecipe(Recipe r, bool home) {
    this.current = r;
    this.home = home;
    // print("watch recipe");
    // print(current.publish);
    // print(r.publish);
  }
  bool home;
  List<IngredientsModel> ing = [];
  List<Stages> stages = [];
  Recipe current;
  bool done = false;
  int count = 0;
  String tags = '';
  final db = Firestore.instance;
  Color levelColor;
  String levelString = '';
  var uid;
  IconData iconPublish = Icons.public;
  String publishString = "publish this recipe";
  String saveRecipe = '';
  IconData iconSave = Icons.favorite_border;
  String saveString = 'save';

  List usernames = [];
  bool likeRecipe = false;
  List recipeLikes;
  //bool publish = false;

  @override
  @override
  _WatchRecipeState createState() => _WatchRecipeState();
}

class _WatchRecipeState extends State<WatchRecipe> {
  var i;
  @override
  void initState() {
    super.initState();
    getuser();
    getUsersLikeRecipe();
    makeList();
    print("init state");
    // print(widget.current.publish);
    if (widget.current.publish == '') {
      widget.iconPublish = Icons.public;
      widget.publishString = "publish";
    } else {
      widget.iconPublish = Icons.public_off;
      widget.publishString = "un publish";
    }
    print(widget.uid);
  }

  getUsersLikeRecipe() async {
    final db = Firestore.instance;
    var users = await db.collection('users').getDocuments();
    users.documents.forEach((element) async {
      DocumentSnapshot currentUser = await Firestore.instance
          .collection("users")
          .document(element.documentID.toString())
          .get();
      widget.usernames.add(currentUser.data['firstName']);
    });
  }

  void getuser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      widget.uid = user.uid;
      print(widget.uid);
      //print("user uid");
    });
    if (widget.uid != null) {
      // print("user:   " + widget.uid);
      QuerySnapshot snap = await Firestore.instance
          .collection("users")
          .document(widget.uid)
          .collection("saved recipe")
          .getDocuments();
      snap.documents.forEach((element) async {
        if (element.data['recipeID'] == widget.current.id) {
          widget.iconSave = Icons.favorite;
          widget.saveString = 'unsave';
          print("unsave");
        }
      });
      if (widget.home) {
        QuerySnapshot snap = await Firestore.instance
            .collection('publish recipe')
            .getDocuments();
        String id;
        snap.documents.forEach((element) async {
          if (element.data['recipeId'] == widget.current.id) {
            id = element.documentID.toString();
            DocumentSnapshot currentUser = await Firestore.instance
                .collection("users")
                .document(widget.uid)
                .get();
            List userLikes = currentUser.data['likes'] ?? [];
            if (userLikes.contains(id)) {
              widget.likeRecipe = true;
            }

            DocumentSnapshot currentPublishRecipe = await Firestore.instance
                .collection('publish recipe')
                .document(id)
                .get();
            widget.recipeLikes = currentPublishRecipe.data['likes'] ?? [];
          }
        });
      }

      print(widget.saveString);

      //     .then((doc) {
      //   if (doc.data['recipeID'] == widget.current.id) {
      //     print("save");
      //   } else {
      //     print("unsave");
      //   }
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.current.level == 1) {
      widget.levelColor = Colors.green[900];
      widget.levelString = "easy";
    }
    if (widget.current.level == 2) {
      widget.levelColor = Colors.red[900];
      widget.levelString = "nedium";
    }
    if (widget.current.level == 3) {
      widget.levelColor = Colors.blue[900];
      widget.levelString = "hard";
    }

    // getuser();
    //if we came from home screen
//מצב שלישי 333333333333333333333333333333333333333333333333333333333333333333
    if (widget.home) {
      // final FirebaseAuth auth = FirebaseAuth.instance;

      // void getuser() async {
      //   final FirebaseUser user = await auth.currentUser();
      //   setState(() {
      //     widget.uid = user.uid;
      //   });
      // }

      // print("watch reci[e ::");
      // print(widget.uid);
      // print(widget.current.writerUid);

      showAlertDialog() {
        // set up the buttons
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

      // getuser();
      if (!widget.done) {
        return Loading();
      } else {
        return Scaffold(
            backgroundColor: Colors.teal[50],
            appBar: AppBar(
                elevation: 0.0,
                title: Text(
                  'watch this recipe',
                  style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
                ),
                backgroundColor: Colors.teal[900],
                actions: <Widget>[
                  FlatButton.icon(
                      icon: Icon(
                        widget.likeRecipe
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: Colors.red,
                      ),
                      label: Text(
                        widget.likeRecipe ? 'UNLIKE' : 'LIKE',
                        style: TextStyle(
                            fontFamily: 'Raleway', color: Colors.redAccent),
                      ),
                      onPressed: () {
                        if (widget.uid != null) {
                          _likeRecipe();
                        } else {
                          showAlertDialog();
                        }
                      }),
                  TextButton(
                      onPressed: () {
                        if (widget.uid != null) {
                          _showLikesList();
                        } else {
                          showAlertDialog();
                        }
                      },
                      child: Text(
                        'show likes',
                        style: TextStyle(
                            fontFamily: 'Raleway', color: Colors.white),
                      )),
                  FlatButton.icon(
                      icon: Icon(
                        widget.iconSave,
                        color: Colors.white,
                      ),
                      label: Text(
                        widget.saveString,
                        style: TextStyle(
                            fontFamily: 'Raleway', color: Colors.white),
                      ),
                      onPressed: () {
                        if (widget.uid != null) {
                          _showSavedFroup();
                        } else {
                          showAlertDialog();
                        }
                      }),
                ]),
            body: WatchRecipeBody(widget.current, widget.ing, widget.stages,
                widget.levelColor, widget.levelString));
      }
    }
    //מצב ראשון 1111111111111111111111111111111111111111111111111111111111111111111111111111

    //if we come from personal page
    if (!widget.home) {
      //print("watch reci[e ::");

      final user = Provider.of<User>(context);
      final db = Firestore.instance;
      String id = widget.uid;
      String writerId = widget.current.writerUid;
      // print(widget.uid);
      // print(widget.current.writerUid);
      if (!widget.done) {
        return Loading();
      } else {
        if (id == writerId) {
          return Scaffold(
              backgroundColor: Colors.blueGrey[50],
              appBar: AppBar(
                  backgroundColor: Colors.blueGrey[700],
                  elevation: 0.0,
                  title: Text(
                    'watch this recipe',
                    style: TextStyle(fontFamily: 'Raleway'),
                  ),
                  actions: <Widget>[
                    FlatButton.icon(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        label: Text(
                          'publish',
                          style: TextStyle(
                              fontFamily: 'Raleway', color: Colors.white),
                        ),
                        onPressed: () {
                          _showPublishPanel();
                        }),
                    FlatButton.icon(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        label: Text(
                          'edit',
                          style: TextStyle(
                              fontFamily: 'Raleway', color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditRecipe(
                                      widget.current,
                                      widget.ing,
                                      widget.stages)));
                        }),
                    FlatButton.icon(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        label: Text(
                          'delete',
                          style: TextStyle(
                              fontFamily: 'Raleway', color: Colors.white),
                        ),
                        onPressed: () {
                          delete();
                          // if (widget.current.publish != '') {
                          //   db
                          //       .collection('publish recipe')
                          //       .document(widget.current.publish)
                          //       .delete();
                          // }
                          // db
                          //     .collection('users')
                          //     .document(user.uid)
                          //     .collection('recipes')
                          //     .document(widget.current.id)
                          //     .delete();
                          //go back
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeLogIn(widget.uid)));
                        })
                  ]),
              body: WatchRecipeBody(widget.current, widget.ing, widget.stages,
                  widget.levelColor, widget.levelString));
        } else {
          //מצב שני 2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
          return Scaffold(
              backgroundColor: Colors.blueGrey[50],
              appBar: AppBar(
                  backgroundColor: Colors.blueGrey[700],
                  elevation: 0.0,
                  title: Text(
                    'watch this recipe',
                    style:
                        TextStyle(fontFamily: 'Raleway', color: Colors.white),
                  ),
                  actions: <Widget>[
                    FlatButton.icon(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        label: Text(
                          'delete',
                          style: TextStyle(
                              fontFamily: 'Raleway', color: Colors.white),
                        ),
                        onPressed: () {
                          deleteFromSavedRecipe(id);
                          //go back
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => HomeLogIn()));
                        }),
                    FlatButton.icon(
                        icon: Icon(
                          Icons.note_add,
                          color: Colors.white,
                        ),
                        label: Text(
                          'add note',
                          style: TextStyle(
                              fontFamily: 'Raleway', color: Colors.white),
                        ),
                        onPressed: () {
                          _showNotesPanel(id);
                        }),
                  ]),
              body: WatchRecipeBody(widget.current, widget.ing, widget.stages,
                  widget.levelColor, widget.levelString));
        }
      }
    }
  }

  Future<void> makeList() async {
    if (!widget.done) {
      if (widget.current.saveInUser) {
        //final user = Provider.of<User>(context);
        String uid = widget.current.writerUid;
        // print('save in user');
        //print(uid);
        //print(widget.current.id.toString());
        QuerySnapshot snap = await Firestore.instance
            .collection('users')
            .document(uid)
            .collection('recipes')
            .document(widget.current.id.toString())
            .collection('ingredients')
            .getDocuments();
        snap.documents.forEach((element) {
          setState(() {
            widget.ing.add(IngredientsModel.antherConstactor(
                element.data['name'] ?? '',
                element.data['count'] ?? 0,
                element.data['unit'] ?? ''));
          });
        });
        QuerySnapshot snap2 = await Firestore.instance
            .collection('users')
            .document(uid)
            .collection('recipes')
            .document(widget.current.id.toString())
            .collection('stages')
            .getDocuments();
        snap2.documents.forEach((element1) {
          // print(element1.data.toString());
          setState(() {
            widget.stages
                .add(Stages.antheeConstractor(element1.data['stage'] ?? ''));
          });
        });
      } else {
        QuerySnapshot snap = await Firestore.instance
            .collection('recipes')
            .document(widget.current.id)
            .collection('ingredients')
            .getDocuments();
        snap.documents.forEach((element) {
          setState(() {
            widget.ing.add(IngredientsModel.antherConstactor(
                element.data['name'] ?? '',
                element.data['count'] ?? 0,
                element.data['unit'] ?? ''));
          });
        });
        QuerySnapshot snap2 = await Firestore.instance
            .collection('recipes')
            .document(widget.current.id)
            .collection('stages')
            .getDocuments();
        snap2.documents.forEach((element1) {
          //print(element1.data.toString());
          setState(() {
            widget.stages
                .add(Stages.antheeConstractor(element1.data['stage'] ?? ''));
          });
        });
      }

      setState(() {
        widget.done = true;
      });
    }
  }

  void saveRecipe() async {
    final db = Firestore.instance;

    db.collection('users').document(widget.uid).collection('saved recipe').add({
      'saveInUser': widget.current.saveInUser,
      'recipeID': widget.current.id,
      'userID': widget.current.writerUid
    });
  }

  Future<void> unSaveRecipe() async {
    final db = Firestore.instance;
    QuerySnapshot allDocuments = await db
        .collection('users')
        .document(widget.uid)
        .collection('saved recipe')
        .getDocuments();
    String delete;
    allDocuments.documents.forEach((doc) {
      if (doc.data['recipeID'] == widget.current.id) {
        delete = doc.documentID.toString();
      }
      db
          .collection('users')
          .document(widget.uid)
          .collection('saved recipe')
          .document(delete)
          .delete();
    });
  }

  Future<void> publishRecipe() async {
    final user = Provider.of<User>(context);
    final db = Firestore.instance;
    Map<String, dynamic> publishRecipe = {
      'recipeId': widget.current.id,
      'userID': user.uid
    };
    //save this recipe in the publish folder
    var currentRecipe =
        await db.collection('publish recipe').add(publishRecipe);
    String idPublish = currentRecipe.documentID;
    //save where he is publish
    widget.current.publishThisRecipe(idPublish);
    //update in the database
    db
        .collection('users')
        .document(user.uid)
        .collection('recipes')
        .document(widget.current.id)
        .updateData(widget.current.toJson());
  }

  void unPublishRecipe() {
    final user = Provider.of<User>(context);
    final db = Firestore.instance;
    db.collection('publish recipe').document(widget.current.publish).delete();
    widget.current.publishThisRecipe('');

    db
        .collection('users')
        .document(user.uid)
        .collection('recipes')
        .document(widget.current.id)
        .updateData(widget.current.toJson());
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
      if (recipeIdfromSnap == widget.current.id) {
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
      return count++ == 3;
    });
  }

  Future<void> _showNotesPanel(String id) async {
    final db = Firestore.instance;
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(id)
        .collection('saved recipe')
        .getDocuments();
    snap.documents.forEach((element) async {
      String recipeIdfromSnap = element.data['recipeID'];
      if (recipeIdfromSnap == widget.current.id) {
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
                    notes, id, element.documentID, widget.current.id)));
      }
    });
  }

  Future<void> _showPublishPanel() async {
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
            child:
                PublishGroup2(widget.uid, widget.current.id, widget.current)));
  }

  Future<void> _likeRecipe() async {
    String id;
    final db = Firestore.instance;
    // final user = Provider.of<User>(context);
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) async {
      //id = element.documentID;
      if (element.data['recipeId'] == widget.current.id) {
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
      }
      setState(() {
        widget.likeRecipe = !widget.likeRecipe;
      });
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
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: widget.recipeLikes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    child: Center(child: Text(widget.usernames[index])),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ));
  }

  Future<void> _showSavedFroup() async {
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
            child: SaveGroup(widget.uid, widget.current.id, widget.current)));
  }

  Future<void> delete() async {
    print("delete 1");
    final db = Firestore.instance;
    if (widget.current.publish != '') {
      // final db = Firestore.instance;
      DocumentSnapshot snap = await Firestore.instance
          .collection('publish recipe')
          .document(widget.current.publish)
          .get();
      String recipeID = snap.data['recipeId'];
      List group = snap.data['saveInGroup'] ?? [];
      List users = snap.data['saveUser'] ?? [];
      for (int i = 0; i < group.length; i++) {
        print(group[i]);
        QuerySnapshot snap2 = await Firestore.instance
            .collection('Group')
            .document(group[i])
            .collection('recipes')
            .getDocuments();
        snap2.documents.forEach((element) async {
          if (element.data['recipeId'] == widget.current.id) {
            print("find");
            db
                .collection('Group')
                .document(group[i])
                .collection('recipes')
                .document(element.documentID)
                .delete();
          }
        });
      }
      for (int i = 0; i < users.length; i++) {
        QuerySnapshot snap2 = await Firestore.instance
            .collection('users')
            .document(users[i])
            .collection('saved recipe')
            .getDocuments();
        snap2.documents.forEach((element) async {
          if (element.data['recipeId'] == widget.current.id) {
            db
                .collection('users')
                .document(users[i])
                .collection('saved recipe')
                .document(element.documentID)
                .delete();
          }
        });
      }
    }
    QuerySnapshot snap2 =
        await Firestore.instance.collection('Group').getDocuments();
    snap2.documents.forEach((element) async {
      QuerySnapshot snap3 = await Firestore.instance
          .collection('Group')
          .document(element.documentID)
          .collection('recipes')
          .getDocuments();
      snap3.documents.forEach((element2) {
        if (element2.data['recipeId'] == widget.current.id) {
          db
              .collection('Group')
              .document(element.documentID)
              .collection('recipes')
              .document(element2.documentID)
              .delete();
        }
      });
    });

    print("delete");
    if (widget.current.publish != '') {
      db.collection('publish recipe').document(widget.current.publish).delete();
    }
    db
        .collection('users')
        .document(widget.uid)
        .collection('recipes')
        .document(widget.current.id)
        .delete();
  }
}
