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
import 'package:trenstop/models/chat.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/models/video.dart';
import 'package:trenstop/pages/home/widgets/information.dart';
import 'package:trenstop/pages/videos/widgets/video_chat_widget.dart';

class LiveChatWidget extends StatefulWidget {

  final Video video;

  LiveChatWidget(this.video);

  @override
  _LiveChatWidgetState createState() => _LiveChatWidgetState();
}

class _LiveChatWidgetState extends State<LiveChatWidget> {

  final VideoManager _videoManager = VideoManager.instance;
  final AuthManager _authManager = AuthManager.instance;
  final TextEditingController _chatMessageController = TextEditingController();

  Translation translation;

  bool _publishingComment = false;

  _chatMessage() async {
    String chatMessage = _chatMessageController.text;

    if (chatMessage.isEmpty) {
      return;
    }

    setState(() {
      _publishingComment = true;
    });

    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    User user = await _authManager.getUser(firebaseUser: firebaseUser);

    String chatId = IUID.string;

    ChatBuilder chatMessagesBuilder = ChatBuilder()
      ..message = chatMessage
      ..userPhoto = user.userPhoto
      ..createdAt = Timestamp.fromDate(DateTime.now())
      ..userId = user.uid
      ..userName = user.displayName
      ..chatId = chatId;

    Snapshot<Chat> snapshot =
    await _videoManager.addLiveChat(chatMessagesBuilder.build(), widget.video.videoId);

    if (snapshot.hasError) {
      return;
    }

    setState(() {
      _chatMessageController.clear();
      _publishingComment = false;
    });

    setState(() {});
  }

  Widget _buildCommentItem(BuildContext context, DocumentSnapshot snapshot,
      Animation animation, int index) {
    final chatMessage = Chat.fromDocumentSnapshot(snapshot);

    return FadeTransition(
      opacity: animation,
      child: chatMessage != null
          ? VideoChatWidget(
        chat: chatMessage,
      )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildAddLiveChatWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _chatMessageController,
        maxLines: 1,
        inputFormatters: [LengthLimitingTextInputFormatter(256)],
        textInputAction: TextInputAction.send,
        onSubmitted: (text) => _chatMessage(),
        decoration: InputDecoration(
          enabled: !_publishingComment,
          contentPadding: const EdgeInsets.all(16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          hintText: translation.addMessageLabel,
          suffixIcon: IconButton(
            icon: _publishingComment
                ? SizedBox.fromSize(
              size: Size.fromRadius(10.0),
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            )
                : Icon(Icons.send),
            tooltip: translation.addMessageLabel,
            onPressed: _chatMessage,
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
          _buildAddLiveChatWidget(),
          Container(
            child: FirestoreAnimatedList(
              shrinkWrap: true,
              primary: false,
              query: _videoManager
                  .videoChatQuery(widget.video.videoId)
                  .snapshots(),
              errorChild: InformationWidget(
                icon: Icons.error,
                subtitle: translation.errorLoadChat,
              ),
              emptyChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      translation.noChatsYet,
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
