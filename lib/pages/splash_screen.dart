import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/misc/prefs.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/widgets/full_app_logo.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';

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

  _firestoreConfig() async {
//    InitFirestore();
    AuthManager _authManager = AuthManager.instance;
    await _authManager.fetchMessages();

    RemoteConfig remoteConfig = await RemoteConfig.instance;
    Map defaults = Map<String, dynamic>();
    defaults["showContentCreator"] = true;
    defaults["showCreateChannel"] = true;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
      debugMode: true,
    ));
    await remoteConfig.setDefaults(defaults);

    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
    print('welcome message: ' +
        remoteConfig.getBool('showContentCreator').toString());
    print('welcome message: ' +
        remoteConfig.getBool('showCreateChannel').toString());
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
