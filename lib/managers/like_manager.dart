import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/models/category.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/models/comments.dart';
import 'package:trenstop/models/trailer.dart';

class LikeManager {

  static String TAG = "LIKES_MANAGER";

  static LikeManager _instance;

  static LikeManager get instance {
    if (_instance == null) _instance = LikeManager();
    return _instance;
  }

  final Firestore _store = Firestore.instance;

  static const String LIKES_TAG = "likes";

  CollectionReference get likesCollection => _store.collection(LIKES_TAG);

  Future<int> isWhat(String userId, String id, String type) async {

    String error;

    DocumentReference reference = likesCollection.document("$userId:$id:$type");

    final errorHandler = (exception, stacktrace) {
      Logger.log(TAG,
          message: "Couldn't update user on database, error: $exception");
      error = "Unknown Error";
    };

    final snap = await reference.get().catchError(errorHandler);

    if(snap.exists) {
      int what = snap.data['what'];
      return what;
    } else {
      return 2;
    }
  }

  what(String userId, String id, int what, String type) async {

    DocumentReference reference = likesCollection.document("$userId:$id:$type");

    Map<String, int> updateData = Map();
    updateData['what'] = what;

    DocumentSnapshot snap = await reference.get();

    if(snap.exists) {
      reference.updateData(updateData);
    } else {
      reference.setData(updateData);
    }
  }

}