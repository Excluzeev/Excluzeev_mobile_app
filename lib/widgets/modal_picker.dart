import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:image_picker/image_picker.dart';

class ModalImagePicker extends StatelessWidget {
  static const String TAG = "MODAL_IMAGE_PICKER";

  final Function(File) onSelected;
  final bool pop;

  const ModalImagePicker({Key key, @required this.onSelected, this.pop: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translation = Translation.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          onTap: () {
            if (pop) Navigator.of(context).pop();

            ImagePicker.pickImage(source: ImageSource.camera)
                .catchError((exception, stacktrace) {
              Logger.log(TAG,
                  message: "Couldn't get file from gallery, error: $exception");
              return null;
            }).then(onSelected);
          },
          leading: Icon(Icons.add_a_photo),
          title: Text(translation.cameraLabel),
        ),
        ListTile(
          onTap: () {
            if (pop) Navigator.of(context).pop();

            ImagePicker.pickImage(source: ImageSource.gallery)
                .catchError((exception, stacktrace) {
              Logger.log(TAG,
                  message: "Couldn't get file from gallery, error: $exception");
              return null;
            }).then(onSelected);
          },
          leading: Icon(Icons.image),
          title: Text(translation.galleryLabel),
        ),
      ],
    );
  }
}
