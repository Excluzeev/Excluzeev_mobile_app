import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/widgets/white_app_bar.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PaymentPage extends StatefulWidget {
  static const String TAG = "PAYMENTS_PAGE";

  final Trailer trailer;
  final User user;
  final bool isDonate;
  final int price;

  PaymentPage(this.trailer, this.user, this.isDonate, {this.price});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthManager _authManager = AuthManager.instance;
  Translation translation;

  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  bool _isPreparing = true;

  bool _isFinishing = false;

  _showSnackBar(String message) {
    if (mounted && message != null && message.isNotEmpty)
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
  }

  _preparing() {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(_isFinishing
                ? translation.paymentVerifying
                : translation.paymentPreparing),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  _startPayment() {
    return Container();
  }

  _body() {
    return _isPreparing ? _preparing() : _startPayment();
  }

  _preparePayment() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    var body = {
      "channelId": widget.trailer.channelId,
      "userId": firebaseUser.uid
    };

    if (widget.isDonate) {
      body["donate"] = widget.price.toString();
    }

    Logger.log(PaymentPage.TAG, message: "$body");

    var client = new http.Client();
    var response = await client.post(
        "https://us-central1-trenstop-2033f.cloudfunctions.net/generatePayKey",
        body: body);

    Logger.log(PaymentPage.TAG, message: response.body);
    var res = json.decode(response.body);

    if (res['responseEnvelope']['ack'] != "Success") {
      _showSnackBar(translation.paymentFailed);
    } else {
      var payKey = res['payKey'];
      startPaymentProcess(payKey);
    }
    client.close();
  }

  startPaymentProcess(String payKey) {
//    var payUrl = "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey=$payKey";
    var payUrl =
        "https://www.sandbox.paypal.com/webapps/adaptivepayment/flow/pay?paykey=$payKey&expType=mini";
    flutterWebViewPlugin.launch(
      payUrl,
      scrollBar: true,
      withZoom: true,
      disableBack: true,
    );
  }

  _markSubscribed() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    var body = {
      "channelId": widget.trailer.channelId,
      "userId": firebaseUser.uid,
      "channelName": widget.trailer.channelName
    };

    var client = new http.Client();
    var response = await client.post(
        "https://us-central1-trenstop-2033f.cloudfunctions.net/subscribeToChannel",
        body: body);

    Logger.log(PaymentPage.TAG, message: response.body);
    var res = json.decode(response.body);

    if (res['error']) {
      _showSnackBar(res['message']);
    } else {
      User user =
          await _authManager.getUser(firebaseUser: firebaseUser, force: true);

      if (user.subscribedChannels.contains(widget.trailer.channelId)) {
        Navigator.of(context).pop();
      }
    }
    client.close();
  }

  _recordPayment() async {
    if (mounted) {
      setState(() {
        _isFinishing = true;
        _isPreparing = true;
      });
    }
//    _markSubscribed();
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    User user =
        await _authManager.getUser(firebaseUser: firebaseUser, force: true);

    if (user.subscribedChannels.contains(widget.trailer.channelId)) {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      Logger.log(PaymentPage.TAG, message: url);
      print(url.contains("/pagePaymentSuccess"));
      if (url.contains("/pagePaymentSuccess")) {
        flutterWebViewPlugin.close();
        _recordPayment();
      } else if (url.contains("/pagePaymentCanceled")) {
        flutterWebViewPlugin.close();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(translation.paymentFailedLabel),
                content: Text(translation.paymentFailedDialogContent),
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

    _preparePayment();
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: WhiteAppBar(),
      body: Container(
        child: _body(),
      ),
    );
  }
}
