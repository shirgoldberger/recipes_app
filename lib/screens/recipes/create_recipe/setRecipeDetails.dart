import 'package:flutter/material.dart';
import 'package:recipes_app/screens/recipes/create_recipe/uploadRecipeImage.dart';
import '../../../config.dart';

class SetRecipeDetails extends StatefulWidget {
  @override
  _SetRecipeDetailsState createState() => _SetRecipeDetailsState();
}

class _SetRecipeDetailsState extends State<SetRecipeDetails> {
  String recipeName = '';
  String recipeDescription = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: <Widget>[
            box,
            box,
            box,
            Text(
              'Set name & description\nof your recipe',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontFamily: 'Raleway'),
            ),
            box,
            recipeNameField(),
            box,
            box,
            recipeDescriptionField(),
            SizedBox(
              height: 160,
            ),
            Row(children: [
              SizedBox(
                width: 20,
              ),
              previousLevelButton(),
              SizedBox(
                width: 260,
              ),
              nextLevelButton()
            ])
          ],
        ),
        resizeToAvoidBottomPadding: false,
      ),
    );
  }

  Widget recipeNameField() {
    return TextFormField(
      cursorWidth: 10,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.edit),
        icon: Icon(Icons.dns),
        hintText: 'Recipe Name',
      ),
      validator: (val) => val.isEmpty ? 'Enter a name of your recipe' : null,
      onChanged: (val) {
        setState(() => recipeName = val);
      },
    );
  }

  Widget recipeDescriptionField() {
    return TextFormField(
      maxLines: 5,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.edit),
        icon: Icon(Icons.description),
        hintText: 'Description',
        border: OutlineInputBorder(),
      ),
      validator: (val) =>
          val.length < 6 ? 'Enter a description with 6 letter at least' : null,
      onChanged: (val) {
        setState(() => recipeDescription = val);
      },
    );
  }

  Widget nextLevelButton() {
    return Visibility(
        visible: recipeName != '' && recipeDescription != '',
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.green,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UploadRecipeImage(recipeName, recipeDescription)));
            }
          },
          tooltip: 'next',
          child: Icon(Icons.navigate_next),
        ));
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
