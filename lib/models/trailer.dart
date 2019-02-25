import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trenstop/misc/logger.dart';

part 'trailer.g.dart';

abstract class Trailer implements Built<Trailer, TrailerBuilder> {

  static String TAG = "TRAILER_MODEL";

  String get userId;
  String get trailerId;
  String get channelId;
  String get channelName;
  String get categoryId;
  String get categoryName;
  String get createdBy;
  String get title;
  String get description;

  String get videoUrl;
  String get channelType;

  @nullable
  String get originalUrl;
  @nullable
  String get playbackId;

  @nullable
  String get image;

  @nullable
  String get channelImage;

  Timestamp get createdDate;


  Trailer._();

  factory Trailer([updates(TrailerBuilder b)]) = _$Trailer;

  factory Trailer.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null || !snapshot.exists || snapshot.data.isEmpty)
      return null;
    try {
      final data = snapshot.data;
      final builder = TrailerBuilder()
        ..userId = data['userId'] ?? ''
        ..trailerId = data['trailerId'] ?? ''
        ..channelId = data['channelId'] ?? ''
        ..channelName = data['channelName'] ?? ''
        ..categoryId = data['categoryId'] ?? ''
        ..categoryName = data['categoryName'] ?? ''
        ..channelType = data['channelType'] ?? ''
        ..createdBy = data['createdBy'] ?? ''
        ..title = data['title'] ?? ''
        ..description = data['description'] ?? ''
        ..image = 'https://image.mux.com/${data['playbackId']}/thumbnail.png'
        ..channelImage = 'https://firebasestorage.googleapis.com/v0/b/trenstop-public/o/channels%2F${data['channelId']}%2Fthumbnail.jpg?alt=media'
        ..videoUrl = "https://stream.mux.com/${data['playbackId']}.m3u8"
        ..originalUrl = data['videoUrl'] ?? ''
        ..playbackId = data['playbackId'] ?? ''
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
    "channelType": this.channelType,
    "categoryId": this.categoryId,
    "categoryName": this.categoryName,
    "createdBy": this.createdBy,
    "title": this.title,
    "description": this.description,
    "videoUrl": this.videoUrl,
    "createdDate": this.createdDate,
  };

  static Serializer<Trailer> get serializer => _$trailerSerializer;
}
