import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:trenstop/widgets/white_app_bar.dart';
import 'package:trenstop/i18n/translation.dart';

class LeagalLinks extends StatelessWidget {
  static String TAG = "LEGAL_LINKS";

  Translation translation;
  TextStyle drawerItemTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0);


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
  
  @override
  Widget build(BuildContext context) {
    translation = Translation.of(context);

    return Scaffold(
      appBar: WhiteAppBar(
        title: Text(translation.legalDocs),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
        children: <Widget>[
          FlatButton(
            onPressed: () { _launchURL(context, "https://excluzeev.com/license-agreement"); },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                translation.termsOfUse,
                style: drawerItemTextStyle,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Divider(),
          FlatButton(
            onPressed: () { _launchURL(context, "https://excluzeev.com/privacy-policy"); },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                translation.privacyPolicy,
                style: drawerItemTextStyle,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Divider(),
          FlatButton(
            onPressed: () { _launchURL(context, "https://excluzeev.com/content-creator-policy"); },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                translation.contentCreatorPolicy,
                style: drawerItemTextStyle,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Divider(),
          FlatButton(
            onPressed: () { _launchURL(context, "https://excluzeev.com/cookie-policy"); },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                translation.cookiePolicy,
                style: drawerItemTextStyle,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
    ),
      ),
    );
  }
}