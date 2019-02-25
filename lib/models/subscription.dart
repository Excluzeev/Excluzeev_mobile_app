import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trenstop/misc/logger.dart';

part 'subscription.g.dart';

abstract class Subscription implements Built<Subscription, SubscriptionBuilder> {

  static String TAG = "SUBSCRIPTION_MODEL";

  String get userId;
  String get channelId;
  String get subscribedDate;
  String get channelName;
  String get channelImage;

  String get expiryDate;

  String get subscriptionId;

  bool get isActive;


  Subscription._();

  factory Subscription([updates(SubscriptionBuilder b)]) = _$Subscription;

  factory Subscription.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null || !snapshot.exists || snapshot.data.isEmpty)
      return null;
    try {
      final data = snapshot.data;
      final builder = SubscriptionBuilder()
        ..userId = data['userId'] ?? ''
        ..channelImage = 'https://firebasestorage.googleapis.com/v0/b/trenstop-public/o/channels%2F${data['channelId']}%2Fthumbnail.jpg?alt=media'
        ..channelId = data['channelId'] ?? ''
        ..channelName = data['channelName'] ?? ''
        ..subscribedDate = data['subscribedDate'] ?? null
        ..expiryDate = data['expiryDate'] ?? null
        ..isActive = data['isActive'] ?? false
        ..subscriptionId = data['subscriptionId'] ?? '';
      return builder.build();
    } catch (error) {
      Logger.log(TAG, message: "Couldn't build user object, error: $error");
      return null;
    }
  }


  static Serializer<Subscription> get serializer => _$subscriptionSerializer;
}
