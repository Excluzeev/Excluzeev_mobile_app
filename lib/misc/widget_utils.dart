import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/pages/auth/sign_in_page.dart';
import 'package:trenstop/pages/channel/add_trailer.dart';
import 'package:trenstop/pages/channel/new_channel.dart';
import 'package:trenstop/pages/creatorauth/content_creator_email_page.dart';
import 'package:trenstop/pages/creatorauth/content_creator_signup_page.dart';
import 'package:trenstop/pages/home/feed.dart';
import 'package:trenstop/pages/trailer/trailer_detail.dart';

class WidgetUtils {
  static const String TAG = "WIDGET_UTILS";

  static void proceedToAuth(
      BuildContext context, {
        bool replaceAll = false,
        String invite,
      }) async {
    String tag;
    Widget page;

    // final bool finishedTeaser =
    //    await Prefs.getBool(PreferenceKey.finishedTeaser, defaultValue: false);

    final user = await AuthManager.instance.getUser(force: true);

    final bool loggedIn = user != null;

    if (loggedIn) {
      tag = FeedPage.TAG;
      page = FeedPage();
    } else {
      tag = SignInPage.TAG;
      page = SignInPage();
      print("auth");
    }

    final route = CupertinoPageRoute(
      maintainState: true,
      settings: RouteSettings(name: tag),
      builder: (context) => page,
    );

    if (replaceAll) {
      Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
    } else {
      Navigator.of(context).push(route);
    }
  }

  static Future<bool> showContentCreatorSignUp(BuildContext context) async {
    String tag = ContentCreatorSignUpPage.TAG;
    Widget page = ContentCreatorSignUpPage();

    final route = CupertinoPageRoute<bool>(
      maintainState: true,
      fullscreenDialog: true,
      settings: RouteSettings(name: tag),
      builder: (context) => page,
    );
    bool isDone = await Navigator.of(context).push(route);

    if(isDone) {
      await showContentCreatorEmail(context);
    }
    return true;
  }

  static Future<bool> showContentCreatorEmail(BuildContext context) async {
    String tag = ContentCreatorEmailPage.TAG;
    Widget page = ContentCreatorEmailPage();

    final route = CupertinoPageRoute(
      maintainState: true,
      fullscreenDialog: true,
      settings: RouteSettings(name: tag),
      builder: (context) => page,
    );
    Navigator.of(context).push(route);
    return true;
  }

  static void showCreateChannelPage(BuildContext context) async {
    String tag = NewChannelPage.TAG;
    Widget page = NewChannelPage();

    final route = CupertinoPageRoute<bool>(
      maintainState: true,
      settings: RouteSettings(name: tag),
      builder: (context) => page,
    );
    Navigator.of(context).push(route);
  }

  static void showCreateTrailerPage(BuildContext context, Channel channel) async {
    String tag = AddTrailerPage.TAG;
    Widget page = AddTrailerPage(channel);

    final route = CupertinoPageRoute<bool>(
      maintainState: true,
      settings: RouteSettings(name: tag),
      builder: (context) => page,
    );
    Navigator.of(context).push(route);
  }

  static void showTrailerDetails(BuildContext context, Trailer trailer) async {
    String tag = TrailerDetailPage.TAG;
    Widget page = TrailerDetailPage(trailer);

    final route = CupertinoPageRoute<bool>(
      maintainState: true,
      settings: RouteSettings(name: tag),
      builder: (context) => page,
    );
    Navigator.of(context).push(route);
  }


//  static void launchUrl(String url) async {
//    if (url != null && url.isNotEmpty) {
//      url = Uri.encodeFull(url);
//      Logger.log(TAG, message: "Trying to launch: $url");
//      if (await canLaunch(url).catchError((error) =>
//          Logger.log(TAG, message: "Error within url_launcher: $error"))) {
//        await launch(url);
//      } else {
//        Logger.log(TAG, message: "Couldn't launch url");
//      }
//    } else {
//      Logger.log(TAG, message: "Couldn't launch url, it's null or empty");
//    }
//  }

  static void showSnackBar(
      State state, GlobalKey<ScaffoldState> key, String message) {
    if ((state?.mounted ?? false) &&
        key != null &&
        message != null &&
        message.isNotEmpty)
      key.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
  }

  static bool isValidUrl(String url) {
    return RegExp(r"^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+$").hasMatch(url);
  }
}
