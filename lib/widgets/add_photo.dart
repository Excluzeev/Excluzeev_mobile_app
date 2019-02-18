import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/misc/palette.dart';

class AddWidget extends StatelessWidget {
  final String label;

  const AddWidget({Key key, @required this.label})
      : assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: Colors.grey[300],
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 24.0,
                backgroundColor: Palette.darkBlue,
                child: Icon(
                  Icons.add,
                  size: 32.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                label?.toUpperCase() ??
                    Translation.of(context).addPhoto.toUpperCase(),
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: Palette.darkBlue,
                      fontWeight: FontWeight.bold,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
