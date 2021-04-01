import 'package:flutter/material.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/shared_screen/loading.dart';

class SettingForm extends StatefulWidget {
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();

  String _cuttentFirstName;
  String _cuttentLastName;
  String _cuttentPhone;
  int _cuttentAge;
  String _cuttentEmail;

  Widget box = SizedBox(
    height: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DataBaseService(user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
                key: _formKey,
                child: Scaffold(
                  backgroundColor: Colors.blueGrey[350],
                  body: ListView(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                    children: <Widget>[
                      box,
                      box,
                      Text(
                        'Update your details',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 20,
                            color: Colors.blueGrey[800]),
                        textAlign: TextAlign.center,
                      ),
                      box,
                      TextFormField(
                        initialValue: userData.firstName,
                        decoration: InputDecoration(labelText: 'First name'),
                        validator: (val) =>
                            val.isEmpty ? 'Please enter a first name' : null,
                        onChanged: (val) =>
                            setState(() => _cuttentFirstName = val),
                      ),
                      box,
                      TextFormField(
                        initialValue: userData.lastName,
                        decoration: InputDecoration(labelText: 'Last name'),
                        validator: (val) =>
                            val.isEmpty ? 'Please enter a last name' : null,
                        onChanged: (val) =>
                            setState(() => _cuttentLastName = val),
                      ),
                      box,
                      TextFormField(
                        initialValue: userData.email,
                        decoration: InputDecoration(labelText: 'email'),
                        validator: (val) =>
                            val.isEmpty ? 'Please enter an email' : null,
                        onChanged: (val) => setState(() => _cuttentEmail = val),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: userData.age.toString(),
                        decoration: InputDecoration(labelText: 'your age'),
                        validator: (val) =>
                            val.isEmpty ? 'Please enter a age' : null,
                        onChanged: (val) =>
                            setState(() => _cuttentAge = int.parse(val)),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: userData.phone,
                        decoration: InputDecoration(labelText: 'Phone'),
                        validator: (val) =>
                            val.isEmpty ? 'Please enter a phone' : null,
                        onChanged: (val) => setState(() => _cuttentPhone = val),
                      ),
                      box,
                      RaisedButton(
                          color: Colors.cyan[600],
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await DataBaseService(user.uid).updateUserData(
                                  _cuttentFirstName ?? userData.firstName,
                                  _cuttentLastName ?? userData.lastName,
                                  _cuttentPhone ?? userData.phone,
                                  _cuttentAge ?? userData.age,
                                  _cuttentEmail ?? userData.email);
                              Navigator.pop(context);
                            }
                          })
                    ],
                  ),
                  resizeToAvoidBottomPadding: false,
                ));
          } else {
            Loading();
          }
        });
  }
}
