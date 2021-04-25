import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/screens/personal_screen/Setting_form.dart';
import '../groups/GroupList.dart';
import 'logIn/logInWrapper.dart';
import '../groups/newGroup.dart';
import '../recipes/plusRecipe.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/services/fireStorageService.dart';
import '../../config.dart';
import '../book_page.dart';
import '../recipes/create_recipe/mainCreateRecipe.dart';

class HomeLogIn extends StatefulWidget {
  HomeLogIn(String _user) {
    this.uid = _user;
  }
  String uid;
  @override
  _HomeLogInState createState() => _HomeLogInState();
}

class _HomeLogInState extends State<HomeLogIn> {
  final db = Firestore.instance;
  final AuthService _auth = AuthService();

  String name = "";
  String mail = "";
  String imagePath = "";
  NetworkImage m;
  List<String> groupName;
  List<String> groupId;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void _getImage(BuildContext context, String image) async {
    if (image == "") {
      setState(() {
        imagePath = "";
      });
      return null;
    }
    image = "uploads/" + image;
    String downloadUrl =
        await FireStorageService.loadFromStorage(context, image);
    setState(() {
      imagePath = downloadUrl.toString();
      m = NetworkImage(imagePath);
    });
  }

  Future<void> getGroups() async {
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('groups')
        .getDocuments();
    snap.documents.forEach((element) async {
      groupId.add(element.data['groupId']);
      groupName.add(element.data['groupName']);
    });
  }

  void getData() async {
    DocumentSnapshot a =
        await Firestore.instance.collection('users').document(widget.uid).get();
    setState(() {
      name = a.data["firstName"];
      mail = a.data["Email"];
      imagePath = a.data['imagePath'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // _getImage(context, imagePath);
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar(),
        drawerDragStartBehavior: DragStartBehavior.down,
        drawerScrimColor: Colors.blueGrey[200],
        drawer: leftMenu(),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ListView(children: <Widget>[
              box,
              Text(
                // add the name of the user
                "Hello " + name + "!",
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 20,
                    color: Colors.blueGrey[800]),
                textAlign: TextAlign.center,
              ),
              box,
              Row(children: [
                newGroupButton(),
                SizedBox(
                  width: 70,
                ),
                watchGroupButton(),
              ]),
            ])),
        floatingActionButton: addNewRecipe());
  }

  void _showSettingPannel() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: SettingForm(widget.uid),
          );
        });
  }

  Widget appBar() {
    return AppBar(
      title: Text(
        appName,
        style: TextStyle(fontFamily: 'LogoFont'),
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
    return CircleAvatar(
      backgroundImage: imagePath == "" ? ExactAssetImage(noImagePath) : m,
    );
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
    return FlatButton.icon(
      minWidth: 300,
      icon: Icon(
        Icons.settings,
        color: Colors.black,
      ),
      label: Text(
        'Setting',
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () => _showSettingPannel(),
    );
  }

  Widget logOutIcon() {
    return FlatButton.icon(
      minWidth: 300,
      icon: Icon(Icons.person, color: Colors.black),
      label: Text('Log Out', style: TextStyle(color: Colors.black)),
      onPressed: () async {
        await _auth.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LogInWrapper()));
      },
    );
  }

  Widget addNewRecipe() {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlusRecipe()));
      },
      tooltip: 'Add New Recipe',
      child: Icon(Icons.add),
    );
  }

  Widget recipesBookIcon() {
    return FlatButton.icon(
        color: Colors.blueGrey[400],
        icon: Icon(
          Icons.book,
          color: Colors.white,
        ),
        label: Text(
          'Recipes Book',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipesBookPage(widget.uid)));
        });
  }

  Widget newGroupButton() {
    return Container(
      width: 120,
      height: 100,
      decoration: BoxDecoration(
          // color: Colors.blueGrey[200],
          image: DecorationImage(
              image: ExactAssetImage('lib/images/create_group.png'),
              fit: BoxFit.fill),
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: FlatButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewGroup(widget.uid)));
        },
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
      child: FlatButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GroupList(widget.uid)));
        },
      ),
    );
  }
}
