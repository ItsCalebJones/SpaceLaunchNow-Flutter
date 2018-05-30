import 'package:flutter/foundation.dart';

class AppConfiguration {
  AppConfiguration({
    @required this.allowOneHourNotifications,
    @required this.allowTwentyFourHourNotifications,
    @required this.allowTenMinuteNotifications,
    @required this.allowStatusChanged,
    @required this.subscribeSpaceX,
    @required this.subscribeNASA,
    @required this.subscribeArianespace,
    @required this.subscribeULA,
    @required this.subscribeRoscosmos,
    @required this.subscribeCASC,
    @required this.subscribeCAPE,
    @required this.subscribePLES,
    @required this.subscribeISRO,
    @required this.subscribeKSC,
    @required this.subscribeVAN,
    @required this.subscribeALL,
    @required this.nightMode,
  })
      : assert (nightMode != null),
        assert(allowOneHourNotifications != null),
        assert(allowTwentyFourHourNotifications != null),
        assert(allowTenMinuteNotifications != null),
        assert(allowStatusChanged != null),
        assert(subscribeSpaceX != null),
        assert(subscribeNASA != null),
        assert(subscribeArianespace != null),
        assert(subscribeULA != null),
        assert(subscribeRoscosmos != null),
        assert(subscribeCASC != null),
        assert(subscribeCAPE != null),
        assert(subscribePLES != null),
        assert(subscribeISRO != null),
        assert(subscribeKSC != null),
        assert(subscribeVAN != null),
        assert(subscribeALL != null);

  bool nightMode;
  bool allowOneHourNotifications;
  bool allowTwentyFourHourNotifications;
  bool allowTenMinuteNotifications;
  bool allowStatusChanged;
  bool subscribeSpaceX;
  bool subscribeNASA;
  bool subscribeArianespace;
  bool subscribeULA;
  bool subscribeRoscosmos;
  bool subscribeCASC;
  bool subscribeCAPE;
  bool subscribePLES;
  bool subscribeISRO;
  bool subscribeKSC;
  bool subscribeVAN;
  bool subscribeALL;

  AppConfiguration copyWith({
    bool nightMode,
    bool allowOneHourNotifications,
    bool allowTwentyFourHourNotifications,
    bool allowTenMinuteNotifications,
    bool allowStatusChanged,
    bool subscribeSpaceX,
    bool subscribeNASA,
    bool subscribeArianespace,
    bool subscribeULA,
    bool subscribeRoscosmos,
    bool subscribeCASC,
    bool subscribeCAPE,
    bool subscribePLES,
    bool subscribeISRO,
    bool subscribeKSC,
    bool subscribeVAN,
    bool subscribeALL,
  }) {
    return new AppConfiguration(
      nightMode: nightMode ?? this.nightMode,
      allowOneHourNotifications: allowOneHourNotifications ??
          this.allowOneHourNotifications,
      allowTwentyFourHourNotifications: allowTwentyFourHourNotifications ??
          this.allowTwentyFourHourNotifications,
      allowTenMinuteNotifications: allowTenMinuteNotifications ??
          this.allowTenMinuteNotifications,
      allowStatusChanged: allowStatusChanged ?? this.allowStatusChanged,
      subscribeSpaceX: subscribeSpaceX ?? this.subscribeSpaceX,
      subscribeNASA: subscribeNASA ?? this.subscribeNASA,
      subscribeArianespace: subscribeArianespace ?? this.subscribeArianespace,
      subscribeULA: subscribeULA ?? this.subscribeULA,
      subscribeRoscosmos: subscribeRoscosmos ?? this.subscribeRoscosmos,
      subscribeCASC: subscribeCASC ?? this.subscribeCASC,
      subscribeCAPE: subscribeCAPE ?? this.subscribeCAPE,
      subscribePLES: subscribePLES ?? this.subscribePLES,
      subscribeISRO: subscribeISRO ?? this.subscribeISRO,
      subscribeKSC: subscribeKSC ?? this.subscribeKSC,
      subscribeVAN: subscribeVAN ?? this.subscribeVAN,
      subscribeALL: subscribeALL ?? this.subscribeALL,
    );
  }
}