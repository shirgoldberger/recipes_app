import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'settingForm.dart';
import '../groups/GroupList.dart';
import '../groups/newGroup.dart';
import '../../services/auth.dart';
import '../../services/fireStorageService.dart';
import '../../config.dart';
import '../recipes/create_recipe/mainCreateRecipe.dart';

// ignore: must_be_immutable
class HomeLogIn extends StatefulWidget {
  String uid;
  HomeLogIn(String _uid) {
    this.uid = _uid;
  }
  @override
  _HomeLogInState createState() => _HomeLogInState();
}

class _HomeLogInState extends State<HomeLogIn> {
  final AuthService _auth = AuthService();

  String name = "";
  String mail = "";
  String imagePath = "";
  NetworkImage image;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    DocumentSnapshot a =
        await Firestore.instance.collection('users').document(widget.uid).get();
    setState(() {
      name = a.data["firstName"];
      mail = a.data["Email"];
      imagePath = a.data['imagePath'];
    });
  }

  void getProfileImage(BuildContext context) async {
    if (image != null || imagePath == "") {
      return;
    }
    String downloadUrl = await FireStorageService.loadFromStorage(
        context, "uploads/" + imagePath);
    setState(() {
      imagePath = downloadUrl.toString();
      image = NetworkImage(imagePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    getProfileImage(context);
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar(),
        drawer: leftMenu(),
        drawerEdgeDragWidth: 30.0,
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ListView(children: <Widget>[
              box,
              title(),
              box,
              Row(children: [
                newGroupButton(),
                widthBox(70),
                watchGroupButton(),
              ]),
            ])),
        floatingActionButton: addNewRecipe());
  }

  Widget appBar() {
    return AppBar(
      title: Text(
        appName,
        style: TextStyle(fontFamily: logoFont),
      ),
      backgroundColor: appBarBackgroundColor,
    );
  }

  Widget leftMenu() {
    return Container(
      color: appBarBackgroundColor,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            profileDetails(),
            Column(children: [settingsIcon(), logOutIcon()]),
          ],
        ),
      ),
    );
  }

  Widget profilePicture() {
    // there is no image yet
    if (imagePath == "") {
      return CircleAvatar(
          backgroundColor: backgroundColor,
          radius: 40,
          backgroundImage: ExactAssetImage(noImagePath));
    } else {
      return CircleAvatar(
          backgroundColor: backgroundColor, radius: 40, backgroundImage: image);
    }
  }

  Widget profileDetails() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: appBarBackgroundColor,
      ),
      arrowColor: appBarBackgroundColor,
      accountName: Text(name),
      accountEmail: Text(mail),
      currentAccountPicture: profilePicture(),
    );
  }

  Widget settingsIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        minWidth: 300,
        icon: Icon(
          Icons.settings,
        ),
        label: Text(
          'Setting',
        ),
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingForm(widget.uid, image)));
        });
  }

  Widget logOutIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
      minWidth: 300,
      icon: Icon(Icons.person),
      label: Text('Log Out'),
      onPressed: () async {
        await _auth.signOut();
        Phoenix.rebirth(context);
      },
    );
  }

  Widget title() {
    return Text(
      // add the name of the user
      "Hello " + name + "!",
      style:
          TextStyle(fontFamily: ralewayFont, fontSize: 20, color: titleColor),
      textAlign: TextAlign.center,
    );
  }

  Widget addNewRecipe() {
    return FloatingActionButton(
      backgroundColor: mainButtonColor,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainCreateRecipe(name, widget.uid)));
      },
      tooltip: 'Add New Recipe',
      child: Icon(Icons.add),
    );
  }

  Widget newGroupButton() {
    return Container(
      width: 120,
      height: 100,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage(createGroupPath), fit: BoxFit.fill),
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      // ignore: deprecated_member_use
      child: TextButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewGroup(widget.uid)));
        },
        child: null,
      ),
    );
  }

  Widget watchGroupButton() {
    return Container(
      width: 100,
      height: 98,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage(yourGroupsPath), fit: BoxFit.fill),
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      // ignore: deprecated_member_use
      child: TextButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GroupList(widget.uid)));
        },
        child: null,
      ),
    );
  }
}
