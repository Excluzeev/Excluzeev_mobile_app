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
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
//                  onTap: () => _showProfile(context),
            child: CircleAvatar(
              backgroundImage:
              AdvancedNetworkImage(trailer.channelImage, useDiskCache: true),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    trailer.title,
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
                    "${trailer.channelName} ${trailer.channelType == "CrowdFunding" ?  '- ' + trailer.channelType : ''}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    DateUtils.getLocalizedTimeAgo(trailer.createdDate.toDate(), locale: Localizations.localeOf(context)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}