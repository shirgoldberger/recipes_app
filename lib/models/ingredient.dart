class IngredientsModel {
  String name;
  int count;
  String unit;

  IngredientsModel({this.count = 0, this.name = '', this.unit = ''});
  IngredientsModel.antherConstactor(String name, int count, String unit) {
    this.name = name;
    this.count = count;
    this.unit = unit;
  }

  Map<String, dynamic> toJson() => {'name': name, 'count': count, "unit": unit};
}
