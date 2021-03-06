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
  List<Map<String, dynamic>> get tiers;

  @nullable
  double get targetFund;

  @nullable
  double get currentFund;

  @nullable
  double get percentage;

  @nullable
  bool get isDeleted;

  @nullable
  DateTime get deleteOn;

  @nullable
  DateTime get expiry;

  Channel._();

  factory Channel([updates(ChannelBuilder b)]) = _$Channel;

  factory Channel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null || !snapshot.exists || snapshot.data.isEmpty)
      return null;
    try {
      final data = snapshot.data;
      print(data['tiers']);
      List<Map<String, dynamic>> listTiers = List();
      if (data['tiers'] != null) {
        data['tiers'].forEach((d) {
          Map<String, dynamic> m = {
            "description": d["description"],
            "price": d["price"],
            "tier": d["tier"]
          };
          listTiers.add(m);
        });
      }
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
        ..tiers = data['tiers'] != null ? listTiers : []
        ..expiry = data['expiry'] != null && data['expiry'].toString().isNotEmpty ? data['expiry'].toDate() : null
        ..coverImage = data['coverImage'] ?? ''
        ..createdDate = data['createdDate'] ?? null
        ..deleteOn = data['deleteOn'] != null ? data['deleteOn'].toDate() : null
        ..isDeleted = data['isDeleted'] ?? false
        ..subscriberCount = data['subscriberCount'] ?? 0
        ..price = double.parse(
                (data['price'] != null) ? data['price'].toString() : "0") ??
            0.0
        ..targetFund = double.parse((data['targetFund'] != null)
                ? data['targetFund'].toString()
                : "0") ??
            0.0
        ..currentFund = double.parse((data['currentFund'] != null)
                ? data['currentFund'].toString()
                : "0") ??
            0.0
        ..percentage = double.parse((data['percentage'] != null)
                ? data['percentage'].toString()
                : "0") ??
            0.0;
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
        "tiers": this.tiers,
        "coverImage": this.coverImage,
        "createdDate": this.createdDate,
        "subscriberCount": this.subscriberCount,
        "price": this.price,
        "tiers": tiers,
        "expiry": expiry != null ? Timestamp.fromDate(expiry) : null,
        "targetFund": this.targetFund,
        "currentFund": this.currentFund,
        "percentage": this.percentage,
      };

  static Serializer<Channel> get serializer => _$channelSerializer;
}
