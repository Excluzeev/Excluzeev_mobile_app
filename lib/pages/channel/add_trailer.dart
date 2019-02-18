import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/managers/channel_manager.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/managers/storage_manager.dart';
import 'package:trenstop/managers/trailer_manager.dart';
import 'package:trenstop/misc/iuid.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/bloc_provider.dart';
import 'package:trenstop/pages/channel/blocs/add_trailer_bloc.dart';
import 'package:trenstop/widgets/add_photo.dart';
import 'package:trenstop/widgets/custom_text_field.dart';
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
            child: videoFile == null ?
            AddWidget(label: translation.videoLabel)
                :
            Stack(
              children: <Widget>[
                SizedBox.expand(
                  child: AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.black),
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

  _addTrailer() async {

    _updateLoading(true);

    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    User user = await _authManager.getUser(firebaseUser: firebaseUser);
    String trailerId = IUID.string;

    Snapshot video = await _storageManager.uploadTrailerVideo(firebaseUser.uid, widget.channel.channelId, trailerId, videoFile);
    if(video.error != null) {
      _showSnackBar(video.error);
      return;
    }

    TrailerBuilder trailerBuilder = TrailerBuilder()
        ..trailerId = trailerId
        ..categoryName = widget.channel.categoryName
        ..categoryId = widget.channel.categoryId
        ..userId = widget.channel.userId
        ..channelId = widget.channel.channelId
        ..channelName = widget.channel.title
        ..title = _titleController.text
        ..description = _descriptionController.text
        ..videoUrl = video.data
        ..createdDate = Timestamp.fromDate(DateTime.now())
        ..createdBy = user.displayName;

    Snapshot<Trailer> snapshot = await _trailerManager.addTrailer(trailerBuilder.build());

    if(snapshot.error != null) {
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
            ?
        Center(
          child: CircularProgressIndicator(),
        )
            :
        SingleChildScrollView(
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
                StreamBuilder(
                  stream: bloc.submitValid,
                  builder: (context, snapshot) => RoundedButton(
                    enabled: snapshot.hasData,
                    text: translation.addTrailer.toUpperCase(),
                    onPressed: () => snapshot.hasData ?  _addTrailer() : _showSnackBar(translation.errorFields),
                  ),
                ),
              ],
            ),
          ),
        )
        ,
      ),
    );
  }
}
