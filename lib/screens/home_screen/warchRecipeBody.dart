import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stages.dart';

class WatchRecipeBody extends StatefulWidget {
  WatchRecipeBody(Recipe c, List<IngredientsModel> ing, List<Stages> stages,
      Color levelColor, String levelString) {
    this.current = c;
    this.ing = ing;
    this.stages = stages;
    this.levelColor = levelColor;
    this.levelString = levelString;
  }
  Recipe current;
  List<IngredientsModel> ing = [];
  List<Stages> stages = [];
  Color levelColor;
  String levelString = '';
  @override
  _WatchRecipeBodyState createState() => _WatchRecipeBodyState();
}

class _WatchRecipeBodyState extends State<WatchRecipeBody> {
  @override
  Widget build(BuildContext context) {
    return new Container(
        child: ListView(children: [
      Container(
          child: new Column(children: [
        Center(
          child: new Text(
            widget.current.name + " / " + widget.current.writer,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.brown[900],
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
                fontSize: 40),
          ),
        ),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        new Text(
          widget.current.description,
          style: TextStyle(
              color: Colors.brown[900],
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontFamily: 'Open Sans',
              fontSize: 30),
        ),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        new Text(
          makeTags(),
          style: new TextStyle(color: Colors.brown, fontSize: 25.0),
        ),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        new Text(
          'ingredients for the recipe:',
          style: new TextStyle(color: Colors.brown, fontSize: 25.0),
        ),
        new Padding(padding: EdgeInsets.only(top: 10.0)),
        //level buttom
        if (widget.levelString != '')
          RaisedButton(
              color: widget.levelColor,
              child: Text(
                widget.levelString,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {}),
        new Padding(padding: EdgeInsets.only(top: 10.0)),
        Column(
          children: <Widget>[
            for (var i = 0; i < widget.ing.length; i++)
              Text(
                (i + 1).toString() +
                    "." +
                    "  " +
                    widget.ing[i].count.toString() +
                    " " +
                    widget.ing[i].unit.toString() +
                    " " +
                    widget.ing[i].name.toString(),
                textAlign: TextAlign.left,
                style: new TextStyle(color: Colors.brown, fontSize: 25.0),
              ),
          ],
        ),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        new Text(
          'stages for the recipe:',
          style: new TextStyle(color: Colors.brown, fontSize: 25.0),
        ),
        new Padding(padding: EdgeInsets.only(top: 10.0)),
        Column(
          children: <Widget>[
            for (var j = 0; j < widget.stages.length; j++)
              Text(
                (j + 1).toString() + "." + "  " + widget.stages[j].s,
                textAlign: TextAlign.left,
                style: new TextStyle(color: Colors.brown, fontSize: 25.0),
              ),
          ],
        ),
      ]))
    ]));
  }

  String makeTags() {
    String tag = '';
    for (int i = 0; i < widget.current.myTag.length; i++) {
      tag += "#" + widget.current.myTag[i] + " ,";
    }
    return tag;
  }
}
