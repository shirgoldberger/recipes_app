import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:recipes_app/screens/groups/GroupList.dart';
import 'package:recipes_app/screens/personal_screen/converts.dart';
import 'package:recipes_app/services/groupFromDB.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import 'package:recipes_app/services/userFromDB.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import 'settingForm.dart';
import '../groups/newGroup.dart';
import '../../services/auth.dart';
import '../../services/fireStorageService.dart';
import '../../shared_screen/config.dart';
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
    String firstName = await UserFromDB.getUserFirstName(widget.uid);
    String email = await UserFromDB.getUserEmail(widget.uid);
    String path = await UserFromDB.getUserImage(widget.uid);
    setState(() {
      name = firstName;
      mail = email;
      imagePath = path;
    });
  }

  void getProfileImage(BuildContext context) async {
    if (image != null || imagePath == "") {
      return;
    }
    String downloadUrl = await FireStorageService.loadFromStorage(
        context, "uploads/" + imagePath);
    if (downloadUrl != null) {
      setState(() {
        imagePath = downloadUrl.toString();
        image = NetworkImage(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getProfileImage(context);
    if (name == "") {
      return Loading();
    } else {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar(),
        drawer: leftMenu(),
        drawerEdgeDragWidth: 30.0,
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ListView(children: <Widget>[
              title(),
              box,
              newRecipeButtom(),
              box,
              Column(children: [
                coffe1(),
                //   newGroupButtom2(),
                box,
                widthBox(70),
                coffe2(),
                //  watchGroupButtom2(),
              ]),
            ])),
      );
    }
    // floatingActionButton: addNewRecipe());
  }

  Widget newRecipeButtom() {
    return InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        borderRadius: BorderRadius.circular(5),
        highlightColor: Colors.blueGrey,
        child: Container(
          width: 250,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey[50],
            image: DecorationImage(
                image: ExactAssetImage('lib/images/aaa.JPG'),
                fit: BoxFit.cover),
          ),
          child: FlatButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MainCreateRecipe(name, widget.uid)));
            },
          ),
        ));
  }

  Widget coffe1() {
    return InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        borderRadius: BorderRadius.circular(5),
        highlightColor: Colors.blueGrey,
        child: Container(
          width: 370,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey[50],
            image: DecorationImage(
                image: ExactAssetImage('lib/images/coffe1.JPG'),
                fit: BoxFit.cover),
          ),
          child: FlatButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewGroup(widget.uid)));
            },
          ),
        ));
  }

  Widget coffe2() {
    return InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        borderRadius: BorderRadius.circular(5),
        highlightColor: Colors.blueGrey,
        child: Container(
          width: 370,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey[50],
            image: DecorationImage(
                image: ExactAssetImage('lib/images/coffe2.JPG'),
                fit: BoxFit.cover),
          ),
          child: FlatButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupList(widget.uid)));
            },
          ),
        ));
  }

  Widget appBar() {
    return AppBar(
      title: Text(
        appName,
        style: TextStyle(fontFamily: logoFont),
      ),
      backgroundColor: appBarBackgroundColor,
      actions: [convertsIcon()],
    );
  }

  Widget convertsIcon() {
    return FlatButton.icon(
      icon: Icon(
        Icons.change_circle,
        color: Colors.white,
      ),
      label: Text("Weight\nConversion",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 10)),
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => Converts())),
    );
  }

  Widget leftMenu() {
    return Container(
      color: appBarBackgroundColor,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
        child: ListView(
          children: <Widget>[
            profileDetails(),
            Column(
                children: [settingsIcon(), logOutIcon(), deleteAccountIcon()]),
          ],
        ),
      ),
    );
  }

  Widget profilePicture() {
    // there is no image yet
    if (image == null) {
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
                      builder: (context) => SettingForm(widget.uid, image)))
              .then((value) => setState(() {
                    imagePath = value["path"];
                    image = value["image"];
                  }));
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

  Widget deleteAccountIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
      minWidth: 300,
      icon: Icon(Icons.person),
      label: Text('Delete Account'),
      onPressed: () async {
        _showAlertDialog();
        // await _auth.deleteAccount();
        // await UserFromDB.deleteUser(widget.uid);
        // await RecipeFromDB.deletePublushRecipesOfUser(widget.uid);
        // await GroupFromDB.deleteUserFromAllGroups(widget.uid);
        // Phoenix.rebirth(context);
      },
    );
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'You\'re sure you want to delete your account permanently ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('yes- delete'),
              onPressed: () async {
                await GroupFromDB.deleteUserFromAllGroups(widget.uid);
                await RecipeFromDB.deletePublushRecipesOfUser(widget.uid);
                await UserFromDB.deleteUser(widget.uid);
                await _auth.deleteAccount();

                Phoenix.rebirth(context);
              },
            ),
            TextButton(
              child: Text('no- go back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget title() {
    return Text(
        // add the name of the user
        "Hello " + name + "!",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.brown[900],
            fontWeight: FontWeight.w900,
            //fontStyle: FontStyle.italic,
            fontFamily: 'Raleway',
            fontSize: 40));
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

  Widget newGroupButtom2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.grey), //Background Color
            elevation: MaterialStateProperty.all(8), //Defines Elevation
            shadowColor:
                MaterialStateProperty.all(Colors.grey), //Defines shadowColor
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewGroup(widget.uid)));
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('   Create Group     ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Raleway',
                    fontSize: 27)),
          ),
        ),
      ),
    );
  }

  Widget watchGroupButtom2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.grey), //Background Color
            elevation: MaterialStateProperty.all(8), //Defines Elevation
            shadowColor:
                MaterialStateProperty.all(Colors.grey), //Defines shadowColor
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GroupList(widget.uid)));
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Watch your Group',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Raleway',
                    fontSize: 27)),
          ),
        ),
      ),
    );

    // return Padding(
    //     padding: const EdgeInsets.all(0),
    //     // ignore: deprecated_member_use
    //     child: RaisedButton(
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(18.0),
    //             side: BorderSide(color: subButtonColor)),
    //         onPressed: () {
    //           Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => GroupList(widget.uid)));
    //         },
    //         padding: EdgeInsets.all(20.0),
    //         color: Colors.grey,
    //         textColor: Colors.white,
    //         child: Center(
    //           child: Text(
    //             'Watch ypur Group',
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.w900,
    //                 fontStyle: FontStyle.italic,
    //                 fontFamily: 'Raleway',
    //                 fontSize: 27),
    //           ),
    //         )));
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
