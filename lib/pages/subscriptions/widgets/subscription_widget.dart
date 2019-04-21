import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/src/flutter_advanced_networkimage.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/models/subscription.dart';
// ignore: duplicate_import
import 'package:trenstop/models/subscription.dart';

class SubscriptionWidget extends StatelessWidget {
  const SubscriptionWidget(
      {Key key, @required this.subscription, this.onTap, this.onUnsubscribe})
      : super(key: key);

  final Subscription subscription;
  final Function(Subscription) onTap;
  final Function(Subscription) onUnsubscribe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () => onTap?.call(subscription),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
//            onTap: () => _showProfile(context),
              child: CircleAvatar(
                backgroundImage: AdvancedNetworkImage(
                  subscription.channelImage,
                  retryLimit: 1,
                  useDiskCache: true,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      subscription.channelName,
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
                      "Expires in ${subscription.expiryDate.difference(DateTime.now()).inDays} days",
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: Palette.primary,
              ),
              onPressed: () => onUnsubscribe?.call(subscription),
              tooltip: "Unsubscribe ${subscription.channelName}",
            )
          ],
        ),
      ),
    );
  }
}
