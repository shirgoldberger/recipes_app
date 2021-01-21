import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final CollectionReference recipeCollection =
      Firestore.instance.collection('recipe');
}
