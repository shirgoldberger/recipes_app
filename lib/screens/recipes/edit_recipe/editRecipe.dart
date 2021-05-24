import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:recipes_app/screens/personal_screen/uploadImage.dart';
import 'package:recipes_app/screens/recipes/edit_recipe/editRecipeIngredients.dart';
import 'package:recipes_app/screens/recipes/edit_recipe/editRecipeLevel.dart';
import 'package:recipes_app/services/fireStorageService.dart';
import '../../../config.dart';
import 'editRecipeNotes.dart';
import 'editRecipeStages.dart';
import 'editRecipeTags.dart';

// ignore: must_be_immutable
class EditRecipe extends StatefulWidget {
  String uid;
  Recipe current;
  List<Stages> stages;
  List<IngredientsModel> ingredients;
  NetworkImage recipeImage;
  String levelString;
  Color levelColor;
  String imagePath;
  String timeText = '';
  EditRecipe(
      String _uid,
      Recipe _current,
      List<Stages> _stages,
      List<IngredientsModel> _ingredients,
      String _levelString,
      Color _levelColor) {
    uid = _uid;
    current = _current;
    stages = _stages;
    current.stages = stages;
    ingredients = _ingredients;
    levelString = _levelString;
    levelColor = _levelColor;
    imagePath = current.imagePath;
  }

  @override
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  @override
  void initState() {
    super.initState();
    getUserImage();
    sortStages();
    sortIngredients();
    setTimeText();
  }

  void getImage(BuildContext context) async {
    if (widget.recipeImage != null || widget.imagePath == "") {
      return;
    }
    String downloadUrl = await FireStorageService.loadFromStorage(
        context, "uploads/" + widget.imagePath);
    setState(() {
      widget.imagePath = downloadUrl.toString();
      widget.recipeImage = NetworkImage(downloadUrl);
    });
  }

  void getUserImage() async {
    DocumentSnapshot user = await Firestore.instance
        .collection('users')
        .document(widget.current.writerUid)
        .get();
    setState(() {
      widget.imagePath = user.data['imagePath'];
    });
  }

  void sortIngredients() {
    setState(() {
      widget.ingredients.sort((a, b) => a.index.compareTo(b.index));
    });
  }

