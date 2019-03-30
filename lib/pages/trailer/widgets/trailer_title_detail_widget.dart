import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trenstop/misc/date_utils.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/models/trailer.dart';

class TrailerTitleDetailWidget extends StatelessWidget {
  const TrailerTitleDetailWidget({
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
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
                              fontSize: 24.0,
                              color: Palette.primary,
                            ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "${trailer.views} views • $daysAgo",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
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
