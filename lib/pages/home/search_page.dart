import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:trenstop/managers/channel_manager.dart';
import 'package:trenstop/managers/trailer_manager.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/home/widgets/information.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:trenstop/pages/trailer/widgets/trailer_widget.dart';
import 'package:http/http.dart' as http;
import 'package:trenstop/widgets/white_app_bar.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  static const String TAG = "SEARCH_PAGE";

  final User user;
  final String query;

  SearchPage(this.user, this.query);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Translation translation;
  ChannelManager _channelManager = ChannelManager.instance;
  TrailerManager _trailerManager = TrailerManager.instance;

  List<Trailer> trailersList = List();
  List<dynamic> indexs = List();

  _show(Trailer trailer) {
    WidgetUtils.showTrailerDetails(context, trailer);
  }

  _shareTrailer(Trailer trailer) {}

  Widget _buildItem(
      BuildContext context, Map<String, dynamic> snapshot, int index) {
    final trailer = Trailer.fromAlogliaSearchIndex(snapshot);

    return trailer != null
        ? TrailerWidget(
            trailer: trailer,
            onTap: _show,
            onShare: _shareTrailer,
            showShare: false,
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

// -H "X-Algolia-API-Key: a43f7e807dbde9c65ecd0b08fd5f4bb7" \
//      -H "X-Algolia-Application-Id: 8LGSQX6S2G" \
  _startFetch() async {
    Map<String, String> headers = Map();
    headers["X-Algolia-Application-Id"] = "8LGSQX6S2G";
    headers["X-Algolia-API-Key"] = "a43f7e807dbde9c65ecd0b08fd5f4bb7";

    try {
      var response = await http.get(
        "https://8LGSQX6S2G-dsn.algolia.net/1/indexes/trailers?query=${widget.query}",
        headers: headers,
      );
      if (response.statusCode == 200) {
        print(json.decode(response.body)["hits"]);
        setState(() {
          indexs = json.decode(response.body)["hits"];
        });
        // Timestamp.fromMillisecondsSinceEpoch(milliseconds)
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    _startFetch();
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: WhiteAppBar(
        title: Text(
          widget.query,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
          child: ListView.builder(
        itemBuilder: (context, index) {
          return _buildItem(context, indexs[index], index);
        },
        itemCount: indexs.length,
      )
          // FirestoreAnimatedList(
          //   query: _trailerManager.trailersQuery.snapshots(),
          //   errorChild: InformationWidget(
          //     icon: Icons.error,
          //     subtitle: translation.errorLoadTrailers,
          //   ),
          //   emptyChild: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Text(
          //           translation.errorEmptyTrailers,
          //           style: textTheme.title,
          //           textAlign: TextAlign.center,
          //         ),
          //       ),
          //     ],
          //   ),
          //   itemBuilder: _buildItem,
          // ),
          ),
    );
  }
}
