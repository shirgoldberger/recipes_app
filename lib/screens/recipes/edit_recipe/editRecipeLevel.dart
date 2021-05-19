import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/stage.dart';
import '../../../config.dart';

// ignore: must_be_immutable
class EditRecipeLevel extends StatefulWidget {
  int level;
  int time;
  Color easyColor = Colors.green[200];
  Color midColor = Colors.red[200];
  Color hardColor = Colors.blue[200];

  Color timeInit1 = Colors.black;
  Color timeInit2 = Colors.black;
  Color timeInit3 = Colors.black;
  EditRecipeLevel(int _level, int _time) {
    this.level = _level;
    this.time = _time;
    print(time);
    print(level);
  }

  @override
  _EditRecipeLevelState createState() => _EditRecipeLevelState();
}

class _EditRecipeLevelState extends State<EditRecipeLevel> {
  @override
  Widget build(BuildContext context) {
    setLevels();
    setTime();
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
                    icon: Icon(Icons.watch_later, color: widget.timeInit1),
                    onPressed: () {
                      setState(() {
                        widget.time = 1;
                        widget.timeInit1 = Colors.green[400];
                        widget.timeInit2 = Colors.black;
                        widget.timeInit3 = Colors.black;
                      });
                    }),
                Text('Until half-hour')
              ]),
            ),
            Expanded(
              // ignore: deprecated_member_use
              child: Column(children: [
                IconButton(
                    icon: Icon(Icons.watch_later, color: widget.timeInit2),
                    onPressed: () {
                      setState(() {
                        widget.time = 2;
                        widget.timeInit1 = Colors.black;
                        widget.timeInit2 = Colors.yellow[400];
                        widget.timeInit3 = Colors.black;
                      });
                    }),
                Text('Until hour')
              ]),
            ),
            Expanded(
              // ignore: deprecated_member_use
              child: Column(children: [
                IconButton(
                    icon: Icon(Icons.watch_later, color: widget.timeInit3),
                    onPressed: () {
                      setState(() {
                        widget.time = 3;
                        widget.timeInit1 = Colors.black;
                        widget.timeInit2 = Colors.black;
                        widget.timeInit3 = Colors.pink[400];
                      });
                    }),
                Text('Over an hour')
              ]),
            ),
          ]),
          SizedBox(
            height: 200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 60),
              saveButton(),
              SizedBox(width: 60),
              cancelButton()
            ],
          )
        ],
      ),
    );
  }

  setLevels() {
    print("set");
    print(widget.level);
    if (widget.level == 1) {
      setState(() {
        widget.easyColor = Colors.green[400];
      });
    }
    if (widget.level == 2) {
      setState(() {
        widget.midColor = Colors.red[900];
      });
    }
    if (widget.level == 3) {
      setState(() {
        widget.hardColor = Colors.blue[900];
      });
    }
  }

  void setTime() {
    switch (widget.time) {
      case 1:
        setState(() {
          widget.timeInit1 = Colors.green[400];
        });
        break;
      case 2:
        setState(() {
          widget.timeInit2 = Colors.pink[400];
        });
        break;
      case 3:
        setState(() {
          widget.timeInit3 = Colors.yellow[400];
        });
        break;
      default:
    }
  }

  Widget saveButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.green,
      onPressed: () {
        Navigator.pop(context, {"level": widget.level, "time": widget.time});
      },
      tooltip: 'save',
      child: Icon(Icons.save_rounded),
    );
  }

  Widget cancelButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.pop(context, {"level": null, "time": null}),
      elevation: 2.0,
      heroTag: null,
      backgroundColor: mainButtonColor,
      child: Icon(
        Icons.cancel,
        color: Colors.white,
      ),
      shape: CircleBorder(),
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
        color: widget.easyColor,
        child: Text(
          'Easy',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            widget.level = 1;
            widget.easyColor = Colors.green[900];
            widget.midColor = Colors.red[200];
            widget.hardColor = Colors.blue[200];
          });
        });
  }

  Widget mediumLevel() {
    // ignore: deprecated_member_use
    return RaisedButton(
        color: widget.midColor,
        child: Text(
          'Medium',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            widget.level = 2;
            widget.easyColor = Colors.green[200];
            widget.midColor = Colors.red[900];
            widget.hardColor = Colors.blue[200];
          });
        });
  }

  Widget hardLevel() {
    // ignore: deprecated_member_use
    return RaisedButton(
        color: widget.hardColor,
        child: Text(
          'Hard',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            widget.level = 3;
            widget.easyColor = Colors.green[200];
            widget.midColor = Colors.red[200];
            widget.hardColor = Colors.blue[900];
          });
        });
  }
}
