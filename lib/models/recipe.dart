import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/screen/home_screen/ingredients.dart';

class Recipe {
  String name;
  String description;
  List<IngredientsModel> ingredients;

  Recipe(String n, String desc) {
    this.name = n;
    this.description = desc;
    //this.ingredients = ing;
  }

  Map<String, dynamic> toJson() => {'name': name, 'description': description};
}
