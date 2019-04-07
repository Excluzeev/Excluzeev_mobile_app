import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/channel_manager.dart';
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

  RemoteConfig remoteConfig;

  _onTapChannel(Channel channel) {
    WidgetUtils.showChannelDetails(context, widget.user, channel);
  }

  _onDelete(Channel channel) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Delete Channel"),
              content: Text(
                  "Do you want to delete from ${channel.title}.\nusers will have 30 days notice period"),
              actions: <Widget>[
                FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _channelManager.doDeleteChannel(channel);
                    }),
                FlatButton(
                  child: Text("No"),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot snapshot,
      Animation animation, int index) {
    final channel = Channel.fromDocumentSnapshot(snapshot);

    return FadeTransition(
      opacity: animation,
      child: channel != null
          ? ChannelWidget(
              channel: channel,
              onTap: _onTapChannel,
              onDelete: _onDelete,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  _createChannel() {
    WidgetUtils.showCreateChannelPage(context);
  }

  _initRemoteConfig() async {
    remoteConfig = await RemoteConfig.instance;
  }

  @override
  void initState() {
    super.initState();
    _initRemoteConfig();
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    if (remoteConfig == null) {
      _initRemoteConfig();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: WhiteAppBar(
        title: Text(translation.myChannels),
        centerTitle: true,
        actions: <Widget>[
          Platform.isIOS && !remoteConfig.getBool("showCreateChannel")
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.add,
                  ),
                  onPressed: () => _createChannel(),
                ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: widget.user == null
            ? CircularProgressIndicator()
            : FirestoreAnimatedList(
                query: _channelManager
                    .myChannelsQuery(widget.user.uid)
                    .snapshots(),
                errorChild: InformationWidget(
                  icon: Icons.error,
                  subtitle: translation.errorLoadTrailers,
                ),
                emptyChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Platform.isIOS && !remoteConfig.getBool("showCreateChannel")
                        ? Container()
                        : RaisedButton.icon(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            color: Colors.white,
                            textColor: ThemeData().primaryColor,
                            icon: Icon(
                              Icons.add,
                            ),
                            label: Text(
                              "Create a Channel",
                              style: TextStyle(
                                fontSize: 24.0,
                              ),
                            ),
                            onPressed: () => _createChannel(),
                          ),
                    Image.asset(
                      'res/icons/empty-create-channel.png',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: <Widget>[
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text(
                //         translation.errorEmptyChannels,
                //         style: textTheme.title,
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   ],
                // ),
                itemBuilder: _buildItem,
              ),
      ),
    );
  }
}
