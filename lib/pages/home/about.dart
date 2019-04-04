import 'package:flutter/material.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/widgets/full_app_logo.dart';
import 'package:trenstop/widgets/white_app_bar.dart';

class AboutPage extends StatelessWidget {
  static String TAG = "ABOUT_PAGE";

  Translation translation;

  @override
  Widget build(BuildContext context) {
    translation = Translation.of(context);
    
    return Scaffold(
      appBar: WhiteAppBar(
        title: Text(translation.aboutUs),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedAppLogo(),
            Text(
              translation.aboutData,
              style: TextStyle(
                fontSize: 18.0
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}