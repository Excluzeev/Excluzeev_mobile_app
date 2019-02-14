import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/pages/auth/blocs/auth_bloc.dart';
import 'package:trenstop/pages/bloc_provider.dart';
import 'package:trenstop/widgets/rounded_border.dart';

class EmailPasswordForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordVerifyController;

  const EmailPasswordForm({
    Key key,
    this.emailController,
    this.passwordController,
    this.passwordVerifyController,
  }) : super(key: key);

  @override
  _EmailPasswordFormState createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  Translation translation;

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    final bloc = BlocProvider.of<AuthBloc>(context);
    return Column(
      children: <Widget>[
        RoundedBorder(
          child: StreamBuilder(
            stream: bloc.email,
            builder: (context, snapshot) => TextField(
                  controller: widget.emailController,
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
                  controller: widget.passwordController,
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
        Offstage(
          offstage: widget.passwordVerifyController == null,
          child: RoundedBorder(
            child: StreamBuilder(
              stream: bloc.passwordVerify,
              builder: (context, snapshot) => TextField(
                    controller: widget.passwordVerifyController,
                    obscureText: true,
                    onChanged: bloc.updatePasswordVerify,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      border: InputBorder.none,
                      errorText: snapshot.error,
                      hintText: translation.passwordVerifyHint,
                    ),
                  ),
            ),
          ),
        )
      ],
    );
  }
}
