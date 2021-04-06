import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/home_screen/recipeHeadLine.dart';
import 'package:recipes_app/screens/home_screen/Folfer.dart';

class RecipeList extends StatefulWidget {
  RecipeList(List<Recipe> list, String head, bool home) {
    this.list = list;
    this.head = head;
    this.home = home;
  }
  bool home;
  List<Recipe> list = [];
  String head;
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: Text(
            widget.head + " recipes:",
            style: TextStyle(fontFamily: 'Raleway'),
          ),
          backgroundColor: Colors.blueGrey[700],
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                // print('recipeList');
                // print(widget.list[index]);
                return Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0)),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0)),
                            child:
                                //                       SizedBox(
                                //   height: 20.0,
                                // );
                                RecipeHeadLine(
                                    widget.list[index], widget.home))));
                //return Folder(widget.list, widget.home);
              },
            ),
          )
        ]));
  }
}
