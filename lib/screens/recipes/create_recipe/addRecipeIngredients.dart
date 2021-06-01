/// add ingredients to user's recipe ///

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/screens/recipes/create_recipe/addRecipeStages.dart';
import '../../../shared_screen/config.dart';

// ignore: must_be_immutable
class AddRecipeIngredients extends StatefulWidget {
  String username;
  String uid;
  String name;
  String description;
  String imagePath;
  List<String> errorIng = [];

  AddRecipeIngredients(String _username, String _uid, String _name,
      String _description, String _imagePath) {
    username = _username;
    uid = _uid;
    name = _name;
    description = _description;
    imagePath = _imagePath;
  }
  @override
  _AddRecipeIngredientsState createState() => _AddRecipeIngredientsState();
}

class _AddRecipeIngredientsState extends State<AddRecipeIngredients> {
  List<IngredientsModel> ingredients = [];
  String error = "";
  bool _showError = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            children: [
              heightBox(70),
              title(),
              heightBox(20),
              Container(
                  height: 540,
                  child: Column(children: [
                    Text(error,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                    ingredients.length <= 0
                        ? noIngredientsText()
                        : ingredientsContainer(),
                    box,
                    addButton(),
                  ])),
              Row(
                children: [
                  widthBox(10),
                  previousLevelButton(),
                  widthBox(10),
                  progressBar(),
                  widthBox(10),
                  nextLevelButton()
                ],
              )
            ]),
        resizeToAvoidBottomInset: false);
  }

  Widget noIngredientsText() {
    return Visibility(
      visible: _showError,
      child: Text(
        'There is no ingredients in this recipe yet',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: errorColor, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget ingredientsContainer() {
    return Container(
        height: min(80 * ingredients.length.toDouble(), 400),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: ingredients.length,
          itemBuilder: (_, i) => Column(children: [
            ingredientRow(i),
            Text(widget.errorIng[i],
                style: TextStyle(
                  color: Colors.red,
                ))
          ]),
        ));
  }

  Widget ingredientRow(int i) {
    return Row(
      children: <Widget>[
        widthBox(20),
        ingredientIndex(i),
        Expanded(child: SizedBox(height: 37.0, child: ingredientName(i))),
        Expanded(child: SizedBox(height: 37.0, child: ingredientAmount(i))),
        Expanded(child: SizedBox(height: 37.0, child: ingredientUnit(i))),
        widthBox(10),
        deleteButton(i)
      ],
    );
  }

  Widget ingredientName(int i) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Name',
      ),
      validator: (val) =>
          val.length < 2 ? 'Enter a name with 2 letter at least' : null,
      onChanged: (val) {
        setState(() => ingredients[i].name = val);
      },
    );
  }

  Widget ingredientAmount(int i) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Amount',
      ),
      onChanged: (val) {
        if (val.toString() == '0') {
          setState(() {
            widget.errorIng[i] = 'The amount should be greater than 0';
          });
        } else if ((double.tryParse(val) == null) && (val != null)) {
          setState(() {
            widget.errorIng[i] = 'The amount should be a number';
          });
        } else {
          setState(() {
            widget.errorIng[i] = '';
          });
          setState(() => ingredients[i].count = double.parse(val));
        }
      },
    );
  }

  Widget ingredientUnit(int i) {
    List unitList = [
      "Unit",
      "Milligram",
      "Gram",
      "Kilogram",
      "Milliliter",
      "Liter",
      "Cup",
      "Box",
      "Teaspoon",
      "Tablespoon"
    ];

    return DropdownButton(
      dropdownColor: Colors.grey,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 36,
      isExpanded: true,
      value: ingredients[i].unit,
      onChanged: (newValue) {
        setState(() {
          ingredients[i].unit = newValue;
        });
      },
      items: unitList.map((valueItem) {
        return DropdownMenuItem(
          value: valueItem,
          child: Text(valueItem),
        );
      }).toList(),
    );
  }

  Widget progressBar() {
    return LinearPercentIndicator(
      width: 240,
      animation: true,
      lineHeight: 18.0,
      animationDuration: 500,
      percent: 0.25,
      center: Text(
        "25%",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: Colors.grey[600],
    );
  }

  void onDelteIng(int i) {
    setState(() {
      ingredients.removeAt(i);
      error = "";
      widget.errorIng.removeAt(i);
    });
  }

  void addIng() {
    setState(() {
      widget.errorIng.add('');
      ingredients.add(IngredientsModel());
      ingredients.last.setIndex(ingredients.length);
    });
  }

  Widget addButton() {
    return FloatingActionButton(
      onPressed: addIng,
      elevation: 2.0,
      heroTag: null,
      backgroundColor: mainButtonColor,
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
    return Text('Add Ingredients',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: ralewayFont));
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
          this.ingredients.length != 0 ? Colors.green : Colors.grey,
      onPressed: () {
        List<IngredientsModel> notEmptyIngredients = [];
        bool checkNullIng = false;
        for (IngredientsModel ingredient in this.ingredients) {
          if (ingredient.count != 0.0 &&
              ingredient.name != "" &&
              ingredient.unit != "") {
            notEmptyIngredients.add(ingredient);
          } else {
            checkNullIng = true;
          }
        }
        if ((notEmptyIngredients.length != 0) && (!checkNullIng)) {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(seconds: 0),
                  pageBuilder: (context, animation1, animation2) =>
                      AddRecipeStages(widget.username, widget.uid, widget.name,
                          widget.description, widget.imagePath, ingredients)));
        } else {
          if (checkNullIng) {
            setState(() {
              _showError = false;
              error = "All ingredients details should be complete";
            });
          } else {
            setState(() {
              _showError = false;
              error = "Add some ingredients to your recipe";
            });
          }
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
