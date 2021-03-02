import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/screen/home_screen/ingredients.dart';

class Recipe {
  String name;
  String description;
  List<IngredientsModel> ingredients;
  var id;
  List<String> myTag;
  int level;

  Recipe(String n, String desc, List<String> tags, int level) {
    this.name = n;
    this.description = desc;
    this.myTag = tags;
    this.level = level;
    //this.ingredients = ing;
  }
  void setId(var id) {
    this.id = id;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'level': level.toString(),
        'tags': (myTag.map((e) => e).toList())
      };
}
