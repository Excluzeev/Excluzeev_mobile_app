import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/prefs.dart';
import 'package:trenstop/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthManagerError {
  UNKNOWN,
  EMAIL_IN_USE,
  NO_ACCOUNT,
  USERNAME_TAKEN,
  GOOGLE_ERROR,
  EMAIL_ERROR,
}

class EmailError {
  static const String EMAIL_IN_USE =
      "The email address is already in use by another account.";
}

class AuthManager {
  static AuthManager _instance;

  static AuthManager get instance {
    if (_instance == null) _instance = AuthManager();
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _store = Firestore.instance;

  // These tags are for both logging and accessing Firestore's collections
  static const String TAG = "AUTH_MANAGER";
  static const String COLLECTION_TAG = "users";

  Future<FirebaseUser> get currentUser async => await _auth.currentUser();

  Future<bool> isLoggedIn() async {
    var firebaseUser = await currentUser;
    if (firebaseUser == null) return false;
    return true;
  }

  Future<User> getUser({FirebaseUser firebaseUser, bool force = false}) async {
    if (firebaseUser == null) firebaseUser = await currentUser;
    if (firebaseUser == null) return null;

    int lastFetched = await Prefs.getInt(PreferenceKey.lastFetched);
    // Logger.log(TAG, message: "lastFetched $lastFetched");
    if (lastFetched != 0 && force != true) {
      lastFetched = lastFetched + 5 * 60 * 1000;
      // print(lastFetched);
      // Logger.log(TAG, message: "again lastFetched $lastFetched");
      if (lastFetched > DateTime.now().millisecondsSinceEpoch) {
        String userData = await Prefs.getString(PreferenceKey.user);
        Uint8List data = base64Decode(userData);
        // print(String.fromCharCodes(data));
        Map<String, dynamic> jsonData = json.decode(String.fromCharCodes(data));
        User user = User.fromMap(jsonData);

        return user;
      }
    }

    final DocumentSnapshot snapshot = await collection
        .document(firebaseUser.uid)
        .get()
        .catchError((exception, stacktrace) {
      Logger.log(TAG, message: "Couldn't receive document: $exception");
    });
    User user;
    if (snapshot == null || !snapshot.exists || snapshot.data.isEmpty) {
      user = null;
      Logger.log(TAG, message: "Snapshot is null");
    } else {
      Logger.log(TAG, message: "Snapshot exsits");
      user = User.fromDocumentSnapshot(snapshot);

      List<int> encoded = Utf8Encoder().convert(json.encode(user.toMap));
      Prefs.setString(PreferenceKey.user, base64Encode(encoded));
      Prefs.setInt(
          PreferenceKey.lastFetched, DateTime.now().millisecondsSinceEpoch);
    }
    // Logger.log(TAG, message: "Received user data: ${user != null}");
    return user;
  }

  resetPassword(String email) async {
    bool isOkay = true;
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (exception) {
      isOkay = false;
      Logger.log(TAG, message: "Error occurred: $exception");
    }
    return Snapshot<bool>(
      data: isOkay,
      error: null,
    );
  }

  connectWithEmailAndPassword(bool isSignUp, Translation translation,
      {String email, String password}) async {
    String error;
    FirebaseUser firebaseUser;
    User user;

    final exceptionHandler = (exception, stacktrace) {
      Logger.log(TAG, message: "Error occurred: $exception, $stacktrace");
      error = exception.message;
    };

    await _auth
        .fetchSignInMethodsForEmail(email: email)
        .catchError(exceptionHandler)
        .then((providers) async {
      if (providers != null && (providers?.contains("password") ?? false)) {
        AuthResult authResult = await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .catchError(exceptionHandler);
        firebaseUser = authResult.user;
      } else {
        if (isSignUp) {
          AuthResult authResult = await _auth
              .createUserWithEmailAndPassword(email: email, password: password)
              .catchError(exceptionHandler);
          firebaseUser = authResult.user;
        } else {
          error = translation.noAccountFound;
        }
      }
    });

    user = await getUser(firebaseUser: firebaseUser);

    if (isSignUp && (user == null)) {
      user = User.fromEmail(firebaseUser);
      if (user == null) error = translation.unknownError;
    }

    return Snapshot<User>(
      data: user,
      error: error,
    );
  }

  CollectionReference get collection => _store.collection(COLLECTION_TAG);

  Future<DocumentCheck<User>> checkUser(String uid) async {
    final data = await collection.document(uid).get();
    return DocumentCheck<User>(
      data: User.fromDocumentSnapshot(data),
      exists: data?.exists ?? false,
    );
  }

  updateUser(User user) async {
    AuthManagerError error;

    final reference = collection.document(user.uid);
    Logger.log(TAG, message: "Trying to retrieve ${reference.path}");

    final errorHandler = (exception, stacktrace) {
      Logger.log(TAG,
          message: "Couldn't update user on database, error: $exception");
      error = AuthManagerError.UNKNOWN;
    };

    final freshSnap = await reference.get().catchError(errorHandler);

    await _store.runTransaction((transaction) async {
      final data = user.toMap;
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

    return Snapshot<User>(
      data: user,
      error: error,
    );
  }

  Future<String> fetchMessages() async {
    String allMessages = await Prefs.getString(PreferenceKey.subWarning);
    int lastFetched = await Prefs.getInt(PreferenceKey.lastFetched);

    if (lastFetched != 0) {
      lastFetched = lastFetched + 60 * 60 * 1000;
      if (lastFetched > DateTime.now().millisecondsSinceEpoch) {
        await _fetchAppMessages();
      }
    }
    allMessages = await Prefs.getString(PreferenceKey.subWarning);

    if (allMessages.isEmpty) {
      return await _fetchAppMessages();
    }
    return allMessages;
  }

  Future<String> _fetchAppMessages() async {
    DocumentSnapshot data = await Firestore.instance
        .collection("appmessages")
        .document("all")
        .get();

    print(data.data["subscriptionWarning"]);
    Prefs.setString(
        PreferenceKey.subWarning, data.data["subscriptionWarning"].toString());

    Prefs.setInt(
        PreferenceKey.lastSubWarn, DateTime.now().millisecondsSinceEpoch);
    return data.data["subscriptionWarning"];
  }
}
