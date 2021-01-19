import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  String totalScore;
  Result(int total) {
    this.totalScore = total.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "tou did it!! your score is  " + totalScore,
        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
      ),
    );
  }
}
