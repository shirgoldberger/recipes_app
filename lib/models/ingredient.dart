class IngredientsModel {
  String name;
  double count;
  String unit;
  int index;

  setIndex(int i) {
    this.index = i;
  }

  IngredientsModel({this.count = 0, this.name = '', this.unit = 'Unit'});
  IngredientsModel.antherConstactor(
      String _name, double _count, String _unit, int i) {
    this.name = _name;
    this.count = _count;
    this.unit = _unit;
    this.index = i;
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'count': count, "unit": unit, "index": index};
}
