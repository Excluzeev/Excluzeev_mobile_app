import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/managers/video_manager.dart';
import 'package:trenstop/misc/iuid.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/models/comments.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/models/video.dart';
import 'package:trenstop/pages/home/widgets/information.dart';
import 'package:trenstop/pages/videos/widgets/video_comments_widget.dart';

class CommentWidget extends StatefulWidget {
  final Video video;

  CommentWidget(this.video);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final VideoManager _videoManager = VideoManager.instance;
  final AuthManager _authManager = AuthManager.instance;
  final TextEditingController _commentController = TextEditingController();

  Translation translation;

  bool _publishingComment = false;

  _comment() async {
    String comment = _commentController.text;

    if (comment.isEmpty) {
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
      return;
    }

    setState(() {
      _commentController.clear();
      _publishingComment = false;
    });

    setState(() {});
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
          contentPadding: const EdgeInsets.only(
            top: 8.0,
            left: 16.0,
            right: 16.0,
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

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      child: Column(
        children: <Widget>[
          _buildAddCommentWidget(),
          Container(
            child: FirestoreAnimatedList(
              shrinkWrap: true,
              primary: false,
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
