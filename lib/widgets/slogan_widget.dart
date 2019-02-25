import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/misc/palette.dart';

class SloganWidget extends StatelessWidget {
  static const String TAG = "SLOGAN_WIDGET";

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: TAG,
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            Translation.of(context).slogan,
            style: Theme.of(context).textTheme.subhead.copyWith(
                  color: Palette.darkBlue,
                  fontWeight: FontWeight.bold,
              fontSize: 14.0
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
