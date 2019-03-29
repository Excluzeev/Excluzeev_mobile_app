import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/models/category.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/models/subscription.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/models/user.dart';

class SubscriptionManager {
  static String TAG = "SUBSCRIPTION_MANAGER";

  static SubscriptionManager _instance;

  static SubscriptionManager get instance {
    if (_instance == null) _instance = SubscriptionManager();
    return _instance;
  }

  final Firestore _store = Firestore.instance;

  static const String COLLECTION_TAG = "subscriptions";
  static const String USERS_TAG = "users";
  static const String CHANNEL_TAG = "channels";

  CollectionReference get subscriptionsCollection =>
      _store.collection(COLLECTION_TAG);

  CollectionReference get userCollection => _store.collection(USERS_TAG);

  CollectionReference get channelCollection => _store.collection(CHANNEL_TAG);

  Query mySubscriptionsQuery(String userId) {
    return subscriptionsCollection
        .where("userId", isEqualTo: userId)
        .where("isActive", isEqualTo: true);
  }

  fetchData(String userId) {
    Logger.log(TAG, message: userId);
    var data = subscriptionsCollection
        .where("userId", isEqualTo: userId)
        .getDocuments()
        .then((qSnap) =>
            {Logger.log(TAG, message: qSnap.documents.length.toString())});
  }

  Future<void> doUnSubscribe(Subscription subscription) async {
    String error = "";

    AuthManager _authManager = AuthManager.instance;

    DocumentReference reference =
        subscriptionsCollection.document(subscription.subscriptionId);

    Logger.log(TAG, message: "Trying to retrieve ${reference.documentID}");

    final errorHandler = (exception, stacktrace) {
      Logger.log(TAG,
          message: "Couldn't update user on database, error: $exception");
      error = "Unknown Error";
    };

    final snap = await reference.get().catchError(errorHandler);

    if (snap.exists) {
      var updateData = new Map<String, dynamic>();
      updateData["isCanceled"] = true;
      updateData["isActive"] = false;
      updateData["expiryDate"] = Timestamp.fromDate(DateTime.now());

      await snap.reference.updateData(updateData);

      FirebaseUser fUser = await _authManager.currentUser;
      DocumentSnapshot userDoc = await userCollection.document(fUser.uid).get();

      DocumentSnapshot channelDoc =
          await channelCollection.document(subscription.channelId).get();

      if (userDoc.exists) {
        User user = User.fromDocumentSnapshot(userDoc);
        var subscribedChannels = user.subscribedChannels;

        // Filter array
        var filteredSubscribedChannels = subscribedChannels
            .where((value) => value != subscription.channelId)
            .toList();

        var userUpdateData = Map<String, dynamic>();
        userUpdateData["subscribedChannels"] =
            filteredSubscribedChannels.toList();

        await userDoc.reference.updateData(userUpdateData);
      }

      if (channelDoc.exists) {
        Channel channel = Channel.fromDocumentSnapshot(channelDoc);

        var channelUpdateData = Map<String, dynamic>();
        channelUpdateData["subscriberCount"] =
            channel.subscriberCount > 0 ? channel.subscriberCount + 1 : 1;

        await channelDoc.reference.updateData(channelUpdateData);
      }

      await _authManager.getUser(force: true);
    }
  }
}
