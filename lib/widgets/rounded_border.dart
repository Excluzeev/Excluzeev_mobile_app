import 'package:flutter/material.dart';

class RoundedBorder extends StatelessWidget {
  final Widget child;
  final double radius;

  RoundedBorder({
    Key key,
    @required this.child,
    this.radius = 32.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(this.radius)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: this.child,
      ),
    );
  }
}
