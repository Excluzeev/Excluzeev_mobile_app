import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/src/flutter_advanced_networkimage.dart';
import 'package:trenstop/misc/date_utils.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/models/video.dart';
import 'package:trenstop/pages/trailer/widgets/trailer_title_widget.dart';
import 'package:trenstop/pages/videos/widgets/video_title_widget.dart';
import 'package:trenstop/widgets/image_display.dart';

class VideoWidget extends StatelessWidget {
  static const String TAG = "VIDEO_WIDGET";

  final Video video;
  final Function(Video) onTap;
  final Function(Video) onShare;
  final bool zoomable;
  final bool showShare;

  const VideoWidget({
    Key key,
    this.video,
    this.onTap,
    this.onShare,
    this.showShare = false,
    this.zoomable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap?.call(video) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: <Widget>[
                SizedBox.expand(
                  child: Container(
                    color: Colors.blueGrey,
                    child: ImageDisplay(
                      urls: [video.image],
                      zoomable: this.zoomable,
                    ),
                  ),
                ),
                showShare
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircleAvatar(
                            radius: 26.0,
                            backgroundColor: Colors.black38,
                            child: FittedBox(
                              child: InkWell(
                                onTap: () {
                                  onShare(video);
                                },
                                child: Icon(
                                  Platform.isAndroid
                                      ? Icons.share
                                      : CupertinoIcons.share,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          VideoTitleWidget(video: video)
        ],
      ),
    );
  }
}
