import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screen/home_screen/ingredients.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/screen/home_screen/plusRecipe.dart';

class ListIngredients extends StatefulWidget {
  @override
  _ListIngredientsState createState() => _ListIngredientsState();
}

class _ListIngredientsState extends State<ListIngredients> {
  List<IngredientsModel> ingredients = [];

  @override
  Widget build(BuildContext context) {
    final db = Firestore.instance;
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: .0,
        leading: Icon(
          Icons.wb_cloudy,
        ),
        title: Text('INGREDIENTE DOR RECIPE'),
        actions: <Widget>[
          FlatButton(
            child: Text('Save'),
            textColor: Colors.white,
            onPressed: onSave,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF30C1FF),
              Color(0xFF2AA7DC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ingredients.length <= 0
            ? Text('empty')
            : ListView.builder(
                addAutomaticKeepAlives: true,
                itemCount: ingredients.length,
                itemBuilder: (_, i) => Ingredients(
                      ing: ingredients[i],
                      onDelete: () => onDelete(i),
                    )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addIng,
        foregroundColor: Colors.white,
      ),
    );
  }

  void onDelete(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  void addIng() {
    setState(() {
      ingredients.add(IngredientsModel());
    });
  }

  void onSave() {}
}
