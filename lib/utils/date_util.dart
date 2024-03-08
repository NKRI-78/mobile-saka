import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:saka/localization/language_constraints.dart';

class DateHelper {
  static String formatDate(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.yMMMMEEEEd("id").format(dateTime);
  }

  static String formatDateTime(String val, BuildContext context) {
    return val.contains("hours ago")
        ? "${val.split(' ')[0]} ${getTranslated("HOURS_AGO", context)}"
        : val.contains("minutes ago")
            ? "${val.split('')[0]}${val.split('')[1]} ${getTranslated("MINUTES_AGO", context)}"
            : val.contains("years ago")
                ? "${val.split('')[0]} ${getTranslated("YEARS_AGO", context)}"
                : val.contains("an hour ago")
                    ? getTranslated("AN_HOUR_AGO", context)
                    : val.contains("days ago")
                        ? "${val.split(' ')[0]} ${getTranslated("DAYS_AGO", context)}"
                        : val.contains("seconds ago")
                            ? getTranslated("SECONDS_AGO", context)
                            : val.contains("a minute ago")
                                ? getTranslated("A_MINUTE_AGO", context)
                                : val.contains("a day ago")
                                    ? getTranslated("A_DAY_AGO", context)
                                    : val;
  }
}
