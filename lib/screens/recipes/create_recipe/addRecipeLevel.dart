import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/stage.dart';
import '../../../config.dart';
import 'addRecipeNotes.dart';

// ignore: must_be_immutable
class AddRecipeLevel extends StatefulWidget {
  String username;
  String uid;
  String name;
  String description;
  String imagePath;
  List<IngredientsModel> ingredients;
  List<Stages> stages;
  List<String> tags;
  AddRecipeLevel(
      String _username,
      String _uid,
      String _name,
      String _description,
      String _imagePath,
      List<IngredientsModel> _ingredients,
      List<Stages> _stages,
      List<String> _tags) {
    username = _username;
    uid = _uid;
    name = _name;
    description = _description;
    imagePath = _imagePath;
    ingredients = _ingredients;
    stages = _stages;
    tags = _tags;
  }
  @override
  _AddRecipeLevelState createState() => _AddRecipeLevelState();
}

class _AddRecipeLevelState extends State<AddRecipeLevel> {
  int level = 0;
  Color easyColor = Colors.green[200];
  Color midColor = Colors.red[200];
  Color hardColor = Colors.blue[200];
  int time = 0;
  Color timeInit1 = Colors.black;
  Color timeInit2 = Colors.black;
  Color timeInit3 = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          box,
          box,
          SizedBox(height: 37.0, child: levelTitle()),
          box,
          box,
          Row(children: <Widget>[
            SizedBox(
              width: 50,
            ),
            easyLevel(),
            SizedBox(
              width: 20,
            ),
            mediumLevel(),
            SizedBox(
              width: 20,
            ),
            hardLevel()
          ]),
          box,
          box,
          box,
          SizedBox(height: 37.0, child: timeTitle()),
          Row(children: <Widget>[
            Expanded(
              // ignore: deprecated_member_use
              child: Column(children: [
                IconButton(
                    icon: Icon(Icons.watch_later, color: timeInit1),
                    onPressed: () {
                      setState(() {
                        time = 1;
                        timeInit1 = Colors.green[400];
                        timeInit2 = Colors.black;
                        timeInit3 = Colors.black;
                      });
                    }),
                Text('Until half-hour')
              ]),
            ),
            Expanded(
              // ignore: deprecated_member_use
              child: Column(children: [
                IconButton(
                    icon: Icon(Icons.watch_later, color: timeInit2),
                    onPressed: () {
                      setState(() {
                        time = 2;
                        timeInit1 = Colors.black;
                        timeInit2 = Colors.yellow[400];
                        timeInit3 = Colors.black;
                      });
                    }),
                Text('Until hour')
              ]),
            ),
            Expanded(
              // ignore: deprecated_member_use
              child: Column(children: [
                IconButton(
                    icon: Icon(Icons.watch_later, color: timeInit3),
                    onPressed: () {
                      setState(() {
                        time = 3;
                        timeInit1 = Colors.black;
                        timeInit2 = Colors.black;
                        timeInit3 = Colors.pink[400];
                      });
                    }),
                Text('Over an hour')
              ]),
            ),
          ]),
          SizedBox(
            height: 300,
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
                percent: 0.625,
                center: Text(
                  "62.5%",
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
        ],
      ),
    );
  }

  Widget levelTitle() {
    return Text('Choose the level of the recipe:',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Raleway'));
  }

  Widget timeTitle() {
    return Text('Choose the average time of your recipe:',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Raleway'));
  }

  Widget easyLevel() {
    // ignore: deprecated_member_use
    return RaisedButton(
        color: easyColor,
        child: Text(
          'Easy',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            level = 1;
            easyColor = Colors.green[900];
            midColor = Colors.red[200];
            hardColor = Colors.blue[200];
          });
        });
  }

  Widget mediumLevel() {
    // ignore: deprecated_member_use
    return RaisedButton(
        color: midColor,
        child: Text(
          'Medium',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            level = 2;
            easyColor = Colors.green[200];
            midColor = Colors.red[900];
            hardColor = Colors.blue[200];
          });
        });
  }

  Widget hardLevel() {
    // ignore: deprecated_member_use
    return RaisedButton(
        color: hardColor,
        child: Text(
          'Hard',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            level = 3;
            easyColor = Colors.green[200];
            midColor = Colors.red[200];
            hardColor = Colors.blue[900];
          });
        });
  }

  Widget nextLevelButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor:
          this.level != 0 && this.time != 0 ? Colors.green : Colors.grey,
      onPressed: (this.level == 0 || this.time == 0)
          ? null
          : () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      transitionDuration: Duration(seconds: 0),
                      pageBuilder: (context, animation1, animation2) =>
                          AddRecipeNotes(
                              widget.username,
                              widget.uid,
                              widget.name,
                              widget.description,
                              widget.imagePath,
                              widget.ingredients,
                              widget.stages,
                              widget.tags,
                              level,
                              time)));
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
