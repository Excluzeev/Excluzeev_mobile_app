import 'package:flutter/material.dart';

class InformationWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String subtitle;
  final TextStyle subtitleStyle;

  const InformationWidget({
    Key key,
    this.icon,
    this.color = Colors.black,
    this.subtitle,
    this.subtitleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(this.icon, color: this.color, size: 36.0),
            SizedBox(height: 8.0),
            Text(
              this.subtitle,
              textAlign: TextAlign.center,
              style: this.subtitleStyle ??
                  Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: this.color ?? Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
