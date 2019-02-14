import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/channel_manager.dart';
import 'package:trenstop/models/category.dart';
import 'package:trenstop/widgets/white_app_bar.dart';


class NewChannelPage extends StatefulWidget {
  static String TAG = "NEW_CHANNEL_PAGE";

  @override
  _NewChannelPageState createState() => _NewChannelPageState();
}

class _NewChannelPageState extends State<NewChannelPage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final ChannelManager _channelManager = ChannelManager.instance;
  Translation translation;

  bool _isLoading = false;

  List<Category> _listCategories = List();

  _updateLoading(status) {
    setState(() {
      _isLoading = status;
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchCategories();
  }

  _fetchCategories() async {
    _updateLoading(true);
    _listCategories = await _channelManager.getCategories();
    _updateLoading(false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: WhiteAppBar(),
      body: _isLoading
      ?
          Center(
            child: CircularProgressIndicator(),
          )
      :
          Container()
      ,
    );
  }
}
