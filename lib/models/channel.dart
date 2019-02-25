import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trenstop/misc/logger.dart';

part 'channel.g.dart';

abstract class Channel implements Built<Channel, ChannelBuilder> {

  static String TAG = "CHANNEL_MODEL";

  String get userId;
  String get channelId;
  String get categoryId;
  String get categoryName;
  String get createdBy;
  String get channelType;
  String get title;
  String get description;

  @nullable
  String get image;

  @nullable
  String get coverImage;

  Timestamp get createdDate;

  @nullable
  int get subscriberCount;

  double get price;

  @nullable
  double get targetFund;

  @nullable
  int get currentFund;

  @nullable
  double get percentage;


  Channel._();

  factory Channel([updates(ChannelBuilder b)]) = _$Channel;

  factory Channel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null || !snapshot.exists || snapshot.data.isEmpty)
      return null;
    try {
      final data = snapshot.data;
      final builder = ChannelBuilder()
        ..userId = data['userId'] ?? ''
        ..channelId = data['channelId'] ?? ''
        ..categoryId = data['categoryId'] ?? ''
        ..categoryName = data['categoryName'] ?? ''
        ..createdBy = data['createdBy'] ?? ''
        ..channelType = data['channelType'] ?? ''
        ..title = data['title'] ?? ''
        ..description = data['description'] ?? ''
        ..image = data['image'] ?? ''
        ..coverImage = data['coverImage'] ?? ''
        ..createdDate = data['createdDate'] ?? null
        ..subscriberCount = data['subscriberCount'] ?? 0
        ..price = double.parse(data['price'].toString()) ?? 0.0
        ..targetFund = double.parse(data['targetFund'].toString()) ?? 0.0
        ..currentFund = data['currentFund'] ?? 0
        ..percentage = data['percentage'] ?? 0.0;
      return builder.build();
    } catch (error) {
      Logger.log(TAG, message: "Couldn't build user object, error: $error");
      return null;
    }
  }

  Map<String, dynamic> get toMap => {
    "userId": this.userId,
    "channelId": this.channelId,
    "categoryId": this.categoryId,
    "categoryName": this.categoryName,
    "createdBy": this.createdBy,
    "channelType": this.channelType,
    "title": this.title,
    "description": this.description,
    "image": this.image,
    "coverImage": this.coverImage,
    "createdDate": this.createdDate,
    "subscriberCount": this.subscriberCount,
    "price": this.price,
    "targetFund": this.targetFund,
    "currentFund": this.currentFund,
    "percentage": this.percentage,
  };

  static Serializer<Channel> get serializer => _$channelSerializer;
}