  void sortStages() {
    for (int i = 0; i < widget.stages.length; i++) {
      print(widget.stages[i].i);
    }
    widget.stages.sort((a, b) => a.i.compareTo(b.i));
    // List<Stages> stageCopy = [];
    // stageCopy.addAll(widget.stages);
    // for (int i = 0; i < stageCopy.length; i++) {
    //   setState(() {
    //     widget.stages[stageCopy[i].i] = stageCopy[i];
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    getImage(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        title: Text(
          'Edit Recipe',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
        ),
        actions: [saveIcon(), cancelIcon()],
      ),
      body: Container(
          child: ListView(children: [
        Container(
            child: new Column(children: [
          name(),
          new Padding(padding: EdgeInsets.only(top: 15.0)),
          if (widget.levelString != '') level(),
          Divider(
            height: 40,
            thickness: 8,
          ),
          padding,
          description(),
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
          editTags()
        ]))
      ])),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget imageBox() {
    return TextButton(
      child: CircleAvatar(
          backgroundColor: backgroundColor,
          radius: 40,
          backgroundImage: (widget.recipeImage == null)
              ? ExactAssetImage(noImagePath)
              : widget.recipeImage),
      onPressed: uploadImagePressed,
    );
  }

  Widget saveIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'SAVE',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
        ),
        onPressed: save);
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

  Widget cancelIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(
          Icons.cancel,
          color: Colors.white,
        ),
        label: Text(
          'Cancel',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
        ),
        onPressed: () => Navigator.pop(context, null));
  }

  void save() async {
    BuildContext dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                backgroundColor: Colors.black87,
                content: loadingIndicator()));
      },
    );
    await saveThisRecipe();
    Navigator.pop(dialogContext);
    Navigator.pop(context, widget.current);
  }

  Future<void> saveThisRecipe() async {
    final db = Firestore.instance;
    await db
        .collection('users')
        .document(widget.uid)
        .collection('recipes')
        .document(widget.current.id)
        .updateData(widget.current.toJson());
    //set the new id to data base
    QuerySnapshot ingredientsFromDb = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('recipes')
        .document(widget.current.id)
        .collection('ingredients')
        .getDocuments();
    ingredientsFromDb.documents.forEach((element) async {
      await db
          .collection('users')
          .document(widget.uid)
          .collection('recipes')
          .document(widget.current.id)
          .collection('ingredients')
          .document(element.documentID)
          .delete();
    });

    for (int i = 0; i < widget.ingredients.length; i++) {
      await db
          .collection('users')
          .document(widget.uid)
          .collection('recipes')
          .document(widget.current.id)
          .collection('ingredients')
          .add(widget.ingredients[i].toJson());
    }

    QuerySnapshot stagwsFromDB = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('recipes')
        .document(widget.current.id)
        .collection('stages')
        .getDocuments();
    stagwsFromDB.documents.forEach((element) async {
      await db
          .collection('users')
          .document(widget.uid)
          .collection('recipes')
          .document(widget.current.id)
          .collection('stages')
          .document(element.documentID)
          .delete();
    });

    for (int i = 0; i < widget.stages.length; i++) {
      await db
          .collection('users')
          .document(widget.uid)
          .collection('recipes')
          .document(widget.current.id)
          .collection('stages')
          .add(widget.stages[i].toJson(i));
    }
    widget.current.ingredients = widget.ingredients;
    widget.current.stages = widget.stages;
  }

  Widget name() {
    return Center(
      child: new TextFormField(
        initialValue: widget.current.name,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway',
            fontSize: 60),
        onChanged: (value) => widget.current.name = value,
      ),
    );
  }

  Widget picture() {
    // there is no image yet
    if (widget.imagePath == "") {
      return CircleAvatar(
          backgroundColor: backgroundColor,
          radius: 30,
          backgroundImage: ExactAssetImage(noImagePath),
          child: FlatButton(onPressed: uploadImagePressed));
    } else {
      if (widget.recipeImage != null) {
        return CircleAvatar(
            backgroundColor: backgroundColor,
            radius: 30,
            backgroundImage: widget.recipeImage,
            child: FlatButton(onPressed: uploadImagePressed));
      } else {
        return Container(
            height: 20, width: 20, child: CircularProgressIndicator());
      }
    }
  }

  void uploadImagePressed() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UploadingImageToFirebaseStorage()))
        .then((value) async {
      if (value != "") {
        setState(() {
          widget.imagePath = value;
          widget.current.imagePath = value;
        });

        String downloadUrl = await FireStorageService.loadFromStorage(
            context, "uploads/" + widget.imagePath);
        setState(() {
          widget.recipeImage = NetworkImage(downloadUrl);
        });
      }
    });
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

  Widget description() {
    return TextFormField(
      initialValue: widget.current.description,
      style:
          TextStyle(color: Colors.black, fontFamily: 'Raleway', fontSize: 20),
      onChanged: (value) => widget.current.description = value,
    );
  }

  Widget level() {
    // ignore: deprecated_member_use
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        picture(),
        SizedBox(width: 20),
        RaisedButton(
          color: widget.levelColor,
          child: Text(
            widget.levelString,
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: 10),
        time(),
        RawMaterialButton(
          onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditRecipeLevel(
                          widget.current.level, widget.current.time)))
              .then((value) => {
                    if (value != null)
                      {
                        setState(() {
                          widget.current.level = value["level"];
                          widget.current.time = value["time"];
                          setLevels();
                          setTimeText();
                        })
                      }
                  }),
          child: Icon(
            Icons.edit,
          ),
          shape: CircleBorder(),
        ),
      ],
    );
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
              'Ingredients:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Raleway',
                  fontSize: 27),
            ),
            new Padding(padding: EdgeInsets.only(top: 10.0)),
            for (var i = 0; i < widget.ingredients.length; i++)
              Row(
                children: [
                  Text(
                    widget.ingredients[i].count.toString() +
                        " " +
                        widget.ingredients[i].unit.toString() +
                        " " +
                        widget.ingredients[i].name.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Raleway',
                        fontSize: 20),
                  ),
                ],
              ),
            editIngredients(),
            new Padding(padding: EdgeInsets.only(top: 20.0)),
          ],
        ),
      ),
    );
  }

  setLevels() {
    if (widget.current.level == 1) {
      widget.levelColor = Colors.green[900];
      widget.levelString = "Easy";
    }
    if (widget.current.level == 2) {
      widget.levelColor = Colors.red[900];
      widget.levelString = "Medium";
    }
    if (widget.current.level == 3) {
      widget.levelColor = Colors.blue[900];
      widget.levelString = "Hard";
    }
  }

  Widget editIngredients() {
    return RawMaterialButton(
      onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditRecipeIngredients(widget.uid, widget.ingredients)))
          .then((value) => {
                if (value != null)
                  {
                    setState(() {
                      widget.ingredients = value;
                      print("change");
                    })
                  }
                else
                  {print("else" + widget.ingredients.length.toString())}
              }),
      elevation: 0.2,
      child: Icon(
        Icons.add,
        size: 20,
      ),
      padding: EdgeInsets.all(5.0),
      shape: CircleBorder(),
    );
  }

  Widget editStages() {
    return RawMaterialButton(
      onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditRecipeStages(widget.uid, widget.stages)))
          .then((value) => {
                if (value != null)
                  {
                    setState(() {
                      widget.stages = value;
                      print("change");
                    })
                  }
                else
                  {print("else" + widget.ingredients.length.toString())}
              }),
      elevation: 0.2,
      child: Icon(
        Icons.add,
        size: 20,
      ),
      padding: EdgeInsets.all(5.0),
      shape: CircleBorder(),
    );
  }

  Widget editTags() {
    return RawMaterialButton(
      onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditRecipeTags(widget.uid, widget.current.tags)))
          .then((value) => {
                if (value != null)
                  {
                    setState(() {
                      widget.current.tags = value;
                    })
                  }
              }),
      elevation: 0.2,
      child: Icon(
        Icons.add,
        size: 20,
      ),
      padding: EdgeInsets.all(5.0),
      shape: CircleBorder(),
    );
  }

  Widget editNotes() {
    return RawMaterialButton(
      onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditRecipeNotes(widget.uid, widget.current.notes)))
          .then((value) => {
                if (value != null)
                  {
                    setState(() {
                      widget.current.notes = value;
                      print("change");
                    })
                  }
                else
                  {print("else" + widget.ingredients.length.toString())}
              }),
      elevation: 0.2,
      child: Icon(
        Icons.add,
        size: 20,
      ),
      padding: EdgeInsets.all(5.0),
      shape: CircleBorder(),
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
            'Stages:',
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
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
              itemCount: widget.stages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    index.toString() + ". " + widget.stages[index].s,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Raleway',
                        fontSize: 20),
                  ),
                );
              }),
          editStages()
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
            'Notes:',
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
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
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
              }),
          editNotes()
        ],
      ),
    ));
  }

  String makeTags() {
    String tag = '';
    for (int i = 0; i < widget.current.tags.length; i++) {
      tag += "#" + widget.current.tags[i] + " ,";
    }
    return tag;
  }

  //   Future<void> _showLikesList() async {
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
  //           child: LikesList(widget.current)));
  // }
}
