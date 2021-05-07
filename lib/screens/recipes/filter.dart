import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';

import '../../config.dart';

class Filter extends StatefulWidget {
  Filter(List<Recipe> _list, List<Recipe> _listForWatch, List<int> _levelList,
      List<String> myTags) {
    this.list = _list;
    this.listForWatch = _listForWatch;
    this.levelList = _levelList;
    this.myTags = myTags;
  }

  String easyButtom = 'easy';
  Color easyButtomColor = Colors.green[50];
  String midButtom = 'medium';
  Color midButtomColor = Colors.yellow[50];
  String hardButtom = 'hard';
  Color hardButtomColor = Colors.blue[50];
  List<int> levelList = [];
  List<Recipe> list = [];
  List<String> myTags = [];
  List<Recipe> listForWatch = [];
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
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.myTags.length; i++) {
      widget.tagList.remove(widget.myTags[i]);
    }
    if (widget.levelList.contains(1)) {
      setState(() {
        widget.easyButtom = '-easy';
        widget.easyButtomColor = Colors.green[400];
      });
    }
    if (widget.levelList.contains(2)) {
      setState(() {
        widget.midButtom = '-medium';
        widget.midButtomColor = Colors.yellow[400];
      });
    }
    if (widget.levelList.contains(3)) {
      setState(() {
        widget.hardButtom = '-hard';
        widget.hardButtomColor = Colors.blue[400];
      });
    }
    String selectedSubject;
    return Container(
        child: Column(
      children: [
        Text(
          "Filter:",
          style: TextStyle(
              fontFamily: 'Raleway', color: Colors.black, fontSize: 25),
        ),
        new Center(
            child: new Container(
                width: 400,
                decoration: new BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      dropdownColor: appBarBackgroundColor,
                      value: selectedSubject,
                      onChanged: (value) {
                        setState(() {
                          tagList.remove(value);
                          widget.myTags.add(value);
                          // addtag(value);
                        });
                      },
                      items: tagList.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem(
                            value: value, child: Text(value));
                      }).toList(),
                    ),
                    //Flexible(
                    //flex: (widget.myTags.length % 3) * 10,
                    Container(
                      height: MediaQuery.of(context).size.height * 0.13,
                      child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          childAspectRatio: (30 / 10),
                          children:
                              List.generate(widget.myTags.length, (index) {
                            return Flexible(child: tags(index));
                          })),
                    ),
                  ],
                ))),
        new Padding(padding: EdgeInsets.only(top: 25.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Padding(padding: EdgeInsets.only(left: 15.0)),
            easyButton(),
            new Padding(padding: EdgeInsets.only(left: 15.0)),
            midButton(),
            new Padding(padding: EdgeInsets.only(left: 15.0)),
            hardButton(),
            new Padding(padding: EdgeInsets.only(left: 15.0)),
          ],
        ),
        new Padding(padding: EdgeInsets.only(top: 25.0)),
        save(),
      ],
    ));
  }

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
                setState(() {
                  widget.myTags.remove(widget.myTags[index]);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget save() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        color: Colors.grey[300],
        icon: Icon(
          Icons.save,
          color: Colors.black,
        ),
        label: Text(
          "save",
          style: TextStyle(
              fontFamily: 'Raleway', color: Colors.black, fontSize: 30),
        ),
        onPressed: () {
          Navigator.pop(context, {
            'a': widget.listForWatch,
            'b': widget.levelList,
            'c': widget.myTags
          });
        });
  }

  Widget easyButton() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        color: widget.easyButtomColor,
        icon: Icon(
          Icons.label,
          color: Colors.black,
        ),
        label: Text(
          widget.easyButtom,
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
        onPressed: () {
          if (widget.easyButtom == 'easy') {
            setState(() {
              widget.levelList.add(1);
              widget.easyButtom = '-easy';
              widget.easyButtomColor = Colors.green[400];
            });
            pushEasy();
          } else {
            setState(() {
              widget.levelList.remove(1);
              widget.easyButtom = 'easy';
              widget.easyButtomColor = Colors.green[50];
            });
            unPushEasy();
          }
        });
  }

  Widget midButton() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        color: widget.midButtomColor,
        icon: Icon(Icons.label, color: Colors.black),
        label: Text(
          widget.midButtom,
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
        onPressed: () {
          if (widget.midButtom == 'medium') {
            setState(() {
              widget.levelList.add(2);
              widget.midButtom = '-medium';
              widget.midButtomColor = Colors.yellow[400];
            });
            pushEasy();
          } else {
            setState(() {
              widget.levelList.remove(2);
              widget.midButtom = 'medium';
              widget.midButtomColor = Colors.yellow[50];
            });
            unPushEasy();
          }
        });
  }

  Widget hardButton() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        color: widget.hardButtomColor,
        icon: Icon(
          Icons.label,
          color: Colors.black,
        ),
        label: Text(
          widget.hardButtom,
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
        onPressed: () {
          if (widget.hardButtom == 'hard') {
            setState(() {
              widget.levelList.add(3);
              widget.hardButtom = '-hard';
              widget.hardButtomColor = Colors.blue[400];
            });
            pushEasy();
          } else {
            setState(() {
              widget.levelList.remove(3);
              widget.hardButtom = 'hard';
              widget.hardButtomColor = Colors.blue[50];
            });
            unPushEasy();
          }
        });
  }

  void pushEasy() {
    setState(() {
      widget.listForWatch.clear();
    });
    print(widget.list);
    print(widget.listForWatch);
    for (int i = 0; i < widget.list.length; i++) {
      print(widget.list[i].level);
      if (widget.levelList.contains(widget.list[i].level)) {
        setState(() {
          widget.listForWatch.add(widget.list[i]);
        });
      }
    }
  }

  void unPushEasy() {
    if (widget.levelList.isEmpty) {
      setState(() {
        widget.listForWatch.clear();
        widget.listForWatch.addAll(widget.list);
      });
    } else {
      pushEasy();
    }
  }
}
