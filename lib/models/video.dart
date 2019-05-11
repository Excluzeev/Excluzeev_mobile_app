import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trenstop/misc/logger.dart';

part 'video.g.dart';

abstract class Video implements Built<Video, VideoBuilder> {
  static String TAG = "VIDEO_MODEL";

  String get userId;
  String get videoId;
  String get channelId;
  String get channelName;
  String get categoryId;
  String get categoryName;
  String get createdBy;
  String get title;
  String get description;
  String get type; // live or vod

  @nullable
  int get likes;
  @nullable
  int get dislikes;
  @nullable
  int get neutral;
  @nullable
  int get views;

  @nullable
  String get image;

  @nullable
  String get playbackId;

  @nullable
  String get videoUrl;

  @nullable
  String get channelImage;
  @nullable
  String get later;
  @nullable
  Timestamp get scheduleDate;
  @nullable
  String get sDate;
  @nullable
  String get streamKey;
  @nullable
  String get muxId;

  Timestamp get createdDate;

  Video._();

  factory Video([updates(VideoBuilder b)]) = _$Video;

  factory Video.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null || !snapshot.exists || snapshot.data.isEmpty)
      return null;
    try {
      final data = snapshot.data;
      final builder = VideoBuilder()
        ..userId = data['userId'] ?? ''
        ..videoId = data['videoId'] ?? ''
        ..channelId = data['channelId'] ?? ''
        ..channelName = data['channelName'] ?? ''
        ..categoryId = data['categoryId'] ?? ''
        ..categoryName = data['categoryName'] ?? ''
        ..createdBy = data['createdBy'] ?? ''
        ..title = data['title'] ?? ''
        ..type = data['type'] ?? ''
        ..later = data['later'] ?? 'now'
        ..scheduleDate = data['scheduleDate'] ?? null
        ..description = data['description'] ?? ''
        ..image =
            'https://image.mux.com/${data['playbackId']}/thumbnail.png?width=214&fit_mode=pad&token=${data['imageToken']}'
        ..streamKey = data['streamKey'] ?? ''
        ..muxId = data['muxId'] ?? ''
        ..channelImage =
            'https://firebasestorage.googleapis.com/v0/b/trenstop-public/o/channels%2F${data['channelId']}%2Fthumbnail.jpg?alt=media'
        ..playbackId = data['playbackId'] ?? ''
        ..createdDate = data['createdDate'] ?? null
        ..likes = data['likes'] ?? 0
        ..views = data['views'] ?? 0
        ..dislikes = data['dislikes'] ?? 0
        ..neutral = data['neutral'] ?? 0;
      return builder.build();
    } catch (error) {
      Logger.log(TAG, message: "Couldn't build user object, error: $error");
      return null;
    }
  }

  Map<String, dynamic> get toMap => {
        "userId": this.userId,
        "videoId": this.videoId,
        "channelId": this.channelId,
        "channelName": this.channelName,
        "categoryId": this.categoryId,
        "categoryName": this.categoryName,
        "createdBy": this.createdBy,
        "title": this.title,
        "type": this.type,
        "description": this.description,
        "videoUrl": this.videoUrl,
        "createdDate": this.createdDate,
      };

  Map<String, dynamic> get toJson => {
        "userId": this.userId,
        "videoId": this.videoId,
        "channelId": this.channelId,
        "channelName": this.channelName,
        "categoryId": this.categoryId,
        "categoryName": this.categoryName,
        "createdBy": this.createdBy,
        "title": this.title,
        "type": this.type,
        "description": this.description,
        "later": this.later,
        "sDate": this.sDate,
        "videoUrl": this.videoUrl,
      };

  static Serializer<Video> get serializer => _$videoSerializer;
}
