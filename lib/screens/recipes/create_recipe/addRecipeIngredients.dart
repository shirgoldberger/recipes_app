import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/screens/recipes/create_recipe/addRecipeLevels.dart';

import '../../../config.dart';

class AddRecipeIngredients extends StatefulWidget {
  String name;
  String description;
  String imagePath;
  AddRecipeIngredients(String _name, String _description, String _imagePath) {
    name = _name;
    description = _description;
    imagePath = _imagePath;
  }
  @override
  _AddRecipeIngredientsState createState() => _AddRecipeIngredientsState();
}

class _AddRecipeIngredientsState extends State<AddRecipeIngredients> {
  List<IngredientsModel> ingredients = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      box,
      box,
      title(),
      box,
      box,
      // ingredients list: its a row with 3 element : ingredient, count, unit.
      Container(
          child: Column(
        children: [
          ingredients.length <= 0
              ? Text(
                  'There is no ingredients\nin this recipe yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: true,
                  itemCount: ingredients.length,
                  itemBuilder: (_, i) => Column(children: [
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            ingredientIndex(i),
                            Expanded(
                                child: SizedBox(
                                    height: 37.0,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Ingredient',
                                      ),
                                      validator: (val) => val.length < 2
                                          ? 'Enter a description eith 2 letter at least'
                                          : null,
                                      onChanged: (val) {
                                        setState(
                                            () => ingredients[i].name = val);
                                      },
                                    ))),
                            Expanded(
                                child: SizedBox(
                                    height: 37.0,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'amount',
                                      ),
                                      validator: (val) => val.length < 6
                                          ? 'Enter a description eith 6 letter at least'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => ingredients[i].count =
                                            int.parse(val));
                                      },
                                    ))),
                            Expanded(
                                child: SizedBox(
                                    height: 37.0,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'unit',
                                      ),
                                      validator: (val) => val.length < 6
                                          ? 'Enter a description eith 6 letter at least'
                                          : null,
                                      onChanged: (val) {
                                        setState(
                                            () => ingredients[i].unit = val);
                                      },
                                    ))),
                            deleteButton(i)
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ])),
          box,
          box,
          addButton(),
          nextLevelButton()
        ],
      ))
    ]));
  }

  void onDelteIng(int i) {
    setState(() {
      ingredients.removeAt(i);
    });
  }

  void addIng() {
    setState(() {
      ingredients.add(IngredientsModel());
    });
  }

  Widget addButton() {
    return FloatingActionButton(
      onPressed: addIng,
      elevation: 2.0,
      heroTag: null,
      backgroundColor: Colors.black,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      shape: CircleBorder(),
    );
  }

  Widget deleteButton(int i) {
    return RawMaterialButton(
      onPressed: () => onDelteIng(i),
      elevation: 0.2,
      child: Icon(
        Icons.delete_forever,
        size: 30,
      ),
      padding: EdgeInsets.all(5.0),
      shape: CircleBorder(),
    );
  }

  Widget title() {
    return Text('Add Ingredients to your recipe',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Raleway'));
  }

  Widget ingredientIndex(int i) {
    return Text(
      (i + 1).toString() + "." + " ",
      style: TextStyle(fontSize: 20, fontFamily: 'DescriptionFont'),
    );
  }

  Widget nextLevelButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor:
          this.ingredients.length != 0 ? Colors.green : Colors.greenAccent,
      onPressed: () {
        if (this.ingredients.length != 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddRecipeLevels(widget.name,
                      widget.description, widget.imagePath, ingredients)));
        }
      },
      tooltip: 'next',
      child: Icon(Icons.navigate_next),
    );
  }

  Widget previousLevelButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
      tooltip: 'previous',
      child: Icon(Icons.navigate_before),
    );
  }
}
