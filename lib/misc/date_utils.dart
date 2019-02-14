import 'dart:ui' show Locale;

import 'package:intl/intl.dart';
import 'package:meta/meta.dart' show required;
import 'package:timeago/timeago.dart' as timeago;

class DateUtils {
  static init() async {
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    timeago.setLocaleMessages('pt_BR_short', timeago.PtBrShortMessages());
  }

  static String formatDateTime(DateTime dateTime) =>
      DateFormat.yMd().add_Hms().format(dateTime);

  static String getLocalizedTimeAgo(DateTime dateTime,
          {@required Locale locale}) =>
      timeago.format(dateTime, locale: locale.toString());
}
