import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/channel_manager.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/channel/widgets/channel_widget.dart';
import 'package:trenstop/pages/home/widgets/information.dart';
import 'package:trenstop/widgets/white_app_bar.dart';

class MyChannelsPage extends StatefulWidget {
  static const String TAG = "MY_CHANNEL_PAGE";
  final User user;

  MyChannelsPage(this.user);

  @override
  _MyChannelsPageState createState() => _MyChannelsPageState();
}

class _MyChannelsPageState extends State<MyChannelsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ChannelManager _channelManager = ChannelManager.instance;
  Translation translation;


  _onTapChannel(Channel channel) {
    WidgetUtils.showChannelDetails(context, widget.user, channel);
  }


  Widget _buildItem(BuildContext context, DocumentSnapshot snapshot, Animation animation, int index) {
    final channel = Channel.fromDocumentSnapshot(snapshot);

    return FadeTransition(
      opacity: animation,
      child: channel != null
          ? ChannelWidget(
        channel: channel,
        onTap: _onTapChannel
      )
          : Center(child: CircularProgressIndicator()),
    );
  }


  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    if(translation == null) translation = Translation.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: WhiteAppBar(
        title: Text(
          translation.myChannels
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: widget.user == null
            ? CircularProgressIndicator()
            : FirestoreAnimatedList(
          query: _channelManager.myChannelsQuery(widget.user.uid).snapshots(),
          errorChild: InformationWidget(
            icon: Icons.error,
            subtitle: translation.errorLoadTrailers,
          ),
          emptyChild: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  translation.errorEmptyChannels,
                  style: textTheme.title,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          itemBuilder: _buildItem,
        ),
      ),
    );
  }
}
