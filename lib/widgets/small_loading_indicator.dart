import 'package:flutter/material.dart';

class SmallLoadingIndicator extends StatelessWidget {
  final Color color;
  final double value;
  final double radius;

  const SmallLoadingIndicator(
      {Key key, this.radius = 10.0, this.color, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.fromRadius(this.radius),
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        value: this.value,
        valueColor: AlwaysStoppedAnimation<Color>(this.color),
      ),
    );
  }
}
