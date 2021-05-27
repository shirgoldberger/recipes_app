import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingredient.dart';
import '../../../shared_screen/config.dart';

// ignore: must_be_immutable
class EditRecipeIngredients extends StatefulWidget {
  String uid;
  List<IngredientsModel> ingredients = [];
  EditRecipeIngredients(String _uid, List<IngredientsModel> _ingredients) {
    uid = _uid;
    ingredients = [];
    ingredients.addAll(_ingredients);
  }
  @override
  _EditRecipeIngredientsState createState() => _EditRecipeIngredientsState();
}

class _EditRecipeIngredientsState extends State<EditRecipeIngredients> {
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        heightBox(40),
        title(),
        heightBox(40),
        Container(
            child: Column(
          children: [
            Text(error,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            widget.ingredients.length <= 0
                ? noIngredientsText()
                : ingredientsContainer(),
            box,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                addButton(),
                SizedBox(width: 60),
                saveButton(),
                SizedBox(width: 60),
                cancelButton()
              ],
            )
          ],
        ))
      ]),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget noIngredientsText() {
    return Text(
      'There is no ingredients in this recipe yet',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: errorColor, fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget ingredientsContainer() {
    return Container(
      height: min(50 * widget.ingredients.length.toDouble(), 300),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.ingredients.length,
          itemBuilder: (_, i) => Column(children: [
                ingredientRow(i),
              ])),
    );
  }

  Widget ingredientRow(int i) {
    return Row(
      children: <Widget>[
        widthBox(20),
        ingredientIndex(i),
        Expanded(child: SizedBox(height: 37.0, child: ingredientName(i))),
        Expanded(child: SizedBox(height: 37.0, child: ingredientAmount(i))),
        Expanded(child: SizedBox(height: 37.0, child: ingredientUnit(i))),
        deleteButton(i)
      ],
    );
  }

  Widget ingredientName(int i) {
    return TextFormField(
      initialValue: widget.ingredients[i].name,
      decoration: InputDecoration(
        hintText: 'Name',
      ),
      validator: (val) =>
          val.length < 2 ? 'Enter a description with 2 letter at least' : null,
      onChanged: (val) {
        setState(() => widget.ingredients[i].name = val);
      },
    );
  }

  Widget ingredientAmount(int i) {
    return TextFormField(
      initialValue: widget.ingredients[i].count.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Amount',
      ),
      validator: (val) =>
          val.length < 6 ? 'Enter a description eith 6 letter at least' : null,
      onChanged: (val) {
        setState(() => widget.ingredients[i].count = double.parse(val));
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
      value: widget.ingredients[i].unit,
      dropdownColor: Colors.grey,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 36,
      isExpanded: true,
      onChanged: (newValue) {
        setState(() {
          widget.ingredients[i].unit = newValue;
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

  void onDelteIng(int i) {
    setState(() {
      widget.ingredients.removeAt(i);
      error = "";
    });
  }

  void addIng() {
    IngredientsModel ingredient = IngredientsModel();
    ingredient.unit = 'Unit';
    setState(() {
      widget.ingredients.add(ingredient);
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
    return Text('Ingredients list:',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: ralewayFont));
  }

  Widget ingredientIndex(int i) {
    return Text(
      (i + 1).toString() + "." + " ",
      style: TextStyle(fontSize: 20, fontFamily: 'DescriptionFont'),
    );
  }

  Widget saveButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor:
          widget.ingredients.length != 0 ? Colors.green : Colors.grey,
      onPressed: () {
        List<IngredientsModel> notEmptyIngredients = [];
        for (IngredientsModel ingredient in widget.ingredients) {
          if (ingredient.count != 0 ||
              ingredient.name == "" ||
              ingredient.unit == "") {
            notEmptyIngredients.add(ingredient);
          }
        }
        if (notEmptyIngredients.length != 0) {
          Navigator.pop(context, widget.ingredients);
        } else {
          setState(() {
            error = "Add some ingredients to your recipe";
          });
        }
      },
      tooltip: 'save',
      child: Icon(Icons.save_rounded),
    );
  }

  Widget cancelButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.pop(context, null),
      elevation: 2.0,
      heroTag: null,
      backgroundColor: mainButtonColor,
      child: Icon(
        Icons.cancel,
        color: Colors.white,
      ),
      shape: CircleBorder(),
    );
  }
}
