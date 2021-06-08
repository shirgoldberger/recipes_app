import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:recipes_app/shared_screen/uploadImage.dart';
import 'package:recipes_app/screens/recipes/edit_recipe/editRecipeIngredients.dart';
import 'package:recipes_app/screens/recipes/edit_recipe/editRecipeLevel.dart';
import 'package:recipes_app/services/fireStorageService.dart';
import '../../../shared_screen/config.dart';
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
  List previousTags = [];
  EditRecipe(
      String _uid,
      Recipe _current,
      List<Stages> _stages,
      List<IngredientsModel> _ingredients,
      String _levelString,
      Color _levelColor,
      NetworkImage _image) {
    uid = _uid;
    current = _current;
    stages = _stages;
    current.stages = stages;
    ingredients = _ingredients;
    levelString = _levelString;
    levelColor = _levelColor;
    imagePath = current.imagePath;
    recipeImage = _image;
  }

  @override
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  @override
  void initState() {
    super.initState();
    widget.previousTags.addAll(widget.current.tags);
    sortStages();
    sortIngredients();
    setTimeText();
  }

  // void getImage(BuildContext context) async {
  //   if (widget.recipeImage != null || widget.imagePath == "") {
  //     return;
  //   }
  //   String downloadUrl = await FireStorageService.loadFromStorage(
  //       context, "uploads/" + widget.imagePath);
  //   setState(() {
  //     widget.imagePath = downloadUrl.toString();
  //     widget.recipeImage = NetworkImage(downloadUrl);
  //   });
  // }

  // void getUserImage() async {
  //   DocumentSnapshot user = await Firestore.instance
  //       .collection('users')
  //       .document(widget.current.writerUid)
  //       .get();
  //   setState(() {
  //     widget.imagePath = user.data['imagePath'];
  //   });
  // }

  void sortIngredients() {
    setState(() {
      widget.ingredients.sort((a, b) => a.index.compareTo(b.index));
    });
  }

  void sortStages() {
    widget.stages.sort((a, b) => a.i.compareTo(b.i));
  }

  @override
  Widget build(BuildContext context) {
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
    Navigator.pop(context, {
      "recipe": widget.current,
      "image": widget.recipeImage,
      "imagePath": widget.imagePath
    });
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

    if (widget.current.publish != "") {
      var tags =
          await db.collection('tags').document('xt0XXXOLgprfkO3QiANs').get();
      // delete tags
      for (int i = 0; i < widget.previousTags.length; i++) {
        List tag = tags.data[widget.previousTags[i]];
        List copyTag = [];
        copyTag.addAll(tag);
        copyTag.remove(widget.current.publish);
        db
            .collection('tags')
            .document('xt0XXXOLgprfkO3QiANs')
            .updateData({widget.previousTags[i]: copyTag});
      }

      // add tags
      for (int i = 0; i < widget.current.tags.length; i++) {
        List tag = tags.data[widget.current.tags[i]];
        List copyTag = [];
        copyTag.addAll(tag);
        copyTag.add(widget.current.publish);
        db
            .collection('tags')
            .document('xt0XXXOLgprfkO3QiANs')
            .updateData({widget.current.tags[i]: copyTag});
      }
    }
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
          // ignore: missing_required_param
          child: FlatButton(onPressed: uploadImagePressed));
    } else {
      if (widget.recipeImage != null) {
        return CircleAvatar(
            backgroundColor: backgroundColor,
            radius: 30,
            backgroundImage: widget.recipeImage,
            // ignore: missing_required_param
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
        // ignore: deprecated_member_use
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
            'Ingredients:',
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
              itemCount: widget.ingredients.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.ingredients[i].count.toString() +
                        " " +
                        widget.ingredients[i].unit.toString() +
                        " " +
                        widget.ingredients[i].name.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Raleway',
                        fontSize: 20),
                  ),
                );
              }),
          editIngredients()
        ],
      ),
    ));
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
              physics: NeverScrollableScrollPhysics(),
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
              physics: NeverScrollableScrollPhysics(),
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
      if (i != widget.current.tags.length - 1) {
        tag += "#" + widget.current.tags[i] + " ,";
      } else {
        tag += "#" + widget.current.tags[i];
      }
    }
    return tag;
  }
}
