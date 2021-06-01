/// loading page ///

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipes_app/shared_screen/config.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.grey[350],
        child: Center(
            child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              SpinKitThreeBounce(
                color: Colors.grey[600],
                size: 50.0,
              ),
              heightBox(20),
              Text(
                'Loading...',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: logoFont,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]),
              )
            ],
          ),
        )),
      ),
    );
  }
}
