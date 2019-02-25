import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/models/category.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/models/trailer.dart';

class ChannelManager {

  static String TAG = "CHANNEL MANAGER";

  static ChannelManager _instance;

  static ChannelManager get instance {
    if (_instance == null) _instance = ChannelManager();
    return _instance;
  }

  final Firestore _store = Firestore.instance;

  static const String COLLECTION_TAG = "channels";
  static const String CATEGORY_TAG = "categories";

  CollectionReference get channelsCollection => _store.collection(COLLECTION_TAG);

  CollectionReference get categories => _store.collection(CATEGORY_TAG);


  Query myChannelsQuery(String userId) {
    return channelsCollection
        .where("userId", isEqualTo: userId)
        .orderBy("createdDate", descending: true);
  }
  // Queries
//  Query getUserChallenges(String userUid) => collection
//      .where("userUid", isEqualTo: userUid)
//      .orderBy("timestamp", descending: true);


  getCategories() async {
    QuerySnapshot querySnapshot = await categories.getDocuments();
    if(querySnapshot != null && querySnapshot.documents.length > 0) {
      List<Category> listCategories = querySnapshot.documents.map((snapshot) => Category.fromDocumentSnapshot(snapshot)).toList();
      return listCategories;
    } else
      return null;
  }

  Future<Snapshot<Channel>> getChannelFromId(String channelId) async {

    String error;

    DocumentReference reference = channelsCollection.document(channelId);

    Logger.log(TAG, message: "Trying to retrieve ${reference.documentID}");

    final errorHandler = (exception, stacktrace) {
      Logger.log(TAG,
          message: "Couldn't update user on database, error: $exception");
      error = "Unknown Error";
    };

    final snap = await reference.get().catchError(errorHandler);

    Channel channel = Channel.fromDocumentSnapshot(snap);

    return Snapshot<Channel>(
      data: channel,
      error: error,
    );

  }

  Future<Snapshot<Channel>> addChannel(Channel channel) async {

    String error;


    DocumentReference reference = channelsCollection.document(channel.channelId);

    Logger.log(TAG, message: "Trying to retrieve ${reference.documentID}");

    final errorHandler = (exception, stacktrace) {
      Logger.log(TAG,
          message: "Couldn't update user on database, error: $exception");
      error = "Unknown Error";
    };

    final freshSnap = await reference.get().catchError(errorHandler);

    await _store.runTransaction((transaction) async {
      final data = channel.toMap;
      print(data);
      final isUpdate = freshSnap?.exists ?? false;
      if (isUpdate) {
        Logger.log(TAG,
            message: "Sending data with isUpdate ($isUpdate): ${data.keys}");
        await transaction.update(reference, data).catchError(errorHandler);
      } else {
        Logger.log(TAG,
            message: "Sending data with isUpdate ($isUpdate): ${data.keys}");
        await transaction.set(reference, data).catchError(errorHandler);
      }
    }).catchError(errorHandler);

    return Snapshot<Channel>(
      data: channel,
      error: error,
    );

  }
}