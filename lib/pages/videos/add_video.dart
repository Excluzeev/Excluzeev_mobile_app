import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/managers/storage_manager.dart';
import 'package:trenstop/managers/video_manager.dart';
import 'package:trenstop/misc/iuid.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/models/video.dart';
import 'package:trenstop/pages/bloc_provider.dart';
import 'package:trenstop/pages/videos/blocs/add_video_bloc.dart';
import 'package:trenstop/widgets/add_photo.dart';
import 'package:trenstop/widgets/rounded_border.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';
import 'package:flutter_rtmp_publisher/flutter_rtmp_publisher.dart';

import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class AddVideoPage extends StatefulWidget {
  static const String TAG = "ADD_TRAILER_PAGE";

  final Channel channel;
  final User user;
  bool hideVideoUpload = false;

  AddVideoPage({this.user, this.channel, this.hideVideoUpload});

  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthManager _authManager = AuthManager.instance;
  final VideoManager _videoManager = VideoManager.instance;
  final StorageManager _storageManager = StorageManager.instance;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  VideoPlayerController _videoController;

  Translation translation;
  AddVideoBloc bloc;

  File videoFile;

  bool _isLoading = false;
  String timePublish = "now";

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

  _pickVideo() {
    ImagePicker.pickVideo(source: ImageSource.gallery)
        .catchError((exception, stacktrace) {
      Logger.log(AddVideoPage.TAG,
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

  DateTime _dateValue;

  Future _selectDate() async {
    var initDate = DateTime.now();
    var initTime = TimeOfDay.fromDateTime(initDate);
    DateTime date = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: initDate,
      lastDate: new DateTime(2020),
    );
    showTimePicker(
      context: context,
      initialTime: initTime,
    ).then((TimeOfDay value) {
      _dateValue =
          DateTime(date.year, date.month, date.day, value.hour, value.minute);
      Logger.log(AddVideoPage.TAG,
          message:
              "${DateTime(date.year, date.month, date.day, value.hour, value.minute)}");

      _dateController.text =
          DateFormat('EEE, MMM d yyyy HH:mm').format(_dateValue);
    });
  }

  _uploadVideoWidget() {
    return Container(
      height: 150.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          clipBehavior: Clip.antiAlias,
          color: Colors.grey[300],
          child: InkWell(
            onTap: _pickVideo,
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

  _addVideo() async {
    _updateLoading(true);

    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    User user = await _authManager.getUser(firebaseUser: firebaseUser);
    String videoId = IUID.string;
    Snapshot video;
    if (!widget.hideVideoUpload) {
      video = await _storageManager.uploadVideoVideo(
          firebaseUser.uid, videoId, videoFile);
      if (video.error != null) {
        _showSnackBar(video.error);
        return;
      }
    }

    VideoBuilder videoBuilder = VideoBuilder()
      ..videoId = videoId
      ..categoryName = widget.channel.categoryName
      ..categoryId = widget.channel.categoryId
      ..userId = widget.channel.userId
      ..channelId = widget.channel.channelId
      ..channelName = widget.channel.title
      ..title = _titleController.text
      ..description = _descriptionController.text
      ..type = widget.hideVideoUpload ? "Live" : "VOD"
      ..videoUrl = widget.hideVideoUpload ? "" : video.data
      ..createdDate = Timestamp.fromDate(DateTime.now())
      ..later = timePublish
      ..createdBy = user.displayName;

    if (timePublish == "later") {
      videoBuilder = videoBuilder..sDate = _dateValue.toIso8601String();
    } else {
      videoBuilder = videoBuilder..sDate = "";
    }

    Video videoBuilt = videoBuilder.build();

    // is Live
    if (widget.hideVideoUpload) {
      http.Response response = await _videoManager.addLiveVideo(videoBuilt);
      var res = json.decode(response.body);
      if (res['error']) {
        _showSnackBar(res['message']);
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        if (timePublish == "now") {
          Logger.log(AddVideoPage.TAG,
              message: "rtmp://live.mux.com/app/${res['message']}");
          RTMPPublisher.streamVideo(
              "rtmp://live.mux.com/app/${res['message']}");
        }
      }
    } else {
      Snapshot<Video> snapshot = await _videoManager.addVideo(videoBuilt);

      if (snapshot.error != null) {
        _showSnackBar(snapshot.error);
        return;
      }

      Navigator.of(context).pop();
    }
//    WidgetUtils.proceedToAuth(context, replaceAll: true);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _dateController.text = "Select Date";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    if (bloc == null)
      bloc = AddVideoBloc(validator: AddVideoBlocValidator(translation));

    return BlocProvider(
      bloc: bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: WhiteAppBar(
          title: Text(
            widget.hideVideoUpload
                ? translation.liveTitle
                : translation.videoTitle,
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Text(
                          translation.titleLabel,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Palette.primary,
                          ),
                        ),
                      ),
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
                                  hintText: translation.titleVideoHintLabel,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Text(
                          translation.descriptionLabel,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Palette.primary,
                          ),
                        ),
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
                                  hintText:
                                      translation.descriptionVideoHintLabel,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(255)
                                ],
                              ),
                        ),
                      ),
                      widget.hideVideoUpload
                          ? Container()
                          : _uploadVideoWidget(),
                      widget.hideVideoUpload
                          ? ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                CheckboxListTile(
                                  title: Text(
                                    translation.now,
                                  ),
                                  value: timePublish == "now",
                                  onChanged: (value) {
                                    setState(() {
                                      timePublish = "now";
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: Text(
                                    translation.schedule,
                                  ),
                                  value: timePublish == "later",
                                  onChanged: (value) {
                                    setState(() {
                                      timePublish = "later";
                                    });
                                  },
                                ),
                                timePublish == "later"
                                    ? InkWell(
                                        onTap: _selectDate,
                                        child: RoundedBorder(
                                          child: TextField(
                                            enabled: false,
                                            controller: _dateController,
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              contentPadding: EdgeInsets.zero,
                                              filled: true,
                                              border: InputBorder.none,
                                              suffix: Icon(
                                                Icons.calendar_today,
                                                size: 18.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 16.0,
                      ),
                      StreamBuilder(
                        stream: bloc.submitValid,
                        builder: (context, snapshot) => RoundedButton(
                              enabled: snapshot.hasData,
                              text: widget.hideVideoUpload
                                  ? translation.next.toUpperCase()
                                  : translation.addVideo.toUpperCase(),
                              onPressed: () => snapshot.hasData
                                  ? _addVideo()
                                  : _showSnackBar(translation.errorEmptyField),
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
