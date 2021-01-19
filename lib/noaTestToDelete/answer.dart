import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  @override
  final Function presset;
  String ans_text;
  int color_index;
  Answer(this.presset, this.ans_text, this.color_index);
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.pink[color_index],
        child: Text(ans_text),
        onPressed: presset,
      ),
    );
  }
}
