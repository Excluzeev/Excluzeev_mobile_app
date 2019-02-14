import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/pages/auth/blocs/forgot_password_bloc.dart';
import 'package:trenstop/pages/bloc_provider.dart';
import 'package:trenstop/widgets/full_app_logo.dart';
import 'package:trenstop/widgets/rounded_border.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const String TAG = "FORGOT_PASSWORD";

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final AuthManager _authManager = AuthManager.instance;

  Translation translation;

  ForgotPasswordBloc bloc;
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
    if(mounted && message != null && message.isNotEmpty) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(message),
          )
      );
    }
  }

  void _resetPassword() async {
    _updateLoading(true);
    final snapshot = await _authManager.resetPassword(_emailController.text);
    if(snapshot.data) {
      _showSnackBar(translation.resetEmailSent);
//      Navigator.of(context).pop();
    } else {
      _showSnackBar(translation.resetEmailSent);
    }
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Palette.overlayStyle);
    if(translation == null) translation = Translation.of(context);

    if(bloc == null) {
      bloc = ForgotPasswordBloc(translation);
    }

    return BlocProvider<ForgotPasswordBloc> (
      bloc: bloc,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: WhiteAppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FullAppLogo(),
              SizedBox(height: 16.0,),
              _loading ?
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              )
              :
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    RoundedBorder(
                      child: StreamBuilder(
                        stream: bloc.email,
                        builder: (context, snapshot) => TextField(
                          controller: _emailController,
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
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: StreamBuilder(
                        stream: bloc.email,
                        builder: (context, snapshot) => RoundedButton(
                          enabled: !snapshot.hasError,
                          text: translation.resetPassword,
                          onPressed: () => !snapshot.hasError ? _resetPassword() : _showSnackBar(translation.invalidEmail),
                        ),
                      ),
                    )
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
