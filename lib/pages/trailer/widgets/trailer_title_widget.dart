import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:trenstop/misc/date_utils.dart';
import 'package:trenstop/models/trailer.dart';

class TrailerTitleWidget extends StatelessWidget {
  const TrailerTitleWidget({
    Key key,
    @required this.trailer,
  }) : super(key: key);

  final Trailer trailer;

  @override
  Widget build(BuildContext context) {
    var daysAgo = DateUtils.getLocalizedTimeAgo(trailer.createdDate.toDate(),
        locale: Localizations.localeOf(context));
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
//                  onTap: () => _showProfile(context),
                  child: CircleAvatar(
                    backgroundImage: AdvancedNetworkImage(trailer.channelImage,
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
                        trailer.title,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.title.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "${trailer.channelName} • ${trailer.views} views • $daysAgo",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 12.0,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
