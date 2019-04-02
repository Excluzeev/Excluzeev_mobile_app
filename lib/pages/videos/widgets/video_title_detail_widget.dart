import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trenstop/misc/date_utils.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/models/video.dart';

class VideoTitleDetailWidget extends StatelessWidget {
  const VideoTitleDetailWidget({
    Key key,
    @required this.video,
  }) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat("d MMM y • hh:mm aaa");
    var daysAgo =
        DateTime.now().difference(video.createdDate.toDate()).inDays < 8
            ? DateUtils.getLocalizedTimeAgo(video.createdDate.toDate(),
                locale: Localizations.localeOf(context))
            : formatter.format(video.createdDate.toDate());
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: 16.0,
          right: 16.0,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                video.title,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.title.copyWith(
                      fontSize: 18.0,
                      color: Palette.primary,
                    ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                "${video.views} views • $daysAgo",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
