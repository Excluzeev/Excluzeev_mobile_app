import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:trenstop/misc/date_utils.dart';
import 'package:trenstop/models/video.dart';

class VideoTitleWidget extends StatelessWidget {
  const VideoTitleWidget({
    Key key,
    @required this.video,
  }) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    var daysAgo = DateUtils.getLocalizedTimeAgo(video.createdDate.toDate(),
        locale: Localizations.localeOf(context));

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
                  backgroundImage: AdvancedNetworkImage(video.channelImage,
                      useDiskCache: true),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      "${video.channelName} • ${video.views} views • $daysAgo",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                            fontWeight: FontWeight.normal,
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
