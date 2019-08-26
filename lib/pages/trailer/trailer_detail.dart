import 'dart:math';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/managers/channel_manager.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/managers/trailer_manager.dart';
import 'package:trenstop/misc/iuid.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/misc/prefs.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/models/comments.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/home/widgets/information.dart';
import 'package:trenstop/pages/trailer/edit_trailer_description.dart';
import 'package:trenstop/pages/trailer/widgets/trailer_comments_widget.dart';
import 'package:trenstop/pages/trailer/widgets/trailer_title_detail_widget.dart';
import 'package:trenstop/pages/trailer/widgets/trailer_title_widget.dart';
import 'package:trenstop/widgets/readmore_text_widget.dart';
import 'package:trenstop/widgets/like_dislike_neutral.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
// import 'package:custom_chewie/custom_chewie.dart';
import 'package:screen/screen.dart';
import 'package:http/http.dart' as http;

class TrailerDetailPage extends StatefulWidget {
  static const String TAG = "TRAILER_DETAILS_PAGE";

  final Trailer trailerMain;

  TrailerDetailPage(this.trailerMain);

  @override
  _TrailerDetailPageState createState() => _TrailerDetailPageState();
}

class _TrailerDetailPageState extends State<TrailerDetailPage>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Trailer trailer;

  final TrailerManager _trailerManager = TrailerManager.instance;
  final AuthManager _authManager = AuthManager.instance;
  final TextEditingController _commentController = TextEditingController();

  Translation translation;
  ChannelManager _channelManager = ChannelManager.instance;

  Channel channel;

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  double aspectRatio = 16.0 / 9.0;
  bool _publishingComment = false;

  static int viewThreshold = Random().nextInt(10);

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
    _trailerManager.countView(trailer);
  }

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.suspending:
        if (!_videoPlayerController.value.isPlaying) {
          _videoPlayerController.pause();
        }
        break;
      case AppLifecycleState.resumed:
        _videoPlayerController.pause();
        _checkSubscription();
        break;
    }
  }

  _fetchChannel() async {
    var channelSnap = await _channelManager.getChannelFromId(trailer.channelId);

    if (channelSnap.error == null) {
      channel = channelSnap.data;
      print(channelSnap.data.toMap);
    }
    setState(() {});
  }

  getChannelPrice() {
    return channel != null ? channel.price : "--";
  }

  @override
  void initState() {
    setState(() {
      trailer = widget.trailerMain;
    });

    _getuser();
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    Screen.keepOn(true);

    _checkSubscription();

    _fetchChannel();

    _videoPlayerController = VideoPlayerController.network(trailer.videoUrl);

    var listener = () async {
      if (!mounted) {
        return;
      }
      if (_videoPlayerController != null) {
        var videoDuration = _videoPlayerController.value.position;
        // var videoDuration;
        if (!_isViewTriggered &&
            videoDuration != null &&
            (videoDuration > Duration(seconds: viewThreshold))) {
          _isViewTriggered = true;
          _triggerVideoView();
        }
      }
      setState(() {});
    };

    _videoPlayerController.addListener(listener);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: aspectRatio,
      autoPlay: true,
      looping: false,
      autoInitialize: true,
      placeholder: Image.asset('res/icons/thumbnail_placeholder.png'),
      allowFullScreen: true,
      allowedScreenSleep: false,
    );
  }

  FirebaseUser fUser;

  _getuser() async {
    var f = await FirebaseAuth.instance.currentUser();
    setState(() {
      fUser = f;
    });
  }

  _checkSubscription() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    User user = await _authManager.getUser(firebaseUser: firebaseUser);

    if (user != null) {
      if (user.subscribedChannels.contains(trailer.channelId)) {
        setState(() {
          _showSubscribe = false;
        });
        if (trailer.categoryName != "Call-to-Action") {
          setState(() {
            _showSubscribe = true;
          });
        }
      } else {
        setState(() {
          _showSubscribe = true;
        });
      }

      if (trailer.userId == user.uid) {
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

    if (Platform.isIOS) {
      String subWarning = await _authManager.fetchMessages();
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              subWarning,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Ok",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      return;
    }

    User user = await _authManager.getUser(firebaseUser: firebaseUser);
    WidgetUtils.showPaymentScreen(context, trailer, user, isDonate,
        price: price);
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(() {});
    // _videoPlayerController?.pause();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
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
      ..channelName = trailer.channelName
      ..channelId = trailer.channelId
      ..userId = user.uid
      ..userName = user.displayName
      ..vtId = trailer.trailerId
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
          contentPadding: const EdgeInsets.only(
            top: 8.0,
            left: 16.0,
            right: 16.0,
            bottom: 8.0,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
              width: 1.0,
              style: BorderStyle.solid,
              color: Palette.primary,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
              width: 0.8,
              style: BorderStyle.solid,
              color: Palette.primary,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
              width: 0.2,
              style: BorderStyle.solid,
              color: Palette.primary,
            ),
          ),
          hintText: translation.addCommentLabel,
          hintStyle: TextStyle(fontSize: 14.0),
          suffixIcon: IconButton(
            icon: _publishingComment
                ? SizedBox.fromSize(
                    size: Size.fromRadius(10.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  )
                : Icon(
                    Icons.send,
                    color: Palette.primary,
                  ),
            tooltip: translation.addCommentLabel,
            onPressed: _comment,
          ),
        ),
      ),
    );
  }

  _donateButton() {
    if (_showSubscribe && channel != null) {
      if (trailer.channelType != "CrowdFunding") {
        return Container();
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (int i = 0; i < channel.tiers.length; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ExpansionTile(
                    title: Text(
                      "Join Tier ${i + 1}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(channel.tiers[i]["description"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          shape: StadiumBorder(),
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                            left: 24.0,
                            right: 24.0,
                          ),
                          textColor: Colors.white,
                          child: Text(
                            "Donate ${channel.tiers[i]['price']}\$",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          color: Palette.primary,
                          onPressed: () => _startSubscribe(true,
                              price: int.parse(channel.tiers[i]['price'])),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }
    } else {
      return Container();
    }
  }

  _subscribeButton() {
    return Center(
      child: _showSubscribe
          ? trailer.channelType != "CrowdFunding"
              ? Container(
                  child: RaisedButton(
                    shape: StadiumBorder(),
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                      left: 24.0,
                      right: 24.0,
                    ),
                    textColor: Colors.white,
                    child: Text(
                      "${translation.subscribe} CAD \$${getChannelPrice()}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    color: Palette.primary,
                    onPressed: () => _startSubscribe(false),
                  ),
                )
              : Container()
          : RaisedButton(
              shape: StadiumBorder(),
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
                left: 24.0,
                right: 24.0,
              ),
              textColor: Palette.primary,
              child: Text(
                "${translation.subscribed}",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              color: Colors.white,
              onPressed: () {},
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: WhiteAppBar(),
      // Platform.isIOS
      //     ? WhiteAppBar()
      //     : PreferredSize(
      //         preferredSize: Size(0.0, 0.0),
      //         child: Container(),
      //       ),
      body: trailer == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(
                    //   height: 24.0,
                    // ),
                    AspectRatio(
                      aspectRatio: aspectRatio,
                      child: _videoPlayerController.value.initialized
                          ? Chewie(
                              controller: _chewieController,
                            )
                          : _videoPlayerController.value.hasError &&
                                  !_videoPlayerController.value.isPlaying
                              ? Center(
                                  child: Text("Error Playing Video."),
                                )
                              : Container(
                                  color: Colors.black,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                ),
                      // Platform.isIOS
                      //     ? VideoPlayer(_videoPlayerController)
                      //     :
                      //     Chewie(
                      //   _videoPlayerController,
                      //   aspectRatio: aspectRatio,
                      //   autoPlay: false,
                      //   placeholder:
                      //       Image.asset('res/icons/thumbnail_placeholder.png'),
                      //   key: Key(trailer.trailerId),
                      // ),
                    ),
                    TrailerTitleDetailWidget(
                      trailer: trailer,
                    ),
                    Divider(),
                    LikeDislikeNeutral(
                      id: trailer.trailerId,
                      type: "t",
                      likes: trailer.likes,
                      dislikes: trailer.dislikes,
                      neutral: trailer.neutral,
                    ),
                    Divider(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.black26,
                                  backgroundImage: AdvancedNetworkImage(
                                    trailer.channelImage,
                                    useDiskCache: true,
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      trailer.channelName,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _subscribeButton(),
                    Container(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          left: 16.0,
                          right: 16.0,
                          top: 4.0,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          constraints: BoxConstraints(
                            minHeight: 40.0,
                          ),
                          child: (fUser != null && fUser.uid == trailer.userId)
                              ? Stack(
                                  fit: StackFit.loose,
                                  children: <Widget>[
                                    ReadMoreTextWidget(
                                      text: trailer.description,
                                    ),
                                    Positioned(
                                      right: 0.0,
                                      child: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () async {
                                          String descp =
                                              await Navigator.of(context).push(
                                            CupertinoPageRoute(
                                              builder: (context) {
                                                return EditTrailerDescription(
                                                    trailer);
                                              },
                                              fullscreenDialog: true,
                                            ),
                                          );

                                          var tra = trailer.toBuilder();
                                          tra..description = descp;
                                          trailer = tra.build();

                                          if (descp.isNotEmpty) {
                                            if (mounted) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                CupertinoPageRoute(
                                                  builder: (context) {
                                                    return TrailerDetailPage(
                                                        trailer);
                                                  },
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : ReadMoreTextWidget(
                                  text: trailer.description,
                                ),
                        )

                        // Text(
                        //   trailer.description,
                        //   style: TextStyle(
                        //     fontSize: 14.0,
                        //   ),
                        // ),
                        ),
                    _donateButton(),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: _buildAddCommentWidget(),
              ),
              SliverToBoxAdapter(
                child: FirestoreAnimatedList(
                  primary: false,
                  shrinkWrap: true,
                  query: _trailerManager
                      .trailerCommentQuery(trailer.trailerId)
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
