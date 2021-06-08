import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:recipes_app/screens/recipes/create_recipe/finishCreateRecipe.dart';
import '../../../shared_screen/config.dart';

// ignore: must_be_immutable
class AddRecipeNotes extends StatefulWidget {
  String username;
  String error = '';
  String uid;
  String name;
  String description;
  String imagePath;
  List<IngredientsModel> ingredients;
  List<Stages> stages;
  List<String> tags;
  int level;
  int time;
  AddRecipeNotes(
      String _username,
      String _uid,
      String _name,
      String _description,
      String _imagePath,
      List<IngredientsModel> _ingredients,
      List<Stages> _stages,
      List<String> _tags,
      int _level,
      int _time) {
    username = _username;
    uid = _uid;
    name = _name;
    description = _description;
    imagePath = _imagePath;
    ingredients = _ingredients;
    stages = _stages;
    tags = _tags;
    level = _level;
    time = _time;
  }
  @override
  _AddRecipeNotesState createState() => _AddRecipeNotesState();
}

class _AddRecipeNotesState extends State<AddRecipeNotes> {
  List<String> notes = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        box, box,
        title(), box, box,
        Text(
          widget.error,
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        //notes
        Container(
            height: 498,
            child: Column(children: [
              notes.length <= 0
                  ? Text(
                      'There is no notes in this recipe yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )
                  : Container(
                      height: min(60 * notes.length.toDouble(), 400),
                      child: ListView.builder(
                          shrinkWrap: true,
                          addAutomaticKeepAlives: true,
                          itemCount: notes.length,
                          itemBuilder: (_, i) => Row(children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                noteIndex(i),
                                Expanded(
                                    child: SizedBox(
                                        height: 37.0,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'add note...',
                                          ),
                                          validator: (val) => val.length < 2
                                              ? 'Enter a description eith 2 letter at least'
                                              : null,
                                          onChanged: (val) {
                                            setState(() => notes[i] = val);
                                          },
                                        ))),
                                SizedBox(
                                  width: 10,
                                ),
                                deleteButton(i)
                              ]))),
              box,
              addButton(),
            ])),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            previousLevelButton(),
            SizedBox(
              width: 10,
            ),
            LinearPercentIndicator(
              width: 250,
              animation: true,
              lineHeight: 18.0,
              animationDuration: 1000,
              percent: 0.75,
              center: Text(
                "75%",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.grey[600],
            ),
            SizedBox(
              width: 10,
            ),
            nextLevelButton()
          ],
        )
      ]),
      resizeToAvoidBottomInset: false,
    );
  }

  void addNotes() {
    setState(() {
      notes.add(' ');
    });
  }

  void onDelteNotes(int i) {
    setState(() {
      notes.removeAt(i);
    });
    if (notes.length == 0) {
      setState(() {
        widget.error = "";
      });
    }
  }

  Widget nextLevelButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.green,
      onPressed: () {
        bool check = false;
        for (int i = 0; i < notes.length; i++) {
          if ((notes[i] == null) || (notes[i] == ' ')) {
            check = true;
          }
        }
        if (!check) {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(seconds: 0),
                  pageBuilder: (context, animation1, animation2) =>
                      FinishCreateRecipe(
                          widget.username,
                          widget.uid,
                          widget.name,
                          widget.description,
                          widget.imagePath,
                          widget.ingredients,
                          widget.stages,
                          widget.tags,
                          widget.level,
                          widget.time,
                          notes)));
        } else {
          setState(() {
            widget.error = "note cant be null";
          });
        }
      },
      tooltip: 'next',
      child: Icon(Icons.navigate_next),
    );
  }

  Widget previousLevelButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
      tooltip: 'previous',
      child: Icon(Icons.navigate_before),
    );
  }

  Widget title() {
    return Text('Add Notes to your recipe',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Raleway'));
  }

  Widget addButton() {
    return FloatingActionButton(
      onPressed: addNotes,
      elevation: 2.0,
      heroTag: null,
      backgroundColor: Colors.black,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      shape: CircleBorder(),
    );
  }

  Widget deleteButton(int i) {
    return RawMaterialButton(
      onPressed: () => onDelteNotes(i),
      elevation: 0.2,
      child: Icon(
        Icons.delete_forever,
        size: 30,
      ),
      padding: EdgeInsets.all(5.0),
      shape: CircleBorder(),
    );
  }

  Widget noteIndex(int i) {
    return Text(
      (i + 1).toString() + "." + " ",
      style: TextStyle(fontSize: 20, fontFamily: 'DescriptionFont'),
    );
  }
}
