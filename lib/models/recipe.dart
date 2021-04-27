import 'package:recipes_app/models/ingredient.dart';

class Recipe {
  String writer;
  String writerUid;
  String name;
  String description;
  List<IngredientsModel> ingredients;
  String id;
  List<String> myTag;
  List<String> notes;
  int level;
  int time;
  //אם המתכון שמור בתיקית ביוזר או אם המתכון שמור בתיקית המתכונים.
  bool saveInUser;
  String publish = '';
  bool saveRecipe;
  String imagePath;
  List<String> likes;

  Recipe(
      String n,
      String desc,
      List<String> tags,
      int level,
      List<String> notes,
      String writer,
      String writerUid,
      int time,
      bool save,
      String id,
      String publish,
      String path) {
    this.name = n;
    this.description = desc;
    this.myTag = tags;
    this.level = level;
    this.notes = notes;
    this.writer = writer;
    this.writerUid = writerUid;
    this.time = time;
    this.saveInUser = save;
    this.id = id;
    this.publish = publish;
    this.imagePath = path;
    this.likes = new List();
    //this.ingredients = ing;
  }

  Recipe.forSearchRecipe(String _id, String _path) {
    this.id = _id;
    this.imagePath = _path;
  }

  void setId(var id) {
    this.id = id;
  }

  void publishThisRecipe(String id) {
    this.publish = id;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'level': level.toString(),
        'time': time.toString(),
        'writer': writer,
        'writerUid': writerUid,
        'publishID': publish,
        'recipeID': id,
        'tags': (myTag.map((e) => e).toList()),
        'notes': (notes.map((e) => e).toList()),
        'imagePath': imagePath,
        'likes': (likes.map((e) => e).toList())
      };
}
