import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:trenstop/misc/date_utils.dart';
import 'package:trenstop/misc/image_utils.dart';
import 'package:trenstop/models/chat.dart';

class VideoChatWidget extends StatefulWidget {
  const VideoChatWidget({
    Key key,
    @required this.chat,
  }) : super(key: key);

  final Chat chat;

  @override
  _VideoChatWidgetState createState() => _VideoChatWidgetState();
}

class _VideoChatWidgetState extends State<VideoChatWidget> {
  bool failed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          InkWell(
//                  onTap: () => _showProfile(context),
            child: CircleAvatar(
              backgroundImage: failed
                  ? AssetImage("res/icons/user.png")
                  : AdvancedNetworkImage(
                      widget.chat.userPhoto,
                      useDiskCache: true,
                      loadFailedCallback: () {
                        if (mounted) {
                          setState(() {
                            failed = true;
                          });
                        }
                      },
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.chat.userName,
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
                  widget.chat.message,
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
                  DateUtils.getLocalizedTimeAgo(widget.chat.createdAt.toDate(),
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
