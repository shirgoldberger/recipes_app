import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/services/fireStorageService.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import '../../config.dart';
import '../personal_screen/uploadImage.dart';

class SettingForm extends StatefulWidget {
  String imagePath = "";
  String uid;
  SettingForm(String _uid) {
    uid = _uid;
  }
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  String _currentFirstName;
  String _currentLastName;
  String _currentPhone;
  String _currentEmail;
  int _currentAge;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Widget box = SizedBox(
    height: 20.0,
  );

  getUser() async {
    var currentUser =
        await Firestore.instance.collection('users').document(widget.uid).get();
    setState(() {
      widget.imagePath = currentUser.data['imagePath'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    _getImage(context, widget.imagePath);
    return StreamBuilder<UserData>(
        stream: DataBaseService(user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
                key: _formKey,
                child: Scaffold(
                  backgroundColor: backgroundColor,
                  appBar: appBar(),
                  body: ListView(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                    children: <Widget>[
                      box,
                      Row(children: [title(), box, imageBox()]),
                      firstNameField(userData.firstName),
                      box,
                      lastNameField(userData.lastName),
                      box,
                      emailField(userData.email),
                      box,
                      ageField(userData.age),
                      box,
                      phoneField(userData.phone),
                      box,
                      updateButton(userData)
                    ],
                  ),
                  resizeToAvoidBottomInset: false,
                ));
          } else {
            Loading();
          }
        });
  }

  void changeNameInRecipes(UserData ud) async {
    String writerName = "";
    // get the new name if it exist
    if (_currentFirstName != null) {
      writerName = _currentFirstName + " ";
    } else {
      writerName = ud.firstName + " ";
    }
    if (_currentLastName != null) {
      writerName += _currentLastName;
    } else {
      writerName += ud.lastName;
    }
    // get all user's recipes
    var recipes = await Firestore.instance
        .collection('users')
        .document(ud.uid)
        .collection('recipes')
        .getDocuments();
    // change the writer name in all the recipes
    recipes.documents.forEach((element) async {
      var recipeId = element.documentID.toString();
      var recipe = await Firestore.instance
          .collection('users')
          .document(ud.uid)
          .collection('recipes')
          .document(recipeId)
          .updateData({'writer': writerName});
    });
  }

  Future<Widget> _getImage(BuildContext context, String image) async {
    // there is no image
    if (image == "") {
      return null;
    }
    image = "uploads/" + image;
    Image m;
    // get the image from firebase
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    return m;
  }

  Widget imageBox() {
    // there is no image yet
    if (widget.imagePath == "") {
      return FlatButton(
        child: Image.asset(
          noImagePath,
          width: 80,
          height: 80,
        ),
        onPressed: uploadImagePressed,
      );
    } else {
      // load the image from firebase
      return Container(
          height: 100,
          child: Container(
            child: FutureBuilder(
                future: _getImage(context, widget.imagePath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return Container(
                      child: snapshot.data,
                    );
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container(
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width / 10,
                        child: CircularProgressIndicator());
                }),
          ));
    }
  }

  void uploadImagePressed() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UploadingImageToFirebaseStorage()))
        .then((value) => {
              setState(() {
                widget.imagePath = value.toString();
              })
            });
  }

  Widget title() {
    return Text(
      'Update your details',
      style: TextStyle(
          fontFamily: 'Raleway', fontSize: 20, color: Colors.blueGrey[800]),
      textAlign: TextAlign.center,
    );
  }

  Widget firstNameField(String firstName) {
    return TextFormField(
      initialValue: firstName,
      decoration: InputDecoration(labelText: 'First name'),
      validator: (val) => val.isEmpty ? 'Please enter a first name' : null,
      onChanged: (val) => setState(() => _currentFirstName = val),
    );
  }

  Widget lastNameField(String lastName) {
    return TextFormField(
      initialValue: lastName,
      decoration: InputDecoration(labelText: 'Last name'),
      validator: (val) => val.isEmpty ? 'Please enter a last name' : null,
      onChanged: (val) => setState(() => _currentLastName = val),
    );
  }

  Widget emailField(String email) {
    return TextFormField(
      initialValue: email,
      decoration: InputDecoration(labelText: 'email'),
      validator: (val) => val.isEmpty ? 'Please enter an email' : null,
      onChanged: (val) => setState(() => _currentEmail = val),
    );
  }

  Widget ageField(int age) {
    return TextFormField(
      initialValue: age.toString(),
      decoration: InputDecoration(labelText: 'your age'),
      validator: (val) => val.isEmpty ? 'Please enter a age' : null,
      onChanged: (val) => setState(() => _currentAge = int.parse(val)),
    );
  }

  Widget phoneField(String phone) {
    return TextFormField(
      initialValue: phone,
      decoration: InputDecoration(labelText: 'Phone'),
      validator: (val) => val.isEmpty ? 'Please enter a phone' : null,
      onChanged: (val) => setState(() => _currentPhone = val),
    );
  }

  Widget updateButton(UserData userData) {
    return RaisedButton(
        color: Colors.blueGrey[500],
        child: Text(
          'Update',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            await DataBaseService(userData.uid).updateUserData(
                _currentFirstName ?? userData.firstName,
                _currentLastName ?? userData.lastName,
                _currentPhone ?? userData.phone,
                _currentAge ?? userData.age,
                _currentEmail ?? userData.email,
                widget.imagePath ?? userData.imagePath);
            if (userData.firstName != _currentFirstName ||
                userData.lastName != _currentLastName) {
              changeNameInRecipes(userData);
            }
            Navigator.pop(context);
          }
        });
  }

  Widget appBar() {
    return AppBar(
      title: Text(
        'Cook Book',
        style: TextStyle(fontFamily: 'LogoFont'),
      ),
      backgroundColor: Colors.blueGrey[700],
      elevation: 0.0,
      actions: <Widget>[],
    );
  }
}
