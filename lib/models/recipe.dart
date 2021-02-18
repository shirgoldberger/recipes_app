class Recipe {
  String name;
  String description;

  Recipe(String n, String desc) {
    this.name = n;
    this.description = desc;
  }

  Map<String, dynamic> toJson() => {'name': name, 'description': description};
}
