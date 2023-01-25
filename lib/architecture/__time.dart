import 'package:intl/intl.dart';

class MyTime {
  static String getTime() {
    String time = _formatDateTime(DateTime.now());
    return time;
  }

  static String getDate() {
    String date = DateFormat('dd MMM yyyy, EE').format(DateTime.now());
    date = date.toUpperCase();
    return date;
  }

  static String getDateTime() {
    String week = DateFormat.ABBR_WEEKDAY;
    String dateTime = DateFormat("dd MMM yyyy, ${week.toUpperCase()}, hh:mm:ss a").format(DateTime.now());
    dateTime = dateTime.toUpperCase();
    return dateTime;
  }
}

String _formatDateTime(DateTime dateTime) {
  return DateFormat('hh:mm:ss a').format(dateTime);
}
