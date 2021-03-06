import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:trenstop/managers/channel_manager.dart';
import 'package:trenstop/managers/trailer_manager.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/home/widgets/information.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:trenstop/pages/trailer/widgets/trailer_widget.dart';
import 'package:trenstop/widgets/white_app_bar.dart';

class CallToActionPage extends StatefulWidget {
  static const String TAG = "CALL_TO_ACTION_PAGE";

  final User user;
  CallToActionPage(this.user);

  @override
  _CallToActionPageState createState() => _CallToActionPageState();
}

class _CallToActionPageState extends State<CallToActionPage> {
  Translation translation;
  TrailerManager _trailerManager = TrailerManager.instance;

  _show(Trailer trailer) {
    WidgetUtils.showTrailerDetails(context, trailer);
  }

  _shareTrailer(Trailer trailer) {}

  Widget _buildItem(BuildContext context, DocumentSnapshot snapshot,
      Animation animation, int index) {
    final trailer = Trailer.fromDocumentSnapshot(snapshot);

    return FadeTransition(
      opacity: animation,
      child: trailer != null
          ? TrailerWidget(
              trailer: trailer,
              onTap: _show,
              onShare: _shareTrailer,
              showShare: false,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: WhiteAppBar(
        title: Text(translation.menuCallToAction),
        centerTitle: true,
      ),
      body: Center(
        child: FirestoreAnimatedList(
                query: _trailerManager.trailersQueryCallToAction.snapshots(),
                errorChild: InformationWidget(
                  icon: Icons.error,
                  subtitle: translation.errorLoadTrailers,
                ),
                emptyChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        translation.errorEmptyTrailers,
                        style: textTheme.title,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                itemBuilder: _buildItem,
              ),
      ),
    );
  }
}
