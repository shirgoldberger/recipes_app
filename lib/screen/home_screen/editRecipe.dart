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
                              Row(children: [
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
                                            setState(
                                                () => widget.ing[i].name = val);
                                          },
                                        ))),
                                Text(' '),
                                Expanded(
                                    child: SizedBox(
                                        height: 37.0,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText:
                                                widget.ing[i].count.toString(),
                                          ),
                                          validator: (val) => val.length < 6
                                              ? 'Enter a description eith 6 letter at least'
                                              : null,
                                          onChanged: (val) {
                                            setState(() => widget.ing[i].count =
                                                int.parse(val));
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
                                            setState(
                                                () => widget.ing[i].unit = val);
                                          },
                                        ))),
                              ])
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
                              ])
                          ],
                        )
                      ])),
                    ]),
                  ))));
    }
  }

  void a() {}
  Future<void> makeList2() async {
    final user = Provider.of<User>(context);
    QuerySnapshot snap2 = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('recipes')
        .document(widget.current.id.toString())
        .collection('stages')
        .getDocuments();
    snap2.documents.forEach((element1) {
      print(element1.data.toString());
      setState(() {
        widget.stages
            .add(Stages.antheeConstractor(element1.data['stage'] ?? ''));
      });
    });
    setState(() {
      widget.done = true;
    });
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
