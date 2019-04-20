import 'package:flutter/material.dart';
import 'package:trenstop/widgets/slogan_widget.dart';

class FullAppLogo extends StatelessWidget {
  static const String TAG = "FULL_LOGO";

  final bool showTitle;

  const FullAppLogo({Key key, this.showTitle = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "res/icons/logo/logo_transparent.png",
              ),
              SizedBox(height: 16.0),
              SloganWidget(),
              SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SizedAppLogo extends StatelessWidget {
  static const String TAG = "SIZED_FULL_LOGO";

  final bool showTitle;
  double size = 100.0;

  SizedAppLogo({Key key, this.showTitle = true, this.size}) : super(key: key);

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
              SizedBox(
                  height: size,
                  child: Image.asset(
                    "res/icons/logo/logo_bottom_name.png",
                  )),
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
