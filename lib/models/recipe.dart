import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/stage.dart';

class Recipe {
  String id;
  String writer;
  String writerUid;
  String name;
  String description;
  List<IngredientsModel> ingredients;
  List<String> tags;
  List<String> notes;
  List<String> likes = [];
  int level;
  int time;
  String imagePath;
  List<Stages> stages;

  //אם המתכון שמור בתיקית ביוזר או אם המתכון שמור בתיקית המתכונים.
  bool saveInUser;
  String publish = '';
  bool saveRecipe;

  Recipe(
      String _name,
      String _description,
      List<String> _tags,
      int _level,
      List<String> _notes,
      String _writer,
      String _writerUid,
      int _time,
      bool _save,
      String _id,
      String _publish,
      String _imagePath) {
    this.name = _name;
    this.description = _description;
    this.tags = _tags;
    this.level = _level;
    this.notes = _notes;
    this.writer = _writer;
    this.writerUid = _writerUid;
    this.time = _time;
    this.saveInUser = _save;
    this.id = _id;
    this.publish = _publish;
    this.imagePath = _imagePath;
  }

  Recipe.forSearchRecipe(String _id, String uid, String _path) {
    this.id = _id;
    this.writerUid = uid;
    this.imagePath = _path;
  }

  Recipe.forStream(String _id, String uid) {
    this.id = _id;
    this.writerUid = uid;
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
        'tags': (tags.map((e) => e).toList()),
        'notes': (notes.map((e) => e).toList()),
        'imagePath': imagePath,
        'likes': (likes.map((e) => e).toList())
      };
}
