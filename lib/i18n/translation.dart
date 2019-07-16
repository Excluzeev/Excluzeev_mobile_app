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
  String get appNameTrailers => 'Excluzeev Previews';

  String get dot => '•';

  String get space => ' ';

  String get questionMark => '?';

  String get hintSmsCode => '------';

  String get emailHint => Intl.message("Email", name: "emailHint");
  String get passwordHint => Intl.message("Password", name: "passwordHint");

  String get slogan => 'Stream. Crowdfunding. Social Network.';

  String get loading => Intl.message(
        "Loading...",
        name: "loading",
      );

  String get login => Intl.message(
        "Sign In",
        name: "login",
      );

  String get logout => Intl.message(
        "Sign out",
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
        "Become a Content Creator",
        name: "signUpContentCreator",
      );

  String get menuCallToAction => Intl.message(
        "Call To Action",
        name: "menuCallToAction",
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
        "Field's can't be empty!",
        name: "errorEmptyField",
      );

  String get errorFields => Intl.message(
        "Invalid sign in details",
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
        "Connect Stripe",
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
        "Price should be greater than 1.99",
        name: 'priceError',
      );

  String get priceLess10Error => Intl.message(
        "Cannot be less than 10",
        name: 'priceError',
      );
  String get categoryNameLabel => Intl.message(
        "Category",
        name: 'categoryNameLabel',
      );
  String get categoryNameHintLabel => Intl.message(
        "Select a Category",
        name: 'categoryNameHintLabel',
      );
  String get channelTypeLabel => Intl.message(
        "Channel Type",
        name: 'channelTypeLabel',
      );

  String get channelTierLabel => Intl.message(
        "Channel Tier",
        name: 'channelTierLabel',
      );
  String get titleLabel => Intl.message(
        "Title",
        name: 'titleLabel',
      );
  String get titleVideoHintLabel => Intl.message(
        "Please enter your Video Title",
        name: 'titleVideoHintLabel',
      );
  String get channelLabel => Intl.message(
        "Channel Name",
        name: 'channelLabel',
      );
  String get channelHintLabel => Intl.message(
        "Please enter your Channel Name",
        name: 'channelHintLabel',
      );
  String get descriptionLabel => Intl.message(
        "Description",
        name: 'descriptionLabel',
      );
  String get descriptionHintLabel => Intl.message(
        "Please enter your Channel Description",
        name: 'descriptionHintLabel',
      );
  String get descriptionVideoHintLabel => Intl.message(
        "Please enter your Video Description",
        name: 'descriptionVideoHintLabel',
      );
  String get priceSuffixLabel => Intl.message(
        "CAD \$ per community membership",
        name: 'priceSuffixLabel',
      );
  String priceWarningMsg(String amount) => Intl.message(
        '10% of $amount is for Excluzeev and 5% + 5 cents id paypal fee and remaining amount will credited to you.',
        name: 'priceWarningMsg',
        args: [amount],
      );

  String get priceWarningMsgLearnMore => Intl.message(
        'Learn more about pricing here.',
        name: 'priceWarningMsgLearnMore',
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
  String get subscriptionPriceLabel => Intl.message(
        "Subscription Price",
        name: 'subscriptionPriceLabel',
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
        "Create a Channel",
        name: 'addChannel',
      );
  String get createNow => Intl.message(
        "Create Now",
        name: 'createNow',
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
        "Upload a video",
        name: 'videoTitle',
      );
  String get liveTitle => Intl.message(
        "Start Excluzeev",
        name: 'liveTitle',
      );
  String get excluzeevLive => Intl.message(
        "Excluzeev Live",
        name: 'excluzeevLive',
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
        "Upload Now",
        name: 'addVideo',
      );
  String get addTrailer => Intl.message(
        "Add Trailer",
        name: 'addTrailer',
      );

  String get updateDescription => Intl.message(
        "Update",
        name: 'updateDescription',
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
        name: 'errorEmptyChannels',
      );
  String get addCommentLabel => Intl.message(
        "Type something here to comment",
        name: 'addCommentLabel',
      );
  String get addMessageLabel => Intl.message(
        "Add Message",
        name: 'addMessageLabel',
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
        name: 'noCommentsYet',
      );
  String get errorLoadChat => Intl.message(
        "Loading Chat Failed",
        name: 'errorLoadChat',
      );
  String get noChatsYet => Intl.message(
        "No Chat yet.",
        name: 'noChatsYet',
      );
  String get subscribe => Intl.message(
        "Join this community",
        name: 'subscribe',
      );
  String get subscribed => Intl.message(
        "Joined",
        name: 'subscribed',
      );
  String get donate => Intl.message(
        "Donate",
        name: 'donate',
      );

  String get donate5 => Intl.message(
        "Donate 5\$",
        name: 'donate5',
      );

  String get donate10 => Intl.message(
        "Donate 10\$",
        name: 'donate10',
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

  String get connectingFailedLabel => Intl.message(
        "Connecting Failed",
        name: 'connectingFailedLabel',
      );
  String get paymentFailedDialogContent => Intl.message(
        "Payment Canceled. Please retry the payment after some time.!",
        name: 'paymentFailedDialogContent',
      );

  String get connectingFailedDialogContent => Intl.message(
        "Connecting Canceled. Please retry after some time.!",
        name: 'connectingFailedDialogContent',
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
  String get delete => Intl.message(
        "Delete",
        name: 'delete',
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
        "My Communities",
        name: 'mySubscriptions',
      );
  String get copyrights => Intl.message(
        "©2019. Excluzeev. All Rights Reserved.",
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
  String get deleteDialogTitle => Intl.message(
        "Are you sure to Delete?",
        name: 'deleteDialogTitle',
      );
  String deleteDialogContent(String title) => Intl.message(
        'Delete video "$title"',
        name: 'deleteDialogContent',
        args: [title],
      );

  String get aboutUs => Intl.message('About Us', name: 'aboutUs');
  String get howTo => Intl.message('How To', name: 'howTo');
  String get faqs => Intl.message('FAQ\'s', name: 'faqs');
  String get privacyPolicy =>
      Intl.message('Privacy Policy', name: 'privacyPolicy');
  String get cookiePolicy =>
      Intl.message('Cookie Policy', name: 'cookiePolicy');
  String get contentCreatorPolicy =>
      Intl.message('Content Creator Policy', name: 'contentCreatorPolicy');
  String get termsOfUse => Intl.message('Terms of Use', name: 'termsOfUse');
  String get contentCreatorsTerms =>
      Intl.message('Content Creators Terms', name: 'contentCreatorsTerms');
  String get licenseAgreement =>
      Intl.message('License Agreement', name: 'licenseAgreement');
  String get communityMemberAgreement =>
      Intl.message('Community Member Agreement',
          name: 'communityMemberAgreement');
  String get legalDocs => Intl.message('Legal', name: 'legalDocs');

  String get aboutData => Intl.message(
      'Excluzeev is a streaming platform where content creators feature their exclusive content.\nThere are many steps in the process of content production, and Excluzeev connects all these steps together on its platforms. Excluzeev is about championing diversity within a specific niche. We have created this single destination platform in order to inspire content creators, coaches, and freelancers alike to collaborate creatively and commission boldly.\nTalent need not sacrifice the soul in order to be commercially successful. In fact, we believe in anything but that.Whether you are a full time or a creative part-time content creator looking to explore your options, this is definitely the platform for you.',
      name: 'aboutData');

  String get notAppropriate =>
      Intl.message('Not Appropriate', name: 'notAppropriate');

  // Reasons
  String get nudity => Intl.message('Nudity', name: 'nudity');
  String get violence => Intl.message('Violence', name: 'Violence');
  String get harassment => Intl.message('Harassment', name: 'Harassment');
  String get suicide => Intl.message('Suicide', name: 'suicide');
  String get selfInjury => Intl.message('Self Injury', name: 'selfInjury');
  String get falseNews => Intl.message('False News', name: 'falseNews');
  String get spam => Intl.message('Spam', name: 'spam');
  String get unauthorisedSales =>
      Intl.message('Unauthorised Sales', name: 'unauthorisedSales');
  String get hateSpeech => Intl.message('Hate Speech', name: 'hateSpeech');
  String get terrorism => Intl.message('Terrorism', name: 'terrorism');
  String get other => Intl.message('Other', name: 'other');

  String get typeReason => Intl.message('Type Reason', name: 'typeReason');

  String get reasonError =>
      Intl.message("Please select the reason", name: "reasonError");

  String get reportSuccessful =>
      Intl.message("Trailer Reported succesfully.", name: "reportSuccessful");
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
