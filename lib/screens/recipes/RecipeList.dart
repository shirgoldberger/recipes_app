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
      //   return Card(
      //       child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      //     Expanded(child: Text(widget.myTags[index])),
      //     ButtonBar(children: <Widget>[
      //       FlatButton.icon(
      //           icon: Icon(
      //             Icons.delete,
      //             color: Colors.black,
      //           ),
      //           label: Text(
      //             '',
      //             style: TextStyle(color: Colors.white),
      //           ),
      //           onPressed: () {
      //             deleteTag(widget.myTags[index]);
      //           }),
      //     ])
      //   ]));
      // }

      return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(widget.myTags[index]),
        FlatButton.icon(
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            label: Text(
              '',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              deleteTag(widget.myTags[index]);
            }),
      ]);
    }

    String selectedSubject;

    // void onDelteTags(int i) {
    //   setState(() {
    //     myTags.removeAt(i);
    //   });
    // }

    // void addTags() {
    //   print("add tags");
    //   setState(() {
    //     myTags.add('choose recipe tag');
    //   });
    // }

    setState(() {
      widget.list = (widget.map[widget.head]);
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
        body: ListView(children: <Widget>[
          //tags
          Container(
            // width: double.infinity,
            // height: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton<String>(
                    value: selectedSubject,
                    onChanged: (value) {
                      ///print(value);
                      // print(widget.myTags);
                      setState(() {
                        widget.myTags.add(value);
                        addtag(value);
                      });
                    },
                    items: tagList.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                  ),
                ]),
          ),

          Expanded(
            child: Container(
                height: 100,
                width: 500,
                child: GridView.count(
                    crossAxisCount: 3,
                    children: List.generate(widget.myTags.length, (index) {
                      return tags(index);
                    }))),
          ),

          Expanded(
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

  void addtag(String value) {
    List valueList = widget.map[value];
    for (int i = 0; i < valueList.length; i++) {
      Recipe recipe = valueList[i];
      if (!widget.list.contains(recipe)) {
        widget.list.add(recipe);
      }
    }
  }

  void deleteTag(String value) {
    print(value);
    print("my tags");
    print(widget.myTags);
    setState(() {
      widget.myTags.remove(value);
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