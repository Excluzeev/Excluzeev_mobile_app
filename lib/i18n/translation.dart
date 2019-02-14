import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:trenstop/i18n/messages_all.dart';
import 'package:trenstop/misc/date_utils.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
// flutter packages pub run intl_translation:extract_to_arb --output-dir=lib/i18n lib/i18n/translation.dart
// flutter packages pub run intl_translation:generate_from_arb --output-dir=lib/i18n --no-use-deferred-loading lib/i18n/translation.dart lib/i18n/intl_*.arb

// flutter packages pub run intl_translation:extract_to_arb --output-dir=lib/i18n lib/i18n/translation.dart && flutter packages pub run intl_translation:generate_from_arb --output-dir=lib/i18n --no-use-deferred-loading lib/i18n/translation.dart lib/i18n/intl_*.arb

class Translation {
  static const String TAG = "I18N";
  static const _TranslationDelegate delegate = const _TranslationDelegate();


  static Future<Translation> load(Locale locale) {
    Logger.log(TAG, message: "Loading for locale: $locale");
    final String name =
    locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      initializeDateFormatting(localeName);
      DateUtils.init();
      return Translation();
    });
  }

  static Translation of(BuildContext context) {
    return Localizations.of<Translation>(context, Translation);
  }

  String get appName => 'TrenStop';

  String get dot => '•';

  String get space => ' ';

  String get questionMark => '?';

  String get hintSmsCode => '------';

  String get emailHint => Intl.message(
    "Enter email",
    name: "emailHint"
  );
  String get passwordHint => Intl.message(
      "Enter password",
      name: "passwordHint"
  );

  String get slogan => 'Stream. Crowdfunding. Social Network.';

  String get loading => Intl.message(
    "Loading...",
    name: "loading",
  );

  String get login => Intl.message(
    "Log In",
    name: "login",
  );

  String get forgotLoginDetail => Intl.message(
    "Forgot your login details? Please",
    name: "forgotLoginDetail",
  );

  String get tapHere => Intl.message(
    " tap here!",
    name: "tapHere",
  );

  String get signUp => Intl.message(
    "Sign Up",
    name: "signUp",
  );
  String get resetPassword => Intl.message(
    "Reset Password",
    name: "resetPassword",
  );

  String get invalidEmail => Intl.message(
    "Invalid Email",
    name: "invalidEmail",
  );

  String get errorEmptyField => Intl.message(
    "This field can't be empty!",
    name: "errorEmptyField",
  );

  String get errorFields => Intl.message(
    "Invalid login details",
    name: "errorFields",
  );

  String get errorEmailFormat => Intl.message(
    "Invalid e-mail format",
    name: "errorEmailFormat",
  );

  String get errorPasswordFormat => Intl.message(
    "Password should be at least 8 characters long!",
    name: "errorPasswordFormat",
  );

  String get passwordVerifyHint => Intl.message(
    'Password confirmation',
    name: 'passwordVerifyHint',
  );

  String get errorPasswordMatch => Intl.message(
    "Passwords don't match!",
    name: 'errorPasswordMatch',
  );


  String get cameraLabel => Intl.message(
    "Take photo",
    name: "cameraLabel",
  );

  String get galleryLabel => Intl.message(
    "Pick from gallery",
    name: "galleryLabel",
  );

  String get errorUpdateUser => Intl.message(
    "Unable to update your user information, please try again!",
    name: 'errorUpdateUser',
  );

  String get errorSignIn => Intl.message(
    "Couldn't sign in! Please try again.",
    name: 'errorSignIn',
  );
  String get noAccountFound => Intl.message(
    "No Account Found.",
    name: 'noAccountFound',
  );

  String get unknownError => Intl.message(
    "Unknown Error",
    name: 'unknownError',
  );

  String get or => Intl.message(
    "OR",
    name: 'or',
  );
  String get firstNameLabel => Intl.message(
    "First Name",
    name: 'firstNameLabel',
  );
  String get lastNameLabel => Intl.message(
    "Last Name",
    name: 'lastNameLabel',
  );

  String get resetEmailSent => Intl.message(
    "Reset Email Sent Succesfully. Please check your email.",
    name: 'resetEmailSent',
  );

  String get resetEmailFailed => Intl.message(
    "No Account found with this email",
    name: 'resetEmailFailed',
  );

  String get contentCreatorAuthSave => Intl.message(
    "Update",
    name: 'contentCreatorAuthSave',
  );
  String get paypalEmail => Intl.message(
    "Enter Paypal Email",
    name: 'paypalEmail',
  );
  String get createChannel => Intl.message(
    "Create Channel",
    name: 'createChannel',
  );
}

class _TranslationDelegate extends LocalizationsDelegate<Translation> {
  const _TranslationDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'pt', 'es'].contains(locale.languageCode);

  @override
  Future<Translation> load(Locale locale) => Translation.load(locale);

  @override
  bool shouldReload(_TranslationDelegate old) => false;
}