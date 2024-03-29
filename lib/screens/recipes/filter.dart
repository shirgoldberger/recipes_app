import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import '../../shared_screen/config.dart';

// ignore: must_be_immutable
class Filter extends StatefulWidget {
  String easyButtom = 'easy';
  Color easyButtomColor = Colors.green[100];
  String midButtom = 'medium';
  Color midButtomColor = Colors.yellow[100];
  String hardButtom = 'hard';
  Color hardButtomColor = Colors.red[100];
  List<int> levelList = [];
  String time1Buttom = 'Until half-hour';
  Color time1ButtomColor = Colors.green[100];
  String time2Buttom = 'Until hour';
  Color time2ButtomColor = Colors.yellow[100];
  String time3Buttom = 'Over an hour';
  Color time3ButtomColor = Colors.red[100];
  List<int> timeList = [];
  List<Recipe> list = [];
  List<String> myTags = [];
  List<Recipe> listForWatch = [];
  Map<String, List<Recipe>> map;
  List tagList = [
    'choose recipe tag',
    'fish',
    'meat',
    'dairy',
    'desert',
    'for children',
    'other',
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

  Filter(
      List<Recipe> _list,
      List<Recipe> _listForWatch,
      List<int> _levelList,
      List<String> myTags,
      List<int> _timeList,
      String currentTag,
      Map<String, List<Recipe>> _map) {
    this.list = _list;
    this.listForWatch = [];
    this.levelList = _levelList;
    this.myTags = myTags;
    this.timeList = _timeList;
    this.tagList.remove(currentTag);
    map = _map;
  }

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  void initState() {
    super.initState();
    push();
  }

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
        widget.hardButtomColor = Colors.red[400];
      });
    }

    if (widget.timeList.contains(1)) {
      setState(() {
        widget.time1Buttom = '-Until half-hour';
        widget.time1ButtomColor = Colors.green[400];
      });
    }
    if (widget.timeList.contains(2)) {
      setState(() {
        widget.time2Buttom = '-Until hour';
        widget.time2ButtomColor = Colors.yellow[400];
      });
    }
    if (widget.timeList.contains(3)) {
      setState(() {
        widget.time3Buttom = '-Over an hour';
        widget.time3ButtomColor = Colors.red[400];
      });
    }
    String selectedSubject;
    return Container(
        child: Column(
      children: [
        Text(
          "Filter recipes:",
          style: TextStyle(
              fontFamily: 'Raleway', color: Colors.black, fontSize: 25),
        ),
        box,
        Row(children: [
          widthBox(10),
          Column(children: [
            Text("Choose time:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            time1Button(),
            time2Button(),
            time3Button()
          ]),
          widthBox(10),
          Column(children: [
            Text(
              "Choose level of hardness:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            easyButton(),
            midButton(),
            hardButton()
          ])
        ]),
        box,
        Text(
          "Choose more tags:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Center(
            child: Container(
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: selectedSubject,
                      onChanged: (value) {
                        setState(() {
                          widget.tagList.remove(value);
                          widget.myTags.add(value);
                        });
                      },
                      items:
                          widget.tagList.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem(
                            value: value, child: Text(value));
                      }).toList(),
                    ),
                    Container(
                      height: 230,
                      child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          childAspectRatio: (30 / 10),
                          children:
                              List.generate(widget.myTags.length, (index) {
                            return tags(index);
                          })),
                    ),
                  ],
                ))),
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
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
          ),
          Visibility(
            visible: index != 0,
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  tagList.add(widget.myTags[index]);
                  widget.myTags.remove(widget.myTags[index]);
                });
              },
            ),
          )
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
          "Show Recipes",
          style: TextStyle(
              fontFamily: 'Raleway', color: Colors.black, fontSize: 20),
        ),
        onPressed: () {
          push();
          if (widget.timeList.isEmpty) {
            widget.timeList.add(1);
            widget.timeList.add(2);
            widget.timeList.add(3);
          }
          if (widget.levelList.isEmpty) {
            widget.levelList.add(1);
            widget.levelList.add(2);
            widget.levelList.add(3);
          }
          Navigator.pop(context, {
            'a': widget.listForWatch,
            'b': widget.levelList,
            'c': widget.myTags,
            'd': widget.timeList
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
            // push();
          } else {
            setState(() {
              widget.levelList.remove(1);
              widget.easyButtom = 'easy';
              widget.easyButtomColor = Colors.green[100];
            });
            // unPush();
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
            // push();
          } else {
            setState(() {
              widget.levelList.remove(2);
              widget.midButtom = 'medium';
              widget.midButtomColor = Colors.yellow[100];
            });
            // unPush();
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
              widget.hardButtomColor = Colors.red[400];
            });
            // push();
          } else {
            setState(() {
              widget.levelList.remove(3);
              widget.hardButtom = 'hard';
              widget.hardButtomColor = Colors.red[100];
            });
            // unPush();
          }
        });
  }

  Widget time1Button() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        color: widget.time1ButtomColor,
        icon: Icon(
          Icons.label,
          color: Colors.black,
        ),
        label: Text(
          widget.time1Buttom,
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
        onPressed: () {
          if (widget.time1Buttom == 'Until half-hour') {
            setState(() {
              widget.timeList.add(1);
              widget.time1Buttom = '-Until half-hour';
              widget.time1ButtomColor = Colors.green[400];
            });
            // push();
          } else {
            setState(() {
              widget.timeList.remove(1);
              widget.time1Buttom = 'Until half-hour';
              widget.time1ButtomColor = Colors.green[100];
            });
            // unPush();
          }
        });
  }

  Widget time2Button() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        color: widget.time2ButtomColor,
        icon: Icon(
          Icons.label,
          color: Colors.black,
        ),
        label: Text(
          widget.time2Buttom,
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
        onPressed: () {
          if (widget.time2Buttom == 'Until hour') {
            setState(() {
              widget.timeList.add(2);
              widget.time2Buttom = '-Until hour';
              widget.time2ButtomColor = Colors.yellow[400];
            });
            // push();
          } else {
            setState(() {
              widget.timeList.remove(2);
              widget.time2Buttom = 'Until hour';
              widget.time2ButtomColor = Colors.yellow[100];
            });
            // unPush();
          }
        });
  }

  Widget time3Button() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        color: widget.time3ButtomColor,
        icon: Icon(
          Icons.label,
          color: Colors.black,
        ),
        label: Text(
          widget.time3Buttom,
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
        onPressed: () {
          if (widget.time3Buttom == 'Over an hour') {
            setState(() {
              widget.timeList.add(3);
              widget.time3Buttom = '-Over an hour';
              widget.time3ButtomColor = Colors.red[400];
            });
            // push();
          } else {
            setState(() {
              widget.timeList.remove(3);
              widget.time3Buttom = 'Over an hour';
              widget.time3ButtomColor = Colors.red[100];
            });
            // unPush();
          }
        });
  }

  void push() {
    widget.listForWatch.clear();
    widget.list.clear();
    for (int i = 0; i < widget.myTags.length; i++) {
      widget.list.addAll(widget.map[widget.myTags[i]]);
    }
    for (int i = 0; i < widget.list.length; i++) {
      if (widget.levelList.contains(widget.list[i].level)) {
        if (widget.timeList.contains(widget.list[i].time)) {
          Recipe a = widget.listForWatch.firstWhere(
              (element) => element.id == widget.list[i].id,
              orElse: () => null);
          if (a == null) {
            setState(() {
              widget.listForWatch.add(widget.list[i]);
            });
          }
        }
      }
    }
  }

  void pushTime() {
    // setState(() {
    //   widget.listForWatch.clear();
    // });
    for (int i = 0; i < widget.list.length; i++) {
      if (widget.timeList.contains(widget.list[i].time)) {
        setState(() {
          widget.listForWatch.add(widget.list[i]);
        });
      }
    }
  }

  void unPush() {
    setState(() {
      widget.listForWatch.clear();
    });
    push();
    // if (widget.timeList.isEmpty) {
    //   setState(() {
    //     widget.listForWatch.clear();
    //     widget.listForWatch.addAll(widget.list);
    //   });
    // } else {
    //   pushTime();
    // }
    // for (int i = 0; i < widget.list.length; i++) {
    //   if (widget.levelList.contains(widget.list[i].level)) {
    //     if (widget.timeList.contains(widget.list[i].time)) {
    //       setState(() {
    //         widget.listForWatch.remove(widget.list[i]);
    //       });
    //     }
    //   }
    // }
  }

  void unPushTime() {
    // if (widget.levelList.isEmpty) {
    //   setState(() {
    //     widget.listForWatch.clear();
    //     widget.listForWatch.addAll(widget.list);
    //   });
    // } else {
    //   pushEasy();
    // }
    for (int i = 0; i < widget.list.length; i++) {
      if (widget.timeList.contains(widget.list[i].time)) {
        setState(() {
          widget.listForWatch.remove(widget.list[i]);
        });
      }
    }
  }
}
