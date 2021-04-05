import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  Widget box = SizedBox(
    height: 20.0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(
          'Cook Book',
          style: TextStyle(fontFamily: 'LogoFont'),
        ),
        backgroundColor: Colors.blueGrey[700],
        elevation: 0.0,
        actions: <Widget>[],
      ),
      body: Container(
        child: ListView(
          children: [
            box,
            Text(
              'Search Recipes Here!',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 20,
                  color: Colors.blueGrey[800]),
              textAlign: TextAlign.center,
            ),
            box,
            SearchInput(),
          ],
        ),
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 30,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          fillColor: Colors.white,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
        ),
      ),
    );
  }
}
