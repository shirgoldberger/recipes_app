import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/stages.dart';

class PlusRecipe extends StatefulWidget {
  final db = Firestore.instance;
  final Function toggleView;
  PlusRecipe({this.toggleView});
  @override
  _PlusRecipeState createState() => _PlusRecipeState();
}

class _PlusRecipeState extends State<PlusRecipe> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  List tagList = [
    'fish',
    'meat',
    'dairy',
    'desert',
    'for children',
    'other',
    'choose recipe tag'
  ];
  List<IngredientsModel> ingredientsList = [];
  bool loading = false;
  // text field state
  String recipe_name = '';
  String recipe_description = '';
  String writerName = '';
  String writerUid = '';
  String tagChoose;
  int count = 0;
  List<IngredientsModel> ingredients = [];
  List<Stages> stages = [];
  List<String> myTags = [];
  List<String> notes = [];
  int level = 0;
  int time = 0;
  Color easyColor = Colors.green[200];
  Color midColor = Colors.red[200];
  Color hardColor = Colors.blue[200];
  Color timeInit1 = Colors.black;
  Color timeInit2 = Colors.black;
  Color timeInit3 = Colors.black;

  bool done = false;

  Widget box = SizedBox(
    height: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Loading();
    } else {
      return Container(
          height: 100,
          child: Scaffold(
              resizeToAvoidBottomPadding: false,
              backgroundColor: Colors.blueGrey[50],
              appBar: AppBar(
                title: Text(
                  'Cook Book',
                  style: TextStyle(fontFamily: 'LogoFont'),
                ),
                backgroundColor: Colors.blueGrey[700],
                elevation: 0.0,
                actions: <Widget>[
                  FlatButton.icon(
                      icon: Icon(Icons.save),
                      label: Text('save this recipe'),
                      onPressed: () async {
                        saveThisRecipe();
                        Navigator.of(context).pop();
                      }),
                  // add back button
                ],
              ),
              body: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        Flexible(
                            child: ListView(children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'Enter details about the recipe:',
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 20,
                                color: Colors.blueGrey[800]),
                            textAlign: TextAlign.center,
                          ),
                          box,
                          // name recipe
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Recipe Name',
                            ),
                            validator: (val) => val.isEmpty
                                ? 'Enter a name of your recipe'
                                : null,
                            onChanged: (val) {
                              setState(() => recipe_name = val);
                            },
                          ),
                          box,
                          // description recipe
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Description',
                            ),
                            validator: (val) => val.length < 6
                                ? 'Enter a description with 6 letter at least'
                                : null,
                            onChanged: (val) {
                              setState(() => recipe_description = val);
                            },
                          ),
                          box,
                          // ingredients plus buttom and text explanation
                          Row(children: <Widget>[
                            RawMaterialButton(
                                onPressed: addIng,
                                elevation: 2.0,
                                fillColor: Colors.blueGrey[400],
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(5.0)),
                            Expanded(
                                child: SizedBox(
                              child: Text(
                                "push on the + to add Ingredients",
                                textAlign: TextAlign.left,
                              ),
                            )),
                          ]),
                          // ingredients list: its a row with 3 element : ingredient, count, unit.
                          Container(
                            child: Column(
                              children: [
                                ingredients.length <= 0
                                    ? Text(
                                        'there is no Ingredients in this recipe',
                                        textAlign: TextAlign.right)
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        addAutomaticKeepAlives: true,
                                        itemCount: ingredients.length,
                                        itemBuilder: (_, i) => Row(
                                              children: <Widget>[
                                                Text((i + 1).toString() +
                                                    "." +
                                                    " "),
                                                Expanded(
                                                    child: SizedBox(
                                                        height: 37.0,
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Ingredient',
                                                          ),
                                                          validator: (val) => val
                                                                      .length <
                                                                  2
                                                              ? 'Enter a description eith 2 letter at least'
                                                              : null,
                                                          onChanged: (val) {
                                                            setState(() =>
                                                                ingredients[i]
                                                                        .name =
                                                                    val);
                                                          },
                                                        ))),
                                                Expanded(
                                                    child: SizedBox(
                                                        height: 37.0,
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: 'amount',
                                                          ),
                                                          validator: (val) => val
                                                                      .length <
                                                                  6
                                                              ? 'Enter a description eith 6 letter at least'
                                                              : null,
                                                          onChanged: (val) {
                                                            setState(() =>
                                                                ingredients[i]
                                                                        .count =
                                                                    int.parse(
                                                                        val));
                                                          },
                                                        ))),
                                                Expanded(
                                                    child: SizedBox(
                                                        height: 37.0,
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: 'unit',
                                                          ),
                                                          validator: (val) => val
                                                                      .length <
                                                                  6
                                                              ? 'Enter a description eith 6 letter at least'
                                                              : null,
                                                          onChanged: (val) {
                                                            setState(() =>
                                                                ingredients[i]
                                                                        .unit =
                                                                    val);
                                                          },
                                                        ))),
                                                RawMaterialButton(
                                                  onPressed: () =>
                                                      onDelteIng(i),
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
                                            )),
                              ],
                            ),
                          ),
                          // stage buttom and text explenation
                          Row(children: <Widget>[
                            RawMaterialButton(
                              onPressed: addStages,
                              elevation: 2.0,
                              fillColor: Colors.blueGrey[400],
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(5.0),
                              shape: CircleBorder(),
                            ),
                            Expanded(
                              child: SizedBox(
                                  child: Text(
                                "push on the + to add stages",
                                textAlign: TextAlign.left,
                              )),
                            ),
                          ]),
                          // stages
                          Container(
                              child: Column(children: [
                            stages.length <= 0
                                ? Text(
                                    'there is no stages in this recipe',
                                    textAlign: TextAlign.right,
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    addAutomaticKeepAlives: true,
                                    itemCount: stages.length,
                                    itemBuilder: (_, i) =>
                                        Row(children: <Widget>[
                                          Text((i + 1).toString() + "." + " "),
                                          Expanded(
                                              child: SizedBox(
                                                  height: 37.0,
                                                  child: TextFormField(
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'stage of the recipe',
                                                    ),
                                                    validator: (val) => val
                                                                .length <
                                                            2
                                                        ? 'Enter a description eith 2 letter at least'
                                                        : null,
                                                    onChanged: (val) {
                                                      setState(() =>
                                                          stages[i].s = val);
                                                    },
                                                  ))),
                                          RawMaterialButton(
                                            onPressed: () => onDelteStages(i),
                                            elevation: 0.2,
                                            fillColor: Colors.brown[300],
                                            child: Icon(
                                              Icons.delete,
                                              size: 18.0,
                                            ),
                                            padding: EdgeInsets.all(5.0),
                                            shape: CircleBorder(),
                                          )
                                        ]))
                          ])),
                          // notes plus buttom
                          Row(children: <Widget>[
                            RawMaterialButton(
                              onPressed: addNotes,
                              elevation: 2.0,
                              fillColor: Colors.blueGrey[400],
                              child: Icon(Icons.add, color: Colors.white),
                              padding: EdgeInsets.all(5.0),
                              shape: CircleBorder(),
                            ),
                            Expanded(
                              child: SizedBox(
                                  child: Text("push on the + to add notes")),
                            ),
                          ]),
                          //notes
                          Container(
                              child: Column(children: [
                            notes.length <= 0
                                ? Text('there is no notes in this recipe')
                                : ListView.builder(
                                    shrinkWrap: true,
                                    addAutomaticKeepAlives: true,
                                    itemCount: notes.length,
                                    itemBuilder: (_, i) =>
                                        Row(children: <Widget>[
                                          Text((i + 1).toString() + "." + " "),
                                          Expanded(
                                              child: SizedBox(
                                                  height: 37.0,
                                                  child: TextFormField(
                                                    decoration: InputDecoration(
                                                      hintText: 'note',
                                                    ),
                                                    validator: (val) => val
                                                                .length <
                                                            2
                                                        ? 'Enter a description eith 2 letter at least'
                                                        : null,
                                                    onChanged: (val) {
                                                      setState(
                                                          () => notes[i] = val);
                                                    },
                                                  ))),
                                          RawMaterialButton(
                                            onPressed: () => onDelteNotes(i),
                                            elevation: 0.2,
                                            fillColor: Colors.brown[300],
                                            child: Icon(
                                              Icons.delete,
                                              size: 18.0,
                                            ),
                                            padding: EdgeInsets.all(5.0),
                                            shape: CircleBorder(),
                                          )
                                        ]))
                          ])),
                          // plus tag
                          Row(children: <Widget>[
                            RawMaterialButton(
                              onPressed: addTags,
                              elevation: 2.0,
                              fillColor: Colors.blueGrey[400],
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(5.0),
                              shape: CircleBorder(),
                            ),
                            Expanded(
                              child: SizedBox(
                                  child: Text("push on the + to add tags")),
                            ),
                          ]),
                          // tags
                          Container(
                              child: Column(children: [
                            ListView.builder(
                                shrinkWrap: true,
                                addAutomaticKeepAlives: true,
                                itemCount: myTags.length,
                                itemBuilder: (_, i) => Row(children: <Widget>[
                                      Expanded(
                                          child: SizedBox(
                                        height: 37.0,
                                        child: DropdownButton(
                                          hint: Text("choose this recipe tag"),
                                          dropdownColor: Colors.brown[300],
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 36,
                                          isExpanded: true,
                                          value: myTags[i],
                                          onChanged: (newValue) {
                                            setState(() {
                                              myTags[i] = newValue;
                                            });
                                          },
                                          items: tagList.map((valueItem) {
                                            return DropdownMenuItem(
                                              value: valueItem,
                                              child: Text(valueItem),
                                            );
                                          }).toList(),
                                        ),
                                      )),
                                      RawMaterialButton(
                                        onPressed: () => onDelteTags(i),
                                        elevation: 0.2,
                                        fillColor: Colors.brown[300],
                                        child: Icon(
                                          Icons.delete,
                                          size: 18.0,
                                        ),
                                        padding: EdgeInsets.all(5.0),
                                        shape: CircleBorder(),
                                      )
                                    ])),
                            //tags + buttom
                            box,
                            SizedBox(
                                child: Text(
                                    "Choose the level of the recipe: hard / medium / easy:")),
                            //tags
                            Row(children: <Widget>[
                              Expanded(
                                  child: RaisedButton(
                                      color: easyColor,
                                      child: Text(
                                        'easy',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          level = 1;
                                          easyColor = Colors.green[900];
                                          midColor = Colors.red[200];
                                          hardColor = Colors.blue[200];
                                        });
                                      })),
                              Expanded(
                                  child: RaisedButton(
                                      color: midColor,
                                      child: Text(
                                        'medium',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          level = 2;
                                          easyColor = Colors.green[200];
                                          midColor = Colors.red[900];
                                          hardColor = Colors.blue[200];
                                        });
                                      })),
                              Expanded(
                                  child: RaisedButton(
                                      color: hardColor,
                                      child: Text(
                                        'hard',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          level = 3;
                                          easyColor = Colors.green[200];
                                          midColor = Colors.red[200];
                                          hardColor = Colors.blue[900];
                                        });
                                      }))
                            ]),
                            box,
                            SizedBox(
                                child: Text(
                                    "How long does it take to prepare the recipe?")),
                            //time
                            Row(children: <Widget>[
                              Expanded(
                                child: FlatButton.icon(
                                    icon: Icon(Icons.watch_later,
                                        color: timeInit1),
                                    label: Text(''),
                                    onPressed: () {
                                      setState(() {
                                        time = 1;
                                        timeInit1 = Colors.green[400];
                                        timeInit2 = Colors.black;
                                        timeInit3 = Colors.black;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: FlatButton.icon(
                                    icon: Icon(Icons.watch_later,
                                        color: timeInit2),
                                    label: Text(''),
                                    onPressed: () {
                                      setState(() {
                                        time = 2;
                                        timeInit1 = Colors.black;
                                        timeInit2 = Colors.yellow[400];
                                        timeInit3 = Colors.black;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: FlatButton.icon(
                                    icon: Icon(Icons.watch_later,
                                        color: timeInit3),
                                    label: Text(''),
                                    onPressed: () {
                                      setState(() {
                                        time = 3;
                                        timeInit1 = Colors.black;
                                        timeInit2 = Colors.black;
                                        timeInit3 = Colors.pink[400];
                                      });
                                    }),
                              ),
                            ]),
                          ])),
                          // save the recipe
                          FlatButton.icon(
                            color: Colors.blueAccent,
                            icon: Icon(
                              Icons.settings,
                              color: Colors.black,
                            ),
                            label: Text(
                              'SAVE',
                              style: TextStyle(color: Colors.black),
                            ),
                            padding: EdgeInsets.all(5.0),
                            shape: RoundedRectangleBorder(),
                            onPressed: () async {
                              saveThisRecipe();
                              Navigator.of(context).pop();
                            },
                          )
                        ])),
                      ])))));
    }
  }

  void onDeleteIng(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  void addIng() {
    setState(() {
      ingredients.add(IngredientsModel());
    });
  }

  void addStages() {
    setState(() {
      stages.add(Stages());
    });
  }

  void addTags() {
    setState(() {
      myTags.add('choose recipe tag');
    });
  }

  void addNotes() {
    setState(() {
      notes.add(' ');
    });
    print(notes.length);
  }

  void onDelteIng(int i) {
    setState(() {
      ingredients.removeAt(i);
    });
  }

  void onDelteStages(int i) {
    setState(() {
      stages.removeAt(i);
    });
  }

  void onDelteTags(int i) {
    setState(() {
      myTags.removeAt(i);
    });
  }

  void onDelteNotes(int i) {
    setState(() {
      notes.removeAt(i);
    });
  }

  void saveThisRecipe() async {
    final db = Firestore.instance;
    final user = Provider.of<User>(context);
    var snap =
        await Firestore.instance.collection('users').document(user.uid).get();
    String firstName = (snap.data['firstName']);
    String lsatName = (snap.data['lastName']);
    print(firstName);
    print("noa");
    print(user.uid);
    setState(() {
      writerUid = user.uid;
    });
    setState(() {
      writerName = firstName + " " + lsatName;
    });
    print("writer uid");
    print(time);
    Recipe recipe = Recipe(recipe_name, recipe_description, myTags, level,
        notes, writerName, writerUid, time, true, '', '');
    var currentRecipe = await db
        .collection('users')
        .document(user.uid)
        .collection('recipes')
        .add(recipe.toJson());
    //set the new id to data base

    print(currentRecipe.documentID.toString());
    String id = currentRecipe.documentID.toString();
    recipe.setId(id);
    var fixID = await db
        .collection('users')
        .document(user.uid)
        .collection('recipes')
        .document(id)
        .updateData({'recipeID': id});

    for (int i = 0; i < ingredients.length; i++) {
      await db
          .collection('users')
          .document(user.uid)
          .collection('recipes')
          .document(id)
          .collection('ingredients')
          .add(ingredients[i].toJson());
    }
    for (int i = 0; i < stages.length; i++) {
      await db
          .collection('users')
          .document(user.uid)
          .collection('recipes')
          .document(id)
          .collection('stages')
          .add(stages[i].toJson(i));
    }
  }

  Future<void> getUserName() async {
    final db = Firestore.instance;
    final user = Provider.of<User>(context);

    var snap =
        await Firestore.instance.collection('users').document(user.uid).get();
    String firstName = (snap.data['firstName']);
    String lsatName = (snap.data['lastName']);

    setState(() {
      writerUid = user.uid;
    });
    setState(() {
      writerName = firstName + " " + lsatName;
    });
    setState(() {
      done = true;
    });
  }
}
