import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stages.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screen/home_screen/homeLogIn.dart';
import 'package:recipes_app/screen/home_screen/ingredients.dart';
import 'package:recipes_app/shared_screen/loading.dart';

class EditRecipe extends StatefulWidget {
  EditRecipe(Recipe r, List<IngredientsModel> ing, List<Stages> stages) {
    this.current = r;
    this.ing = ing;
    this.stages = stages;
  }
  List<IngredientsModel> ing = [];
  List<Stages> stages = [];
  Recipe current;
  List tagList = [
    "fish",
    "meet",
    "dairy",
    "desert",
    "for childre",
    "other",
    "choose recipe tag"
  ];
  bool done = false;
  int count = 0;
  @override
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  var i;

  @override
  Widget build(BuildContext context) {
    final db = Firestore.instance;
    final user = Provider.of<User>(context);
    {
      return Container(
          height: 100,
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Scaffold(
                  backgroundColor: Colors.brown[100],
                  appBar: AppBar(
                      backgroundColor: Colors.brown[400],
                      elevation: 0.0,
                      title: Text('edit this recipe'),
                      actions: <Widget>[
                        FlatButton.icon(
                            icon: Icon(Icons.save),
                            label: Text('save this recipe'),
                            onPressed: () {
                              editAndSave();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeLogIn()));
                            }),
                      ]),
                  body: Container(
                    child: ListView(children: [
                      Container(
                          child: new Column(children: [
                        Center(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: widget.current.name,
                            ),
                            validator: (val) => val.length < 6
                                ? 'Enter a description eith 6 letter at least'
                                : null,
                            onChanged: (val) {
                              setState(() => widget.current.name = val);
                            },
                          ),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 15.0)),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: widget.current.description,
                          ),
                          validator: (val) => val.length < 6
                              ? 'Enter a description eith 6 letter at least'
                              : null,
                          onChanged: (val) {
                            setState(() => widget.current.description = val);
                          },
                        ),
                        new Padding(padding: EdgeInsets.only(top: 15.0)),
                        RawMaterialButton(
                          onPressed: addIng,
                          elevation: 2.0,
                          fillColor: Colors.brown[300],
                          child: Icon(
                            Icons.add,
                            size: 18.0,
                          ),
                          padding: EdgeInsets.all(5.0),
                          shape: CircleBorder(),
                        ),
                        new Text(
                          'ingredients for the recipe:',
                          style: new TextStyle(
                              color: Colors.brown, fontSize: 25.0),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 10.0)),
                        Column(
                          children: <Widget>[
                            for (var i = 0; i < widget.ing.length; i++)
                              Row(
                                children: [
                                  Text((i + 1).toString() + "." + " "),
                                  Expanded(
                                      child: SizedBox(
                                          height: 37.0,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: widget.ing[i].name,
                                            ),
                                            validator: (val) => val.length < 2
                                                ? 'Enter a description eith 2 letter at least'
                                                : null,
                                            onChanged: (val) {
                                              setState(() =>
                                                  widget.ing[i].name = val);
                                            },
                                          ))),
                                  Text(' '),
                                  Expanded(
                                      child: SizedBox(
                                          height: 37.0,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: widget.ing[i].count
                                                  .toString(),
                                            ),
                                            validator: (val) => val.length < 6
                                                ? 'Enter a description eith 6 letter at least'
                                                : null,
                                            onChanged: (val) {
                                              setState(() => widget.ing[i]
                                                  .count = int.parse(val));
                                            },
                                          ))),
                                  Text(' '),
                                  Expanded(
                                      child: SizedBox(
                                          height: 37.0,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: widget.ing[i].unit,
                                            ),
                                            validator: (val) => val.length < 6
                                                ? 'Enter a description eith 6 letter at least'
                                                : null,
                                            onChanged: (val) {
                                              setState(() =>
                                                  widget.ing[i].unit = val);
                                            },
                                          ))),
                                  RawMaterialButton(
                                    onPressed: () => onDeletIng(i),
                                    elevation: 0.2,
                                    fillColor: Colors.brown[300],
                                    child: Icon(
                                      Icons.delete,
                                      size: 18.0,
                                    ),
                                    padding: EdgeInsets.all(5.0),
                                    shape: CircleBorder(),
                                  )
                                ],
                              ),
                          ],
                        ),
                        new Padding(padding: EdgeInsets.only(top: 15.0)),
                        new Text(
                          'stages for the recipe:',
                          style: new TextStyle(
                              color: Colors.brown, fontSize: 25.0),
                        ),
                        RawMaterialButton(
                          onPressed: addStages,
                          elevation: 2.0,
                          fillColor: Colors.brown[300],
                          child: Icon(
                            Icons.add,
                            size: 18.0,
                          ),
                          padding: EdgeInsets.all(5.0),
                          shape: CircleBorder(),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 10.0)),
                        Column(
                          children: <Widget>[
                            for (var j = 0; j < widget.stages.length; j++)
                              Row(children: [
                                Text((j + 1).toString() + "." + " "),
                                Expanded(
                                    child: SizedBox(
                                        height: 37.0,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: widget.stages[j].s,
                                          ),
                                          validator: (val) => val.length < 2
                                              ? 'Enter a description eith 2 letter at least'
                                              : null,
                                          onChanged: (val) {
                                            setState(
                                                () => widget.stages[j].s = val);
                                          },
                                        ))),
                                RawMaterialButton(
                                  onPressed: () => onDeletStages(j),
                                  elevation: 0.2,
                                  fillColor: Colors.brown[300],
                                  child: Icon(
                                    Icons.delete,
                                    size: 18.0,
                                  ),
                                  padding: EdgeInsets.all(5.0),
                                  shape: CircleBorder(),
                                )
                              ])
                          ],
                        ),
                        //tags
                        new Padding(padding: EdgeInsets.only(top: 15.0)),
                        new Text(
                          'tags for the recipe:',
                          style: new TextStyle(
                              color: Colors.brown, fontSize: 25.0),
                        ),
                        RawMaterialButton(
                          onPressed: addTags,
                          elevation: 2.0,
                          fillColor: Colors.brown[300],
                          child: Icon(
                            Icons.add,
                            size: 18.0,
                          ),
                          padding: EdgeInsets.all(5.0),
                          shape: CircleBorder(),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 10.0)),
                        Column(
                          children: <Widget>[
                            for (var t = 0;
                                t < widget.current.myTag.length;
                                t++)
                              Row(children: [
                                Text((t + 1).toString() + "." + " "),
                                Expanded(
                                    child: SizedBox(
                                  height: 37.0,
                                  child: DropdownButton(
                                    hint: Text("choose this recipe tag"),
                                    dropdownColor: Colors.brown[300],
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 36,
                                    isExpanded: true,
                                    value: widget.tagList[convertToIndex(
                                        widget.current.myTag[t])],
                                    onChanged: (newValue) {
                                      setState(() {
                                        widget.current.myTag[t] = newValue;
                                      });
                                    },
                                    items: widget.tagList.map((valueItem) {
                                      return DropdownMenuItem(
                                        value: valueItem,
                                        child: Text(valueItem),
                                      );
                                    }).toList(),
                                  ),
                                )),
                                RawMaterialButton(
                                  onPressed: () => onDeleteTags(t),
                                  elevation: 0.2,
                                  fillColor: Colors.brown[300],
                                  child: Icon(
                                    Icons.delete,
                                    size: 18.0,
                                  ),
                                  padding: EdgeInsets.all(5.0),
                                  shape: CircleBorder(),
                                )
                              ])
                          ],
                        )
                      ])),
                    ]),
                  ))));
    }
  }

  int convertToIndex(String s) {
    if (s[0] == ' ') {
      s = s.substring(1);
    }
    switch (s) {
      case "fish":
        return 0;
        break;
      case "meet":
        return 1;
        break;
      case "dairy":
        return 2;
        break;
      case "desert":
        return 3;
        break;
      case "for childre":
        return 4;
        break;
      case "other":
        return 5;
        break;
      case "choose recipe tag":
        return 6;
        break;
    }
  }

  void addIng() {
    setState(() {
      widget.ing.add(IngredientsModel());
    });
  }

  void addStages() {
    setState(() {
      widget.stages.add(Stages());
    });
  }

  void addTags() {
    setState(() {
      widget.current.myTag.add('choose recipe tag');
    });
  }

  void onDeletIng(int i) {
    setState(() {
      widget.ing.removeAt(i);
    });
  }

  void onDeletStages(int i) {
    setState(() {
      widget.stages.removeAt(i);
    });
  }

  void onDeleteTags(int i) {
    setState(() {
      widget.current.myTag.removeAt(i);
    });
  }

  void editAndSave() async {
    final db = Firestore.instance;
    final user = Provider.of<User>(context);
    //delete the last recipe  and then add new one
    db
        .collection('users')
        .document(user.uid)
        .collection('recipes')
        .document(widget.current.id)
        .delete();
    var currentRecipe = await db
        .collection('users')
        .document(user.uid)
        .collection('recipes')
        .add(widget.current.toJson());

    String id = currentRecipe.documentID.toString();
    for (int i = 0; i < widget.ing.length; i++) {
      await db
          .collection('users')
          .document(user.uid)
          .collection('recipes')
          .document(id)
          .collection('ingredients')
          .add(widget.ing[i].toJson());
    }
    for (int i = 0; i < widget.stages.length; i++) {
      await db
          .collection('users')
          .document(user.uid)
          .collection('recipes')
          .document(id)
          .collection('stages')
          .add(widget.stages[i].toJson(i));
    }
  }
}
