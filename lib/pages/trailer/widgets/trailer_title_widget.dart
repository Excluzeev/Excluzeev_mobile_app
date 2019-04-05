import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:intl/intl.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/misc/date_utils.dart';
import 'package:trenstop/misc/iuid.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/widgets/reason_chip_choice.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrailerTitleWidget extends StatefulWidget {
  const TrailerTitleWidget({
    Key key,
    @required this.trailer,
  }) : super(key: key);

  final Trailer trailer;

  @override
  _TrailerTitleWidgetState createState() => _TrailerTitleWidgetState();
}

class _TrailerTitleWidgetState extends State<TrailerTitleWidget> {
  AuthManager _authManager = AuthManager.instance;
  Translation translation;

  String reasonString = "";
  List selectReasonList;

  _showLogin() {
    WidgetUtils.goToAuth(context);
  }

  _reportReason() async {
    if (selectReasonList.isEmpty) {
      Fluttertoast.showToast(
        msg: translation.reasonError,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        fontSize: 16.0,
      );
      return;
    }

    if (selectReasonList.contains("Other") && reasonString.isEmpty) {
      Fluttertoast.showToast(
        msg: translation.reasonError,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        fontSize: 16.0,
      );
      return;
    }

    if (reasonString.isNotEmpty) {
      selectReasonList.remove("Other");
      selectReasonList.add(reasonString);
    }

    Map updateData = Map<String, dynamic>();

    User user = await _authManager.getUser();

    updateData["id"] = widget.trailer.trailerId;
    updateData["type"] = "trailer";
    updateData["userName"] = user.displayName;
    updateData["userId"] = user.uid;
    updateData["reasons"] = selectReasonList;

    String reportId = IUID.string;

    DocumentReference reportRef =
        Firestore.instance.collection("reports").document(reportId);

    await reportRef.setData(updateData);

    selectReasonList.clear();
    reasonString = "";
    Fluttertoast.showToast(
      msg: translation.reportSuccessful,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      fontSize: 16.0,
    );
  }

  _showReasonDialog() async {
    User user = await _authManager.getUser();
    if (user == null) {
      _showLogin();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Reason"),
            content: MultiChipChoice(
              onChanged: (List reasonList) {
                selectReasonList = reasonList;
              },
              onResonEnter: (String reason) {
                reasonString = reason;
              },
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _reportReason();
                },
                child: Text(
                  "Report",
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildResonWidget() {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        _showReasonDialog();
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: "Report",
              child: Text(
                'Report',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
    );
  }

  @override
  Widget build(BuildContext context) {
    translation = Translation.of(context);

    var formatter = new DateFormat("d MMM y • hh:mm aaa");
    var daysAgo =
        DateTime.now().difference(widget.trailer.createdDate.toDate()).inDays <
                8
            ? DateUtils.getLocalizedTimeAgo(widget.trailer.createdDate.toDate(),
                locale: Localizations.localeOf(context))
            : formatter.format(widget.trailer.createdDate.toDate());

    return Container(
      // width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
//                  onTap: () => _showProfile(context),
                  child: CircleAvatar(
                    backgroundImage: AdvancedNetworkImage(
                      widget.trailer.channelImage,
                      useDiskCache: true,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    // width: MediaQuery.of(context).size.width * 0.65,
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.trailer.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.title.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Palette.primary,
                              ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text.rich(
                          TextSpan(
                            text: "${widget.trailer.channelName}\n",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    "${widget.trailer.views} views • $daysAgo",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12.0,
                                    ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildResonWidget(),
        ],
      ),
    );
  }
}
