import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/managers/channel_manager.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/managers/video_manager.dart';
import 'package:trenstop/misc/iuid.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/models/comments.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/models/video.dart';
import 'package:trenstop/pages/home/widgets/information.dart';
import 'package:trenstop/pages/videos/widgets/video_comments_widget.dart';
import 'package:trenstop/pages/videos/widgets/video_title_widget.dart';
import 'package:trenstop/widgets/ensure_visiblity.dart';
import 'package:trenstop/widgets/like_dislike_neutral.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';
import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
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

class _VideoDetailPageState extends State<VideoDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final VideoManager _videoManager = VideoManager.instance;
  final AuthManager _authManager = AuthManager.instance;
  final TextEditingController _commentController = TextEditingController();

  Translation translation;
  ChannelManager _channelManager = ChannelManager.instance;

  VideoPlayerController _videoPlayerController;
//  ChewieController _chewieController;
  double aspectRatio = 16.0 / 9.0;
  bool _publishingComment = false;
  String videoUrl = "";
  bool _isLoading = true;
  bool _isError = false;

  bool _showStartStream = false;

  FocusNode _focusNode = new FocusNode();

  _showSnackBar(String message) {
    setState(() {
      _publishingComment = false;
    });
    if (mounted && message != null && message.isNotEmpty)
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
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

  void _setVideo() async {
    await _getVideoUrl();
    _videoPlayerController = VideoPlayerController.network(videoUrl);
    _videoPlayerController
      ..initialize().then((v) {
        if (aspectRatio != _videoPlayerController.value.aspectRatio) {
          setState(() {
            aspectRatio = _videoPlayerController.value.aspectRatio;
          });
        }
      });
    _videoPlayerController.addListener(() {
      Logger.log(VideoDetailPage.TAG,
          message: _videoPlayerController.value.toString());
      if (_videoPlayerController.value.errorDescription != null) {
        setState(() {
          _isLoading = true;
          _isError = true;
        });
      }
    });
    _videoPlayerController.addListener(() {});
//    _chewieController = ChewieController(
//      videoPlayerController: _videoPlayerController,
//      aspectRatio: aspectRatio,
//      autoPlay: false,
//      looping: false,
//    );
  }

  void _setStreamButton() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (widget.video.userId == user.uid) {
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
    if (widget.video.later != "later") {
      _setVideo();
    } else {
      _isLoading = false;
    }

    _setStreamButton();
  }

  @override
  void dispose(){
    super.dispose();
  }


  _comment() async {
    String comment = _commentController.text;

    if (comment.isEmpty) {
      _showSnackBar(translation.commentEmpty);
      return;
    }

    setState(() {
      _publishingComment = true;
    });

    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    User user = await _authManager.getUser(firebaseUser: firebaseUser);

    String commentId = IUID.string;

    CommentsBuilder commentsBuilder = CommentsBuilder()
      ..comment = comment
      ..userPhoto = user.userPhoto
      ..createdDate = Timestamp.fromDate(DateTime.now())
      ..channelName = widget.video.channelName
      ..channelId = widget.video.channelId
      ..userId = user.uid
      ..userName = user.displayName
      ..vtId = widget.video.videoId
      ..commentId = commentId;

    Snapshot<Comments> snapshot =
        await _videoManager.addComment(commentsBuilder.build());

    if (snapshot.hasError) {
      _showSnackBar(snapshot.error);
      return;
    }

    setState(() {
      _publishingComment = false;
    });

    setState(() {});
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

  Widget _buildCommentItem(BuildContext context, DocumentSnapshot snapshot,
      Animation animation, int index) {
    final comment = Comments.fromDocumentSnapshot(snapshot);

    return FadeTransition(
      opacity: animation,
      child: comment != null
          ? VideoCommentsWidget(
              comment: comment,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildAddCommentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _commentController,
        maxLines: 1,
        inputFormatters: [LengthLimitingTextInputFormatter(256)],
        textInputAction: TextInputAction.send,
        onSubmitted: (text) => _comment(),
        decoration: InputDecoration(
          enabled: !_publishingComment,
          contentPadding: const EdgeInsets.all(16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          hintText: translation.addCommentLabel,
          suffixIcon: IconButton(
            icon: _publishingComment
                ? SizedBox.fromSize(
                    size: Size.fromRadius(10.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  )
                : Icon(Icons.send),
            tooltip: translation.addCommentLabel,
            onPressed: _comment,
          ),
        ),
      ),
    );
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
            title: Text(
                translation.deleteDialogTitle
            ),
            content: Text(
                translation.deleteDialogContent(widget.video.title)
            ),
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
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
//      appBar: WhiteAppBar(),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: <Widget>[

                Column(children: <Widget>[
                  SizedBox(
                    height: 24.0,
                  ),
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
                  VideoTitleWidget(
                    video: widget.video,
                  ),
                  LikeDislikeNeutral(
                    id: widget.video.videoId,
                    type: 'v',
                    likes: widget.video.likes,
                    dislikes: widget.video.dislikes,
                    neutral: widget.video.neutral,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  _startStreamButton(),
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.video.description,
                      style: textTheme.subtitle,
                    ),
                  ),
                  SizedBox(
                    height: .5,
                    child: Container(
                      color: Colors.grey[500],
                    ),
                  ),
                  _buildAddCommentWidget(),
                ]),
                Positioned(
                  top: 30.0,
                  right: 8.0,
                  child: IconButton(
                    icon: Icon(
                        Icons.delete
                    ),
                    color: Colors.white,
                    onPressed: _delete,
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: FirestoreAnimatedList(
              shrinkWrap: true,
              query: _videoManager
                  .videoCommentQuery(widget.video.videoId)
                  .snapshots(),
              errorChild: InformationWidget(
                icon: Icons.error,
                subtitle: translation.errorLoadComments,
              ),
              emptyChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      translation.noCommentsYet,
                      style: textTheme.title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              itemBuilder: _buildCommentItem,
            ),
          )
        ],
      ),
    );
  }
}
