import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trenstop/misc/logger.dart';

part 'user.g.dart';

abstract class User implements Built<User, UserBuilder> {

  static String TAG = "USER_MODEL";

  String get uid;
  String get email;

  @nullable
  String get firstName;

  @nullable
  String get lastName;

  String get displayName => "$firstName $lastName";

  @nullable
  String get userPhoto;

  @nullable
  bool get isContentCreator;

  @nullable
  String get paypalEmail;

  @nullable
  BuiltList<String> get subscribedChannels;

  User._();

  factory User([updates(UserBuilder b)]) = _$User;

  factory User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null || !snapshot.exists || snapshot.data.isEmpty)
      return null;
    try {
      final data = snapshot.data;
      final builder = UserBuilder()
        ..firstName = data['firstName'] ?? ''
        ..lastName = data['lastName'] ?? ''
        ..uid = data['uid'] ?? ''
        ..email = data['email'] ?? ''
        ..userPhoto = data['userPhoto'] ?? ''
        ..isContentCreator = data['isContentCreator'] ?? false
        ..paypalEmail = data['paypalEmail'] ?? ''
        ..subscribedChannels = ListBuilder<String>(
          data['subscribed_channels'] != null
              ? List<String>.from(data['subscribedChannels'])
              : [],
        );
      return builder.build();
    } catch (error) {
      Logger.log(TAG, message: "Couldn't build user object, error: $error");
      return null;
    }
  }

  factory User.fromEmail(FirebaseUser firebaseUser) {
    try {
      final builder = UserBuilder()
        ..email = firebaseUser.email
        ..uid = firebaseUser.uid;
      return builder.build();
    } catch (error) {
      Logger.log(TAG, message: "Couldn't build user object, error: $error");
      return null;
    }
  }


  Map<String, dynamic> get toMap => {
    "firstName": this.firstName,
    "lastName": this.lastName,
    "uid": this.uid,
    "email": this.email,
    "isContentCreator": this.isContentCreator,
    "paypalEmail": this.paypalEmail,
    "userPhoto": this.userPhoto,
    "subscribedChannels": this.subscribedChannels?.toList()
  };

  static Serializer<User> get serializer => _$userSerializer;
}
