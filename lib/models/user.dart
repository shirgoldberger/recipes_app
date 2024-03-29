class User {
  final String uid;
  final bool verified;
  User({this.uid, this.verified});
}

class UserData {
  final String uid;
  final String firstName;
  final String lastName;
  final String phone;
  final int age;
  final String email;
  List<String> likes = [];
  String imagePath = "";
  UserData(
      {this.uid,
      this.firstName,
      this.lastName,
      this.email,
      this.age,
      this.phone,
      this.imagePath});
}
