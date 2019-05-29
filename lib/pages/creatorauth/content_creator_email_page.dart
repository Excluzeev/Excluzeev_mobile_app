import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/managers/user_manager.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/widgets/full_app_logo.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';
import 'package:http/http.dart' as http;

class ContentCreatorEmailPage extends StatefulWidget {
  static String TAG = "CONTENT_CREATOR_EMAIL_PAGE";

  @override
  _ContentCreatorEmailPageState createState() =>
      _ContentCreatorEmailPageState();
}

class _ContentCreatorEmailPageState extends State<ContentCreatorEmailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserManager _userMangaer = UserManager.instance;
  final AuthManager _authManager = AuthManager.instance;

  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  Translation translation;
  String error = "";
  String fullUrl = "";

  _preparing() {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Connecting..."),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  _showSnackBar(String message) {
    if (mounted && message != null && message.isNotEmpty)
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
  }

  _startConnectingProcess() {
    var connectUrl =
        "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_F90HDO14vD97St5ir3scNmlL8b2DXiD1&scope=read_write";
    flutterWebViewPlugin.launch(connectUrl,
        scrollBar: true,
        withZoom: true,
        allowFileURLs: true,
        disableBack: true,
        rect: Rect.fromLTWH(0.0, 24.0, MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height));
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebViewPlugin.dispose();
  }

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      Logger.log(ContentCreatorEmailPage.TAG, message: url);
      print(url.contains("/connect?scope="));
      if (url.contains("/connect?scope=")) {
        fullUrl = url;
        flutterWebViewPlugin.close();
        _checkUpdateUser();
      } else if (url.contains("/connect?error=")) {
        flutterWebViewPlugin.close();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(translation.connectingFailedLabel),
                content: Text(translation.connectingFailedDialogContent),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(translation.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
        flutterWebViewPlugin.close();
      }
    });
    Future.delayed(Duration(seconds: 1), () {
      _startConnectingProcess();
    });
  }

  _checkUpdateUser() async {
    Uri uri = Uri.parse(fullUrl);

    String code = uri.queryParameters["code"];

    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    var body = {"uid": firebaseUser.uid, "code": code};

    var client = new http.Client();
    var response =
        await client.post("https://excluzeev.com/connectS", body: body);

    Logger.log(ContentCreatorEmailPage.TAG, message: response.body);
    var res = json.decode(response.body);

    if (res['error']) {
      _showSnackBar(res['message']);
      WidgetUtils.proceedToAuth(context, replaceAll: true);
    } else {
      _showSnackBar(res['message']);
      User user =
          await _authManager.getUser(firebaseUser: firebaseUser, force: true);

      WidgetUtils.proceedToAuth(context, replaceAll: true);
    }
    client.close();
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: WhiteAppBar(),
      body: _preparing(),
    );
  }
}
