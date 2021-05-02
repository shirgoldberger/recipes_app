import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/stage.dart';
import 'package:recipes_app/models/user.dart';
import '../../../config.dart';

// ignore: must_be_immutable
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
  void initState() {
    super.initState();
    setLevelColor();
    setTimeColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(),
      body: ListView(children: [
        box,
        Center(
          child: recipeNameField(),
        ),
        box,
        recipeDescriptionField(),
        box,
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
        Text(
          'ingredients for the recipe:',
          style: new TextStyle(color: Colors.brown, fontSize: 25.0),
        ),
        box,
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
                              setState(() => widget.ing[i].name = val);
                            },
                          ))),
                  Text(' '),
                  Expanded(
                      child: SizedBox(
                          height: 37.0,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: widget.ing[i].count.toString(),
                            ),
                            validator: (val) => val.length < 6
                                ? 'Enter a description eith 6 letter at least'
                                : null,
                            onChanged: (val) {
                              setState(
                                  () => widget.ing[i].count = int.parse(val));
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
                              setState(() => widget.ing[i].unit = val);
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
          style: new TextStyle(color: Colors.brown, fontSize: 25.0),
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
                            setState(() => widget.stages[j].s = val);
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
          style: new TextStyle(color: Colors.brown, fontSize: 25.0),
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
            for (var t = 0; t < widget.current.tags.length; t++)
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
                    value: tagList[convertToIndex(widget.current.tags[t])],
                    onChanged: (newValue) {
                      setState(() {
                        widget.current.tags[t] = newValue;
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
        SizedBox(height: 37.0, child: Text("push on the + to add tags")),
        Row(children: <Widget>[
          Expanded(
              // ignore: deprecated_member_use
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
              // ignore: deprecated_member_use
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
              // ignore: deprecated_member_use
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
        ]), //time text
        SizedBox(
            height: 37.0,
            child: Text("How long does it take to prepare the recipe?")),
        //time
        Row(children: <Widget>[
          Expanded(
            // ignore: deprecated_member_use
            child: FlatButton.icon(
                icon: Icon(Icons.watch_later, color: widget.timeInit1),
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
            // ignore: deprecated_member_use
            child: FlatButton.icon(
                icon: Icon(Icons.watch_later, color: widget.timeInit2),
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
            // ignore: deprecated_member_use
            child: FlatButton.icon(
                icon: Icon(Icons.watch_later, color: widget.timeInit3),
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
                            setState(() => widget.current.notes[j] = val);
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
      resizeToAvoidBottomInset: false,
    );
  }

  Widget recipeNameField() {
    TextEditingController _controller =
        new TextEditingController(text: widget.current.name);
    return TextFormField(
      controller: _controller,
      cursorWidth: 10,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.edit),
        icon: Icon(Icons.dns),
        border: OutlineInputBorder(),
        // hintText: 'Recipe Name',
      ),
      validator: (val) => val.isEmpty ? 'Enter a name of your recipe' : null,
      onChanged: (val) {
        setState(() => widget.current.name = val);
      },
    );
  }

  Widget recipeDescriptionField() {
    TextEditingController _controller =
        new TextEditingController(text: widget.current.description);
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.edit),
        icon: Icon(Icons.description),
        hintText: 'Description',
        border: OutlineInputBorder(),
      ),
      validator: (val) =>
          val.length < 6 ? 'Enter a description with 6 letter at least' : null,
      onChanged: (val) {
        setState(() => widget.current.description = val);
      },
    );
  }

  Widget appBar() {
    return AppBar(
        backgroundColor: appBarBackgroundColor,
        elevation: 0.0,
        title: Text('Edit Recipe', style: TextStyle(fontFamily: 'Raleway')),
        actions: <Widget>[
          saveIcon(),
        ]);
  }

  Widget saveIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        icon: Icon(Icons.save, color: Colors.white),
        label: Text('SAVE', style: TextStyle(color: Colors.white)),
        onPressed: () {
          editAndSave();
        });
  }

  void setTimeColor() {
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
  }

  void setLevelColor() {
    if (widget.current.level == 1) {
      widget.easyColor = Colors.green[900];
    }
    if (widget.current.level == 2) {
      widget.midColor = Colors.red[900];
    }
    if (widget.current.level == 3) {
      widget.hardColor = Colors.blue[900];
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
    return 1;
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
      widget.current.tags.add('choose recipe tag');
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
      widget.current.tags.removeAt(i);
    });
  }

  void onDeleteNotes(int i) {
    setState(() {
      widget.current.notes.removeAt(i);
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
