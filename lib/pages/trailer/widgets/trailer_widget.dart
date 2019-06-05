import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:trenstop/misc/date_utils.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/trailer/widgets/trailer_title_widget.dart';
import 'package:trenstop/widgets/image_display.dart';

class TrailerWidget extends StatelessWidget {
  static const String TAG = "TRAILER_WIDGET";

  final Trailer trailer;
  final Function(Trailer) onTap;
  final Function(Trailer) onShare;
  final bool zoomable;
  final bool showShare;

  const TrailerWidget({
    Key key,
    this.trailer,
    this.onTap,
    this.onShare,
    this.showShare = false,
    this.zoomable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap?.call(trailer) : null,
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
                  child: ImageDisplay(
                    urls: [trailer.image],
                    zoomable: this.zoomable,
                    key: Key(trailer.trailerId),
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
                                  onShare(trailer);
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
          TrailerTitleWidget(trailer: trailer)
        ],
      ),
    );
  }
}
