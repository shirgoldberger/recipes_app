import 'package:recipes_app/models/recipe.dart';

class Directory {
  String id;
  String name;
  Map<dynamic, dynamic> recipesId;
  List<Recipe> recipes;
  initRecipes(List<Recipe> _recipes) {
    this.recipes = _recipes;
  }

  Directory({this.id, this.name, this.recipesId, this.recipes});
}
