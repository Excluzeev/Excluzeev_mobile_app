
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/models/user.dart';

class UserManager {
  static UserManager _instance;

  static UserManager get instance {
    if (_instance == null) _instance = UserManager();
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _store = Firestore.instance;

  static const String TAG = "AUTH_MANAGER";
  static const String COLLECTION_TAG = "users";

  CollectionReference get collection => _store.collection(COLLECTION_TAG);

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    if (firebaseUser == null) return null;
    final DocumentSnapshot snapshot = await collection
        .document(firebaseUser.uid)
        .get()
        .catchError((exception, stacktrace) {
      Logger.log(TAG, message: "Couldn't receive document: $exception");
    });
    User user;
    if (snapshot == null || !snapshot.exists || snapshot.data.isEmpty)
      user = null;
    else
      user = User.fromDocumentSnapshot(snapshot);
    Logger.log(TAG, message: "Received user data: ${user != null}");
    return user;
  }

  setUserPayPalEmail(String email) async {
    String error;

    User user = await getUser();
    if(user == null) return null;
    final reference = collection.document(user.uid);
    Logger.log(TAG, message: "Trying to retrieve ${reference.path}");

    final errorHandler = (exception, stacktrace) {
      Logger.log(TAG,
          message: "Couldn't update user on database, error: $exception");
      error = "Update Failed";
    };

    final freshSnap = await reference.get().catchError(errorHandler);

    UserBuilder userBuilder = UserBuilder()
      ..replace(user)
      ..paypalEmail = email
      ..isContentCreator = true;

    User newUser = userBuilder.build();

    await _store.runTransaction((transaction) async {
      final data = newUser.toMap;
      final isUpdate = freshSnap?.exists ?? false;
      if (isUpdate) {
        Logger.log(TAG,
            message: "Sending data with isUpdate ($isUpdate): ${data.keys}");
        await transaction.update(reference, data).catchError(errorHandler);
      } else {
        await transaction.set(reference, data).catchError(errorHandler);
      }
    }).catchError(errorHandler);

    return Snapshot<User>(
      data: user,
      error: error,
    );
  }

}