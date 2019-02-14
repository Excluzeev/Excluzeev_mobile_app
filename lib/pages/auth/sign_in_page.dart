import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/auth/blocs/auth_bloc.dart';
import 'package:trenstop/pages/auth/forgot_password_page.dart';
import 'package:trenstop/pages/auth/sign_up_page.dart';
import 'package:trenstop/pages/auth/widgets/email_password_form.dart';
import 'package:trenstop/pages/auth/widgets/or_widget.dart';
import 'package:trenstop/pages/bloc_provider.dart';
import 'package:trenstop/pages/home/feed.dart';
import 'package:trenstop/widgets/full_app_logo.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';

class SignInPage extends StatefulWidget {
  static const String TAG = "SIGN_IN";

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final AuthManager _authManager = AuthManager.instance;

  bool _loading = false;

  Translation translation;
  AuthBloc bloc;

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

  void proceed(User user) async {
    String tag;
    Widget page;

    tag = FeedPage.TAG;
    page = FeedPage();

    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(
        settings: RouteSettings(name: tag),
        builder: (context) => page,
      ),
          (route) => false,
    );
  }

  void _goSignUp() async {
    String tag = SignUpPage.TAG;
    Widget page = SignUpPage();

    Navigator.of(context).push(
      CupertinoPageRoute(
        settings: RouteSettings(name: tag),
        builder: (context) => page,
      ),
    );
  }

  void _goResetPassword() async {
    String tag = ForgotPasswordPage.TAG;
    Widget page = ForgotPasswordPage();

    Navigator.of(context).push(
      CupertinoPageRoute(
        settings: RouteSettings(name: tag),
        builder: (context) => page,
      ),
    );
  }

  void _verifyLogin(User user) async {
    _updateLoading(true);
    final checkUser = await _authManager.checkUser(user.uid);
    if (checkUser.data == null) {
      _showSnackBar(translation.errorSignIn);
    } else {
      proceed(checkUser.data);
    }
  }

  void _emailConnect() async {
    _updateLoading(true);
    final snapshot = await _authManager.connectWithEmailAndPassword(
      false,
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
      _verifyLogin(snapshot.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    if (bloc == null)
      bloc = AuthBloc(validator: AuthBlocValidator(translation));
    final style = Theme.of(context).textTheme.subhead.copyWith(
      color: Palette.primary,
      fontSize: 12.0,
    );

    return BlocProvider<AuthBloc>(
      bloc: bloc,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: WhiteAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FullAppLogo(showTitle: false),
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
                    EmailPasswordForm(
                      emailController: _emailTextController,
                      passwordController: _passwordTextController,
                    ),
                    StreamBuilder(
                      stream: bloc.submitValid,
                      builder: (context, snapshot) => RoundedButton(
                        enabled: snapshot.hasData,
                        text: translation.login.toUpperCase(),
                        onPressed: () => snapshot.hasData ?  _emailConnect() : _showSnackBar(translation.errorFields),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    InkWell(
                      onTap: () => _goResetPassword(),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: translation.forgotLoginDetail,
                          style: style,
                          children: [
                            TextSpan(
                              text: translation.tapHere.toLowerCase(),
                              style: style.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OrWidget(),
                    ),
                    RoundedButton(
                      text: translation.signUp.toUpperCase(),
                      onPressed: () => _goSignUp(),
                    ),
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
