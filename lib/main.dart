import 'package:flutter/material.dart';
import 'package:recipes_app/screens/book_page.dart';
import 'package:recipes_app/screens/home.dart';
import 'package:recipes_app/screens/personal_screen/logIn/logInWrapper.dart';
import 'package:recipes_app/screens/search_page.dart';
import 'package:recipes_app/services/auth.dart';
import 'models/user.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
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
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 2;
  List<Widget> pageList = List<Widget>();

  @override
  void initState() {
    pageList.add(Search());
    pageList.add(Home());
    pageList.add(Personal());
    pageList.add(Book());
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.grey),
              label: 'Search',
              activeIcon: Icon(
                Icons.search,
                color: Colors.cyan,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, color: Colors.grey),
              label: 'Home',
              activeIcon: Icon(
                Icons.home,
                color: Colors.cyan,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined, color: Colors.grey),
              label: 'Personal',
              activeIcon: Icon(
                Icons.account_circle_rounded,
                color: Colors.cyan,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined, color: Colors.grey),
              label: 'Book',
              activeIcon: Icon(
                Icons.book,
                color: Colors.cyan,
              )),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
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
