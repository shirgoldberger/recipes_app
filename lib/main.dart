import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:recipes_app/screens/bookPage.dart';
import 'package:recipes_app/screens/home.dart';
import 'package:recipes_app/screens/personal_screen/logIn/logInWrapper.dart';
import 'package:recipes_app/screens/search_screen/search_page.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/services/fireStorageService.dart';
import 'config.dart';
import 'models/user.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  runApp(Phoenix(child: MyApp()));
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  bool internetConnection = false;
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 3;
  List<Widget> pageList = [];
  NetworkImage image;
  String personLabel = 'Personal';
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    super.initState();
    pageList.add(Home());
    pageList.add(Search());
    pageList.add(Book());
    pageList.add(Personal());

    getProfileImage();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  void checkConnection() {
    String string;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        string = "Offline";
        break;
      case ConnectivityResult.mobile:
        string = "Mobile: Online";
        break;
      case ConnectivityResult.wifi:
        string = "WiFi: Online";
    }
    if (string == 'Offline') {
      Future.delayed(Duration.zero, () async {
        _showAlertDialog();
      });
    }
    print(string);
  }

  void getProfileImage() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    if (user != null) {
      DocumentSnapshot snap =
          await Firestore.instance.collection("users").document(user.uid).get();
      String imagePath = snap.data['imagePath'] ?? "";
      if (imagePath != "") {
        String downloadUrl = await FireStorageService.loadFromStorage(
            context, "uploads/" + imagePath);
        setState(() {
          image = NetworkImage(downloadUrl);
          personLabel = "";
        });
      }
    }
  }

  void _onItemTapped(int index) {
    getProfileImage();
    setState(() {
      _selectedIndex = index;
    });
  }

  _showAlertDialog() {
    // set up the buttons
    // ignore: deprecated_member_use
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed: () async {
        Phoenix.rebirth(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Ooops..."),
      content: Text(
          "You do not seem to have internet connection - please try again"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () async {
      checkConnection();
    });
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, color: Colors.grey),
              label: 'Home',
              activeIcon: Icon(
                Icons.home,
                color: appBarBackgroundColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.grey),
              label: 'Search',
              activeIcon: Icon(
                Icons.search,
                color: appBarBackgroundColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined, color: Colors.grey),
              label: 'Book',
              activeIcon: Icon(
                Icons.book,
                color: appBarBackgroundColor,
              )),
          BottomNavigationBarItem(
            icon: image == null
                ? Icon(Icons.account_circle_outlined, color: Colors.grey)
                : CircleAvatar(
                    backgroundColor: backgroundColor,
                    radius: 12,
                    backgroundImage: image),
            label: personLabel,
            activeIcon: image == null
                ? Icon(
                    Icons.account_circle_rounded,
                    color: appBarBackgroundColor,
                  )
                : CircleAvatar(
                    radius: 14,
                    backgroundColor: appBarBackgroundColor,
                    child: CircleAvatar(
                        backgroundColor: backgroundColor,
                        radius: 12,
                        backgroundImage: image)),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: appBarBackgroundColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Personal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          fontFamily: 'Nunito',
        ),
        home: LogInWrapper());
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          fontFamily: 'Nunito',
        ),
        home: HomePage());
  }
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchPage(),
    );
  }
}

class Book extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: A(),
      ),
    );
  }
}

class A extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // if the user is null - no user us cinnect
    if (user == null) {
      return RecipesBookPage("");
    } else {
      return RecipesBookPage(user.uid);
    }
  }
}

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
