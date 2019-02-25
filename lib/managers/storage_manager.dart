import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/misc/image_utils.dart';
import 'package:trenstop/misc/iuid.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:path_provider/path_provider.dart';

class StorageManager {
  static const String TAG = "STORAGE";

  static StorageManager _instance;

  static StorageManager get instance {
    if (_instance == null) _instance = StorageManager();
    return _instance;
  }

  static const String PROFILE_PICTURE = 'profile_picture.jpg';
  static const String THUMBNAIL = 'thumbnail.jpg';
  static const String USERS = "users";
  static const String MESSAGES = "messages";
  static const String TRAILERS = "trailers";

  static const int MODEL_SIZE = 244;
  static const int THUMBNAIL_SIZE = 256;
  static const int SQUARE_SIZE = 512;
  static const int DEFAULT_SIZE = 683;

  FirebaseStorage _storage =
      FirebaseStorage(storageBucket: "gs://trenstop-public");

  FirebaseStorage _storageVideos =
  FirebaseStorage(storageBucket: "gs://trenstop-videos");

  StorageUploadTask _uploadTask;
  StorageFileDownloadTask _downloadTask;

  Future<Snapshot<File>> getFile(StorageReference reference) async {
    String error;
    File data;

    final directory = await getTemporaryDirectory();
    final id = IUID.string;
    File file = File("${directory.path}/$id");

    _downloadTask = reference.writeToFile(file);
    await _downloadTask.future.catchError((exception, stacktrace) {
      Logger.log(TAG,
          message:
              "Couldn't get download url for this file, error: $exception");
      error = exception.toString();
    }).then((value) {
      Logger.log(TAG,
          message: "Downloaded file with ${value.totalByteCount} bytes");
      data = file;
    });

    return Snapshot<File>(
      data: data,
      error: error,
    );
  }

  Future<Snapshot<String>> getBase64(StorageReference reference) async {
    String error;
    String data;

    final directory = await getTemporaryDirectory();
    final id = IUID.string;
    File file = File("${directory.path}/$id");

    _downloadTask = reference.writeToFile(file);
    await _downloadTask.future.catchError((exception, stacktrace) {
      Logger.log(TAG,
          message:
              "Couldn't get download url for this file, error: $exception");
      error = exception.toString();
    }).then((value) {
      Logger.log(TAG,
          message: "Downloaded file with ${value.totalByteCount} bytes");
    });

    try {
      final bytes = await file.readAsBytes();
      data = base64Encode(bytes);
    } catch (exception) {
      error = "Failed to encode to base64";
      Logger.log(TAG, message: "$error, error: $exception");
    }

    return Snapshot<String>(
      data: data,
      error: error,
    );
  }

  Future<Snapshot<String>> getURL(StorageReference reference) async {
    String error;
    String url;

    await reference.getDownloadURL().catchError((exception, stacktrace) {
      Logger.log(TAG,
          message:
              "Couldn't get download url for this file, error: $exception");
      error = exception.toString();
    }).then((value) {
      if (value != null) url = value.toString();
    });

    return Snapshot<String>(
      data: url,
      error: error,
    );
  }

  Future<Snapshot<String>> uploadFile(
      String uid, StorageReference reference, File file) async {
    String error;
    String url;

    if (file == null) {
      error = "Received file is null";
    } else {
      _uploadTask = reference.putFile(
        file,
        StorageMetadata(
          customMetadata: <String, String>{'uid': uid},
        ),
      );

      final snapshot =
          await _uploadTask.onComplete.catchError((exception, stacktrace) {
        Logger.log(TAG,
            message: "Couldn't upload file to Storage, error: $exception");
        error = exception.toString();
      });

      if (snapshot != null) {
        Logger.log(TAG,
            message: "Snapshot returned: $snapshot, error: ${snapshot.error}");
        final urlSnapshot = await getURL(reference);
        if (urlSnapshot.success) {
          url = urlSnapshot.data;
        }
      }
    }

    return Snapshot<String>(
      data: url,
      error: error,
    );
  }

  cancelDownload() async {
    try {
      _downloadTask = null;
    } catch (error) {
      Logger.log(TAG, message: "Couldn't cancel download task, error: $error");
    }
  }

  cancelUpload() async {
    try {
      _uploadTask?.cancel();
    } catch (error) {
      Logger.log(TAG, message: "Couldn't cancel upload task, error: $error");
    }
  }

  StorageReference getUserReference(String uid) =>
      _storage.ref().child("$USERS/$uid");

  Future<Snapshot<String>> getProfilePicture(String uid) async {
    return await getURL(getUserReference(uid).child(PROFILE_PICTURE));
  }

  Future<Snapshot<String>> getThumbnail(String uid) async {
    return await getURL(getUserReference(uid).child(THUMBNAIL));
  }

  Future<List<Snapshot<String>>> uploadProfilePicture(
      String uid, File image) async {
    Logger.log(TAG,
        message: "Initializing upload of profile picture to Storage");
    final snapshots = [
      uploadFile(
        uid,
        getUserReference(uid).child(PROFILE_PICTURE),
        image,
      )
    ];
    final resized = await ImageUtils.nativeResize(image, THUMBNAIL_SIZE);
    if (resized.success)
      snapshots.add(uploadFile(
        uid,
        getUserReference(uid).child(THUMBNAIL),
        resized.data,
      ));
    return Future.wait(snapshots);
  }

