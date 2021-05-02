import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:recipes_app/screens/personal_screen/likesList.dart';
import 'package:recipes_app/services/fireStorageService.dart';
import 'package:recipes_app/shared_screen/loading.dart';

// ignore: must_be_immutable
class WatchRecipeBody extends StatefulWidget {
  WatchRecipeBody(Recipe c, List<IngredientsModel> ing, List<Stages> stages,
      Color levelColor, String levelString, String _uid) {
    //  print(c.likes);
    print("'eatch recipe bodt");
    this.current = c;
    this.uid = _uid;

    this.ing = ing;

    _isChecked = List<bool>.filled(ing.length, false);
    //print(_isChecked);
    //  widget._isCheckedStages = List<bool>.filled(widget.stages.length, false);
    //  print(widget._isCheckedStages);
    //   print("222222222222222222222");

    // print(ing);
    this.stages = stages;
    // print(stages);
    this.levelColor = levelColor;
    this.levelString = levelString;
  }
  Recipe current;
  List<IngredientsModel> ing = [];
  List<Stages> stages = [];
  Color levelColor;
  String levelString = '';
  String imagePath = "";
  //bool value = true;
  List<bool> _isChecked = [];
  // List<bool> _isCheckedStages = [];
  bool doneLoadLikeList = false;
  Map<String, String> usersLikes = {};
  bool isLikeRecipe = false;
  String uid;
  String publishRecipeId;
  @override
  _WatchRecipeBodyState createState() => _WatchRecipeBodyState();
}

class _WatchRecipeBodyState extends State<WatchRecipeBody> {
  @override
  void initState() {
    print("1111111111111111111111");
    super.initState();

    // setState(() {
    //   widget._isChecked = List<bool>.filled(widget.ing.length, false);
    //   print(widget._isChecked);
    //   widget._isCheckedStages = List<bool>.filled(widget.stages.length, false);
    //   print(widget._isCheckedStages);
    //   print("222222222222222222222");
    // });

    getData();
    sortStages();
    print("init like icon");
    if (widget.current.publish != '') {
      if (widget.uid != null) {
        initLikeIcon();
      }
      _getLikesList();
    } else {
      setState(() {
        widget.doneLoadLikeList = true;
      });
    }
  }

  var m;
  Future<Widget> _getImage(BuildContext context, String image) async {
    // print("imageeeeeeeeeeeeeeeeeeeee" + image);
    if (image == "") {
      return null;
    }
    if (this.m != null) {
      return this.m;
    }
    image = "uploads/" + image;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      //  print("downloadUrl:" + downloadUrl.toString());
      this.m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    //  print("3");

    return this.m;
  }

  void getData() async {
    // print("4");

    DocumentSnapshot a = await Firestore.instance
        .collection('users')
        .document(widget.current.writerUid)
        .get();
    setState(() {
      widget.imagePath = a.data['imagePath'];
    });
  }

