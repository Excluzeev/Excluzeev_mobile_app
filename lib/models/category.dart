import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trenstop/misc/logger.dart';

part 'category.g.dart';

abstract class Category implements Built<Category, CategoryBuilder> {

  static String TAG = "CATEGORY_MODEL";

  String get id;
  String get name;

  @nullable
  String get image;

  Category._();

  factory Category([updates(CategoryBuilder b)]) = _$Category;

  factory Category.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null || !snapshot.exists || snapshot.data.isEmpty)
      return null;
    try {
      final data = snapshot.data;
      final builder = CategoryBuilder()
        ..id = data['id'] ?? ''
        ..name = data['name'] ?? ''
        ..image = data['image'] ?? '';
      return builder.build();
    } catch (error) {
      Logger.log(TAG, message: "Couldn't build user object, error: $error");
      return null;
    }
  }

  static Serializer<Category> get serializer => _$categorySerializer;
}
