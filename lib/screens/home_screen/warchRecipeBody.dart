import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stages.dart';
import 'package:recipes_app/services/fireStorageService.dart';

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
  String imagePath;
  var m;
  Future<Widget> _getImage(BuildContext context, String image) async {
    print("imageeeeeeeeeeeeeeeeeeeee" + image);
    if (image == "") {
      return null;
    }
    if (this.m != null) {
      return this.m;
    }
    image = "uploads/" + image;
    Image m;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      print("downloadUrl:" + downloadUrl.toString());
      this.m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });

    return this.m;
  }

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
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
                fontSize: 40),
          ),
        ),

        new Padding(padding: EdgeInsets.only(top: 15.0)),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: FutureBuilder(
              future: _getImage(context, widget.current.imagePath),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return Container(
                    height: 100,
                    width: 100,
                    child: snapshot.data,
                  );

                if (snapshot.connectionState == ConnectionState.waiting)
                  return Container(
                      height: MediaQuery.of(context).size.height / 10,
                      width: MediaQuery.of(context).size.width / 10,
                      child: CircularProgressIndicator());
              }),
        ),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        new Text(
          widget.current.description,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontFamily: 'Open Sans',
              fontSize: 30),
        ),
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        new Text(
          makeTags(),
          style: new TextStyle(color: Colors.black, fontSize: 25.0),
        ),
        if (widget.levelString != '')
          RaisedButton(
              color: widget.levelColor,
              child: Text(
                widget.levelString,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {}),
        //  new Padding(padding: EdgeInsets.only(top: 10.0)),

        new Padding(padding: EdgeInsets.only(top: 15.0)),

        //level buttom

        new Center(
          child: new Container(
            width: 450,
            // height: 300,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              // boxShadow: [
              //   new BoxShadow(
              //     color: Colors.grey,
              //     offset: new Offset(3.0, 3.0),
              //   ),
              // ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(padding: EdgeInsets.only(top: 20.0)),
                new Text(
                  'ingredients for the recipe:',
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700),
                ),
                new Padding(padding: EdgeInsets.only(top: 10.0)),
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
                        new TextStyle(color: Colors.grey[800], fontSize: 25.0),
                  ),
                new Padding(padding: EdgeInsets.only(top: 20.0)),
              ],
            ),
          ),
        ),
        new Padding(padding: EdgeInsets.only(top: 15.0)),

        new Padding(padding: EdgeInsets.only(top: 10.0)),
        new Center(
            child: new Container(
          width: 450,
          // height: 300,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            // boxShadow: [
            //   new BoxShadow(
            //     color: Colors.grey,
            //     offset: new Offset(3.0, 3.0),
            //   ),
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(top: 20.0)),
              new Text(
                'stages for the recipe:',
                style: new TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700),
              ),
              new Padding(padding: EdgeInsets.only(top: 10.0)),
              for (var j = 0; j < widget.stages.length; j++)
                Text(
                  (j + 1).toString() + "." + "  " + widget.stages[j].s,
                  textAlign: TextAlign.left,
                  style: new TextStyle(color: Colors.grey[800], fontSize: 25.0),
                ),
              new Padding(padding: EdgeInsets.only(top: 20.0)),
            ],
          ),
        ))
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
