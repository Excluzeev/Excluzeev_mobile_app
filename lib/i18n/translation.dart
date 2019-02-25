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

  String get appName => 'Excluzeev';
  String get appNameTrailers => 'Excluzeev Trailers';

  String get dot => '•';

  String get space => ' ';

  String get questionMark => '?';

  String get hintSmsCode => '------';

  String get emailHint => Intl.message(
    "Email",
    name: "emailHint"
  );
  String get passwordHint => Intl.message(
      "Password",
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

  String get logout => Intl.message(
    "Log out",
    name: "logout",
  );

  String get forgotLoginDetail => Intl.message(
    "Forgot your password? Please",
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
  String get signUpContentCreator => Intl.message(
    "Sign Up for Content Creator",
    name: "signUpContentCreator",
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
    "Next",
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
  String get myChannels => Intl.message(
    "My Channels",
    name: 'myChannels',
  );
  String get cannotBeEmpty => Intl.message(
    "Field cannot be empty",
    name: 'cannotBeEmpty',
  );
  String get priceError => Intl.message(
    "Cannot be greater 10 or Lessthan 2",
    name: 'targetFundError',
  );
  String get categoryNameLabel => Intl.message(
    "Category",
    name: 'categoryNameLabel',
  );
  String get channelTypeLabel => Intl.message(
    "Channel Type",
    name: 'channelTypeLabel',
  );
  String get titleLabel => Intl.message(
    "Title",
    name: 'titleLabel',
  );
  String get descriptionLabel => Intl.message(
    "Description",
    name: 'descriptionLabel',
  );
  String get thumbnailLabel => Intl.message(
    "Thumbnail",
    name: 'thumbnailLabel',
  );
  String get videoLabel => Intl.message(
    "Add Video",
    name: 'videoLabel',
  );
  String get coverImageLabel => Intl.message(
    "Cover Image",
    name: 'coverImageLabel',
  );
  String get priceLabel => Intl.message(
    "Price",
    name: 'priceLabel',
  );
  String get targetFundLabel => Intl.message(
    "Target Fund",
    name: 'targetFundLabel',
  );
  String get addPhoto => Intl.message(
    "Add Photo",
    name: 'addPhoto',
  );
  String get errorCropPhoto => Intl.message(
    "Unable to crop photo",
    name: 'errorCropPhoto',
  );
  String get addChannel => Intl.message(
    "Add Channel",
    name: 'addChannel',
  );
  String get trailerTitle => Intl.message(
    "Add a trailer",
    name: 'trailerTitle',
  );
  String get trailers => Intl.message(
    "Trailers",
    name: 'trailers',
  );
  String get videoTitle => Intl.message(
    "Add a video",
    name: 'videoTitle',
  );
  String get liveTitle => Intl.message(
    "Start Excluzeev",
    name: 'liveTitle',
  );
  String get next => Intl.message(
    "Next",
    name: 'next',
  );
  String get videos => Intl.message(
    "Videos",
    name: 'videos',
  );
  String get addVideo => Intl.message(
    "Add Video",
    name: 'addVideo',
  );
  String get addTrailer => Intl.message(
    "Add Trailer",
    name: 'addTrailer',
  );
  String get errorLoadTrailers => Intl.message(
    "Loading Trailer Filed",
    name: 'errorLoadTrailers',
  );
  String get errorLoadChannels => Intl.message(
    "Loading Channels Filed",
    name: 'errorLoadChannels',
  );
  String get errorEmptyTrailers => Intl.message(
    "No Trailers found",
    name: 'errorEmptyTrailers',
  );
  String get errorLoadVideos => Intl.message(
    "Loading Videos Filed",
    name: 'errorLoadVideos',
  );
  String get errorEmptyVideos => Intl.message(
    "No Videos found",
    name: 'errorEmptyVideos',
  );
  String get errorEmptyChannels => Intl.message(
    "No Channels found",
    name: 'errorEmptyTrailers',
  );
  String get addCommentLabel => Intl.message(
    "Add Comment",
    name: 'addCommentLabel',
  );
  String get commentEmpty => Intl.message(
    "Invalid Comment",
    name: 'commentEmpty',
  );
  String get errorLoadComments => Intl.message(
    "Loading Comments Failed",
    name: 'errorLoadComments',
  );
  String get noCommentsYet => Intl.message(
    "No Comments yet.",
    name: 'noCommentsYets',
  );
  String get subscribe => Intl.message(
    "Subscribe",
    name: 'subscribe',
  );
  String get donate => Intl.message(
    "Donate",
    name: 'donate',
  );
  String get paymentPreparing => Intl.message(
    "Preparing for payment",
    name: 'paymentPreparing',
  );
  String get paymentFailed => Intl.message(
    "Error Making payment please try again later!",
    name: 'paymentFailed',
  );
  String get paymentFailedLabel => Intl.message(
    "Payment Failed",
    name: 'paymentFailedLabel',
  );
  String get paymentFailedDialogContent => Intl.message(
    "Payment Canceled. Please retry the payment after some time.!",
    name: 'paymentFailedDialogContent',
  );
  String get paymentVerifying => Intl.message(
    "Verifying payment!",
    name: 'paymentVerifying',
  );
  String get startStream => Intl.message(
    "Start Stream",
    name: 'startStream',
  );
  String get startStreamDialogContent => Intl.message(
    "Are you sure you want to start Excluzeev Stream",
    name: 'startStreamDialogContent',
  );
  String get start => Intl.message(
    "Start",
    name: 'start',
  );
  String get cancel => Intl.message(
    "Cancel",
    name: 'cancel',
  );
  String get now => Intl.message(
    "Now",
    name: 'now',
  );
  String get schedule => Intl.message(
    "Schedule",
    name: 'schedule',
  );
  String get selectDate => Intl.message(
    "Select Date",
    name: 'selectDate',
  );
  String get mySubscriptions => Intl.message(
    "My Subscriptions",
    name: 'mySubscriptions',
  );
  String get errorEmptySubscriptions => Intl.message(
    "No Subscriptions Found.",
    name: 'errorEmptySubscriptions',
  );
  String get errorLoadSubscriptions => Intl.message(
    "Error Loading Subscriptions.",
    name: 'errorLoadSubscriptions',
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