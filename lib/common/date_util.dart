import 'package:intl/intl.dart';

class DateUtil {
  static String formatMilliseconds(int? milliseconds, {DateFormat? format}) {
    if (milliseconds == null || milliseconds == 0) return '';
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds).toLocal();
    DateFormat localFormat = format ?? DateFormat.yMd(/* Get.deviceLocale?.toLanguageTag() */).add_jm();
    return localFormat.format(dateTime);
  }

  static String formatString(String? date, {DateFormat? format}) {
    if (date == null || date.isEmpty) return '';
    DateTime dateTime = DateTime.parse(date).toLocal();
    DateFormat localFormat = format ?? DateFormat.yMd(/* Get.deviceLocale?.toLanguageTag() */).add_jm();
    return localFormat.format(dateTime);
  }
}