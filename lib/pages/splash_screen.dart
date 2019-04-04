import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/misc/prefs.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/widgets/full_app_logo.dart';

class SplashScreen extends StatefulWidget {
  static const String TAG = "SPLASH";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-splash");

  NavigatorState _navigator;

  @override
  void initState() {
    super.initState();
    _firestoreConfig();
    _init();
  }

  _init() async {
    await Future.delayed(
      Duration(seconds: 1),
      () async => WidgetUtils.proceedToHome(context, replaceAll: true),
    );
  }

  _fetchAppMessages() async {
    DocumentSnapshot data = await Firestore.instance
        .collection("appmessages")
        .document("all")
        .get();

    print(data.data["subscriptionWarning"]);
    Prefs.setString(
        PreferenceKey.subWarning, data.data["subscriptionWarning"].toString());

    Prefs.setInt(
        PreferenceKey.lastSubWarn, DateTime.now().millisecondsSinceEpoch);
  }

  _firestoreConfig() async {
//    InitFirestore();

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
      await _fetchAppMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Palette.overlayStyle);

    if (_navigator == null) {
      _navigator = Navigator.of(context, rootNavigator: true);
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: FullAppLogo(
          key: ValueKey("image-logo"),
        ),
      ),
    );
  }
}
