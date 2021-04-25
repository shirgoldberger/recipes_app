import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/models/stages.dart';

import '../../../config.dart';

class AddRecipeLevels extends StatefulWidget {
  String name;
  String description;
  String imagePath;
  List<IngredientsModel> ingredients;
  AddRecipeLevels(String _name, String _description, String _imagePath,
      List<IngredientsModel> _ingredients) {
    name = _name;
    description = _description;
    imagePath = _imagePath;
    ingredients = _ingredients;
  }
  @override
  _AddRecipeLevelsState createState() => _AddRecipeLevelsState();
}

class _AddRecipeLevelsState extends State<AddRecipeLevels> {
  List<Stages> stages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          box,
          box,
          title(),
          box,
          box,
          // stages
          Container(
              child: Column(children: [
            stages.length <= 0
                ? Text(
                    'There is no stages\nin this recipe yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    addAutomaticKeepAlives: true,
                    itemCount: stages.length,
                    itemBuilder: (_, i) => Row(children: <Widget>[
                          Text((i + 1).toString() + "." + " "),
                          Expanded(
                              child: SizedBox(
                                  height: 37.0,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'stage of the recipe',
                                    ),
                                    validator: (val) => val.length < 2
                                        ? 'Enter a description eith 2 letter at least'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => stages[i].s = val);
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
                        ])),
            addButton()
          ])),
        ],
      ),
    );
  }

  void onDelteStages(int i) {
    setState(() {
      stages.removeAt(i);
    });
  }

  void addStages() {
    setState(() {
      stages.add(Stages());
    });
  }

  Widget addButton() {
    return FloatingActionButton(
      onPressed: addStages,
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

  Widget title() {
    return Text('Add Stages to your recipe',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Raleway'));
  }
}
