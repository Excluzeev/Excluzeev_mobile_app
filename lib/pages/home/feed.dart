import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/managers/auth_manager.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/misc/prefs.dart';
import 'package:trenstop/misc/widget_utils.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/home/home.dart';
import 'package:trenstop/widgets/full_app_logo.dart';
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
  TextStyle drawerItemTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0
  );

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
    if(user.isContentCreator) {
      Navigator.pop(context);
      WidgetUtils.showCreateChannelPage(context);
    } else {
      _contentCreator();
    }
  }

  _contentCreatorMenu() {
    return user.isContentCreator ?
    Container()
        :
    FlatButton(
      onPressed: _contentCreator,
      child: Text(
        translation.signUpContentCreator,
        style: drawerItemTextStyle,
      ),
    );
  }

  _myChannels() {
    if(user.isContentCreator) {
      Navigator.pop(context);
      WidgetUtils.showChannels(context, user);
    } else {
      _contentCreator();
    }
  }

  _mySubscriptions() {
    Navigator.pop(context);
    WidgetUtils.showSubscriptions(context, user);
  }

  _createMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          onPressed: _myChannels,
          child: Text(
            translation.myChannels,
            style: drawerItemTextStyle,
          ),
        ),
        FlatButton(
          onPressed: _mySubscriptions,
          child: Text(
            translation.mySubscriptions,
            style: drawerItemTextStyle,
          ),
        ),
        FlatButton(
          onPressed: _createChannel,
          child: Text(
            translation.createChannel,
            style: drawerItemTextStyle,
          ),
        )
      ],
    );
  }

  _logout() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
    await Prefs.clear();
    WidgetUtils.proceedToHome(context, replaceAll: true);
  }

  _login() async {
    await Prefs.clear();
    WidgetUtils.goToAuth(context, replaceAll: false);
  }

  _drawerWidget() {
    return Drawer(
      child: user != null ?
      Container(
        padding: const EdgeInsets.only(left: 16.0),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 32.0,),
                SizedAppLogo(),
                SizedBox(height: 14.0,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Palette.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      user.displayName.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
                _contentCreatorMenu(),
                _createMenu(),
              ],
            ),
            Positioned(
              bottom: 20.0,
              child: FlatButton(
                  onPressed: _logout,
                  child: Text(
                    translation.logout,
                    style: drawerItemTextStyle,
                  )
              ),
            )
          ],
        ),
      )
      :
          Column(
            children: <Widget>[
              SizedBox(height: 32.0,),
              Container(
                child: FlatButton(
                    onPressed: () => _login(),
                    child: Text(
                      translation.login,
                      style: drawerItemTextStyle,
                    )
                ),
              )
            ],
          ),
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
        title: Text(
            translation.appNameTrailers,
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      drawer: _drawerWidget(),
      body: HomePage(user),
    );
  }
}
