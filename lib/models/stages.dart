class Stages {
  String s;

  Stages({this.s});
  Stages.antheeConstractor(String a) {
    this.s = a;
  }
  Map<String, dynamic> toJson(int i) => {'number': i, 'stage': s};
}
