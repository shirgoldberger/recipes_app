import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screen/home_screen/recipeHeadLine.dart';

class RecipeList extends StatefulWidget {
  RecipeList(List<Recipe> list, String head) {
    this.list = list;
    this.head = head;
  }
  List<Recipe> list = [];
  String head;
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text(widget.head + " recipes:"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                return RecipeHeadLine(widget.list[index]);
              },
            ),
          )
        ]));

    return Container();
  }
}
