import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {
  // ignore: unused_element
  FireStorageService._();
  FireStorageService();

  static Future<dynamic> loadFromStorage(BuildContext context, String image) {
    throw ("Platform not found");
  }
}