  initLikeIcon() async {
    var publishRecipes =
        await Firestore.instance.collection('publish recipe').getDocuments();
    publishRecipes.documents.forEach((element) async {
      // the current publish recipe
      if (element.data['recipeId'] == widget.current.id) {
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

  void sortStages() {
    List<Stages> stageCopy = [];
    stageCopy.addAll(widget.stages);
    for (int i = 0; i < stageCopy.length; i++) {
      setState(() {
        widget.stages[stageCopy[i].i] = stageCopy[i];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: LikesList(widget.current)));
    }

    Widget showLikesIcon() {
      if (!widget.doneLoadLikeList) {
        return Loading();
      } else {
        return FlatButton.icon(
          icon: Icon(
            Icons.thumb_up,
            color: Colors.blue[900],
          ),
          label: Text(widget.usersLikes.length.toString() + " Likes",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Raleway',
                  fontSize: 25)),
          onPressed: () {
            _showLikesList();
          },
        );
      }
    }

    Future<void> _getLikesList() async {
      List likes;
      final db = Firestore.instance;
      var publishRecipes = await db.collection('publish recipe').getDocuments();
      publishRecipes.documents.forEach((element) async {
        // the current recipe
        if (element.data['recipeId'] == widget.current.id) {
          var recipe = await db
              .collection('publish recipe')
              .document(element.documentID.toString())
              .get();
          // take likes
          likes = recipe.data['likes'] ?? [];
          // take all usernames
          for (String userId in likes) {
            DocumentSnapshot currentUser = await Firestore.instance
                .collection("users")
                .document(userId)
                .get();
            setState(() {
              widget.usersLikes[currentUser.data['Email']] = userId;
              widget.doneLoadLikeList = true;
            });
          }
        }
      });
      setState(() {
        widget.doneLoadLikeList = true;
      });
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
              _showAlertDialog('you can not save this recipe - ' +
                  'please first register or sign in to this app, do this in the personal page');
            }
          });
    }

    Widget name() {
      return Center(
        // child: Container(
        //   decoration: BoxDecoration(
        //       image: DecorationImage(
        //           image: ExactAssetImage('lib/images/meat.JPG'),
        //           fit: BoxFit.cover)),
        child: new Text(
          widget.current.name,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway',
              fontSize: 60),
        ),
      );
    }

