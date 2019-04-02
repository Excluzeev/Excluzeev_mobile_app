import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:intl/intl.dart';
import 'package:trenstop/misc/date_utils.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/models/trailer.dart';

class TrailerTitleWidget extends StatelessWidget {
  const TrailerTitleWidget({
    Key key,
    @required this.trailer,
  }) : super(key: key);

  final Trailer trailer;

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat("d MMM y • hh:mm aaa");
    var daysAgo =
        DateTime.now().difference(trailer.createdDate.toDate()).inDays < 8
            ? DateUtils.getLocalizedTimeAgo(trailer.createdDate.toDate(),
                locale: Localizations.localeOf(context))
            : formatter.format(trailer.createdDate.toDate());

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
                    backgroundImage: AdvancedNetworkImage(
                      trailer.channelImage,
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
                        trailer.title,
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
                          text: "${trailer.channelName}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: " • ${trailer.views} views • $daysAgo",
                              style:
                                  Theme.of(context).textTheme.caption.copyWith(
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
      ),
    );
  }
}
