import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

import 'package:url_launcher/url_launcher.dart' as uLaunch;

class FeedPage extends StatefulWidget {
  static const String TAG = "HOME_PAGE";

  FeedPage();

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthManager _authManager = AuthManager();
  TextStyle drawerItemTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0);

  RemoteConfig remoteConfig;

  Translation translation;
  User user;

  // Search Bar
  SearchBar searchBar;

  _performSearch(String searchQuery) {
    if (searchQuery.isNotEmpty) {
      print(searchQuery);
      WidgetUtils.goSearchData(context, user, searchQuery);
    }
  }

  _FeedPageState() {
    searchBar = new SearchBar(
      inBar: true,
      setState: setState,
      onSubmitted: _performSearch,
      buildDefaultAppBar: _buildAppBar,
    );
  }
  // Search Bar

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: new CustomTabsAnimation.slideIn(),
          extraCustomTabs: <String>[
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _initRemoteConfig() async {
    try {
      RemoteConfig remoteC = await RemoteConfig.instance;
      setState(() {
        remoteConfig = remoteC;
      });
    } catch (err) {}
  }

  _contentCreator() async {
    Navigator.pop(context);
    await WidgetUtils.showContentCreatorSignUp(context);
    _getUser();
  }

  _getUser() async {
    user = await _authManager.getUser();
    setState(() {});
  }

  _createChannel() async {
    if (user == null) {
      _login();
      return;
    }
    if (user.isContentCreator) {
      Navigator.pop(context);
      WidgetUtils.showCreateChannelPage(context);
    } else {
      _contentCreator();
    }
  }

  _contentCreatorMenu() {
    if (Platform.isIOS && (remoteConfig != null ? !remoteConfig.getBool("showContentCreator") : false)) {
      return Container();
    }
    return user == null
        ? Container()
        : user.isContentCreator
            ? Container()
            : FlatButton(
                onPressed: _contentCreator,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    translation.signUpContentCreator,
                    style: drawerItemTextStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              );
  }

  _myChannels() {
    if (user != null) {
      if (user.isContentCreator) {
        Navigator.pop(context);
        WidgetUtils.showChannels(context, user);
      } else {
        _contentCreator();
      }
    } else {
      _login();
    }
  }

  _mySubscriptions() {
    if (user != null) {
      Navigator.pop(context);
      WidgetUtils.showSubscriptions(context, user);
    } else {
      _login();
    }
  }

  _createMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FlatButton(
          onPressed: _myChannels,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              translation.myChannels,
              style: drawerItemTextStyle,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        FlatButton(
          onPressed: _mySubscriptions,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              translation.mySubscriptions,
              style: drawerItemTextStyle,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Platform.isIOS && (remoteConfig != null ? !remoteConfig.getBool("showCreateChannel") : false)
            ? Container()
            : SizedBox(
                width: double.infinity,
                child: FlatButton(
                  onPressed: _createChannel,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      translation.createChannel,
                      style: drawerItemTextStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  _faqMenu() {
    return FlatButton(
      onPressed: () {
        _launchURL(context, "https://excluzeev.com/faqs");
      },
      child: SizedBox(
        width: double.infinity,
        child: Text(
          translation.faqs,
          style: drawerItemTextStyle,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  _policyMenu() {
    return Column(
      children: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            WidgetUtils.goHowTo(context);
          },
          child: SizedBox(
            width: double.infinity,
            child: Text(
              translation.howTo,
              style: drawerItemTextStyle,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            WidgetUtils.goAbout(context);
          },
          child: SizedBox(
            width: double.infinity,
            child: Text(
              translation.aboutUs,
              style: drawerItemTextStyle,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            WidgetUtils.goLegalDocs(context);
          },
          child: SizedBox(
            width: double.infinity,
            child: Text(
              translation.legalDocs,
              style: drawerItemTextStyle,
              textAlign: TextAlign.left,
            ),
          ),
        ),
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
    Navigator.of(context).pop();
    WidgetUtils.goToAuth(context, replaceAll: false);
  }

  _drawerWidget() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0),
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 75.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // SizedBox(
                      //   height: 32.0,
                      // ),
                      SizedAppLogo(size: 150.0),
                      // SizedBox(
                      //   height: 14.0,
                      // ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Palette.primary,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            user == null
                                ? "Welcome".toUpperCase()
                                : user.displayName.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      _contentCreatorMenu(),
                      _createMenu(),
                      _policyMenu(),
                      _faqMenu(),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20.0,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    user != null
                        ? FlatButton(
                            onPressed: _logout,
                            child: Text(
                              translation.logout,
                              style: drawerItemTextStyle,
                            ))
                        : Container(
                            child: FlatButton(
                                onPressed: () => _login(),
                                child: Text(
                                  translation.login,
                                  style: drawerItemTextStyle,
                                )),
                          ),
                    InkWell(
                      child: Text(
                        translation.copyrights,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      onTap: () {
                        _launchURL(
                            context, "https://excluzeev.com/license-agreement");
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// For Search Bar
  WhiteAppBar _buildAppBar(BuildContext context) {
    return WhiteAppBar(
      iconTheme: IconThemeData(color: Palette.primary),
      textTheme: TextTheme(
        title: Theme.of(context).textTheme.title.copyWith(
              color: Palette.primary,
            ),
      ),
      centerTitle: true,
      title: Text(
        translation.appNameTrailers,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[searchBar.getSearchAction(context)],
    );
  }
  // For Search Bar

  @override
  void initState() {
    _initRemoteConfig();
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (translation == null) translation = Translation.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: searchBar.build(context), //Search bar
      drawer: _drawerWidget(),
      body: HomePage(user),
    );
  }
}
