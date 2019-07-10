import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ReadMoreTextWidget extends StatefulWidget {
  final String text;

  ReadMoreTextWidget({@required this.text});

  @override
  _ReadMoreTextWidgetState createState() => _ReadMoreTextWidgetState();
}

class _ReadMoreTextWidgetState extends State<ReadMoreTextWidget> {
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 100) {
      firstHalf = widget.text.substring(0, 100);
      secondHalf = widget.text.substring(100, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? Text(firstHalf)
          : Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                  child: Text.rich(
                    TextSpan(
                      text: firstHalf,
                      children: <TextSpan>[
                        flag
                            ? TextSpan(
                                text: " ...more",
                                style: Theme.of(context).textTheme.caption,
                              )
                            : TextSpan(
                                text: secondHalf,
                              )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
