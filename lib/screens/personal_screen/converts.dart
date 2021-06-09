// convertion food page ///

import 'package:flutter/material.dart';
import '../../shared_screen/config.dart';

// ignore: must_be_immutable
class Converts extends StatefulWidget {
  @override
  _ConvertsState createState() => _ConvertsState();
}

class _ConvertsState extends State<Converts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: ListView(children: <Widget>[
            Text(
              "Unbleached all-purpose flour: 1 cup = 120 grams",
              style: TextStyle(fontSize: 20, fontFamily: 'DescriptionFont'),
            ),
            heightBox(10),
            Text(
              "Self-rising flour:\n1 cup = 113 grams",
              style: TextStyle(fontSize: 20, fontFamily: 'DescriptionFont'),
            ),
            heightBox(10),
            Text(
              "Baking powder:\n1 teaspoon = 4 gramss",
              style: TextStyle(fontSize: 20, fontFamily: 'DescriptionFont'),
            ),
            heightBox(10),
            Text(
              "Baking soda:\n1/2 teaspoon = 3 grams",
              style: TextStyle(fontSize: 20, fontFamily: 'DescriptionFont'),
            ),
            heightBox(10),
            Text(
              "Butter:\n1/2 cup = 113 grams",
              style: TextStyle(fontSize: 20, fontFamily: 'DescriptionFont'),
            ),
            heightBox(10),
            Text(
              "Sugar (granulated white):\n1 cup = 198 grams",
              style: TextStyle(fontSize: 20, fontFamily: 'DescriptionFont'),
            )
          ])),
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
}
