import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:recipes_app/screens/personal_screen/likesList.dart';
import 'package:recipes_app/services/fireStorageService.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import '../../../shared_screen/config.dart';
import '../../search_screen/userRecipeList.dart';

// ignore: must_be_immutable
class WatchRecipeBody extends StatefulWidget {
  Recipe current;
  List<IngredientsModel> ing = [];
  List<Stages> stages = [];
  Color levelColor;
  String levelString = '';
  Color timeColor;
  String timeString = '';
  String imagePath = "";
  NetworkImage userImage;
  NetworkImage recipeImage;
  List<bool> _isChecked = [];
  bool doneLoadLikeList = false;
  Map<String, String> usersLikes = {};
  bool isLikeRecipe = false;
  String uid;
  String publishRecipeId;
  String timeText = '';
  int likeAmount;
  bool isGettingImage = false;
  bool init = false;

  WatchRecipeBody(
      Recipe _current,
      List<IngredientsModel> _ing,
      List<Stages> _stages,
      Color _levelColor,
      String _levelString,
      String _uid,
      NetworkImage _image) {
    this.current = _current;
    this.ing = _ing;
    _isChecked = List<bool>.filled(ing.length, false);
    this.stages = _stages;
    this.levelColor = _levelColor;
    this.levelString = _levelString;
    this.uid = _uid;
    this.recipeImage = _image;
  }

  @override
  _WatchRecipeBodyState createState() => _WatchRecipeBodyState();
}

class _WatchRecipeBodyState extends State<WatchRecipeBody> {
  @override
  void initState() {
    super.initState();
    sortStages();
    sortIngredients();
    setTimeText();
    // its publish recipe
    if (widget.current.publish != '') {
      if (widget.uid != null) {
        initLikeIcon();
      }
    } else {
      setState(() {
        widget.doneLoadLikeList = true;
      });
    }
  }

  setTimeText() {
    switch (widget.current.time) {
      case 1:
        setState(() {
          widget.timeText = 'Until half-hour';
        });

        break;
      case 2:
        setState(() {
          widget.timeText = 'Until hour';
        });

        break;
      case 3:
        setState(() {
          widget.timeText = 'Over an hour';
        });

        break;
    }
  }

  void getUserImage() async {
    if (!widget.isGettingImage) {
      if (widget.userImage != null) {
        return;
      }
      DocumentSnapshot writer = await Firestore.instance
          .collection('users')
          .document(widget.current.writerUid)
          .get();
      widget.imagePath = writer.data['imagePath'] ?? "";
      if (widget.imagePath == "") {
        return;
      }

      String downloadUrl = await FireStorageService.loadFromStorage(
          context, "uploads/" + widget.imagePath);
      if (downloadUrl != null) {
        if (!mounted) {
          return;
        }
        setState(() {
          widget.userImage = NetworkImage(downloadUrl);
          widget.isGettingImage = true;
        });
      }
    }
  }

  initLikeIcon() async {
    if (widget.init) {
      return;
    }
    var publishRecipe = await Firestore.instance
        .collection('publish recipe')
        .document(widget.current.publish)
        .get();
    List users = publishRecipe.data['likes'] ?? [];
    if (users.contains(widget.uid)) {
      setState(() {
        widget.isLikeRecipe = true;
        widget.init = true;
      });
    }
  }

  void sortStages() {
    setState(() {
      widget.stages.sort((a, b) => a.i.compareTo(b.i));
    });
  }

  void sortIngredients() {
    setState(() {
      widget.ing.sort((a, b) => a.index.compareTo(b.index));
    });
  }

