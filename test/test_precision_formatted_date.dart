
import 'package:logger/logger.dart';
import 'package:spacelaunchnow_flutter/util/date_formatter.dart';

void main() {
  var logger = Logger();
  DateTime now = DateTime.now().subtract(const Duration(hours: 5));
  for (int i = 0; i < 17; i++) {

    logger.i(PrecisionFormattedDate.getPrecisionFormattedDate(i, now, locale: "en_GB"));
    logger.i(PrecisionFormattedDate.getPrecisionFormattedDate(i, now, locale: "en_US"));
    logger.i(PrecisionFormattedDate.getPrecisionFormattedDate(i, now, locale: "fr"));
    logger.i("===========================");
    logger.i(PrecisionFormattedDate.getShortPrecisionFormattedDate(i, now, locale: "en_GB"));
    logger.i(PrecisionFormattedDate.getShortPrecisionFormattedDate(i, now, locale: "en_US"));
    logger.i(PrecisionFormattedDate.getShortPrecisionFormattedDate(i, now, locale: "fr"));
    logger.i("===========================");
  }
}