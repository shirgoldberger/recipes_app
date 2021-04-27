import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipes/recipeHeadLine.dart';

class RecipeList extends StatefulWidget {
  RecipeList(Map<String, List> map, String head, bool home) {
    // this.list = list;
    this.head = head;
    this.home = home;
    this.map = map;
  }
  bool home;
  List<Recipe> list = [];
  String head;
  Map<String, List> map = {};
  List<String> myTags = [];
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List tagList = [
    'choose recipe tag',
    'fish',
    'meat',
    'dairy',
    'desert',
    'for children',
    'other',
    //
    'vegetarian',
    'Gluten free',
    'without sugar',
    'vegan',
    'Without milk',
    'No eggs',
    'kosher',
    'baking',
    'cakes and cookies',
    'Food toppings',
    'Salads',
    'Soups',
    'Pasta',
    'No carbs',
    'Spreads',
  ];
  @override
  Widget build(BuildContext context) {
    Widget tags(int index) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Flexible(
              child: Text(
                widget.myTags[index],
                style: TextStyle(
                    fontFamily: 'Raleway', color: Colors.black, fontSize: 13),
              ),
            ),
            Expanded(
              child: FlatButton(
                child: Icon(Icons.cancel, size: 20),
                onPressed: () {
                  deleteTag(widget.myTags[index]);
                },
              ),
            ),
          ],
        ),
      );
    }

    String selectedSubject;

    setState(() {
      widget.list = (widget.map[widget.head]);
      tagList.remove(widget.head);
      if (!widget.myTags.contains(widget.head)) {
        widget.myTags.add(widget.head);
      }
    });
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: Text(
            widget.head + " recipes:",
            style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey[700],
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: Column(children: <Widget>[
          DropdownButton<String>(
            value: selectedSubject,
            onChanged: (value) {
              setState(() {
                tagList.remove(value);
                widget.myTags.add(value);
                addtag(value);
              });
            },
            items: tagList.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
          ),
          Flexible(
            //flex: (widget.myTags.length % 3) * 10,
            child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                childAspectRatio: (30 / 10),
                children: List.generate(widget.myTags.length, (index) {
                  return Flexible(child: tags(index));
                })),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          // Container(
          //   height: MediaQuery.of(context).size.height *
          //       (1 - (widget.myTags.length * 0.1)),
          Flexible(
            // flex: 100 - ((widget.myTags.length % 3) * 10),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                // print('recipeList');
                // print(widget.list[index]);
                return Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0)),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0)),
                            child: RecipeHeadLine(
                                widget.list[index], widget.home))));
              },
            ),
          )
        ]));
  }

  void addtag(String value) {
    List valueList = widget.map[value];
    if (valueList != null) {
      for (int i = 0; i < valueList.length; i++) {
        Recipe recipe = valueList[i];
        if (!widget.list.contains(recipe)) {
          widget.list.add(recipe);
        }
      }
    }
  }

  void deleteTag(String value) {
    //  print(value);
    //  print("my tags");
    //  print(widget.myTags);
    setState(() {
      widget.myTags.remove(value);
    });
    setState(() {
      tagList.add(value);
    });
    print(widget.myTags);
    List valueList = widget.map[value];
    for (int i = 0; i < valueList.length; i++) {
      bool findTag = false;
      Recipe recipe = valueList[i];
      for (int j = 0; j < recipe.myTag.length; j++) {
        print(recipe.myTag);
        print(widget.myTags);
        if (widget.myTags.contains(recipe.myTag[j])) {
          print("fibd");
          findTag = true;
        }
      }
      if (!findTag) {
        widget.list.remove(recipe);
      }
    }
  }
}