  @override
  Widget build(BuildContext context) {
    getUserImage();
    if (widget.current.publish != '') {
      getLikesList();
      initLikeIcon();
    }
    return new Container(
        child: ListView(children: [
      Container(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(children: [
          Row(children: [widthBox(20), name(), widthBox(30)]),
          padding,
          description(),
          padding,
          recipePicture(),
          padding,
          if (widget.current.publish != '')
            Row(
              children: [
                showLikesButton(),
                likeIcon(),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.levelString != '') level(),
              SizedBox(
                height: 20.0,
                width: 20,
              ),
              time(),
            ],
          ),
          Divider(
            height: 40,
            thickness: 8,
          ),
          padding,
          Row(children: [
            picture(),
            padding,
            writer(),
          ]),
          padding,
          ingredients(),
          padding,
          stages(),
          padding,
          notes(),
          padding,
          new Text(
            makeTags(),
            style: TextStyle(
                color: Colors.black, fontFamily: 'Raleway', fontSize: 20),
          ),
        ]),
      ))
    ]));
  }

  void getRecipeImage(BuildContext context) async {
    if (widget.recipeImage != null || widget.current.imagePath == "") {
      return;
    }
    String downloadUrl = await FireStorageService.loadFromStorage(
        context, "uploads/" + widget.current.imagePath);
    setState(() {
      widget.recipeImage = NetworkImage(downloadUrl);
    });
  }

  String makeTags() {
    String tag = '';
    for (int i = 0; i < widget.current.tags.length; i++) {
      if (i != widget.current.tags.length - 1) {
        tag += "#" + widget.current.tags[i] + " ,";
      } else {
        tag += "#" + widget.current.tags[i];
      }
    }
    return tag;
  }

  Widget picture() {
    // there is no image yet
    if (widget.imagePath == "") {
      return CircleAvatar(
          // ignore: missing_required_param
          child: TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserRecipeList(widget.current.writerUid)))),
          backgroundColor: backgroundColor,
          radius: 40,
          backgroundImage: ExactAssetImage(noImagePath));
    } else {
      if (widget.userImage != null) {
        return CircleAvatar(
            // ignore: missing_required_param
            child: TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserRecipeList(widget.current.writerUid)))),
            backgroundColor: backgroundColor,
            radius: 30,
            backgroundImage: widget.userImage);
      } else {
        return Container(
            height: 20, width: 20, child: CircularProgressIndicator());
      }
    }
  }

  Widget recipePicture() {
    if (widget.recipeImage != null) {
      return CircleAvatar(
          backgroundColor: backgroundColor,
          radius: 120,
          backgroundImage: widget.recipeImage);
    } else {
      return CircleAvatar(
          backgroundColor: backgroundColor,
          radius: 120,
          backgroundImage: ExactAssetImage(noImagePath));
    }
  }

  Widget description() {
    return Text(
      widget.current.description,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'DescriptionFont',
        fontSize: 20,
      ),
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
        onPressed: null);
  }

  Widget time() {
    return Text(widget.timeText,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            // fontStyle: FontStyle.italic,
            fontFamily: 'Raleway',
            fontSize: 15));
  }

  Widget writer() {
    return Row(children: [
      padding,
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
        style: TextStyle(fontFamily: 'Raleway', fontSize: 20),
      )
    ]);
  }

  Widget ingredients() {
    return Center(
      child: Container(
        width: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text(
              '  Ingredients:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Raleway',
                  fontSize: 27),
            ),
            new Padding(padding: EdgeInsets.only(top: 10.0)),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                itemCount: widget.ing.length,
                itemBuilder: (context, i) {
                  return Stack(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Checkbox(
                            value: widget._isChecked[i],
                            onChanged: (val) {
                              setState(() {
                                widget._isChecked[i] = val;
                              });
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "        " +
                                widget.ing[i].count.toString() +
                                " " +
                                widget.ing[i].unit.toString() +
                                " " +
                                widget.ing[i].name.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'DescriptionFont',
                                fontSize: 20),
                          ),
                        )
                      ]);
                }),
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
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
              itemCount: widget.stages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (index + 1).toString() + ". " + widget.stages[index].s,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'DescriptionFont',
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
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
              itemCount: widget.current.notes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (index + 1).toString() + ". " + widget.current.notes[index],
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'DescriptionFont',
                        fontSize: 20),
                  ),
                );
              })
        ],
      ),
    ));
  }

  Future<void> showLikesList() async {
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

  Widget showLikesButton() {
    return TextButton(
      child: Text(widget.usersLikes.length.toString() + " Likes",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway',
              fontSize: 25)),
      onPressed: () {
        showLikesList();
      },
    );
  }

  Widget likeIcon() {
    // ignore: deprecated_member_use
    return IconButton(
        icon: Icon(
          widget.isLikeRecipe ? Icons.thumb_up : Icons.thumb_up_outlined,
          color: Colors.blue[900],
        ),
        onPressed: () {
          if (widget.uid != null) {
            _pressLikeRecipe();
          } else {
            _showAlertDialog('you can not like this recipe - ' +
                'please first register or sign in to this app');
          }
        });
  }

  Widget name() {
    return Center(
      child: new Text(
        widget.current.name,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'AcmeFont',
            fontSize: 40),
      ),
    );
  }

  Future<void> getLikesList() async {
    if (widget.doneLoadLikeList) {
      return;
    }
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
          if (mounted) {
            setState(() {
              widget.usersLikes[currentUser.data['Email']] = userId;
              widget.doneLoadLikeList = true;
            });
          }
        }
      }
    });
    setState(() {
      widget.likeAmount = widget.usersLikes.length;
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
    String email = await RecipeFromDB.like(widget.current.publish, widget.uid);
    setState(() {
      widget.isLikeRecipe = !widget.isLikeRecipe;
      // add to likes list
      widget.usersLikes[email] = widget.uid;
    });
  }

  Future<void> unlike() async {
    String email = await RecipeFromDB.like(widget.current.publish, widget.uid);
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
}
