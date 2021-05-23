import 'package:recipes_app/models/recipe.dart';

class Directory {
  String id;
  String name;
  List recipesId;
  List<Recipe> recipes;
  initRecipes(List<Recipe> _recipes) {
    this.recipes = _recipes;
  }

  Directory({this.id, this.name, this.recipesId, this.recipes});
}
