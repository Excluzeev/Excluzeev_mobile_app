import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:trenstop/misc/date_utils.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/models/comments.dart';
import 'package:trenstop/models/trailer.dart';

class VideoCommentsWidget extends StatelessWidget {
  const VideoCommentsWidget({
    Key key,
    @required this.comment,
  }) : super(key: key);

  final Comments comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 8.0,
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          InkWell(
//                  onTap: () => _showProfile(context),
            child: CircleAvatar(
              backgroundImage: comment.userPhoto.isNotEmpty
                  ? AdvancedNetworkImage(
                      comment.userPhoto,
                      useDiskCache: true,
                    )
                  : AssetImage(
                      "res/icons/avatar.png",
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  comment.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                        color: Palette.primary,
                      ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  comment.comment,
                  maxLines: null,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  DateUtils.getLocalizedTimeAgo(comment.createdDate.toDate(),
                      locale: Localizations.localeOf(context)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
