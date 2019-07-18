import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/auth/blocs/signup_bloc.dart';
import 'package:trenstop/pages/auth/widgets/email_password_form.dart';
import 'package:trenstop/pages/bloc_provider.dart';
import 'package:trenstop/pages/home/feed.dart';
import 'package:trenstop/widgets/custom_text_field.dart';
import 'package:trenstop/widgets/full_app_logo.dart';
import 'package:trenstop/widgets/rounded_border.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';

class SignUpPage extends StatefulWidget {
  static const String TAG = "SIGN_UP";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final AuthManager _authManager = AuthManager.instance;

  Translation translation;
  SignUpBloc bloc;
  bool _loading = false;

  bool agreeTerms = false;

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: new CustomTabsAnimation.slideIn(),
          extraCustomTabs: <String>[
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _updateLoading(bool value) {
    if (mounted) {
      setState(() {
        _loading = value;
      });
    }
  }

  _showSnackBar(String message) {
    _updateLoading(false);
    if (mounted && message != null && message.isNotEmpty)
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
  }

  void _emailSignUpConnect() async {
    if (!agreeTerms) {
      _showSnackBar("Please accept terms.");
      return;
    }
    _updateLoading(true);
    final snapshot = await _authManager.connectWithEmailAndPassword(
      true,
      translation,
      email: _emailTextController.text,
      password: _passwordTextController.text,
    );
    if (snapshot.hasError) {
      String message = snapshot.error is AuthManagerError ? "Error" : "error";
      _showSnackBar(snapshot.error.toString());
    } else {
      _updateUser();
    }
  }

  _updateUser() async {
    FirebaseUser firebaseUser = await _authManager.currentUser;
    UserBuilder userBuilder = UserBuilder()
      ..firstName = _firstNameController.text
      ..lastName = _lastNameController.text
      ..email = _emailTextController.text
      ..uid = firebaseUser.uid
      ..isContentCreator = false;

    User user = userBuilder.build();

    final snapshot = await _authManager.updateUser(user);
    if (snapshot.hasError) {
      _showSnackBar(translation.errorUpdateUser);
    } else {
      Future.delayed(
          Duration(
            seconds: 1,
          ), () {
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
              settings: RouteSettings(name: FeedPage.TAG),
              builder: (context) => FeedPage()),
          (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Palette.overlayStyle);
    if (translation == null) translation = Translation.of(context);

    if (bloc == null) bloc = SignUpBloc(translation);
    final style = Theme.of(context).textTheme.subhead.copyWith(
          color: Palette.primary,
          fontSize: 12.0,
        );

    return BlocProvider<SignUpBloc>(
      bloc: bloc,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: WhiteAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedAppLogo(
                showTitle: false,
                size: 100.0,
              ),
//              Padding(
//                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                child: Image.asset("res/icons/logo/logo_side_name.png"),
//              ),
              SizedBox(height: 24.0),
              _loading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 24.0),
                          RoundedBorder(
                            child: StreamBuilder(
                              stream: bloc.firstName,
                              builder: (context, snapshot) => TextField(
                                controller: _firstNameController,
                                onChanged: bloc.updateFirstName,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.zero,
                                  filled: true,
                                  border: InputBorder.none,
                                  errorText: snapshot.error,
                                  hintText: translation.firstNameLabel,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          RoundedBorder(
                            child: StreamBuilder(
                              stream: bloc.lastName,
                              builder: (context, snapshot) => TextField(
                                controller: _lastNameController,
                                onChanged: bloc.updateLastName,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.zero,
                                  filled: true,
                                  border: InputBorder.none,
                                  errorText: snapshot.error,
                                  hintText: translation.lastNameLabel,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          RoundedBorder(
                            child: StreamBuilder(
                              stream: bloc.email,
                              builder: (context, snapshot) => TextField(
                                controller: _emailTextController,
                                onChanged: bloc.updateEmail,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.zero,
                                  filled: true,
                                  border: InputBorder.none,
                                  errorText: snapshot.error,
                                  hintText: translation.emailHint,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          RoundedBorder(
                            child: StreamBuilder(
                              stream: bloc.password,
                              builder: (context, snapshot) => TextField(
                                controller: _passwordTextController,
                                obscureText: true,
                                onChanged: bloc.updatePassword,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.zero,
                                  filled: true,
                                  border: InputBorder.none,
                                  errorText: snapshot.error,
                                  hintText: translation.passwordHint,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),

                          CheckboxListTile(
                            value: agreeTerms,
                            onChanged: (value) {
                              setState(() {
                                agreeTerms = value;
                              });
                            },
                            title: Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: "Agree to "),
                                  TextSpan(
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    text: "Terms",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchURL(context,
                                            "https://excluzeev.com/license-agreement");
                                      },
                                  ),
                                  TextSpan(text: ", "),
                                  TextSpan(
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    text: "Privacy Policy",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchURL(context,
                                            "https://excluzeev.com/privacy-policy");
                                      },
                                  ),
                                  TextSpan(text: ", "),
                                  TextSpan(
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    text: "Call to Action terms",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchURL(context,
                                            "https://excluzeev.com/call-to-action-terms");
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 16.0),
                          StreamBuilder(
                            stream: bloc.submitValid,
                            builder: (context, snapshot) => RoundedButton(
                              enabled: snapshot.hasData,
                              text: translation.signUp.toUpperCase(),
                              onPressed: () => snapshot.hasData
                                  ? _emailSignUpConnect()
                                  : _showSnackBar(translation.errorFields),
                            ),
                          ),
                          SizedBox(height: 24.0),
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: OrWidget(),
//                      ),
//                      RoundedButton(
//                        text: translation.signUp.toUpperCase(),
//                        onPressed: () => _goSignUp(),
//                      ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
