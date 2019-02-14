import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'dart:io';
import 'package:rounded_modal/rounded_modal.dart';

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

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AdvancedNetworkImage(widget.url, useDiskCache: true),
      fit: BoxFit.cover,
    );
  }
}
