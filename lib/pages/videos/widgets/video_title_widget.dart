import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:intl/intl.dart';
import 'package:trenstop/misc/date_utils.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/models/video.dart';

class VideoTitleWidget extends StatelessWidget {
  const VideoTitleWidget({
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

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
//                  onTap: () => _showProfile(context),
                child: CircleAvatar(
                  backgroundImage: AdvancedNetworkImage(
                    video.channelImage,
                    useDiskCache: true,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      video.title,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: Palette.primary,
                          ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text.rich(
                      TextSpan(
                        text: "${video.channelName}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: " • ${video.views} views • $daysAgo",
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.0,
                                ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
