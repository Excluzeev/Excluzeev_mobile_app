import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/trailer/trailers_list.dart';
import 'package:trenstop/pages/videos/videos_list.dart';
import 'package:trenstop/widgets/small_loading_indicator.dart';
import 'package:trenstop/widgets/white_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';

class ChannelDetailPage extends StatefulWidget {
  static const String TAG = "CHANNEL_DETAIL_PAGE";
  final Channel channel;
  final User user;

  const ChannelDetailPage({Key key, this.channel, this.user}) : super(key: key);

  @override
  _ChannelDetailPageState createState() => _ChannelDetailPageState();
}

class _ChannelDetailPageState extends State<ChannelDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Translation translation;

  bool _isPreparingStream = false;

  requestPermission() async {
    List<PermissionGroup> permissionGroups = [];

    permissionGroups.add(PermissionGroup.camera);
    permissionGroups.add(PermissionGroup.microphone);

    if (Platform.isAndroid) {
      permissionGroups.add(PermissionGroup.storage);
    }

    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(permissionGroups);

    var allAccept = true;
    permissions.forEach((group, PermissionStatus status) {
      if (status != PermissionStatus.granted) {
        allAccept = false;
      }
    });

    if (allAccept) {
      _showStartLive();
    } else {
      bool isOpened = await PermissionHandler().openAppSettings();
    }
  }

  Widget _getChannelTrailers() {
    return TrailersListPage(widget.channel, widget.user);
  }

  Widget _getChannelVideos() {
    return VideosListPage(widget.user, widget.channel);
  }

  _showAddVideo() {
    WidgetUtils.showAddVideo(context, widget.user, widget.channel);
  }

  _showStartLive() {
    WidgetUtils.showAddVideo(context, widget.user, widget.channel,
        hideVideoUpload: true);

//    showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: Text(
//                translation.startStream
//            ),
//            content: Text(
//                translation.startStreamDialogContent
//            ),
//            actions: <Widget>[
//              new FlatButton(
//                child: new Text(translation.start),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                  _prepareStream();
//                },
//              ),
//              new FlatButton(
//                child: new Text(translation.cancel),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//            ],
//          );
//        }
//    );
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: WhiteAppBar(
          title: Text(widget.channel.title),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Palette.primary,
            labelColor: Palette.primary,
            unselectedLabelColor: Colors.black,
            tabs: <Widget>[
              Tab(
                text: translation.trailers,
              ),
              Tab(
                text: translation.videos,
              ),
            ],
          ),
          actions: <Widget>[
            widget.channel.isDeleted || widget.channel.userId != widget.user.uid
                ? Container()
                : IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _showAddVideo,
                  ),
//            _isPreparingStream ?
//                Padding(
//                  padding: const EdgeInsets.all(18.0),
//                  child: SizedBox(
//                    height: 5.0,
//                    child: SmallLoadingIndicator(),
//
//                  ),
//                )
//                :
//            IconButton(
//              icon: Image.asset(
//                'res/icons/logo_live_e.png'
//              ),
//              onPressed: () => requestPermission(),
//            )
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton:
            widget.channel.isDeleted || widget.channel.userId != widget.user.uid
                ? Container()
                : FloatingActionButton.extended(
                    icon: Image.asset(
                      'res/icons/logo_live_e.png',
                      color: Colors.white,
                    ),
                    label: Text(
                      translation.excluzeevLive,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => requestPermission(),
                    isExtended: true,
                  ),
        body: TabBarView(
          children: <Widget>[
            _getChannelTrailers(),
            _getChannelVideos(),
          ],
        ),
      ),
    );
  }
}
