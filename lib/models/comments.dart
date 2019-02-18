import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trenstop/misc/logger.dart';

part 'comments.g.dart';

abstract class Comments implements Built<Comments, CommentsBuilder> {

  static String TAG = "TRAILER_MODEL";

  String get userId;
  String get trailerId;
  String get channelId;
  String get channelName;
  String get commentId;

  @nullable
  String get userPhoto;

  String get comment;
  String get userName;

  Timestamp get createdDate;


  Comments._();

  factory Comments([updates(CommentsBuilder b)]) = _$Comments;

  factory Comments.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null || !snapshot.exists || snapshot.data.isEmpty)
      return null;
    try {
      final data = snapshot.data;
      final builder = CommentsBuilder()
        ..userId = data['userId'] ?? ''
        ..trailerId = data['trailerId'] ?? ''
        ..channelId = data['channelId'] ?? ''
        ..channelName = data['channelName'] ?? ''
        ..userName = data['userName'] ?? ''
        ..userPhoto = data['userPhoto'] ?? ''
        ..comment = data['comment'] ?? ''
        ..commentId = data['commentId'] ?? ''
        ..createdDate = data['createdDate'] ?? null;
      return builder.build();
    } catch (error) {
      Logger.log(TAG, message: "Couldn't build user object, error: $error");
      return null;
    }
  }

  Map<String, dynamic> get toMap => {
    "userId": this.userId,
    "trailerId": this.trailerId,
    "channelId": this.channelId,
    "channelName": this.channelName,
    "userName": this.userName,
    "userPhoto": this.userPhoto,
    "comment": this.comment,
    "commentId": this.commentId,
    "createdDate": this.createdDate,
  };

  static Serializer<Comments> get serializer => _$commentsSerializer;
}
