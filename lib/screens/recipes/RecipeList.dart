import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipes/filter.dart';
import 'package:recipes_app/screens/recipes/recipeHeadLine.dart';

import '../../config.dart';

class RecipeList extends StatefulWidget {
  RecipeList(Map<String, List> map, String head, bool home) {
    // this.list = list;
    this.head = head;
    this.home = home;
    this.map = map;
  }
  bool home;
  List<Recipe> list = [];
  List<Recipe> listForWatch = [];
  String head;
  Map<String, List> map = {};
  List<String> myTags = [];
  String easyButtom = 'easy';
  Color easyButtomColor = Colors.green[100];
  String midButtom = 'medium';
  Color midButtomColor = Colors.yellow[100];
  String hardButtom = 'hard';
  Color hardButtomColor = Colors.blue[100];
  List<int> levelList = [];
  List<int> timeList = [];

  //Color noteEasyButtomColor = Colors.red[400];
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
  void initState() {
    super.initState();
    init();
  }

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

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            widget.head + " recipes:",
            style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
          ),
          backgroundColor: appBarBackgroundColor,
          elevation: 0.0,
          actions: <Widget>[
            filtterIcon(),
          ],
        ),
        body: Column(children: <Widget>[
          new Padding(padding: EdgeInsets.only(top: 15.0)),
          Text(
            "num of results: " + widget.listForWatch.length.toString(),
            style: TextStyle(
                fontFamily: 'Raleway', color: Colors.black, fontSize: 15),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
              itemCount: widget.listForWatch.length,
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
                            child: RecipeHeadLine(
                                widget.listForWatch[index], widget.home))));
              },
            ),
          )
        ]));
  }

  // Widget easyButton() {
  //   return FlatButton.icon(
  //       color: widget.easyButtomColor,
  //       icon: Icon(
  //         Icons.label,
  //         color: Colors.black,
  //       ),
  //       label: Text(
  //         widget.easyButtom,
  //         style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
  //       ),
  //       onPressed: () {
  //         if (widget.easyButtom == 'easy') {
  //           setState(() {
  //             widget.levelList.add(1);
  //             widget.easyButtom = '-easy';
  //             widget.easyButtomColor = Colors.green[400];
  //           });
  //           pushEasy();
  //         } else {
  //           setState(() {
  //             widget.levelList.remove(1);
  //             widget.easyButtom = 'easy';
  //             widget.easyButtomColor = Colors.green[100];
  //           });
  //           unPushEasy();
  //         }
  //       });
  // }

  // Widget midButton() {
  //   return FlatButton.icon(
  //       color: widget.midButtomColor,
  //       icon: Icon(Icons.label, color: Colors.black),
  //       label: Text(
  //         widget.midButtom,
  //         style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
  //       ),
  //       onPressed: () {
  //         if (widget.midButtom == 'medium') {
  //           setState(() {
  //             widget.levelList.add(2);
  //             widget.midButtom = '-medium';
  //             widget.midButtomColor = Colors.yellow[400];
  //           });
  //           pushEasy();
  //         } else {
  //           setState(() {
  //             widget.levelList.remove(2);
  //             widget.midButtom = 'medium';
  //             widget.midButtomColor = Colors.yellow[100];
  //           });
  //           unPushEasy();
  //         }
  //       });
  // }

  // Widget hardButton() {
  //   return FlatButton.icon(
  //       color: widget.hardButtomColor,
  //       icon: Icon(
  //         Icons.label,
  //         color: Colors.black,
  //       ),
  //       label: Text(
  //         widget.hardButtom,
  //         style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
  //       ),
  //       onPressed: () {
  //         if (widget.hardButtom == 'hard') {
  //           setState(() {
  //             widget.levelList.add(3);
  //             widget.hardButtom = '-hard';
  //             widget.hardButtomColor = Colors.blue[400];
  //           });
  //           pushEasy();
  //         } else {
  //           setState(() {
  //             widget.levelList.remove(3);
  //             widget.hardButtom = 'hard';
  //             widget.hardButtomColor = Colors.blue[100];
  //           });
  //           unPushEasy();
  //         }
  //       });
  // }

  void addtag(String value) {
    List valueList = widget.map[value];
    if (valueList != null) {
      for (int i = 0; i < valueList.length; i++) {
        Recipe recipe = valueList[i];
        if (!widget.list.contains(recipe)) {
          setState(() {
            widget.list.add(recipe);
            widget.listForWatch.add(recipe);
          });
          //  widget.list.add(recipe);
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
      for (int j = 0; j < recipe.tags.length; j++) {
        //  print(recipe.myTag);
        // print(widget.myTags);
        if (widget.myTags.contains(recipe.tags[j])) {
          //  print("fibd");
          findTag = true;
        }
      }
      if (!findTag) {
        setState(() {
          widget.list.remove(recipe);
          widget.listForWatch.remove(recipe);
        });
      }
    }
  }

  // void pushEasy() {
  //   print("push easy");
  //   print(widget.list);
  //   print(widget.listForWatch);
  //   setState(() {
  //     widget.listForWatch.clear();
  //   });
  //   print(widget.list);
  //   print(widget.listForWatch);
  //   for (int i = 0; i < widget.list.length; i++) {
  //     print(widget.list[i].level);
  //     if (widget.levelList.contains(widget.list[i].level)) {
  //       setState(() {
  //         widget.listForWatch.add(widget.list[i]);
  //       });
  //     }
  //   }
  // }

  // void unPushEasy() {
  //   if (widget.levelList.isEmpty) {
  //     setState(() {
  //       widget.listForWatch.clear();
  //       widget.listForWatch.addAll(widget.list);
  //     });
  //   } else {
  //     pushEasy();
  //   }
  // }

  void init() {
    for (int i = 0; i < widget.map[widget.head].length; i++) {
      setState(() {
        widget.list.add(widget.map[widget.head][i]);
        widget.listForWatch.add(widget.map[widget.head][i]);
      });
    }
    setState(() {
      tagList.remove(widget.head);
      if (!widget.myTags.contains(widget.head)) {
        widget.myTags.add(widget.head);
      }
    });
  }

  Widget filtterIcon() {
    return FlatButton.icon(
        icon: Icon(
          Icons.filter_alt_sharp,
          color: Colors.white,
        ),
        label: Text(
          'filter',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
        ),
        onPressed: () {
          _showfilter();
        });
  }

  Future<void> _showfilter() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: new BoxDecoration(
              color: backgroundColor,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: Filter(
                widget.list,
                widget.listForWatch,
                widget.levelList,
                widget.myTags,
                widget.timeList))).then((value) => cameBack(value));
  }

  cameBack(value) {
    List myTagCameBack = value['c'];
    // print(myTagCameBack);
    for (int i = 0; i < myTagCameBack.length; i++) {
      addtag(myTagCameBack[i]);
    }
    setState(() {
      widget.listForWatch = value['a'];
      widget.levelList = value['b'];
      widget.timeList = value['d'];
    });
  }
}
