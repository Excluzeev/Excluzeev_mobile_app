import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/models/channel.dart';

class ChannelWidget extends StatelessWidget {
  const ChannelWidget(
      {Key key, @required this.channel, this.onTap, this.onDelete})
      : super(key: key);

  final Channel channel;
  final Function(Channel) onTap;
  final Function(Channel) onDelete;

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
              child: channel.isDeleted
                  ? CircleAvatar(
                      backgroundColor: Colors.white10,
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  : CircleAvatar(
                      backgroundImage: AdvancedNetworkImage(channel.image,
                          useDiskCache: true),
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
                      channel.isDeleted
                          ? "deletes in ${DateTime.now().difference(channel.deleteOn).inDays.abs()} day(s)"
                          : "${channel.subscriberCount} subscriber(s)",
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
            channel.isDeleted
                ? Container()
                : IconButton(
                    icon: Icon(
                      Icons.delete_forever,
                      color: Palette.primary,
                    ),
                    onPressed: () => onDelete?.call(channel),
                    tooltip: "Delete ${channel.title}",
                  )
          ],
        ),
      ),
    );
  }
}
