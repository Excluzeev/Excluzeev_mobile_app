import 'package:flutter/material.dart';
import 'package:trenstop/widgets/slogan_widget.dart';

class FullAppLogo extends StatelessWidget {
  static const String TAG = "FULL_LOGO";

  final bool showTitle;

  const FullAppLogo({Key key, this.showTitle = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: TAG,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("res/icons/logo/logo_transparent.png",),
              SizedBox(height: 8.0),
              SloganWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

