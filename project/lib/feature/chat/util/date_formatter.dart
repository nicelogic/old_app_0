import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String getVerboseDateTimeRepresentation(
      BuildContext context, DateTime dateTime,
      {bool timeOnly = false}) {
    if (dateTime.millisecondsSinceEpoch == 0) {
      return '';
    }

    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(const Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();

    if (!localDateTime.difference(justNow).isNegative) {
      return '刚刚';
    }

    String roughTimeString = DateFormat('jm').format(dateTime);

    if (timeOnly ||
        (localDateTime.day == now.day &&
            localDateTime.month == now.month &&
            localDateTime.year == now.year)) {
      return roughTimeString;
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return '昨天';
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday =
          DateFormat('E', Localizations.localeOf(context).toLanguageTag())
              .format(localDateTime);

      return '$weekday, $roughTimeString';
    }

    return DateFormat('yMMMd', Localizations.localeOf(context).toLanguageTag()).format(dateTime);
  }
}
