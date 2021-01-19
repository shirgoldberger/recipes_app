import 'package:flutter/material.dart';
import './answer.dart';
import './question.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questiones;
  final Function annswerPress;
  final int index;
  Quiz(this.questiones, this.annswerPress, this.index);
  int index_color = 0;
  // ignore: non_constant_identifier_names
  int color_index() {
    index_color = (index_color + 100);
    if (index_color > 900) {
      index_color = 100;
    }
    return index_color;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Questions(
          questiones[index]['question'],
        ),
        ...(questiones[index]['answers'] as List<Map<String, Object>>)
            .map((ans) {
          return Answer(
              () => annswerPress(ans['score']), ans['text'], color_index());
        }).toList()
      ],
    );
  }
}
