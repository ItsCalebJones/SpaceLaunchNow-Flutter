
import 'package:spacelaunchnow_flutter/util/date_formatter.dart';

void main() {
  DateTime now = new DateTime.now().subtract(const Duration(hours: 5));
  for (int i = 0; i < 17; i++) {

    print(PrecisionFormattedDate.getPrecisionFormattedDate(i, now, locale: "en_GB"));
    print(PrecisionFormattedDate.getPrecisionFormattedDate(i, now, locale: "en_US"));
    print(PrecisionFormattedDate.getPrecisionFormattedDate(i, now, locale: "fr"));
    print("===========================");
    print(PrecisionFormattedDate.getShortPrecisionFormattedDate(i, now, locale: "en_GB"));
    print(PrecisionFormattedDate.getShortPrecisionFormattedDate(i, now, locale: "en_US"));
    print(PrecisionFormattedDate.getShortPrecisionFormattedDate(i, now, locale: "fr"));
    print("===========================");
  }
}