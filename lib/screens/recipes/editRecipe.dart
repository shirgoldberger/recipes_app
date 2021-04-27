import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stages.dart';
import 'package:recipes_app/models/user.dart';

class EditRecipe extends StatefulWidget {
  EditRecipe(Recipe r, List<IngredientsModel> ing, List<Stages> stages) {
    this.current = r;
    this.ing = ing;
    this.stages = stages;
  }
  List<IngredientsModel> ing = [];
  List<Stages> stages = [];
  List<String> notes = [];
  Recipe current;
  List tagList = [
    "fish",
    "meat",
    "dairy",
    "desert",
    "for children",
    "other",
    "choose recipe tag"
  ];
  bool done = false;
  int count = 0;
  Color easyColor = Colors.green[200];
  Color midColor = Colors.red[200];
  Color hardColor = Colors.blue[200];
  Color timeInit1 = Colors.black;
  Color timeInit2 = Colors.black;
  Color timeInit3 = Colors.black;
  bool doneEdit = false;
  @override
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  var i;

  @override
  Widget build(BuildContext context) {
    final db = Firestore.instance;
    final user = Provider.of<User>(context);
    if (widget.current.level == 1) {
      widget.easyColor = Colors.green[900];
    }
    if (widget.current.level == 2) {
      widget.midColor = Colors.red[900];
    }
    if (widget.current.level == 3) {
      widget.hardColor = Colors.blue[900];
    }
    switch (widget.current.time) {
      case 1:
        widget.timeInit1 = Colors.green[400];
        break;
      case 2:
        widget.timeInit2 = Colors.yellow[400];
        break;
      case 3:
        widget.timeInit3 = Colors.pink[400];
        break;
    }
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

                            // Navigator.push(
                            // context,
                            //MaterialPageRoute(
                            //  builder: (context) => HomeLogIn()));
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
                        //stages
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
                        ),
                        SizedBox(
                            height: 37.0,
                            child: Text("push on the + to add tags")),
                        Row(children: <Widget>[
                          Expanded(
                              child: RaisedButton(
                                  color: widget.easyColor,
                                  child: Text(
                                    'easy',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      widget.current.level = 1;
                                      widget.easyColor = Colors.green[900];
                                      widget.midColor = Colors.red[200];
                                      widget.hardColor = Colors.blue[200];
                                    });
                                  })),
                          Expanded(
                              child: RaisedButton(
                                  color: widget.midColor,
                                  child: Text(
                                    'medium',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      widget.current.level = 2;
                                      widget.easyColor = Colors.green[200];
                                      widget.midColor = Colors.red[900];
                                      widget.hardColor = Colors.blue[200];
                                    });
                                  })),
                          Expanded(
                              child: RaisedButton(
                                  color: widget.hardColor,
                                  child: Text(
                                    'hard',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      widget.current.level = 3;
                                      widget.easyColor = Colors.green[200];
                                      widget.midColor = Colors.red[200];
                                      widget.hardColor = Colors.blue[900];
                                    });
                                  }))
                        ])
                      ]),
                    ), //time text
                    SizedBox(
                        height: 37.0,
                        child: Text(
                            "How long does it take to prepare the recipe?")),
                    //time
                    Row(children: <Widget>[
                      Expanded(
                        child: FlatButton.icon(
                            icon: Icon(Icons.watch_later,
                                color: widget.timeInit1),
                            label: Text(''),
                            onPressed: () {
                              setState(() {
                                widget.current.time = 1;
                                widget.timeInit1 = Colors.green[400];
                                widget.timeInit2 = Colors.black;
                                widget.timeInit3 = Colors.black;
                              });
                            }),
                      ),
                      Expanded(
                        child: FlatButton.icon(
                            icon: Icon(Icons.watch_later,
                                color: widget.timeInit2),
                            label: Text(''),
                            onPressed: () {
                              setState(() {
                                widget.current.time = 2;
                                widget.timeInit1 = Colors.black;
                                widget.timeInit2 = Colors.yellow[400];
                                widget.timeInit3 = Colors.black;
                              });
                            }),
                      ),
                      Expanded(
                        child: FlatButton.icon(
                            icon: Icon(Icons.watch_later,
                                color: widget.timeInit3),
                            label: Text(''),
                            onPressed: () {
                              setState(() {
                                widget.current.time = 3;
                                widget.timeInit1 = Colors.black;
                                widget.timeInit2 = Colors.black;
                                widget.timeInit3 = Colors.pink[400];
                              });
                            }),
                      ),
                    ]),
                    //notes
                    new Padding(padding: EdgeInsets.only(top: 15.0)),
                    new Text(
                      'notes for the recipe:',
                      style: new TextStyle(color: Colors.brown, fontSize: 25.0),
                    ),
                    RawMaterialButton(
                      onPressed: addNotes,
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
                        for (var j = 0; j < widget.current.notes.length; j++)
                          Row(children: [
                            Text((j + 1).toString() + "." + " "),
                            Expanded(
                                child: SizedBox(
                                    height: 37.0,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: widget.current.notes[j],
                                      ),
                                      validator: (val) => val.length < 2
                                          ? 'Enter a description eith 2 letter at least'
                                          : null,
                                      onChanged: (val) {
                                        setState(() =>
                                            widget.current.notes[j] = val);
                                      },
                                    ))),
                            RawMaterialButton(
                              onPressed: () => onDeleteNotes(j),
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
                  ]),
                ),
                resizeToAvoidBottomInset: false,
              )));
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
      case "meat":
        return 1;
        break;
      case "dairy":
        return 2;
        break;
      case "desert":
        return 3;
        break;
      case "for children":
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

  void addNotes() {
    setState(() {
      widget.current.notes.add('');
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

  void onDeleteNotes(int i) {
    setState(() {
      widget.current.notes.removeAt(i);
    });
  }

//   void edit() async {
//     final db = Firestore.instance;
//     final user = Provider.of<User>(context);
//     //edit the recipe

//     db
//         .collection('users')
//         .document(user.uid)
//         .collection('recipes')
//         .document(widget.current.id)
//         .updateData(widget.current.toJson());

//     int i = 0;
// //update the current ing
//     var a = db
//         .collection('users')
//         .document(user.uid)
//         .collection('recipes')
//         .document(widget.current.id)
//         .collection('ingredients')
//         .getDocuments()
//         .then((snapshot) {
//       for (DocumentSnapshot ds in snapshot.documents) {
//         ds.reference.updateData(widget.ing[i].toJson());
//         i++;
//       }
//       setState(() {
//         widget.doneEdit = true;
//       });
//     });

//     //if we add new ing
//     if (widget.doneEdit) {
//       while (i < widget.ing.length) {
//         print("i");
//         print(i);
//         db
//             .collection('users')
//             .document(user.uid)
//             .collection('recipes')
//             .document(widget.current.id)
//             .collection('ingredients')
//             .add(widget.ing[i].toJson());
//         i++;
//       }
//     }

//     int j = 0;
// //update the current ing
//     var b = db
//         .collection('users')
//         .document(user.uid)
//         .collection('recipes')
//         .document(widget.current.id)
//         .collection('stages')
//         .getDocuments()
//         .then((snapshot) {
//       for (DocumentSnapshot ds in snapshot.documents) {
//         ds.reference.updateData(widget.stages[j].toJson(j));
//         j++;
//       }
//     });
//     //if we add new ing
//     while (i < widget.stages.length) {
//       db
//           .collection('users')
//           .document(widget.current.id)
//           .collection('recipes')
//           .document(widget.current.id)
//           .collection('stages')
//           .add(widget.stages[j].toJson(j));
//       i++;
//     }
//   }

  // void addIngStages() async {
  //   final db = Firestore.instance;
  //   //add new ingredients to the recipe
  //   print("ing");
  //   print(widget.ing.length);
  //   print(widget.ing[0]);
  //   for (int i = 0; i < widget.ing.length; i++) {
  //     await db
  //         .collection('users')
  //         .document(widget.current.id)
  //         .collection('recipes')
  //         .document(widget.current.id)
  //         .collection('ingredients')
  //         .add(widget.ing[i].toJson());
  //     if (i == 0) {
  //       print("insert");
  //     }
  //   }

  //   //addd new stages to the recipe
  //   for (int i = 0; i < widget.stages.length; i++) {
  //     await db
  //         .collection('users')
  //         .document(widget.current.id)
  //         .collection('recipes')
  //         .document(widget.current.id)
  //         .collection('stages')
  //         .add(widget.stages[i].toJson(i));
  //   }
  //   setState(() {
  //     widget.doneEdit = true;
  //   });
  // }

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
    db
        .collection('users')
        .document(user.uid)
        .collection('recipes')
        .document(id)
        .updateData({'recipeID': id});

    if (widget.current.publish != '') {
      //update in the public the new id;
      db
          .collection('publish recipe')
          .document(widget.current.publish)
          .updateData({'recipeId': currentRecipe.documentID.toString()});
    }
    // String id = currentRecipe.documentID.toString();
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
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 3);
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => RecipesBookPage(user.uid)));
  }
}
