/// see the participants in the group ///

import 'dart:ui';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ParticipentsWatch extends StatefulWidget {
  List user;

  ParticipentsWatch(List _users) {
    this.user = _users;
  }

  @override
  _ParticipentsWatchState createState() => _ParticipentsWatchState();
}

class _ParticipentsWatchState extends State<ParticipentsWatch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          child: Column(children: <Widget>[
        for (int i = 0; i < widget.user.length; i++)
          Text(
            (i + 1).toString() + "). " + widget.user[i],
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 18,
            ),
            textAlign: TextAlign.left,
          ),
      ])),
    );
  }
}
