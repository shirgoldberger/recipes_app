import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var i = 0;
  var questiones = [
    {
      'question': 'whats tour favorite color',
      'answers': [
        {'text': 'red', 'score': 100},
        {'text': 'yellow', 'score': 10},
        {'text': 'black', 'score': 50},
        {'text': 'pink', 'score': 80}
      ]
    },
    {
      'question': 'whats tour favorite animal',
      'answers': [
        {'text': 'rabbit', 'score': 100},
        {'text': 'dog', 'score': 10},
        {'text': 'cat', 'score': 50},
        {'text': 'lion', 'score': 80}
      ]
    },
    {
      'question': 'whats tour favorite food',
      'answers': [
        {'text': 'hanburger', 'score': 100},
        {'text': 'pizza', 'score': 10}
      ]
    }
  ];
  int totalScore = 0;
  void press(int score) {
    totalScore += score;
    setState(() {
      i = i + 1;
    });
    print("presed");
  }

  int index = 0;
  // ignore: non_constant_identifier_names
  int color_index() {
    index = (index + 100);
    if (index > 900) {
      index = 100;
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
