import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/screen/home_screen/ingredients.dart';

class Recipe {
  String writer;
  String writerUid;
  String name;
  String description;
  List<IngredientsModel> ingredients;
  var id;
  List<String> myTag;
  List<String> notes;
  int level;
  int time;

  Recipe(String n, String desc, List<String> tags, int level,
      List<String> notes, String writer, String writerUid, int time) {
    this.name = n;
    this.description = desc;
    this.myTag = tags;
    this.level = level;
    this.notes = notes;
    this.writer = writer;
    this.writerUid = writerUid;
    this.time = time;
    //this.ingredients = ing;
  }
  void setId(var id) {
    this.id = id;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'level': level.toString(),
        'time': time.toString(),
        'writer': writer,
        'writerUid': writerUid,
        'tags': (myTag.map((e) => e).toList()),
        'notes': (notes.map((e) => e).toList())
      };
}
