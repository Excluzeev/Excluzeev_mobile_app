import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/user_manager.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/widgets/full_app_logo.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';

class ContentCreatorEmailPage extends StatefulWidget {
  static String TAG = "CONTENT_CREATOR_EMAIL_PAGE";

  @override
  _ContentCreatorEmailPageState createState() => _ContentCreatorEmailPageState();
}

class _ContentCreatorEmailPageState extends State<ContentCreatorEmailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();

  final UserManager _userMangaer = UserManager.instance;

  Translation translation;
  String error = "";


  bool isLoading = false;

  _updateLoading(val) {
    setState(() {
      isLoading = val;
    });
  }

  _showSnackBar(String message) {
    _updateLoading(false);
    if (mounted && message != null && message.isNotEmpty)
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
  }

  _checkUpdateUser() async {
    String email = _emailController.text;
    bool canProceed = false;

    String validationRule =
        r"\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b";
    if (RegExp(validationRule).hasMatch(email)) {
      canProceed = true;
    } else if (email.isEmpty) {
      setState(() {
        error = translation.errorEmptyField;
      });
    } else {
      setState(() {
        error = translation.errorEmailFormat;
      });
    }

    if(canProceed) {
      _updateLoading(true);
      var snapshot = await _userMangaer.setUserPayPalEmail(email);
      if(snapshot.error != null) {
        _showSnackBar("Paypal Email Update failed.");
      } else {
        Future.delayed(
          Duration(seconds: 1),
            () {
              WidgetUtils.proceedToAuth(context, replaceAll: true);
            }
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    if(translation == null) translation = Translation.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: WhiteAppBar(),
      body: isLoading ?
      Center(
        child: CircularProgressIndicator(),
      )
      :
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              FullAppLogo(),
              SizedBox(height: 8.0,),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: translation.paypalEmail,
                  errorText: error,
                ),
              ),
              SizedBox(height: 8.0,),
              RoundedButton(
                onPressed: _checkUpdateUser,
                text: translation.contentCreatorAuthSave,
              )
            ],
          ),
        ),
      ),
    );
  }
}
