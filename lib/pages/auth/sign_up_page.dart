import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    _updateLoading(true);
    final snapshot = await _authManager.connectWithEmailAndPassword(
      true,
      translation,
      email: _emailTextController.text,
      password: _passwordTextController.text,
    );
    if (snapshot.hasError) {
      String message = snapshot.error is AuthManagerError
          ? "Error"
          : "error";
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
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
            settings: RouteSettings(name: FeedPage.TAG),
            builder: (context) => FeedPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Palette.overlayStyle);
    if (translation == null) translation = Translation.of(context);

    if (bloc == null)
      bloc = SignUpBloc(translation);
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
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Image.asset("res/icons/logo/logo_side_name.png"),
              ),
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
                    StreamBuilder(
                      stream: bloc.firstName,
                      builder: (context, snapshot) => CustomTextField(
                        enabled: !_loading,
                        controller: _firstNameController,
                        errorText: snapshot.error,
                        label: translation.firstNameLabel,
                        onChanged: bloc.updateFirstName,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(32)
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    StreamBuilder(
                      stream: bloc.lastName,
                      builder: (context, snapshot) => CustomTextField(
                        enabled: !_loading,
                        controller: _lastNameController,
                        errorText: snapshot.error,
                        label: translation.lastNameLabel,
                        onChanged: bloc.updateLastName,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(32)
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    StreamBuilder(
                      stream: bloc.email,
                      builder: (context, snapshot) => CustomTextField(
                        enabled: !_loading,
                        controller: _emailTextController,
                        errorText: snapshot.error,
                        label: translation.emailHint,
                        onChanged: bloc.updateEmail,
                      ),
                    ),
                    StreamBuilder(
                      stream: bloc.password,
                      builder: (context, snapshot) => CustomTextField(
                        enabled: !_loading,
                        controller: _passwordTextController,
                        obscureText: true,
                        errorText: snapshot.error,
                        label: translation.passwordHint,
                        onChanged: bloc.updatePassword,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: StreamBuilder(
                        stream: bloc.submitValid,
                        builder: (context, snapshot) => RoundedButton(
                          enabled: snapshot.hasData,
                          text: translation.signUp.toUpperCase(),
                          onPressed: () => snapshot.hasData ?  _emailSignUpConnect() : _showSnackBar(translation.errorFields),
                        ),
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
