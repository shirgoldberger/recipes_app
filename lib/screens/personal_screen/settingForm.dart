import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/services/fireStorageService.dart';
import 'package:recipes_app/services/userFromDB.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import '../../config.dart';
import 'uploadImage.dart';

// ignore: must_be_immutable
class SettingForm extends StatefulWidget {
  String uid;
  String imagePath = "";
  NetworkImage m;
  SettingForm(String _uid, NetworkImage _m) {
    uid = _uid;
    m = _m;
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
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DataBaseService(user.uid).userData,
        // ignore: missing_return
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
                      Row(children: [title(), widthBox(20), imageBox()]),
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
        .collection(usersCollectionName)
        .document(ud.uid)
        .collection('recipes')
        .getDocuments();
    // change the writer name in all the recipes
    recipes.documents.forEach((element) async {
      var recipeId = element.documentID.toString();
      await Firestore.instance
          .collection(usersCollectionName)
          .document(ud.uid)
          .collection('recipes')
          .document(recipeId)
          .updateData({'writer': writerName});
    });
  }

  Widget imageBox() {
    return TextButton(
      child: CircleAvatar(
          backgroundColor: backgroundColor,
          radius: 40,
          backgroundImage:
              (widget.m == null) ? ExactAssetImage(noImagePath) : widget.m),
      onPressed: uploadImagePressed,
    );
  }

  void uploadImagePressed() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UploadingImageToFirebaseStorage()))
        .then((value) => {
              FireStorageService.loadFromStorage(context, "uploads/" + value)
                  .then((downloadUrl) {
                setState(() {
                  widget.imagePath = value.toString();
                  UserFromDB.setUserImage(widget.uid, widget.imagePath);
                  widget.m = NetworkImage(downloadUrl);
                });
              })
            });
  }

  Widget title() {
    return Text(
      'Update your details',
      style:
          TextStyle(fontFamily: ralewayFont, fontSize: 20, color: titleColor),
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
      decoration: InputDecoration(labelText: 'Email'),
      validator: (val) => val.isEmpty ? 'Please enter an email' : null,
      onChanged: (val) => setState(() => _currentEmail = val),
    );
  }

  Widget ageField(int age) {
    return TextFormField(
      initialValue: age.toString(),
      decoration: InputDecoration(labelText: 'Age'),
      validator: (val) => val.isEmpty ? 'Please enter an age' : null,
      onChanged: (val) => setState(() => _currentAge = int.parse(val)),
    );
  }

  Widget phoneField(String phone) {
    return TextFormField(
      initialValue: phone,
      decoration: InputDecoration(labelText: 'Phone'),
      onChanged: (val) => setState(() => _currentPhone = val),
    );
  }

  Widget updateButton(UserData userData) {
    // ignore: deprecated_member_use
    return RaisedButton(
        color: mainButtonColor,
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
            Navigator.pop(context, widget.imagePath);
          }
        });
  }

  Widget appBar() {
    return AppBar(
      title: Text(
        'Cook Book',
        style: TextStyle(fontFamily: logoFont),
      ),
      backgroundColor: appBarBackgroundColor,
      elevation: 0.0,
    );
  }
}