    Widget picture() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: FutureBuilder(
            future: _getImage(context, widget.current.imagePath),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Container(
                  height: 300,
                  width: 300,
                  child: snapshot.data,
                );

              if (snapshot.connectionState == ConnectionState.waiting)
                return Container(
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width / 10,
                    child: CircularProgressIndicator());
            }),
      );
    }

    Widget description() {
      return new Text(
        widget.current.description,
        style: TextStyle(
            color: Colors.black,
            // fontWeight: FontWeight.w900,
            //fontStyle: FontStyle.italic,
            fontFamily: 'Raleway',
            fontSize: 20),
      );
    }

    Widget level() {
      // ignore: deprecated_member_use
      return RaisedButton(
          color: widget.levelColor,
          child: Text(
            widget.levelString,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {});
    }

    // Widget profilePicture() {
    //   return CircleAvatar(
    //     backgroundImage: widget.imagePath == "" ? ExactAssetImage("") : m,
    //   );
    // }

    Widget writer() {
      return Row(children: [
        new Padding(padding: EdgeInsets.only(right: 15.0)),
        //profilePicture(),
        Text(
          "By - ",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway',
              fontSize: 20),
        ),
        Text(
          widget.current.writer,
          style: TextStyle(
              color: Colors.black,
              // fontWeight: FontWeight.w900,
              //fontStyle: FontStyle.italic,
              fontFamily: 'Raleway',
              fontSize: 20),
        )
      ]);
    }

    Widget ingredients() {
      return new Center(
        child: new Container(
          width: 450,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(top: 20.0)),
              new Text(
                'ingredients for the recipe:',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Raleway',
                    fontSize: 27),
              ),
              new Padding(padding: EdgeInsets.only(top: 10.0)),
              for (var i = 0; i < widget.ing.length; i++)
                Row(
                  children: [
                    Checkbox(
                        value: widget._isChecked[i],
                        onChanged: (val) {
                          setState(() {
                            widget._isChecked[i] = val;
                          });
                        }),
                    Text(
                      widget.ing[i].count.toString() +
                          " " +
                          widget.ing[i].unit.toString() +
                          " " +
                          widget.ing[i].name.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          // fontWeight: FontWeight.w900,
                          //fontStyle: FontStyle.italic,
                          fontFamily: 'Raleway',
                          fontSize: 20),
                    ),
                  ],
                ),
              new Padding(padding: EdgeInsets.only(top: 20.0)),
            ],
          ),
        ),
      );
    }

    Widget stages() {
      return new Center(
          child: new Container(
        width: 450,
        // height: 300,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 20.0)),
            new Text(
              'stages for the recipe:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Raleway',
                  fontSize: 27),
            ),
            new Padding(padding: EdgeInsets.only(top: 10.0)),
            ListView.builder(
                shrinkWrap: true,
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                itemCount: widget.stages.length,
                itemBuilder: (context, index) {
                  return
                      // return Row(children: [
                      // Checkbox(
                      //     value: widget._isCheckedStages[index],
                      //     onChanged: (val) {
                      //       setState(() {
                      //         widget._isCheckedStages[index] = val;
                      //       });
                      //     }),
                      Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      index.toString() + ". " + widget.stages[index].s,
                      style: TextStyle(
                          color: Colors.black,
                          // fontWeight: FontWeight.w900,
                          //fontStyle: FontStyle.italic,
                          fontFamily: 'Raleway',
                          fontSize: 20),
                    ),
                  );
                })
          ],
        ),
      ));
    }

    Widget notes() {
      return new Center(
          child: new Container(
        width: 450,
        // height: 300,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 20.0)),
            new Text(
              'Writer notes:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Raleway',
                  fontSize: 27),
            ),
            new Padding(padding: EdgeInsets.only(top: 10.0)),
            ListView.builder(
                shrinkWrap: true,
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                itemCount: widget.current.notes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      index.toString() + ". " + widget.current.notes[index],
                      style: TextStyle(
                          color: Colors.black,
                          // fontWeight: FontWeight.w900,
                          //fontStyle: FontStyle.italic,
                          fontFamily: 'Raleway',
                          fontSize: 20),
                    ),
                  );
                })
          ],
        ),
      ));
    }

    return new Container(
        child: ListView(children: [
      Container(
          child: new Column(children: [
        name(),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        if (widget.current.publish != '')
          Row(
            children: [
              showLikesIcon(),
              likeIcon(),
            ],
          ),
        if (widget.levelString != '') level(),
        Divider(
          height: 40,
          thickness: 8,
        ),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        description(),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        writer(),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        picture(),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        ingredients(),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        stages(),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        notes(),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        new Text(
          makeTags(),
          style: TextStyle(
              color: Colors.black,
              // fontWeight: FontWeight.w900,
              //fontStyle: FontStyle.italic,
              fontFamily: 'Raleway',
              fontSize: 20),
        ),
      ]))
    ]));
  }

  String makeTags() {
    String tag = '';
    for (int i = 0; i < widget.current.tags.length; i++) {
      tag += "#" + widget.current.tags[i] + " ,";
    }
    return tag;
  }

  Future<void> _getLikesList() async {
    //print("get likes list");
    List likes;
    final db = Firestore.instance;
    var publishRecipes = await db.collection('publish recipe').getDocuments();
    publishRecipes.documents.forEach((element) async {
      // the current recipe
      if (element.data['recipeId'] == widget.current.id) {
        var recipe = await db
            .collection('publish recipe')
            .document(element.documentID.toString())
            .get();
        // take likes
        likes = recipe.data['likes'] ?? [];
        // take all usernames
        for (String userId in likes) {
          DocumentSnapshot currentUser = await Firestore.instance
              .collection("users")
              .document(userId)
              .get();
          setState(() {
            widget.usersLikes[currentUser.data['Email']] = userId;
            widget.doneLoadLikeList = true;
          });
        }
      }
    });
    setState(() {
      widget.doneLoadLikeList = true;
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
    DocumentSnapshot currentUser = await Firestore.instance
        .collection('users')
        .document(widget.uid.toString())
        .get();
    setState(() {
      widget.usersLikes[currentUser.data['Email']] = widget.uid;
    });
    String id;
    final db = Firestore.instance;
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) async {
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
    DocumentSnapshot currentUser = await Firestore.instance
        .collection('users')
        .document(widget.uid.toString())
        .get();

    setState(() {
      widget.usersLikes.remove(currentUser.data['Email']);
    });
    String id;
    final db = Firestore.instance;
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) async {
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
}
