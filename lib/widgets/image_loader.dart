import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/src/flutter_advanced_networkimage.dart';
import 'dart:io';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:trenstop/misc/image_utils.dart';

class ImageLoaderWidget extends StatefulWidget {
  final String url;

  const ImageLoaderWidget({
    Key key,
    this.url,
  }) : super(key: key);

  @override
  ImageLoaderWidgetState createState() => ImageLoaderWidgetState();
}

class ImageLoaderWidgetState extends State<ImageLoaderWidget> {
  static const String TAG = "IMAGE_LOADER";

  bool failed = false;

  @override
  Widget build(BuildContext context) {
    // print(widget.url);
    return Container(
      color: Colors.grey[350],
      child: failed
          ? Image.asset('res/icons/thumbnail_placeholder.png')
          : Image(
              image: AdvancedNetworkImage(widget.url,
                  useDiskCache: true,
                  retryLimit: 1,
                  retryDuration: Duration(milliseconds: 2000),
                  loadFailedCallback: () {
                if (mounted) {
                  setState(() {
                    failed = true;
                  });
                }
              }),
              fit: BoxFit.cover,
            ),
    );
  }
}
