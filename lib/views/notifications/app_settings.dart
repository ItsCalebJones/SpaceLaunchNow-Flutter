import 'package:flutter/foundation.dart';

class AppConfiguration {
  AppConfiguration({
    @required this.allowOneHourNotifications,
    @required this.allowTwentyFourHourNotifications,
    @required this.allowTenMinuteNotifications,
  }) : assert(allowOneHourNotifications != null),
  assert(allowTwentyFourHourNotifications != null),
  assert(allowTenMinuteNotifications != null);

  bool allowOneHourNotifications;
  bool allowTwentyFourHourNotifications;
  bool allowTenMinuteNotifications;

  AppConfiguration copyWith({
    bool allowOneHourNotifications,
    bool allowTwentyFourHourNotifications,
    bool allowTenMinuteNotifications
  }) {
    return new AppConfiguration(
        allowOneHourNotifications: allowOneHourNotifications ?? this.allowOneHourNotifications,
        allowTwentyFourHourNotifications: allowTwentyFourHourNotifications ?? this.allowTwentyFourHourNotifications,
        allowTenMinuteNotifications: allowTenMinuteNotifications ?? this.allowTenMinuteNotifications);
  }
}