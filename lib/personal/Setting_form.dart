import 'package:flutter/material.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/services/database.dart';
import 'package:recipes_app/shared_screen/constant.dart';
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DataBaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text('update your setting', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                    TextFormField(
                      initialValue: userData.firstName,
                      decoration: InputDecoration(labelText: 'First name'),
                      validator: (val) =>
                          val.isEmpty ? 'Please enter a first name' : null,
                      onChanged: (val) =>
                          setState(() => _cuttentFirstName = val),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      initialValue: userData.lastName,
                      decoration: InputDecoration(labelText: 'Last name'),
                      validator: (val) =>
                          val.isEmpty ? 'Please enter a last name' : null,
                      onChanged: (val) =>
                          setState(() => _cuttentLastName = val),
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 10.0),
                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            await DataBaseService(uid: user.uid).updateUserData(
                                _cuttentFirstName ?? userData.firstName,
                                _cuttentLastName ?? userData.lastName,
                                _cuttentPhone ?? userData.phone,
                                _cuttentAge ?? userData.age,
                                _cuttentEmail ?? userData.email);
                            Navigator.pop(context);
                          }
                        })
                  ],
                ));
          } else {
            Loading();
          }
        });
  }
}
