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
  int get likes;
  @nullable
  int get dislikes;
  @nullable
  int get neutral;
  @nullable
  int get views;

  @nullable
  bool get hasCustomThumbnail;

  @nullable
  String get customThumbnail;

  @nullable
  String get originalUrl;
  @nullable
  String get playbackId;

  @nullable
  String get image;

  @nullable
  String get channelImage;

  Timestamp get createdDate;

  @nullable
  DateTime get expiry;

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
        ..hasCustomThumbnail = data['hasCustomThumbnail'] ?? false
        ..customThumbnail = data['customThumbnail'] ?? ''
        ..description = data['description'] ?? ''
        ..image =
            'https://image.mux.com/${data['playbackId']}/thumbnail.png?width=214&fit_mode=pad'
        ..channelImage =
            'https://firebasestorage.googleapis.com/v0/b/trenstop-public/o/channels%2F${data['channelId']}%2Fthumbnail.jpg?alt=media'
        ..videoUrl = "https://stream.mux.com/${data['playbackId']}.m3u8"
        ..originalUrl = data['videoUrl'] ?? ''
        ..playbackId = data['playbackId'] ?? ''
        ..createdDate = data['createdDate'] ?? null
        ..likes = data['likes'] ?? 0
        ..dislikes = data['dislikes'] ?? 0
        ..neutral = data['neutral'] ?? 0
        ..views = data['views'] ?? 0
        ..expiry = data['expiry'] != null ? data['expiry'].toDate() : null;
      return builder.build();
    } catch (error) {
      Logger.log(TAG, message: "Couldn't build user object, error: $error");
      return null;
    }
  }

// categoryId:	Iyz2r6IaQBD85W9lyBok
// categoryName:	Education
// channelId:	0MM4TxiBXBFGjvnADyZW
// channelName:	Test
// channelType:	VOD
// createdBy:	Karthik Ponnam
// createdDate:	_seconds1555153158_nanoseconds3000000
// description:	Test
// title:	Test Video
// trailerId:	0MM4U9AyPGMDNdKoEMj2
// userId:	8tofk8UcabOsu89X04bOaMwvH2C3
// videoUrl:	https://firebasestorage.googleapis.com/v0/b/trenstop-public/o/0MM4TxiBXBFGjvnADyZW%2F0MM4U9AyPGMDNdKoEMj2%2Foriginal?alt=media&token=bc337291-87d1-4167-95bd-9d9850971c04

  factory Trailer.fromAlogliaSearchIndex(Map<String, dynamic> snapshot) {
    if (snapshot.isEmpty) return null;
    try {
      final data = snapshot;

      final builder = TrailerBuilder()
        ..userId = data['userId'] ?? ''
        ..trailerId = data['trailerId'] ?? ''
        ..channelId = data['channelId'] ?? ''
        ..channelName = data['channelName'] ?? ''
        ..categoryId = data['categoryId'] ?? ''
        ..categoryName = data['categoryName'] ?? ''
        ..channelType = data['channelType'] ?? ''
        ..createdBy = data['createdBy'] ?? ''
        ..hasCustomThumbnail = data['hasCustomThumbnail'] ?? false
        ..customThumbnail = data['customThumbnail'] ?? ''
        ..title = data['title'] ?? ''
        ..description = data['description'] ?? ''
        ..image =
            'https://image.mux.com/${data['playbackId']}/thumbnail.png?width=214&fit_mode=pad'
        ..channelImage =
            'https://firebasestorage.googleapis.com/v0/b/trenstop-public/o/channels%2F${data['channelId']}%2Fthumbnail.jpg?alt=media'
        ..videoUrl = "https://stream.mux.com/${data['playbackId']}.m3u8"
        ..originalUrl = data['videoUrl'] ?? ''
        ..playbackId = data['playbackId'] ?? ''
        ..createdDate = data['createdDate'] != null
            ? Timestamp.fromMillisecondsSinceEpoch(
                data['createdDate']['_seconds'] * 1000)
            : null
        ..likes = data['likes'] ?? 0
        ..dislikes = data['dislikes'] ?? 0
        ..neutral = data['neutral'] ?? 0
        ..views = data['views'] ?? 0;
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
        "hasCustomThumbnail": this.hasCustomThumbnail,
        "customThumbnail": this.customThumbnail,
        "title": this.title,
        "description": this.description,
        "videoUrl": this.videoUrl,
        "createdDate": this.createdDate,
      };

  static Serializer<Trailer> get serializer => _$trailerSerializer;
}
