import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trenstop/misc/logger.dart';

part 'chat.g.dart';

abstract class Chat implements Built<Chat, ChatBuilder> {

  static String TAG = "CHAT_MODEL";

  String get userId;
  String get chatId;

  @nullable
  String get userPhoto;

  String get message;
  String get userName;

  Timestamp get createdAt;


  Chat._();

  factory Chat([updates(ChatBuilder b)]) = _$Chat;

  factory Chat.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null || !snapshot.exists || snapshot.data.isEmpty)
      return null;
    try {
      final data = snapshot.data;
      final builder = ChatBuilder()
        ..userId = data['userId'] ?? ''
        ..userName = data['userName'] ?? ''
        ..userPhoto = data['userPhoto'] ?? ''
        ..message = data['message'] ?? ''
        ..chatId = data['chatId'] ?? ''
        ..createdAt = data['createdAt'] ?? null;
      return builder.build();
    } catch (error) {
      Logger.log(TAG, message: "Couldn't build user object, error: $error");
      return null;
    }
  }

  Map<String, dynamic> get toMap => {
    "userId": this.userId,
    "userName": this.userName,
    "userPhoto": this.userPhoto,
    "message": this.message,
    "chatId": this.chatId,
    "createdAt": this.createdAt,
  };

  static Serializer<Chat> get serializer => _$chatSerializer;
}
