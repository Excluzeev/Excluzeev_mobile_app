import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/managers/channel_manager.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/managers/storage_manager.dart';
import 'package:trenstop/misc/image_utils.dart';
import 'package:trenstop/misc/iuid.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/category.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/bloc_provider.dart';
import 'package:trenstop/pages/channel/blocs/create_channel_bloc.dart';
import 'package:trenstop/widgets/add_photo.dart';
import 'package:trenstop/widgets/custom_text_field.dart';
import 'package:trenstop/widgets/modal_picker.dart';
import 'package:trenstop/widgets/rounded_border.dart';
import 'package:trenstop/widgets/rounded_button.dart';
import 'package:trenstop/widgets/white_app_bar.dart';
import 'package:flutter/gestures.dart';

class NewChannelPage extends StatefulWidget {
  static String TAG = "NEW_CHANNEL_PAGE";

  @override
  _NewChannelPageState createState() => _NewChannelPageState();
}

class _NewChannelPageState extends State<NewChannelPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthManager _authManager = AuthManager.instance;
  final ChannelManager _channelManager = ChannelManager.instance;
  final StorageManager _storageManager = StorageManager.instance;
  Translation translation;
  CreateChannelBloc bloc;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _targetFundController = TextEditingController();

  TextEditingController _dateController = TextEditingController();

  Category selectedCategory;
  String selectedType = "VOD";
  String selectedTier = "Tier 1";
  List<bool> tiersSelection = [false, false, false, false, false];
  List<String> tierDescriptions = ["", "", "", "", ""];
  List<double> tierPrices = [0.0, 0.0, 0.0, 0.0, 0.00];

  DateTime selectedDate;

  bool _isLoading = false;

  List<Category> _listCategories = List();
  File thumbnailFile;
  File coverFile;

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

  @override
  void initState() {
    super.initState();

    _fetchCategories();

    setState(() {
      _priceController.text = 1.0.toString();
    });
  }

  _fetchCategories() async {
    _updateLoading(true);
    _listCategories = await _channelManager.getCategories();
    _updateLoading(false);
  }

  _buildCategoryDropDown() {
    return Container(
      margin:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            translation.categoryNameLabel,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Palette.primary,
            ),
          ),
          DropdownButton<Category>(
            value: selectedCategory,
            hint: Text(translation.categoryNameHintLabel),
            isExpanded: true,
            items: _listCategories.map((Category category) {
              return DropdownMenuItem<Category>(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (cat) {
              bloc.updateCategoryName(cat.name);
              setState(() {
                selectedCategory = cat;
                if (selectedCategory.name == "Call-to-Action") {
                  selectedType = "CrowdFunding";
                } else {
                  selectedType = "VOD";
                }
              });
            },
          ),
        ],
      ),
    );
  }

  _buildTypeDropDown() {
    return Container(
      margin:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            translation.channelTypeLabel,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Palette.primary,
            ),
          ),
          DropdownButton<String>(
            value: selectedType,
            hint: Text(translation.channelTypeLabel),
            isExpanded: true,
            items: <String>["CrowdFunding", "VOD"].map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (type) {
              setState(() {
                selectedType = type;
              });
            },
          ),
        ],
      ),
    );
  }

  _buildExipryDatePicker() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              "Expiry Date",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Palette.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RoundedBorder(
              child: InkWell(
                onTap: () async {
                  DateTime date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365 * 2)));

                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                      _dateController.text = date.toString().split(" ")[0];
                    });
                  }
                },
                child: TextField(
                  controller: _dateController,
                  enabled: false,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    border: InputBorder.none,
                    hintText: "Select Expiry Date",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildTierDropDown() {
    List<Widget> tiersCheckBoxes = List();

    for (int i = 0; i < 5; i++) {
      tiersCheckBoxes.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CheckboxListTile(
            value: tiersSelection[i],
            title: Text("Tier ${i + 1}"),
            onChanged: (value) {
              setState(() {
                tiersSelection[i] = value;
              });
            },
          ),
          if (tiersSelection[i])
            TierDataWidget(
              title: "Tier ${i + 1}",
              onPriceChanged: (value) {
                tierPrices[i] = double.parse(value);
              },
              onDescriptionChanged: (value) {
                tierDescriptions[i] = value;
              },
            )
        ],
      ));
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tiersCheckBoxes,
      ),
    );
    // return Container(
    //   margin:
    //       const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Text(
    //         translation.channelTierLabel,
    //         style: TextStyle(
    //           fontSize: 18.0,
    //           fontWeight: FontWeight.bold,
    //           color: Palette.primary,
    //         ),
    //       ),
    //       DropdownButton<String>(
    //         value: selectedTier,
    //         hint: Text(translation.channelTierLabel),
    //         isExpanded: true,
    //         items: <String>["Tier 1", "Tier 2"].map((String type) {
    //           return DropdownMenuItem<String>(
    //             value: type,
    //             child: Text(type),
    //           );
    //         }).toList(),
    //         onChanged: (type) {
    //           bloc.updateType(type);
    //           setState(() {
    //             selectedTier = type;
    //           });
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }

  _removeThumbnailImage() async {
    setState(() {
      thumbnailFile = null;
    });
  }

  _addThumbnail() async {
    showRoundedModalBottomSheet(
      context: context,
      builder: (context) => ModalImagePicker(
        pop: true,
        onSelected: (file) async {
          if (file != null) {
            Logger.log(NewChannelPage.TAG,
                message: "Received: $file from gallery!");

            final snapshot = await ImageUtils.nativeResize(
              file,
              StorageManager.DEFAULT_SIZE,
              centerCrop: false,
            );

            if (snapshot.success) {
              setState(() {
                thumbnailFile = snapshot.data;
              });
            } else {
              _showSnackBar(translation.errorCropPhoto);
            }
          }
        },
      ),
    );
  }

  _removeCoverImage() {
    setState(() {
      coverFile = null;
    });
  }

  _addCoverImage() {
    showRoundedModalBottomSheet(
      context: context,
      builder: (context) => ModalImagePicker(
        pop: true,
        onSelected: (file) async {
          if (file != null) {
            Logger.log(NewChannelPage.TAG,
                message: "Received: $file from gallery!");

            final snapshot = await ImageUtils.nativeResize(
              file,
              StorageManager.DEFAULT_SIZE,
              centerCrop: false,
            );

            if (snapshot.success) {
              setState(() {
                coverFile = snapshot.data;
              });
            } else {
              _showSnackBar(translation.errorCropPhoto);
            }
          }
        },
      ),
    );
  }

  _uploadThumbnailWidget() {
    return Container(
      height: 150.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          clipBehavior: Clip.antiAlias,
          color: Colors.grey[300],
          child: InkWell(
            onTap: _addThumbnail,
            child: thumbnailFile == null
                ? AddWidget(label: translation.thumbnailLabel)
                : Stack(
                    children: <Widget>[
                      SizedBox.expand(
                        child: Image.file(
                          thumbnailFile,
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
                              icon: Icon(Icons.close, color: Colors.black),
                              onPressed: () => _removeThumbnailImage(),
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

  _uploadCoverWidget() {
    return Container(
      height: 150.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          clipBehavior: Clip.antiAlias,
          color: Colors.grey[300],
          child: InkWell(
            onTap: _addCoverImage,
            child: coverFile == null
                ? AddWidget(label: translation.coverImageLabel)
                : Stack(
                    children: <Widget>[
                      SizedBox.expand(
                        child: Image.file(
                          coverFile,
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
                              icon: Icon(Icons.close, color: Colors.black),
                              onPressed: () => _removeCoverImage(),
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

  _addChannel() async {
    _updateLoading(true);

    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    User user = await _authManager.getUser(firebaseUser: firebaseUser);
    String channelId = IUID.string;

    double targetFund = 0.0;
    try {
      targetFund = double.parse(_targetFundController.text);
    } catch (err) {
      targetFund = 0.0;
    }

    double priceData = 2.0;

    if (selectedDate == null) {
      _showSnackBar("Please select Expiry date.");
      return;
    }

    List<Map<String, dynamic>> tierArray = List();
    var expiry;

    if (selectedType == "CrowdFunding") {
      for (int i = 0; i < tiersSelection.length; i++) {
        int tier = i + 1;
        if (tiersSelection[i]) {
          tierArray.add({
            "tier": "Tier $tier",
            "price": tierPrices[i],
            "description": tierDescriptions[i]
          });
        }
      }
      expiry = Timestamp.fromDate(selectedDate);

      priceData = 0.0;
    } else {
      try {
        priceData = double.parse(_priceController.text);
      } catch (err) {
        priceData = 2.0;
      }
      if (priceData < 2.0) {
        _showSnackBar("Price should be greater than 1.99\$");
        return;
      }
    }

    Snapshot image = await _storageManager.uploadChannelImage(
        firebaseUser.uid, channelId, thumbnailFile, "thumbnail");
    Snapshot coverImage = await _storageManager.uploadChannelImage(
        firebaseUser.uid, channelId, coverFile, "cover");

    if (image.error != null) {
      _showSnackBar(image.error);
      return;
    }

    if (coverImage.error != null) {
      _showSnackBar(coverImage.error);
      return;
    }

    ChannelBuilder channelBuilder = ChannelBuilder()
      ..channelId = channelId
      ..categoryName = selectedCategory.name
      ..categoryId = selectedCategory.id
      ..userId = firebaseUser.uid
      ..createdBy = user.displayName
      ..channelType = selectedType
      ..title = _titleController.text
      ..description = _descriptionController.text
      ..image = image.data
      ..coverImage = coverImage.data
      ..createdDate = Timestamp.fromDate(DateTime.now())
      ..subscriberCount = 0
      ..price = priceData
      ..tiers = tierArray
      ..expiry = selectedDate
      ..targetFund = targetFund
      ..currentFund = 0
      ..percentage = 0.0;

    Snapshot<Channel> snapshot =
        await _channelManager.addChannel(channelBuilder.build());

    if (snapshot.error != null) {
      _showSnackBar(snapshot.error);
      return;
    }

    WidgetUtils.showCreateTrailerPage(context, snapshot.data);
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    if (bloc == null)
      bloc =
          CreateChannelBloc(validator: CreateChannelBlocValidator(translation));

    // bloc.updateTier(selectedTier);

    return BlocProvider(
      bloc: bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: WhiteAppBar(
          title: Text(
            translation.addChannel,
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildCategoryDropDown(),
                        // selectedCategory != null &&
                        //         selectedCategory.name == "Call-to-Action"
                        //     ? _buildTypeDropDown()
                        //     : Container(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Text(
                            translation.channelLabel,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Palette.primary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RoundedBorder(
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
                                  hintText: translation.channelHintLabel,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(32)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Text(
                            translation.descriptionLabel,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Palette.primary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RoundedBorder(
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
                                  hintText: translation.descriptionHintLabel,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(255)
                                ],
                              ),
                            ),
                          ),
                        ),
                        selectedType == "CrowdFunding"
                            ? _buildExipryDatePicker()
                            : Container(),
                        selectedType == "CrowdFunding"
                            ? _buildTierDropDown()
                            : Container(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Text(
                            selectedType != "CrowdFunding"
                                ? translation.priceLabel
                                : translation.targetFundLabel,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Palette.primary,
                            ),
                          ),
                        ),
                        selectedType != "CrowdFunding"
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RoundedBorder(
                                  child: StreamBuilder(
                                    stream: bloc.price,
                                    builder: (context, snapshot) => TextField(
                                      controller: _priceController,
                                      onChanged: (p) =>
                                          bloc.updatePrice(double.parse(p)),
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.zero,
                                        filled: true,
                                        border: InputBorder.none,
                                        errorText: snapshot.error,
                                        hintText: translation.priceLabel,
                                        suffixText:
                                            translation.priceSuffixLabel,
                                        suffixStyle: TextStyle(
                                          color: Palette.primary,
                                        ),
                                      ),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        selectedType == "CrowdFunding"
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RoundedBorder(
                                  child: StreamBuilder(
                                    stream: bloc.targetFund,
                                    builder: (context, snapshot) => TextField(
                                      controller: _targetFundController,
                                      onChanged: (p) => bloc
                                          .updateTargetFund(double.parse(p)),
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.zero,
                                        filled: true,
                                        border: InputBorder.none,
                                        errorText: snapshot.error,
                                        hintText: translation.targetFundLabel,
                                      ),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Text.rich(
                            TextSpan(
                              text: translation.priceWarningMsgLearnMore,
                              style: TextStyle(
                                color: Colors.lightBlue,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  WidgetUtils.launchURL(context,
                                      "http://excluzeev.com/excluzeev-charges");
                                },
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Text(
                            translation.thumbnailLabel,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Palette.primary,
                            ),
                          ),
                        ),
                        _uploadThumbnailWidget(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Text(
                            translation.coverImageLabel,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Palette.primary,
                            ),
                          ),
                        ),
                        _uploadCoverWidget(),
                        StreamBuilder(
                          stream: bloc.submitValid,
                          builder: (context, snapshot) => RoundedButton(
                            enabled: snapshot.hasData,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                translation.createNow.toUpperCase(),
                              ),
                            ),
                            text: translation.createNow.toUpperCase(),
                            onPressed: () => snapshot.hasData
                                ? _addChannel()
                                : _showSnackBar(translation.errorEmptyField),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class TierDataWidget extends StatefulWidget {
  final String title;
  final Function(String) onPriceChanged;
  final Function(String) onDescriptionChanged;

  TierDataWidget({this.title, this.onPriceChanged, this.onDescriptionChanged});

  @override
  _TierDataWidgetState createState() => _TierDataWidgetState();
}

class _TierDataWidgetState extends State<TierDataWidget> {
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              "${widget.title} Price",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Palette.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RoundedBorder(
              child: TextField(
                controller: _priceController,
                onChanged: widget.onPriceChanged,
                maxLines: 1,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  border: InputBorder.none,
                  hintText: "1.0",
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(255)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              "${widget.title} Description",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Palette.primary,
              ),
            ),
          ),
          RoundedBorder(
            child: TextField(
              controller: _descriptionController,
              onChanged: widget.onDescriptionChanged,
              maxLines: 3,
              decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                filled: true,
                border: InputBorder.none,
                hintText: "${widget.title} Description",
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(255)],
            ),
          ),
        ],
      ),
    );
  }
}
