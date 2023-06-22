import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

// https://github.com/dart-lang/i18n/issues/330
// Timezone info still not available in Dart

class PrecisionFormattedDate {
  static String getPrecisionFormattedDate(int datePrecision, DateTime date, {String locale = "en_US"}) {
    date = date.toLocal();
    switch (datePrecision) {
      case 0:
        return DateFormat.jms(locale).addPattern("'-'").add_yMMMMEEEEd().format(date);
      case 1:
        return DateFormat.jm(locale).addPattern("'-'").add_yMMMMEEEEd().format(date);
      case 2:
        // return DateFormat("'[NET]' h:00 a 'on' MMMM dd, yyyy", locale).format(date);
        return DateFormat.jm(locale).addPattern("'(NET) -'").add_yMMMMEEEEd().format(date);
      case 3:
        return DateFormat("'Morning (local)' MMMM dd, yyyy", locale).format(date);
      case 4:
        return DateFormat("'Afternoon (local)' MMMM dd, yyyy", locale).format(date);
      case 5:
        return DateFormat.yMMMMEEEEd(locale).format(date);
      case 6:
        return DateFormat("'Week of'", locale).add_yMMMMEEEEd().format(date);
      case 7:
        return DateFormat("MMMM yyyy", locale).format(date);
      case 8:
        return DateFormat("'Q1' yyyy", locale).format(date);
      case 9:
        return DateFormat("'Q2' yyyy", locale).format(date);
      case 10:
        return DateFormat("'Q3' yyyy", locale).format(date);
      case 11:
        return DateFormat("'Q4' yyyy", locale).format(date);
      case 12:
        return DateFormat("'H1' yyyy", locale).format(date);
      case 13:
        return DateFormat("'H2' yyyy", locale).format(date);
      case 14:
        return DateFormat("'NET' yyyy", locale).format(date);
      case 15:
        return DateFormat("'FY' yyyy", locale).format(date);
      case 16:
        return DateFormat("'Decade' yyyy's'", locale).format(date);
      default:
        return DateFormat.jms(locale).addPattern("'-'").add_yMMMMEEEEd().format(date);
    }
  }
  static String getShortPrecisionFormattedDate(int datePrecision, DateTime date, {String locale = "en_US"}) {
    date = date.toLocal();
    switch (datePrecision) {
      case 0:
        return DateFormat.yMd().format(date);
      case 1:
        return DateFormat.yMd().format(date);
      case 2:
      // return DateFormat("'[NET]' h:00 a 'on' MMMM dd, yyyy", locale).format(date);
        return DateFormat.yMd().format(date);
      case 3:
        return DateFormat.yMd().format(date);
      case 4:
        return DateFormat.yMd().format(date);
      case 5:
        return DateFormat.yMd().format(date);
      case 6:
        return DateFormat.yMd().format(date);
      case 7:
        return DateFormat.yM().format(date);
      case 8:
        return DateFormat.yQQQ().format(date);
      case 9:
        return DateFormat.yQQQ().format(date);
      case 10:
        return DateFormat.yQQQ().format(date);
      case 11:
        return DateFormat.yQQQ().format(date);
      case 12:
        return DateFormat("'H1' yyyy", locale).format(date);
      case 13:
        return DateFormat("'H2' yyyy", locale).format(date);
      case 14:
        return DateFormat("'NET' yyyy", locale).format(date);
      case 15:
        return DateFormat("'FY' yyyy", locale).format(date);
      case 16:
        return DateFormat("'Decade' yyyy's'", locale).format(date);
      default:
        return DateFormat.jms(locale).addPattern("'-'").add_yMMMMEEEEd().format(date);
    }
  }

}