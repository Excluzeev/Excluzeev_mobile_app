import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:trenstop/managers/channel_manager.dart';
import 'package:trenstop/managers/video_manager.dart';
import 'package:trenstop/managers/video_manager.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/models/video.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/models/video.dart';
import 'package:trenstop/pages/home/widgets/information.dart';
import 'package:trenstop/pages/videos/widgets/video_widget.dart';

class VideosListPage extends StatefulWidget {
  static const String TAG = "TRAILERS_LIST_PAGE";

  final User user;
  final Channel channel;

  VideosListPage(this.user, this.channel);

  @override
  _VideosListPageState createState() => _VideosListPageState();
}

class _VideosListPageState extends State<VideosListPage> {

  Translation translation;
  ChannelManager _channelManager = ChannelManager.instance;
  VideoManager _videoManager = VideoManager.instance;


  _show(Video video) {
    WidgetUtils.showVideoDetails(context, video, widget.user);
  }

  _shareVideo(Video video) {

  }

  Widget _buildItem(BuildContext context, DocumentSnapshot snapshot, Animation animation, int index) {
    final video = Video.fromDocumentSnapshot(snapshot);

    return FadeTransition(
      opacity: animation,
      child: video != null
          ? VideoWidget(
        video: video,
        onTap: _show,
        onShare: _shareVideo,
        showShare: false,
      )
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: widget.user == null
          ? CircularProgressIndicator()
          : FirestoreAnimatedList(
        query: _videoManager.videosByUserInChannelQuery(widget.user.uid, widget.channel.channelId).snapshots(),
        errorChild: InformationWidget(
          icon: Icons.error,
          subtitle: translation.errorLoadVideos,
        ),
        emptyChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                translation.errorEmptyVideos,
                style: textTheme.title,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        itemBuilder: _buildItem,
      ),
    );
  }
}
