import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stages.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screen/home_screen/editRecipe.dart';
import 'package:recipes_app/screen/home_screen/homeLogIn.dart';
import 'package:recipes_app/screen/home_screen/ingredients.dart';
import 'package:recipes_app/shared_screen/loading.dart';

class WatchRecipe extends StatefulWidget {
  WatchRecipe(Recipe r) {
    this.current = r;
  }
  List<IngredientsModel> ing = [];
  List<Stages> stages = [];
  Recipe current;
  bool done = false;
  int count = 0;
  String tags = '';
  final db = Firestore.instance;
  Color levelColor;
  String levelString = '';

  @override
  _WatchRecipeState createState() => _WatchRecipeState();
}

class _WatchRecipeState extends State<WatchRecipe> {
  var i;

  @override
  Widget build(BuildContext context) {
    if (widget.current.level == 1) {
      widget.levelColor = Colors.green[900];
      widget.levelString = "easy";
    }
    if (widget.current.level == 2) {
      widget.levelColor = Colors.red[900];
      widget.levelString = "nedium";
    }
    if (widget.current.level == 3) {
      widget.levelColor = Colors.blue[900];
      widget.levelString = "hard";
    }

    makeList();
    final user = Provider.of<User>(context);
    final db = Firestore.instance;
    if (!widget.done) {
      return Loading();
    } else {
      return Scaffold(
          backgroundColor: Colors.brown[100],
          appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('watch this recipe'),
              actions: <Widget>[
                FlatButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text('edit this recipe'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditRecipe(
                                  widget.current, widget.ing, widget.stages)));
                    }),
                FlatButton.icon(
                    icon: Icon(Icons.delete),
                    label: Text('delete this recipe'),
                    onPressed: () {
                      db
                          .collection('users')
                          .document(user.uid)
                          .collection('recipes')
                          .document(widget.current.id)
                          .delete();
                      //go back
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomeLogIn()));
                    })
              ]),
          body: new Container(
              child: ListView(
            children: [
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
                        style:
                            new TextStyle(color: Colors.brown, fontSize: 25.0),
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
                        style:
                            new TextStyle(color: Colors.brown, fontSize: 25.0),
                      ),
                  ],
                ),
              ]))
            ],
          )));
    }
  }

  String makeTags() {
    String tag = '';
    for (int i = 0; i < widget.current.myTag.length; i++) {
      tag += "#" + widget.current.myTag[i] + " ,";
    }
    return tag;
  }

  Future<void> makeList() async {
    if (!widget.done) {
      final user = Provider.of<User>(context);

      QuerySnapshot snap = await Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('recipes')
          .document(widget.current.id.toString())
          .collection('ingredients')
          .getDocuments();
      snap.documents.forEach((element) {
        print(element.data.toString());
        setState(() {
          widget.ing.add(IngredientsModel.antherConstactor(
              element.data['name'] ?? '',
              element.data['count'] ?? 0,
              element.data['unit'] ?? ''));
        });
      });
      QuerySnapshot snap2 = await Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('recipes')
          .document(widget.current.id.toString())
          .collection('stages')
          .getDocuments();
      snap2.documents.forEach((element1) {
        print(element1.data.toString());
        setState(() {
          widget.stages
              .add(Stages.antheeConstractor(element1.data['stage'] ?? ''));
        });
      });

      setState(() {
        widget.done = true;
      });
    }
  }
}