  StorageReference getChannelTrailerReference() =>
      _storage.ref().child("trailers");
  StorageReference getVideosReference() =>
      _storageVideos.ref().child("videos");

  StorageReference getChannelsReference() => _storage.ref().child("channels");

//  StorageReference getPollListReference(String userUid) =>
//      _storage.ref().child("$USERS/$userUid/$POLLS");
//
//  StorageReference getChallengeListReference(String userUid) =>
//      _storage.ref().child("$USERS/$userUid/$CHALLENGES");
//
//  StorageReference getChallengeItemReference(
//      String userUid, String challengeId, String participantUserId) =>
//      _storage.ref().child("$USERS/$userUid/$CHALLENGES/$challengeId/$participantUserId");

//  StorageReference getImageMessageReference(Message message) =>
//      _storage.ref().child("$MESSAGES/${message.id}/${message.id}.jpg");

//  Future<Snapshot<String>> getImageUrl(ImagePost post) async {
//    return await getURL(getImagePostReference(post));
//  }

  Future<Snapshot<List<StorageUploadTask>>> uploadChannelTrailer(
      String userUid, String channelId, String trailerId, File image) async {
    String error;

    final reference =
        getChannelTrailerReference().child(channelId).child(trailerId);
    final List<StorageUploadTask> uploadTasks = [];

    final id = IUID.string;
    uploadTasks.add(reference.child("thumbnail.jpg").putFile(image));

    return Snapshot<List<StorageUploadTask>>(
      data: uploadTasks.isEmpty ? null : uploadTasks,
      error: error,
    );
  }

  Future<Snapshot<String>> uploadChannelImage(
      String userUid, String channelId, File image, String filename) async {
    String error;
    String url;

    final reference =
        getChannelsReference().child(channelId).child("$filename.jpg");
    StorageUploadTask uploadTasks;

    if (image == null) {
      error = "Received file is null";
    } else {
      _uploadTask = reference.putFile(
        image,
        StorageMetadata(
          customMetadata: <String, String>{'uid': userUid},
        ),
      );

      final snapshot =
          await _uploadTask.onComplete.catchError((exception, stacktrace) {
        Logger.log(TAG,
            message: "Couldn't upload file to Storage, error: $exception");
        error = exception.toString();
      });

      if (snapshot != null) {
        Logger.log(TAG,
            message: "Snapshot returned: $snapshot, error: ${snapshot.error}");
        final urlSnapshot = await getURL(reference);
        if (urlSnapshot.success) {
          url = urlSnapshot.data;
        }
      }
    }

    return Snapshot<String>(
      data: url,
      error: error,
    );
  }

  Future<Snapshot<String>> uploadTrailerVideo(
      String userUid, String channelId, String trailerId, File video) async {
    String error;
    String url;

    final reference = getChannelTrailerReference()
        .child(channelId)
        .child(trailerId)
        .child('original');
    StorageUploadTask uploadTasks;

    if (video == null) {
      error = "Received file is null";
    } else {
      _uploadTask = reference.putFile(
        video,
        StorageMetadata(
          contentType: 'video/mp4',
          customMetadata: <String, String>{'uid': userUid},
        ),
      );

      final snapshot =
          await _uploadTask.onComplete.catchError((exception, stacktrace) {
        Logger.log(TAG,
            message: "Couldn't upload file to Storage, error: $exception");
        error = exception.toString();
      });

      if (snapshot != null) {
        Logger.log(TAG,
            message: "Snapshot returned: $snapshot, error: ${snapshot.error}");
        final urlSnapshot = await getURL(reference);
        if (urlSnapshot.success) {
          url = urlSnapshot.data;
        }
      }
    }

    return Snapshot<String>(
      data: url,
      error: error,
    );
  }

  uploadVideoVideo(String uid, String videoId, File videoFile) async {
    String error;
    String url;

    final reference = getVideosReference()
        .child(videoId)
        .child('original');
    StorageUploadTask uploadTasks;

    if (videoFile == null) {
      error = "Received file is null";
    } else {
      _uploadTask = reference.putFile(
        videoFile,
        StorageMetadata(
          contentType: 'video/mp4',
          customMetadata: <String, String>{'uid': uid},
        ),
      );

      final snapshot =
          await _uploadTask.onComplete.catchError((exception, stacktrace) {
        Logger.log(TAG,
            message: "Couldn't upload file to Storage, error: $exception");
        error = exception.toString();
      });

      if (snapshot != null) {
        Logger.log(TAG,
            message: "Snapshot returned: $snapshot, error: ${snapshot.error}");
        final urlSnapshot = await getURL(reference);
        if (urlSnapshot.success) {
          url = urlSnapshot.data;
        }
      }
    }

    return Snapshot<String>(
      data: url,
      error: error,
    );

  }

  deleteProfilePicture(String uid) async {
    getUserReference(uid).delete().catchError((exception, stacktrace) =>
        Logger.log(TAG,
            message: "Couldn't delete profile picture, error: $exception"));
  }

  delete(StorageReference reference) async => await reference
      .delete()
      .catchError((exception, stacktrace) =>
          Logger.log(TAG, message: "Couldn't delete file, error: $exception"))
      .then((value) => Logger.log(TAG,
          message: "Deleted file ${reference.path} successfully!"));
}
