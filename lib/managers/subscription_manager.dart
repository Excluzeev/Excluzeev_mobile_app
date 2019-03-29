import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/models/category.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/models/subscription.dart';
import 'package:trenstop/models/trailer.dart';

class SubscriptionManager {
  static String TAG = "SUBSCRIPTION_MANAGER";

  static SubscriptionManager _instance;

  static SubscriptionManager get instance {
    if (_instance == null) _instance = SubscriptionManager();
    return _instance;
  }

  final Firestore _store = Firestore.instance;

  static const String COLLECTION_TAG = "subscriptions";

  CollectionReference get subscriptionsCollection =>
      _store.collection(COLLECTION_TAG);

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

    DocumentReference reference =
        subscriptionsCollection.document(subscription.subscriptionId);

    Logger.log(TAG, message: "Trying to retrieve ${reference.documentID}");

    final errorHandler = (exception, stacktrace) {
      Logger.log(TAG,
          message: "Couldn't update user on database, error: $exception");
      error = "Unknown Error";
    };

    final snap = await reference.get().catchError(errorHandler);

    if (snap.exists) {}

    Channel channel = Channel.fromDocumentSnapshot(snap);
  }
}
