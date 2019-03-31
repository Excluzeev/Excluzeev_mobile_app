import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/models/category.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/models/comments.dart';
import 'package:trenstop/models/trailer.dart';

class TrailerManager {
  static String TAG = "TRAILER_MANAGER";

  static TrailerManager _instance;

  static TrailerManager get instance {
    if (_instance == null) _instance = TrailerManager();
    return _instance;
  }

  final Firestore _store = Firestore.instance;

  static const String TRAILERS_TAG = "trailers";

  CollectionReference get trailersCollection => _store.collection(TRAILERS_TAG);

  Query get trailersQuery =>
      trailersCollection.orderBy("createdDate", descending: true);

  Query trailersByUserChannelQuery(String channelId, String userId) {
    return trailersCollection
        .where("channelId", isEqualTo: channelId)
        // .where("userId", isEqualTo: userId)
        .orderBy("createdDate", descending: true);
  }

  Query trailerCommentQuery(String trailerId) {
    return trailersCollection
        .document(trailerId)
        .collection('comments')
        .orderBy("createdDate", descending: true);
  }

  Future<Snapshot<Trailer>> addTrailer(Trailer trailer) async {
    String error;

    DocumentReference reference =
        trailersCollection.document(trailer.trailerId);

    Logger.log(TAG, message: "Trying to retrieve ${reference.documentID}");

    final errorHandler = (exception, stacktrace) {
      Logger.log(TAG,
          message: "Couldn't update user on database, error: $exception");
      error = "Unknown Error";
    };

    final freshSnap = await reference.get().catchError(errorHandler);

    await _store.runTransaction((transaction) async {
      final data = trailer.toMap;
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

    return Snapshot<Trailer>(
      data: trailer,
      error: error,
    );
  }

  Future<Snapshot<Comments>> addComment(Comments comment) async {
    String error;

    DocumentReference reference = trailersCollection
        .document(comment.vtId)
        .collection("comments")
        .document(comment.commentId);

    Logger.log(TAG, message: "Trying to retrieve ${reference.documentID}");

    final errorHandler = (exception, stacktrace) {
      Logger.log(TAG,
          message: "Couldn't update Comment on database, error: $exception");
      error = "Unknown Error";
    };

    final freshSnap = await reference.get().catchError(errorHandler);

    await _store.runTransaction((transaction) async {
      final data = comment.toMap;
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

    return Snapshot<Comments>(
      data: comment,
      error: error,
    );
  }

  Future countView(Trailer trailer) async {
    String error = "";

    DocumentReference reference =
        trailersCollection.document(trailer.trailerId);

    Logger.log(TAG, message: "Trying to retrieve ${reference.documentID}");

    final errorHandler = (exception, stacktrace) {
      Logger.log(TAG,
          message: "Couldn't update Comment on database, error: $exception");
      error = "Unknown Error";
    };

    final freshSnap = await reference.get().catchError(errorHandler);

    await _store.runTransaction((transaction) async {
      final data = {
        "views":
            freshSnap.data["views"] == null ? 1 : freshSnap.data["views"] + 1
      };
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
  }
}
