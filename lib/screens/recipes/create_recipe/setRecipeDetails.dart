import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:recipes_app/screens/recipes/create_recipe/uploadRecipeImage.dart';
import '../../../shared_screen/config.dart';

// ignore: must_be_immutable
class SetRecipeDetails extends StatefulWidget {
  String uid;
  String username;
  SetRecipeDetails(String _username, String _uid) {
    uid = _uid;
    username = _username;
  }
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
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          children: <Widget>[
            heightBox(70),
            Text(
              'Set name & description',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontFamily: 'Raleway'),
            ),
            box,
            Container(
                height: 520,
                child: ListView(children: [
                  recipeNameField(),
                  box,
                  box,
                  recipeDescriptionField(),
                ])),
            Row(children: [
              SizedBox(
                width: 10,
              ),
              previousLevelButton(),
              SizedBox(
                width: 10,
              ),
              LinearPercentIndicator(
                width: 240,
                animation: true,
                lineHeight: 18.0,
                animationDuration: 1000,
                percent: 0.0,
                center: Text(
                  "0%",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.grey[600],
              ),
              SizedBox(
                width: 10,
              ),
              nextLevelButton()
            ])
          ],
        ),
        resizeToAvoidBottomInset: false,
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter recipe name';
        }
        if (value.length > 20) {
          return 'Recipe name is limited to 20 characters';
        }
        return null;
      },
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
          val.length < 4 ? 'Enter a description with 4 letter at least' : null,
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
                  PageRouteBuilder(
                      transitionDuration: Duration(seconds: 0),
                      pageBuilder: (context, animation1, animation2) =>
                          UploadRecipeImage(widget.username, widget.uid,
                              recipeName, recipeDescription)));
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
