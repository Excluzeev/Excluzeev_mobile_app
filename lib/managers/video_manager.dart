import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/models/chat.dart';
import 'package:trenstop/models/video.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/models/comments.dart';
import 'package:http/http.dart' as http;

class VideoManager {

  static String TAG = "VIDEO_MANAGER";

  static VideoManager _instance;

  static VideoManager get instance {
    if (_instance == null) _instance = VideoManager();
    return _instance;
  }

  final Firestore _store = Firestore.instance;

  static const String VIDEOS_TAG = "videos";

  CollectionReference get videosCollection => _store.collection(VIDEOS_TAG);


  Query get videosQuery =>
      videosCollection.orderBy("createdDate", descending: true);

  Query videosByUserInChannelQuery(String userId, String channelId) {
    return videosCollection
        .where("channelId", isEqualTo: channelId)
        .where("userId", isEqualTo: userId)
        .orderBy("createdDate", descending: true);
  }

  Query videoCommentQuery(String videoId) {
    return videosCollection.document(videoId).collection('comments').orderBy("createdDate", descending: true);
  }
  Query videoChatQuery(String videoId) {
    return videosCollection.document(videoId).collection('chat').orderBy("createdAt", descending: true);
  }

  Future<http.Response> addLiveVideo(Video video) async {
//    processLiveVideo

    var client = new http.Client();
    var response = await client.post(
        "https://us-central1-trenstop-2033f.cloudfunctions.net/processLiveVideo", body: video.toJson);
    client.close();

    return response;
  }

  Future<Snapshot<Video>> addVideo(Video video) async {

    String error;

    DocumentReference reference = videosCollection.document(video.videoId);

    Logger.log(TAG, message: "Trying to retrieve ${reference.documentID}");

    final errorHandler = (exception, stacktrace) {
      Logger.log(TAG,
          message: "Couldn't update user on database, error: $exception");
      error = "Unknown Error";
    };

    final freshSnap = await reference.get().catchError(errorHandler);

    await _store.runTransaction((transaction) async {
      final data = video.toMap;
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

    return Snapshot<Video>(
      data: video,
      error: error,
    );

  }


  Future<Snapshot<Comments>> addComment(Comments comment) async {
    String error;

    DocumentReference reference = videosCollection.document(comment.vtId)
        .collection("comments").document(comment.commentId);

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


  Future<Snapshot<Chat>> addLiveChat(Chat chat, String vtId) async {
    String error;

    DocumentReference reference = videosCollection.document(vtId)
        .collection("chat").document(chat.chatId);

    Logger.log(TAG, message: "Trying to retrieve ${reference.documentID}");

    final errorHandler = (exception, stacktrace) {
      Logger.log(TAG,
          message: "Couldn't update Comment on database, error: $exception");
      error = "Unknown Error";
    };

    final freshSnap = await reference.get().catchError(errorHandler);

    await _store.runTransaction((transaction) async {
      final data = chat.toMap;
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

    return Snapshot<Chat>(
      data: chat,
      error: error,
    );
  }

  Future<bool> deleteVideo(Video video) async {
    DocumentReference reference = videosCollection.document(video.videoId);
    var result = await reference.delete();
    return true;
  }

  Future countView(Video video) async {
    DocumentReference reference = videosCollection.document(video.videoId);
    String error = "";

    final errorHandler = (exception, stacktrace) {
      Logger.log(TAG,
          message: "Couldn't update Comment on database, error: $exception");
      error = "Unknown Error";
    };

    final freshSnap = await reference.get().catchError(errorHandler);

    await _store.runTransaction((transaction) async {

      final data = {
        "views": freshSnap.data["views"] ?? 0 + 1
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

//  Future<Snapshot<Comments>> addComment(Comments comment) async {
//    String error;
//
//    DocumentReference reference = videosCollection.document(comment.videoId)
//        .collection("comments").document(comment.commentId);
//
//    Logger.log(TAG, message: "Trying to retrieve ${reference.documentID}");
//
//    final errorHandler = (exception, stacktrace) {
//      Logger.log(TAG,
//          message: "Couldn't update Comment on database, error: $exception");
//      error = "Unknown Error";
//    };
//
//    final freshSnap = await reference.get().catchError(errorHandler);
//
//    await _store.runTransaction((transaction) async {
//      final data = comment.toMap;
//      print(data);
//      final isUpdate = freshSnap?.exists ?? false;
//      if (isUpdate) {
//        Logger.log(TAG,
//            message: "Sending data with isUpdate ($isUpdate): ${data.keys}");
//        await transaction.update(reference, data).catchError(errorHandler);
//      } else {
//        Logger.log(TAG,
//            message: "Sending data with isUpdate ($isUpdate): ${data.keys}");
//        await transaction.set(reference, data).catchError(errorHandler);
//      }
//    }).catchError(errorHandler);
//
//    return Snapshot<Comments>(
//      data: comment,
//      error: error,
//    );
//  }

}