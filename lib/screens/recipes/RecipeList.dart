import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipes/filter.dart';
import 'package:recipes_app/screens/recipes/recipeHeadLine.dart';
import '../../shared_screen/config.dart';

// ignore: must_be_immutable
class RecipeList extends StatefulWidget {
  RecipeList(Map<String, List<Recipe>> map, String head, bool home) {
    this.head = head;
    this.home = home;
    this.map = map;
  }
  bool home;
  List<Recipe> list = [];
  List<Recipe> listForWatch = [];
  String head;
  Map<String, List<Recipe>> map = {};
  List<String> myTags = [];
  String easyButtom = 'easy';
  Color easyButtomColor = Colors.green[100];
  String midButtom = 'medium';
  Color midButtomColor = Colors.yellow[100];
  String hardButtom = 'hard';
  Color hardButtomColor = Colors.red[100];
  List<int> levelList = [1, 2, 3];
  List<int> timeList = [1, 2, 3];
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
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            widget.head + " recipes:",
            style: TextStyle(
                fontFamily: 'Raleway', color: Colors.white, fontSize: 15),
          ),
          backgroundColor: appBarBackgroundColor,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          actions: <Widget>[
            filtterIcon(),
          ],
        ),
        body: Column(children: <Widget>[
          new Padding(padding: EdgeInsets.only(top: 15.0)),
          Text(
            "number of results: " + widget.listForWatch.length.toString(),
            style: TextStyle(
                fontFamily: 'Raleway', color: Colors.black, fontSize: 15),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
              itemCount: widget.listForWatch.length,
              itemBuilder: (context, index) {
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
                                widget.listForWatch[index], widget.home, ""))));
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
          setState(() {
            widget.list.add(recipe);
            widget.listForWatch.add(recipe);
          });
        }
      }
    }
  }

  void deleteTag(String value) {
    setState(() {
      widget.myTags.remove(value);
    });
    setState(() {
      tagList.add(value);
    });

    List valueList = widget.map[value];
    for (int i = 0; i < valueList.length; i++) {
      bool findTag = false;
      Recipe recipe = valueList[i];
      for (int j = 0; j < recipe.tags.length; j++) {
        if (widget.myTags.contains(recipe.tags[j])) {
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
    // ignore: deprecated_member_use
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
        backgroundColor: Colors.blueGrey[50],
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
                widget.timeList,
                widget.head,
                widget.map))).then((value) => cameBack(value));
  }

  cameBack(value) {
    List myTagCameBack = value['c'];
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
