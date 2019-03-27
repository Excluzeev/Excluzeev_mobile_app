import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/models/video.dart';
import 'package:trenstop/pages/auth/sign_in_page.dart';
import 'package:trenstop/pages/payment/payment.dart';
import 'package:trenstop/pages/subscriptions/my_subscriptions.dart';
import 'package:trenstop/pages/trailer/add_trailer.dart';
import 'package:trenstop/pages/channel/channel_details.dart';
import 'package:trenstop/pages/channel/my_channels.dart';
import 'package:trenstop/pages/channel/new_channel.dart';
import 'package:trenstop/pages/creatorauth/content_creator_email_page.dart';
import 'package:trenstop/pages/creatorauth/content_creator_signup_page.dart';
import 'package:trenstop/pages/home/feed.dart';
import 'package:trenstop/pages/trailer/trailer_detail.dart';
import 'package:trenstop/pages/videos/add_video.dart';
import 'package:trenstop/pages/videos/video_detail.dart';

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

  static void proceedToHome(
      BuildContext context, {
        bool replaceAll = false,
        String invite,
      }) async {
    String tag;
    Widget page;

    tag = FeedPage.TAG;
    page = FeedPage();

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

  static void goToAuth(
      BuildContext context, {
        bool replaceAll = false,
      }) async {
    String tag;
    Widget page;


    tag = SignInPage.TAG;
    page = SignInPage();
    print("auth");

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
    bool isDone = await Navigator.of(context).push(route) ?? false;

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
      settings: RouteSettings(name: tag),
      builder: (context) => page,
    );
    Navigator.of(context).push(route);
  }

  static void showChannels(BuildContext context, User user) async {
    String tag = MyChannelsPage.TAG;
    Widget page = MyChannelsPage(user);

    final route = CupertinoPageRoute<bool>(
      maintainState: true,
      settings: RouteSettings(name: tag),
      builder: (context) => page,
    );
    Navigator.of(context).push(route);
  }

  static void showSubscriptions(BuildContext context, User user) async {
    String tag = MySubscriptionsPage.TAG;
    Widget page = MySubscriptionsPage(user);

    final route = CupertinoPageRoute<bool>(
      maintainState: true,
      settings: RouteSettings(name: tag),
      builder: (context) => page,
    );
    Navigator.of(context).push(route);
  }

  static void showChannelDetails(BuildContext context, User user, Channel channel) async {
    String tag = ChannelDetailPage.TAG;
    Widget page = ChannelDetailPage(channel: channel,user: user);

    final route = CupertinoPageRoute<bool>(
      maintainState: true,
      settings: RouteSettings(name: tag),
      builder: (context) => page,
    );
    Navigator.of(context).push(route);
  }

  static void showAddVideo(BuildContext context, User user, Channel channel, {bool hideVideoUpload = false}) async {
    String tag = AddVideoPage.TAG;
    Widget page = AddVideoPage(channel: channel,user: user, hideVideoUpload: hideVideoUpload,);

    final route = CupertinoPageRoute<bool>(
      maintainState: true,
      settings: RouteSettings(name: tag),
      builder: (context) => page,
    );
    Navigator.of(context).push(route);
  }

  static void showVideoDetails(BuildContext context, Video video, User user) async {
    String tag = VideoDetailPage.TAG;
    Widget page = VideoDetailPage(video, user);

    final route = CupertinoPageRoute<bool>(
      settings: RouteSettings(name: tag),
      builder: (context) => page,
    );
    Navigator.of(context).push(route);
  }

  static void showPaymentScreen(BuildContext context, Trailer trailer, User user, bool isDonate, {int price}) async {
    String tag = PaymentPage.TAG;
    Widget page = PaymentPage(trailer, user, isDonate, price: price);

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
