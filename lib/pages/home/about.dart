import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/widgets/full_app_logo.dart';
import 'package:trenstop/widgets/white_app_bar.dart';
import 'package:url_launcher/url_launcher.dart' as uLaunch;

class AboutPage extends StatelessWidget {
  static String TAG = "ABOUT_PAGE";

  Translation translation;

  _socialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
            onPressed: () {
              uLaunch.launch("https://www.facebook.com/excluzeev");
            },
            icon: ImageIcon(
              AssetImage("res/icons/facebook.png"),
              size: 50.0,
              color: Palette.primary,
            )),
        IconButton(
            onPressed: () {
              uLaunch.launch("https://www.instagram.com/excluzeev/");
            },
            icon: ImageIcon(
              AssetImage("res/icons/instagram.png"),
              size: 50.0,
              color: Palette.primary,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    translation = Translation.of(context);

    return Scaffold(
      appBar: WhiteAppBar(
        title: Text(translation.aboutUs),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedAppLogo(),
              Text(
                translation.aboutData,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 16.0,
              ),
              _socialIcons(),
            ],
          ),
        ),
      ),
    );
  }
}
