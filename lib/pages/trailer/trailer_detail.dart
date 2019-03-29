import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/managers/channel_manager.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/managers/trailer_manager.dart';
import 'package:trenstop/misc/iuid.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/comments.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/home/widgets/information.dart';
import 'package:trenstop/pages/trailer/widgets/trailer_comments_widget.dart';
import 'package:trenstop/pages/trailer/widgets/trailer_title_widget.dart';
import 'package:trenstop/widgets/like_dislike_neutral.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';
import 'package:video_player/video_player.dart';
//import 'package:chewie/chewie.dart';
import 'package:custom_chewie/custom_chewie.dart';
import 'package:screen/screen.dart';
import 'package:http/http.dart' as http;

class TrailerDetailPage extends StatefulWidget {
  static const String TAG = "TRAILER_DETAILS_PAGE";

  final Trailer trailer;

  TrailerDetailPage(this.trailer);

  @override
  _TrailerDetailPageState createState() => _TrailerDetailPageState();
}

class _TrailerDetailPageState extends State<TrailerDetailPage>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TrailerManager _trailerManager = TrailerManager.instance;
  final AuthManager _authManager = AuthManager.instance;
  final TextEditingController _commentController = TextEditingController();

  Translation translation;
  ChannelManager _channelManager = ChannelManager.instance;

  VideoPlayerController _videoPlayerController;
//  ChewieController _chewieController;
  double aspectRatio = 16.0 / 9.0;
  bool _publishingComment = false;

  bool _isViewTriggered = false;
  bool _showSubscribe = true;

  _showSnackBar(String message) {
    setState(() {
      _publishingComment = false;
    });
    if (mounted && message != null && message.isNotEmpty)
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
  }

  _triggerVideoView() async {
    _isViewTriggered = true;
    _trailerManager.countView(widget.trailer);
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    Screen.keepOn(true);

    _checkSubscription();

    _videoPlayerController =
        VideoPlayerController.network(widget.trailer.videoUrl);

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
      if (!_isViewTriggered &&
          (await _videoPlayerController.position > Duration(seconds: 5))) {
        _triggerVideoView();
      }
    });

//    _chewieController = ChewieController(
//      videoPlayerController: _videoPlayerController,
//      aspectRatio: aspectRatio,
//      autoPlay: true,
//      looping: false,
//    );
  }

  _checkSubscription() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    User user = await _authManager.getUser(firebaseUser: firebaseUser);

    if (user != null) {
      if (user.subscribedChannels.contains(widget.trailer.channelId)) {
        setState(() {
          _showSubscribe = false;
        });
      }

      if (widget.trailer.userId == user.uid) {
        setState(() {
          _showSubscribe = false;
        });
      }
    }
  }

  _startSubscribe(bool isDonate, {int price}) async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    if (firebaseUser == null) {
      WidgetUtils.goToAuth(context, replaceAll: false);
      return;
    }

    _videoPlayerController.pause();

    User user = await _authManager.getUser(firebaseUser: firebaseUser);
    WidgetUtils.showPaymentScreen(context, widget.trailer, user, isDonate,
        price: price);
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(() {});
    _videoPlayerController.pause();
    _videoPlayerController?.dispose();
//    _chewieController?.dispose();
    super.dispose();
  }

  _comment() async {
    String comment = _commentController.text;

    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser == null) {
      WidgetUtils.goToAuth(context, replaceAll: false);
      return;
    }

    if (comment.isEmpty) {
      _showSnackBar(translation.commentEmpty);
      return;
    }

    setState(() {
      _publishingComment = true;
    });

    User user = await _authManager.getUser(firebaseUser: firebaseUser);

    String commentId = IUID.string;

    CommentsBuilder commentsBuilder = CommentsBuilder()
      ..comment = comment
      ..userPhoto = user.userPhoto
      ..createdDate = Timestamp.fromDate(DateTime.now())
      ..channelName = widget.trailer.channelName
      ..channelId = widget.trailer.channelId
      ..userId = user.uid
      ..userName = user.displayName
      ..vtId = widget.trailer.trailerId
      ..commentId = commentId;

    Snapshot<Comments> snapshot =
        await _trailerManager.addComment(commentsBuilder.build());

    if (snapshot.hasError) {
      _showSnackBar(snapshot.error);
      return;
    }

    setState(() {
      _commentController.clear();
      _publishingComment = false;
    });
  }

  Widget _buildCommentItem(BuildContext context, DocumentSnapshot snapshot,
      Animation animation, int index) {
    final comment = Comments.fromDocumentSnapshot(snapshot);

    return FadeTransition(
      opacity: animation,
      child: comment != null
          ? TrailerCommentsWidget(
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

  _subscribeButton() {
    return _showSubscribe
        ? widget.trailer.channelType != "CrowdFunding"
            ? RoundedButton(
                text: translation.subscribe,
                onPressed: () => _startSubscribe(false),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RoundedButton(
                    text: translation.donate5,
                    onPressed: () => _startSubscribe(true, price: 5),
                  ),
                  RoundedButton(
                    text: translation.donate10,
                    onPressed: () => _startSubscribe(true, price: 10),
                  )
                ],
              )
        : RoundedButton(
            text: translation.subscribed,
            onPressed: null,
          );
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
//      appBar: WhiteAppBar(),
      body: CustomScrollView(slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(children: [
            SizedBox(
              height: 24.0,
            ),
            AspectRatio(
              aspectRatio: aspectRatio,
              child: Platform.isIOS
                  ? VideoPlayer(_videoPlayerController)
                  : Chewie(
                      _videoPlayerController,
                      aspectRatio: aspectRatio,
                      autoPlay: false,
                      placeholder:
                          Image.asset('res/icons/thumbnail_placeholder.png'),
                      key: Key(widget.trailer.trailerId),
                    ),
            ),
            TrailerTitleWidget(
              trailer: widget.trailer,
            ),
            LikeDislikeNeutral(
              id: widget.trailer.trailerId,
              type: "t",
              likes: widget.trailer.likes,
              dislikes: widget.trailer.dislikes,
              neutral: widget.trailer.neutral,
            ),
            SizedBox(
              height: 8.0,
            ),
            _subscribeButton(),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.trailer.description,
                style: textTheme.subtitle,
              ),
            ),
            _buildAddCommentWidget(),
          ]),
        ),
        SliverToBoxAdapter(
          child: FirestoreAnimatedList(
            primary: false,
            shrinkWrap: true,
            query: _trailerManager
                .trailerCommentQuery(widget.trailer.trailerId)
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
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            itemBuilder: _buildCommentItem,
          ),
        ),
      ]),
    );
  }
}
