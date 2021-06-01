/// create new group ///
import 'package:flutter/material.dart';
import 'package:recipes_app/shared_screen/config.dart';
import 'package:recipes_app/services/groupFromDB.dart';
import 'package:recipes_app/services/userFromDB.dart';

// ignore: must_be_immutable
class NewGroup extends StatefulWidget {
  String uid;

  NewGroup(String _uid) {
    this.uid = _uid;
  }
  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  List<String> usersID = [];
  List<String> userFullNames = [];
  String groupName = "";
  String error = '';
  String errorGroupName = '';
  bool findUser = false;
  String emailTocheck;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initializeGroup();
    super.initState();
  }

  void initializeGroup() async {
    usersID.add(widget.uid);
    String firstName = await UserFromDB.getUserFirstName(widget.uid);
    String lastName = await UserFromDB.getUserLastName(widget.uid);
    String fullName = firstName + " " + lastName;
    userFullNames.add(fullName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: _formKey,
        height: 100,
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(),
          body: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Column(children: <Widget>[
                Flexible(
                    child: ListView(children: [
                  title(),
                  heightBox(30),
                  groupNameField(),
                  errorFroupNameText(),
                  heightBox(20),
                  heightBox(20),
                  addMembersText(),
                  heightBox(20),
                  groupEmailField(),
                  heightBox(20),
                  errorText(),
                  addMemberButton(),
                  heightBox(20),
                  new Padding(padding: EdgeInsets.only(top: 10.0)),
                  Column(children: <Widget>[
                    membersList(),
                    new Padding(padding: EdgeInsets.only(top: 20.0)),
                  ]),
                ])),
              ])),
          resizeToAvoidBottomInset: false,
        ));
  }

  Widget appBar() {
    return AppBar(
        title: Text(
          'New group',
          style: TextStyle(fontFamily: logoFont),
        ),
        backgroundColor: appBarBackgroundColor,
        actions: <Widget>[
          // ignore: deprecated_member_use
          saveGroupWidget()
        ]);
  }

  Widget title() {
    return Text(
      'Hey let\'s create a new group!',
      style: TextStyle(
          fontFamily: 'Raleway', fontSize: 25, color: Colors.blueGrey[800]),
      textAlign: TextAlign.center,
    );
  }

  Widget groupNameField() {
    return TextFormField(
      cursorWidth: 10,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.edit),
        icon: Icon(Icons.dns),
        hintText: 'Group Name',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter recipe name';
        }

        return null;
      },
      onChanged: (val) {
        setState(() => groupName = val);
      },
    );
  }

  Widget groupEmailField() {
    return TextFormField(
      cursorWidth: 10,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.edit),
        icon: Icon(Icons.contact_mail),
        hintText: 'email adress',
      ),
      validator: (val) => val.isEmpty ? 'Enter an email of your friend' : null,
      onChanged: (val) {
        setState(() => emailTocheck = val);
      },
    );
  }

  Widget errorText() {
    return Text(
      error,
      style: TextStyle(color: errorColor),
    );
  }

  Widget errorFroupNameText() {
    return Text(
      errorGroupName,
      style: TextStyle(color: errorColor),
    );
  }

  Widget addMemberButton() {
    return RawMaterialButton(
      onPressed: () => saveUser(emailTocheck),
      elevation: 0.9,
      fillColor: Colors.blueGrey[300],
      child: Icon(
        Icons.person_add_alt_1,
        size: 30.0,
      ),
      padding: EdgeInsets.all(5.0),
      shape: CircleBorder(),
    );
  }

  Widget membersList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: userFullNames.length,
        itemBuilder: (context, index) {
          return Text(
            (index + 1).toString() + "." + "  " + userFullNames[index],
            textAlign: TextAlign.left,
            style: new TextStyle(fontSize: 20, color: Colors.blueGrey[800]),
          );
        });
  }

  Widget addMembersText() {
    return Text(
      'Adding participants:',
      style: TextStyle(fontFamily: 'Raleway', fontSize: 20, color: titleColor),
      textAlign: TextAlign.center,
    );
  }

  Widget saveGroupWidget() {
    if (groupName.length > 20) {
      setState(() {
        errorGroupName = 'Group name is limited to 20 characters';
      });
      // ignore: deprecated_member_use
      return FlatButton.icon(
          icon: Icon(
            Icons.save,
            color: Colors.white,
          ),
          label: Text('SAVE', style: TextStyle(color: Colors.white)),
          onPressed: null);
    } else {
      setState(() {
        errorGroupName = '';
      });
      // ignore: deprecated_member_use
      return FlatButton.icon(
          icon: Icon(
            Icons.save,
            color: Colors.white,
          ),
          label: Text('SAVE', style: TextStyle(color: Colors.white)),
          onPressed: () {
            saveGroup();
            Navigator.pop(context);
          });
    }
  }

  Future<void> saveGroup() async {
    await GroupFromDB.createNewGroup(groupName, usersID);
  }

  Future<void> saveUser(String email) async {
    String id = await UserFromDB.getUserByEmail(email);
    if (id == widget.uid) {
      setState(() {
        error = 'it\'s your email!';
      });
      return;
    }
    if (id == null) {
      setState(() {
        error = 'there is no such user, try again';
      });
      return;
    }
    String firstName = await UserFromDB.getUserFirstName(id);
    String lastName = await UserFromDB.getUserLastName(id);
    String fullName = firstName + " " + lastName;
    setState(() {
      error = '';
      if (fullName == ' ') {
        fullName = 'this user has no name:(';
      }
      if (!usersID.contains(id)) {
        userFullNames.add(fullName);
        usersID.add(id);
      } else {
        error = 'This user is already in this group';
      }
    });
  }
}
