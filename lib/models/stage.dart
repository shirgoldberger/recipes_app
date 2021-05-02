class Stages {
  String s;
  int i;
  Stages({this.s});
  Stages.antheeConstractor(String a, int i) {
    this.s = a;
    this.i = i;
  }
  Map<String, dynamic> toJson(int i) => {'number': i, 'stage': s};
}
