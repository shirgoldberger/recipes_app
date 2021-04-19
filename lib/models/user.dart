class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String firstName;
  final String lastName;
  final String phone;
  final int age;
  final String email;
  List<String> likes = new List<String>();

  UserData(
      {this.uid,
      this.firstName,
      this.lastName,
      this.email,
      this.age,
      this.phone});
}
