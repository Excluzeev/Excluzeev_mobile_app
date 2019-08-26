import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/managers/channel_manager.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/managers/storage_manager.dart';
import 'package:trenstop/managers/trailer_manager.dart';
import 'package:trenstop/misc/image_utils.dart';
import 'package:trenstop/misc/iuid.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/bloc_provider.dart';
import 'package:trenstop/pages/trailer/blocs/add_trailer_bloc.dart';
import 'package:trenstop/widgets/add_photo.dart';
import 'package:trenstop/widgets/custom_text_field.dart';
import 'package:trenstop/widgets/modal_picker.dart';
import 'package:trenstop/widgets/rounded_border.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';

import 'package:video_player/video_player.dart';

class AddTrailerPage extends StatefulWidget {
  static const String TAG = "ADD_TRAILER_PAGE";

  final Channel channel;

  AddTrailerPage(this.channel);

  @override
  _AddTrailerPageState createState() => _AddTrailerPageState();
}

class _AddTrailerPageState extends State<AddTrailerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthManager _authManager = AuthManager.instance;
  final TrailerManager _trailerManager = TrailerManager.instance;
  final StorageManager _storageManager = StorageManager.instance;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  VideoPlayerController _videoController;

  Translation translation;
  AddTrailerBloc bloc;

  File videoFile;
  File customThumbnailFile;

  bool hasCustomThumbnail = false;

  bool _isLoading = false;

  _showSnackBar(String message) {
    _updateLoading(false);
    if (mounted && message != null && message.isNotEmpty)
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
  }

  _updateLoading(status) {
    setState(() {
      _isLoading = status;
    });
  }

  _addVideo() {
    ImagePicker.pickVideo(source: ImageSource.gallery)
        .catchError((exception, stacktrace) {
      Logger.log(AddTrailerPage.TAG,
          message: "Couldn't get file from gallery, error: $exception");
      return null;
    }).then((file) {
      setState(() {
        videoFile = file;

        _videoController = VideoPlayerController.file(videoFile)
          ..initialize().then((_) {
//            setState(() {});
          });
      });
    });
  }

  _uploadTrailerWidget() {
    return Container(
      height: 150.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          clipBehavior: Clip.antiAlias,
          color: Colors.grey[300],
          child: InkWell(
            onTap: _addVideo,
            child: videoFile == null
                ? AddWidget(label: translation.videoLabel)
                : Stack(
                    children: <Widget>[
                      SizedBox.expand(
                        child: VideoPlayer(_videoController),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.black),
                              onPressed: () {},
//                        onPressed: () => _removeThumbnailImage(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  _addCustomThumbnail() {
    showRoundedModalBottomSheet(
      context: context,
      builder: (context) => ModalImagePicker(
        pop: true,
        onSelected: (file) async {
          if (file != null) {
            Logger.log(AddTrailerPage.TAG,
                message: "Received: $file from gallery!");

            final snapshot = await ImageUtils.nativeResize(
              file,
              StorageManager.DEFAULT_SIZE,
              centerCrop: false,
            );

            if (snapshot.success) {
              setState(() {
                customThumbnailFile = snapshot.data;
              });
            } else {
              _showSnackBar(translation.errorCropPhoto);
            }
          }
        },
      ),
    );
  }

  _removeCustomThumbnailImage() async {
    setState(() {
      customThumbnailFile = null;
    });
  }

  _uploadCustomThumbnailWidget() {
    return Column(
      children: <Widget>[
        Container(
          child: CheckboxListTile(
            onChanged: (value) {
              setState(() {
                hasCustomThumbnail = value;
              });
            },
            title: Text("Upload Custom Thumnail"),
            subtitle: Text(
              "Note: Make sure image is in 16:9 ratio.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            value: hasCustomThumbnail,
          ),
        ),
        if (hasCustomThumbnail)
          Container(
            height: 150.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Material(
                borderRadius: BorderRadius.circular(8.0),
                clipBehavior: Clip.antiAlias,
                color: Colors.grey[300],
                child: InkWell(
                  onTap: _addCustomThumbnail,
                  child: customThumbnailFile == null
                      ? AddWidget(label: translation.thumbnailLabel)
                      : Stack(
                          children: <Widget>[
                            SizedBox.expand(
                              child: Image.file(
                                customThumbnailFile,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                margin: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                    icon:
                                        Icon(Icons.close, color: Colors.black),
                                    onPressed: () =>
                                        _removeCustomThumbnailImage,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  _addTrailer() async {
    if (hasCustomThumbnail && customThumbnailFile == null) {
      _showSnackBar("Custom Thumbnail cannot be empty");
      return;
    }

    _updateLoading(true);

    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    User user = await _authManager.getUser(firebaseUser: firebaseUser);
    String trailerId = IUID.string;

    String customThumbUrl = "";

    if (customThumbnailFile != null) {
      Snapshot thumbailImage =
          await _storageManager.uploadTrailerCustomThumbanil(firebaseUser.uid,
              widget.channel.channelId, trailerId, customThumbnailFile);
      if (thumbailImage.error != null) {
        _showSnackBar(thumbailImage.error);
        return;
      }
      customThumbUrl = thumbailImage.data;
      // _showSnackBar("Thumbnail Uploaded.");
    }

    Snapshot video = await _storageManager.uploadTrailerVideo(
        firebaseUser.uid, widget.channel.channelId, trailerId, videoFile);
    if (video.error != null) {
      _showSnackBar(video.error);
      return;
    }

    // _showSnackBar("Video Uploaded.");

    TrailerBuilder trailerBuilder = TrailerBuilder()
      ..trailerId = trailerId
      ..categoryName = widget.channel.categoryName
      ..categoryId = widget.channel.categoryId
      ..userId = widget.channel.userId
      ..channelId = widget.channel.channelId
      ..channelName = widget.channel.title
      ..channelType = widget.channel.channelType
      ..title = _titleController.text
      ..description = _descriptionController.text
      ..hasCustomThumbnail = hasCustomThumbnail
      ..customThumbnail = customThumbUrl
      ..videoUrl = video.data
      ..createdDate = Timestamp.fromDate(DateTime.now())
      ..createdBy = user.displayName;

    Snapshot<Trailer> snapshot =
        await _trailerManager.addTrailer(trailerBuilder.build());

    if (snapshot.error != null) {
      _showSnackBar(snapshot.error);
      return;
    }

    WidgetUtils.proceedToAuth(context, replaceAll: true);
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    if (bloc == null)
      bloc = AddTrailerBloc(validator: AddTrailerBlocValidator(translation));

    return BlocProvider(
      bloc: bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: WhiteAppBar(
          title: Text(
            translation.trailerTitle,
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RoundedBorder(
                        child: StreamBuilder(
                          stream: bloc.title,
                          builder: (context, snapshot) => TextField(
                            controller: _titleController,
                            onChanged: bloc.updateTitle,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              border: InputBorder.none,
                              errorText: snapshot.error,
                              hintText: translation.titleLabel,
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(32)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      RoundedBorder(
                        child: StreamBuilder(
                          stream: bloc.description,
                          builder: (context, snapshot) => TextField(
                            controller: _descriptionController,
                            onChanged: bloc.updateDescription,
                            maxLines: 3,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              border: InputBorder.none,
                              errorText: snapshot.error,
                              hintText: translation.descriptionLabel,
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(255)
                            ],
                          ),
                        ),
                      ),
                      _uploadTrailerWidget(),
                      _uploadCustomThumbnailWidget(),
                      StreamBuilder(
                        stream: bloc.submitValid,
                        builder: (context, snapshot) => RoundedButton(
                          enabled: snapshot.hasData,
                          text: translation.addTrailer.toUpperCase(),
                          onPressed: () => snapshot.hasData
                              ? _addTrailer()
                              : _showSnackBar(translation.errorFields),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
