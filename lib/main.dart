import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/misc/palette.dart';
import 'package:trenstop/pages/splash_screen.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        Translation.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        const Locale('en', ''),
      ],
      theme: ThemeData(
        primaryColorBrightness: Brightness.dark,
        primaryColor: Palette.primary,
        accentColor: Palette.primary,
        cursorColor: Palette.primary,
        buttonColor: Palette.primary,
        fontFamily: 'Montserrat',
      ),
      onGenerateTitle: (ctx) => Translation.of(ctx).appName,
      home: SplashScreen(),
    );
  }
}