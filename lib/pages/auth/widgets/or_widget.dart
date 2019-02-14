import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/misc/palette.dart';

class OrWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "OR_WIDGET",
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Translation.of(context).or.toUpperCase(),
            style: TextStyle(
              color: Palette.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
