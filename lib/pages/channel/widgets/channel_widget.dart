import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:trenstop/misc/date_utils.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/models/trailer.dart';

class ChannelWidget extends StatelessWidget {

  const ChannelWidget({
    Key key,
    @required this.channel,
    this.onTap
  }) : super(key: key);

  final Channel channel;
  final Function(Channel) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () => onTap?.call(channel),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
//            onTap: () => _showProfile(context),
              child: CircleAvatar(
                backgroundImage:
                AdvancedNetworkImage(channel.image, useDiskCache: true),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      channel.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.title.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      channel.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}