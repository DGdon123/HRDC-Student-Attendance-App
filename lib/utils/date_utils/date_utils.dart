import 'package:intl/intl.dart';

class DateTimeUtils {
  static String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  static DateTime subtractDaysFromCurrentDate(int days) {
    final now = DateTime.now();
    return now.subtract(Duration(days: days));
  }
}
