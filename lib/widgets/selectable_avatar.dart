import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/src/flutter_advanced_networkimage.dart';
//import 'package:trenstop/managers/storage_manager.dart';
import 'package:trenstop/misc/image_utils.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:trenstop/widgets/modal_picker.dart';

class UserAvatar extends StatefulWidget {
  final String photoUrl;
  final File photoFile;

  const UserAvatar({Key key, this.photoUrl, this.photoFile}) : super(key: key);

  @override
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final radiusRatio = 6.0;
    if (widget.photoUrl != null && widget.photoUrl.isNotEmpty)
      return CircleAvatar(
        backgroundColor: Colors.black26,
        backgroundImage:
            AdvancedNetworkImage(widget.photoUrl, useDiskCache: true),
        radius: screenWidth / radiusRatio,
      );
    else if (widget.photoFile != null)
      return CircleAvatar(
        backgroundColor: Colors.black26,
        backgroundImage: Image.file(widget.photoFile).image,
        radius: screenWidth / radiusRatio,
      );
    else
      return CircleAvatar(
        backgroundColor: Palette.disabled,
        child: Icon(
          Icons.account_circle,
          size: screenWidth / radiusRatio,
          color: Colors.white,
        ),
        radius: screenWidth / radiusRatio,
      );
  }
}

class SelectableAvatar extends StatefulWidget {
  static const String TAG = "SELECTABLE_AVATAR";

  final bool enabled;
  final String photoUrl;
  final File photoFile;
  final Function(File) onFileChanged;

  const SelectableAvatar({
    Key key,
    this.photoFile,
    this.photoUrl,
    this.onFileChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  _SelectableAvatarState createState() => _SelectableAvatarState();
}

class _SelectableAvatarState extends State<SelectableAvatar> {
  _showPhotoSelect() async {
    showRoundedModalBottomSheet(
      context: context,
      builder: (context) => ModalImagePicker(
            pop: true,
            onSelected: (file) async {
              if (file != null) {
                final snapshot = await ImageUtils.nativeResize(
                  file,
                  683,
                  centerCrop: false,
                );

                if (snapshot.success) {
                  Logger.log(SelectableAvatar.TAG,
                      message: "Received: ${snapshot.data} from gallery!");
                  widget.onFileChanged?.call(snapshot.data);
                }
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        UserAvatar(
          photoFile: widget.photoFile,
          photoUrl: widget.photoUrl,
        ),
        FloatingActionButton(
          child: Icon(widget.photoFile != null ? Icons.close : Icons.add),
          backgroundColor:
              widget.photoFile != null ? Colors.red : Palette.primary,
          mini: true,
          onPressed: widget.enabled
              ? widget.photoFile != null
                  ? () => widget.onFileChanged?.call(null)
                  : _showPhotoSelect
              : null,
        )
      ],
    );
  }
}
