class IngredientsModel {
  String name;
  int count;
  String unit;

  IngredientsModel({this.count = 0, this.name = '', this.unit = ''});
  IngredientsModel.antherConstactor(String _name, int _count, String _unit) {
    this.name = _name;
    this.count = _count;
    this.unit = _unit;
  }

  Map<String, dynamic> toJson() => {'name': name, 'count': count, "unit": unit};
}
