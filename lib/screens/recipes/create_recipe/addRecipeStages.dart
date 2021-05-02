import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/stage.dart';
import '../../../config.dart';
import 'addRecipeTags.dart';

// ignore: must_be_immutable
class AddRecipeStages extends StatefulWidget {
  String username;
  String uid;
  String name;
  String description;
  String imagePath;
  List<IngredientsModel> ingredients;
  AddRecipeStages(
      String _username,
      String _uid,
      String _name,
      String _description,
      String _imagePath,
      List<IngredientsModel> _ingredients) {
    username = _username;
    uid = _uid;
    name = _name;
    description = _description;
    imagePath = _imagePath;
    ingredients = _ingredients;
  }
  @override
  _AddRecipeStagesState createState() => _AddRecipeStagesState();
}

class _AddRecipeStagesState extends State<AddRecipeStages> {
  List<Stages> stages = [];
  String error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          box,
          box,
          title(),
          box,
          box,
          // stages
          Container(
              child: Column(children: [
            Text(error),
            stages.length <= 0
                ? Text(
                    'There is no stages in this recipe yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )
                : Container(
                    height: min(50 * stages.length.toDouble(), 300),
                    child: ListView.builder(
                        shrinkWrap: true,
                        addAutomaticKeepAlives: true,
                        itemCount: stages.length,
                        itemBuilder: (_, i) => Row(children: <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              stageIndex(i),
                              Expanded(
                                  child: SizedBox(
                                      height: 37.0,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'write stage...',
                                        ),
                                        validator: (val) => val.length < 2
                                            ? 'Enter a description eith 2 letter at least'
                                            : null,
                                        onChanged: (val) {
                                          setState(() => stages[i].s = val);
                                        },
                                      ))),
                              deleteButton(i),
                            ])),
                  ),
            box,
            addButton(),
            SizedBox(
              height: (min(50 * stages.length.toDouble(), 300) ==
                      50 * stages.length.toDouble())
                  ? 300 - 50 * stages.length.toDouble()
                  : 0,
            ),
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
                  animationDuration: 500,
                  percent: 0.375,
                  center: Text(
                    "37.5%",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
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
          ])),
        ],
      ),
    );
  }

  void onDelteStages(int i) {
    setState(() {
      stages.removeAt(i);
    });
  }

  void addStages() {
    setState(() {
      stages.add(Stages());
    });
  }

  Widget addButton() {
    return FloatingActionButton(
      onPressed: addStages,
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
      onPressed: () => onDelteStages(i),
      elevation: 0.2,
      child: Icon(
        Icons.delete_forever,
        size: 30,
      ),
      padding: EdgeInsets.all(5.0),
      shape: CircleBorder(),
    );
  }

  Widget title() {
    return Text('Add Stages to your recipe',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Raleway'));
  }

  Widget stageIndex(int i) {
    return Text(
      (i + 1).toString() + "." + " ",
      style: TextStyle(fontSize: 20, fontFamily: 'DescriptionFont'),
    );
  }

  Widget nextLevelButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: this.stages.length != 0 ? Colors.green : Colors.grey,
      onPressed: () {
        if (this.stages.length != 0) {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(seconds: 0),
                  pageBuilder: (context, animation1, animation2) =>
                      AddRecipeTags(
                          widget.username,
                          widget.uid,
                          widget.name,
                          widget.description,
                          widget.imagePath,
                          widget.ingredients,
                          stages)));
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
}
