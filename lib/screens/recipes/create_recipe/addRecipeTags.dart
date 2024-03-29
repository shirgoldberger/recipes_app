import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/stage.dart';
import '../../../shared_screen/config.dart';
import 'addRecipeLevel.dart';

// ignore: must_be_immutable
class AddRecipeTags extends StatefulWidget {
  String username;
  String uid;
  String name;
  String description;
  String imagePath;
  String error = '';
  List<IngredientsModel> ingredients;
  List<Stages> stages;
  AddRecipeTags(
      String _username,
      String _uid,
      String _name,
      String _description,
      String _imagePath,
      List<IngredientsModel> _ingredients,
      List<Stages> _stages) {
    username = _username;
    uid = _uid;
    name = _name;
    description = _description;
    imagePath = _imagePath;
    ingredients = _ingredients;
    stages = _stages;
  }
  @override
  _AddRecipeTagsState createState() => _AddRecipeTagsState();
}

class _AddRecipeTagsState extends State<AddRecipeTags> {
  String tagChoose;
  int count = 0;
  List<String> tags = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      box,
      box,
      title(),
      box,
      box,
      Text(
        widget.error,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      Container(
          height: 498,
          child: Column(children: [
            tags.length <= 0
                ? Text(
                    'There is no tags in this recipe yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )
                : Container(
                    height: min(80 * tags.length.toDouble(), 400),
                    child: ListView.builder(
                        shrinkWrap: true,
                        addAutomaticKeepAlives: true,
                        itemCount: tags.length,
                        itemBuilder: (_, i) => Row(children: <Widget>[
                              SizedBox(
                                width: 40,
                              ),
                              Expanded(
                                  child: SizedBox(
                                height: 37.0,
                                child: DropdownButton(
                                  hint: Text("choose this recipe tag"),
                                  dropdownColor: Colors.grey,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  value: tags[i],
                                  onChanged: (newValue) {
                                    setState(() {
                                      tags[i] = newValue;
                                    });
                                  },
                                  items: tagList.map((valueItem) {
                                    return DropdownMenuItem(
                                      value: valueItem,
                                      child: Text(valueItem),
                                    );
                                  }).toList(),
                                ),
                              )),
                              SizedBox(
                                width: 20,
                              ),
                              deleteButton(i)
                            ])),
                  ),
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
            width: 240,
            animation: true,
            lineHeight: 18.0,
            animationDuration: 500,
            percent: 0.5,
            center: Text(
              "50%",
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
    ]));
  }

  void addTags() {
    setState(() {
      tags.add('choose recipe tag');
    });
  }

  void onDelteTags(int i) {
    setState(() {
      tags.removeAt(i);
    });
  }

  Widget title() {
    return Text('Add Tags:',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Raleway'));
  }

  Widget addButton() {
    return FloatingActionButton(
      onPressed: addTags,
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

  Widget nextLevelButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: this.tags.length != 0 ? Colors.green : Colors.grey,
      onPressed: () {
        bool check = false;
        for (int i = 0; i < tags.length; i++) {
          if (tags[i] == 'choose recipe tag') {
            check = true;
          }
        }
        if ((this.tags.length != 0) && (!check)) {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(seconds: 0),
                  pageBuilder: (context, animation1, animation2) =>
                      AddRecipeLevel(
                          widget.username,
                          widget.uid,
                          widget.name,
                          widget.description,
                          widget.imagePath,
                          widget.ingredients,
                          widget.stages,
                          tags)));
        } else {
          if (check) {
            setState(() {
              widget.error = "Choose recipe tag!";
            });
          }
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

  Widget deleteButton(int i) {
    return RawMaterialButton(
      onPressed: () => onDelteTags(i),
      elevation: 0.2,
      child: Icon(
        Icons.delete_forever,
        size: 30,
      ),
      padding: EdgeInsets.all(5.0),
      shape: CircleBorder(),
    );
  }
}
