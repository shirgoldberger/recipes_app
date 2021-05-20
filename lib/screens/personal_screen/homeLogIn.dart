import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:recipes_app/screens/groups/GroupList.dart';
import 'package:recipes_app/services/groupFromDB.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import 'package:recipes_app/services/userFromDB.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import 'settingForm.dart';
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
    setState(() {
      imagePath = downloadUrl.toString();
      image = NetworkImage(imagePath);
    });
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
              box,
              title(),
              box,
              newRecipeButtom(),
              box,
              box,
              Column(children: [
                newGroupButtom2(),
                box,
                widthBox(70),
                watchGroupButtom2(),
              ]),
            ])),
      );
    }
    // floatingActionButton: addNewRecipe());
  }

  Widget newRecipeButtom() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(3.0, 3.0),
                  blurRadius: 5.0,
                  color: Colors.grey[600],
                  spreadRadius: 2.0)
            ]),
        child: Material(
          elevation: 4.0,
          shape: CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: Ink.image(
            image: AssetImage('lib/images/new recipe.jpg'),
            fit: BoxFit.cover,
            width: 260.0,
            height: 260.0,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MainCreateRecipe(name, widget.uid)));
              },
            ),
          ),
        ),
      ),
    );
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
                      builder: (context) => SettingForm(widget.uid, image)))
              .then((value) => setState(() {
                    imagePath = value;
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
                await _auth.deleteAccount();
                await UserFromDB.deleteUser(widget.uid);
                await RecipeFromDB.deletePublushRecipesOfUser(widget.uid);
                await GroupFromDB.deleteUserFromAllGroups(widget.uid);
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
            color: Colors.grey[600],
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
