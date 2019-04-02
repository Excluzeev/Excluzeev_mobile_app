import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/managers/channel_manager.dart';
import 'package:trenstop/managers/video_manager.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/models/video.dart';
import 'package:trenstop/pages/videos/widgets/CommentWidget.dart';
import 'package:trenstop/pages/videos/widgets/LiveChat.dart';
import 'package:trenstop/pages/videos/widgets/video_title_detail_widget.dart';
import 'package:trenstop/pages/videos/widgets/video_title_widget.dart';
import 'package:trenstop/widgets/like_dislike_neutral.dart';
import 'package:trenstop/widgets/readmore_text_widget.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:screen/screen.dart';
import 'package:flutter_rtmp_publisher/flutter_rtmp_publisher.dart';
import 'package:custom_chewie/custom_chewie.dart';

import 'package:http/http.dart' as http;

class VideoDetailPage extends StatefulWidget {
  static const String TAG = "VIDEO_DETAILS_PAGE";

  final Video video;
  final User user;

  VideoDetailPage(this.video, this.user);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final VideoManager _videoManager = VideoManager.instance;
  final AuthManager _authManager = AuthManager.instance;

  Translation translation;
  ChannelManager _channelManager = ChannelManager.instance;

  VideoPlayerController _videoPlayerController;
//  ChewieController _chewieController;
  double aspectRatio = 16.0 / 9.0;
  String videoUrl = "";
  bool _isLoading = true;
  bool _isError = false;
  bool _isViewTriggered = false;

  bool _showStartStream = false;

  FocusNode _focusNode = new FocusNode();

  _showSnackBar(String message) {
    if (mounted && message != null && message.isNotEmpty)
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
  }

  _triggerVideoView() async {
    _isViewTriggered = true;
    _videoManager.countView(widget.video);
  }

  _getVideoUrl() async {
    var body = {
      "videoId": widget.video.videoId,
      "playbackId": widget.video.playbackId
    };

    var client = new http.Client();
    var response = await client.post(
        "https://us-central1-trenstop-2033f.cloudfunctions.net/videoWebHook",
        body: body);

    setState(() {
      _isLoading = false;
      if (response.body.contains("Error")) {
        _isError = true;
      } else {
        videoUrl = response.body;
      }
    });
    client.close();
  }

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.suspending:
        if (!_videoPlayerController.isDisposed) {
          _videoPlayerController.pause();
        }
        break;
      case AppLifecycleState.resumed:
        break;
    }
  }

  void _setVideo() async {
    await _getVideoUrl();
    _videoPlayerController = VideoPlayerController.network(videoUrl);
    _videoPlayerController
      ..initialize().then((v) {
        _videoPlayerController.play();
        if (aspectRatio != _videoPlayerController.value.aspectRatio) {
          setState(() {
            aspectRatio = _videoPlayerController.value.aspectRatio;
          });
        }
      });
    _videoPlayerController.addListener(() async {
      if (_videoPlayerController.value.errorDescription != null) {
        setState(() {
          _isLoading = true;
          _isError = true;
        });
      }

      if (!_isViewTriggered &&
          (await _videoPlayerController.position > Duration(seconds: 5))) {
        _triggerVideoView();
      }
    });
//    _chewieController = ChewieController(
//      videoPlayerController: _videoPlayerController,
//      aspectRatio: aspectRatio,
//      autoPlay: false,
//      looping: false,
//    );
  }

  void _setStreamButton() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (widget.video.userId == user.uid && widget.video.type == "Live") {
      setState(() {
        _showStartStream =
            DateTime.now().difference(widget.video.createdDate.toDate()) <
                Duration(hours: 11);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    if (widget.video.later != "later") {
      _setVideo();
    } else {
      _isLoading = false;
    }

    _setStreamButton();
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(() {});
    _videoPlayerController.pause();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  _startStream(streamKey) async {
    if (widget.video.later == "later") {
      var videoData = {"videoId": widget.video.videoId};
      var client = new http.Client();
      var response = await client.post(
          "https://us-central1-trenstop-2033f.cloudfunctions.net/createMuxLive",
          body: videoData);
      client.close();
      Logger.log(VideoDetailPage.TAG, message: response.body);
      var res = json.decode(response.body);
      if (res['error']) {
        _showSnackBar(res['message']);
      } else {
        RTMPPublisher.streamVideo("rtmp://live.mux.com/app/${res['message']}");
      }
    } else {
      RTMPPublisher.streamVideo("rtmp://live.mux.com/app/$streamKey");
    }
  }

  _startStreamButton() {
    return _showStartStream
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: RoundedButton(
              text: translation.startStream,
              onPressed: () => _startStream(widget.video.streamKey),
            ),
          )
        : Container();
  }

  _triggerDelete() async {
    await _videoManager.deleteVideo(widget.video);
    Navigator.of(context).pop();
  }

  _delete() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(translation.deleteDialogTitle),
            content: Text(translation.deleteDialogContent(widget.video.title)),
            actions: <Widget>[
              new FlatButton(
                child: new Text(translation.delete),
                onPressed: () {
                  Navigator.of(context).pop();
                  _triggerDelete();
                },
              ),
              new FlatButton(
                child: new Text(translation.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      appBar: Platform.isIOS
          ? WhiteAppBar()
          : PreferredSize(
              preferredSize: Size(0.0, 0.0),
              child: Container(),
            ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      child: AspectRatio(
                        aspectRatio: aspectRatio,
//              child: VideoPlayer(_controller),
                        child: _isLoading
                            ? Center(
                                child: _isError
                                    ? Icon(Icons.error)
                                    : CircularProgressIndicator(),
                              )
                            : widget.video.later == "later"
                                ? Center(
                                    child: Image.asset(
                                        'res/icons/thumbnail_placeholder.png'),
                                  )
                                : Platform.isIOS
                                    ? VideoPlayer(_videoPlayerController)
                                    : Chewie(
                                        _videoPlayerController,
                                        aspectRatio: aspectRatio,
                                        autoPlay: false,
                                        looping: false,
                                        placeholder: Image.asset(
                                          'res/icons/thumbnail_placeholder.png',
                                          key: Key(widget.video.videoId),
                                        ),
                                      ),
//                  Chewie(
//                    controller: _chewieController,
//                  ),
                      ),
                    ),
                    VideoTitleDetailWidget(
                      video: widget.video,
                    ),
                    Divider(),
                    LikeDislikeNeutral(
                      id: widget.video.videoId,
                      type: 'v',
                      likes: widget.video.likes,
                      dislikes: widget.video.dislikes,
                      neutral: widget.video.neutral,
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 8.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.black26,
                                backgroundImage: AdvancedNetworkImage(
                                  widget.video.channelImage,
                                  useDiskCache: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.video.channelName,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _startStreamButton(),
                    SizedBox(
                      height: 2.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 8.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: ReadMoreTextWidget(
                        text: widget.video.description,
                      ),
                    ),
                    Divider(),
                  ],
                ),
                Positioned(
                  top: 30.0,
                  right: 8.0,
                  child: widget.video.userId == widget.user.uid
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.white,
                          onPressed: _delete,
                        )
                      : Container(),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: widget.video.type != "Live"
                ? CommentWidget(widget.video)
                : LiveChatWidget(widget.video),
          )
        ],
      ),
    );
  }
}
