import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/user_manager.dart';
import 'package:trenstop/widgets/full_app_logo.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';

class ContentCreatorSignUpPage extends StatefulWidget {
  static String TAG = "CONTENT_CREATOR_SIGNUP_PAGE";

  @override
  _ContentCreatorSignUpPageState createState() => _ContentCreatorSignUpPageState();
}

class _ContentCreatorSignUpPageState extends State<ContentCreatorSignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserManager _userMangaer = UserManager.instance;
  Translation translation;

  bool terms = true;
  bool policy = true;
  bool upload = true;

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

  _checkUpdateUser() {

    if(!terms) {
      _showSnackBar("Please accept Terms");
      return;
    }

    if(!policy) {
      _showSnackBar("Please accept Policy");
      return;
    }

    if(!upload) {
      _showSnackBar("Please accept Upload Policy");
      return;
    }

    if(terms && policy && upload) {
      _updateLoading(true);
      Navigator.of(context).pop(true);
    }
  }


  @override
  Widget build(BuildContext context) {

    if(translation == null) translation = Translation.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: WhiteAppBar(),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            FullAppLogo(),
            SizedBox(height: 8.0,),
            CheckboxListTile(
              value: terms,
              onChanged: (value) {
                setState(() {
                  terms = value;
                });
              },
              title: Text(
                "Accept Terms"
              ),
            ),
            CheckboxListTile(
              value: policy,
              onChanged: (value) {
                setState(() {
                  policy = value;
                });
              },
              title: Text(
                  "Accept Policy"
              ),
            ),
            CheckboxListTile(
              value: upload,
              onChanged: (value) {
                setState(() {
                  upload = value;
                });
              },
              title: Text(
                  "Upload Policy"
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
    );
  }
}
