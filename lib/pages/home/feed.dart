import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/misc/prefs.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/home/home.dart';
import 'package:trenstop/widgets/white_app_bar.dart';

class FeedPage extends StatefulWidget {

  static const String TAG = "HOME_PAGE";

  FeedPage();

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthManager _authManager = AuthManager();

  Translation translation;
  User user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  _contentCreator() async {
    Navigator.pop(context);
    await WidgetUtils.showContentCreatorSignUp(context);
    _getUser();
  }

  _getUser() async {
    user = await _authManager.getUser();
    setState(() {

    });
  }

  _createChannel() async {
    Navigator.pop(context);
    WidgetUtils.showCreateChannelPage(context);
  }

  _contentCreatorMenu() {
    return user.isContentCreator ?
    Container()
        :
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
        onPressed: _contentCreator,
        child: Text("Sign Up for Content Creator"),
      ),
    );
  }

  _createChannelMenu() {
    return user.isContentCreator ?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            onPressed: _createChannel,
            child: Text(translation.createChannel),
          ),
        )
        :
        Container();
  }

  _logout() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
    await Prefs.clear();
    WidgetUtils.proceedToAuth(context, replaceAll: true);
  }

  _drawerWidget() {
    return Drawer(
      child: user != null ?
      Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: 24.0,),
            Text(user.displayName),
            _contentCreatorMenu(),
            _createChannelMenu(),
            FlatButton(
              onPressed: _logout,
              child: Text(
                translation.logout
              )
            ),
          ],
        ),
      )
      :
          Container(),
    );
  }

  @override
  Widget build(BuildContext context) {

    if(translation == null) translation = Translation.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: WhiteAppBar(
        centerTitle: true,
        title: Text(translation.appName),
      ),
      drawer: _drawerWidget(),
      body: HomePage(user),
    );
  }
}
