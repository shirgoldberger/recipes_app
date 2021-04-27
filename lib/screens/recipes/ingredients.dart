import 'package:flutter/material.dart';
import 'package:recipes_app/models/ingredient.dart';

typedef OnDelete();

class Ingredients extends StatefulWidget {
  IngredientsModel ing;
  final state = _IngredientsState();
  OnDelete onDelete;
  Ingredients({Key key, this.ing, this.onDelete}) : super(key: key);
  @override
  _IngredientsState createState() => state;

  bool isValid() => state.validate();
}

class _IngredientsState extends State<Ingredients> {
  final form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        child: Form(
          key: form,
          child: Column(
            children: <Widget>[
              AppBar(
                leading: Icon(Icons.people),
                centerTitle: true,
                title: Text('Ingrediets:'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  )
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.ing.name,
                    onSaved: (val) => widget.ing.name = val,
                    validator: (val) =>
                        val.length > 3 ? null : 'full name is valid',
                    decoration: InputDecoration(
                        labelText: 'name:', hintText: 'enter ingredient name'),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.ing.name,
                    onSaved: (val) => widget.ing.count = int.parse(val),
                    validator: (val) =>
                        val.length > 3 ? null : 'full name is valid',
                    decoration: InputDecoration(
                        labelText: 'amount:', hintText: 'enter amount'),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.ing.name,
                    onSaved: (val) => widget.ing.unit = val,
                    validator: (val) =>
                        val.length > 3 ? null : 'full name is valid',
                    decoration: InputDecoration(
                        labelText: 'unit:', hintText: 'enter unit'),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  bool validate() {
    var valid = form.currentState.validate();
    if (valid) form.currentState.save();
    return valid;
  }
}
