class AppConfiguration {
  AppConfiguration({
    required this.allowOneHourNotifications,
    required this.allowTwentyFourHourNotifications,
    required this.allowTenMinuteNotifications,
    required this.allowStatusChanged,
    required this.subscribeNewsAndEvents,
    required this.subscribeSpaceX,
    required this.subscribeNASA,
    required this.subscribeArianespace,
    required this.subscribeULA,
    required this.subscribeRoscosmos,
    required this.subscribeBlueOrigin,
    required this.subscribeRocketLab,
    required this.subscribeNorthrop,
    required this.subscribeCAPE,
    required this.subscribePLES,
    required this.subscribeISRO,
    required this.subscribeKSC,
    required this.subscribeVAN,
    required this.subscribeRussia,
    required this.subscribeChina,
    required this.subscribeWallops,
    required this.subscribeNZ,
    required this.subscribeJapan,
    required this.subscribeFG,
    required this.subscribeALL,
    required this.nightMode,
    required this.showAds,
  });

  bool showAds;
  bool nightMode;
  bool allowOneHourNotifications;
  bool allowTwentyFourHourNotifications;
  bool allowTenMinuteNotifications;
  bool allowStatusChanged;
  bool subscribeNewsAndEvents;
  bool subscribeSpaceX;
  bool subscribeNASA;
  bool subscribeArianespace;
  bool subscribeULA;
  bool subscribeRoscosmos;
  bool subscribeBlueOrigin;
  bool subscribeRocketLab;
  bool subscribeNorthrop;
  bool subscribeCAPE;
  bool subscribePLES;
  bool subscribeISRO;
  bool subscribeKSC;
  bool subscribeVAN;

  bool subscribeRussia;
  bool subscribeChina;
  bool subscribeWallops;
  bool subscribeNZ;
  bool subscribeJapan;
  bool subscribeFG;

  bool subscribeALL;

  AppConfiguration copyWith({
    bool? showAds,
    bool? nightMode,
    bool? allowOneHourNotifications,
    bool? allowTwentyFourHourNotifications,
    bool? allowTenMinuteNotifications,
    bool? allowStatusChanged,
    bool? subscribeNewsAndEvents,
    bool? subscribeSpaceX,
    bool? subscribeNASA,
    bool? subscribeArianespace,
    bool? subscribeULA,
    bool? subscribeRoscosmos,
    bool? subscribeBlueOrigin,
    bool? subscribeRocketLab,
    bool? subscribeNorthrop,
    bool? subscribeCASC,
    bool? subscribeCAPE,
    bool? subscribePLES,
    bool? subscribeISRO,
    bool? subscribeKSC,
    bool? subscribeVAN,
    bool? subscribeRussia,
    bool? subscribeChina,
    bool? subscribeWallops,
    bool? subscribeNZ,
    bool? subscribeJapan,
    bool? subscribeFG,
    bool? subscribeALL,
  }) {
    return AppConfiguration(
      showAds: showAds ?? this.showAds,
      nightMode: nightMode ?? this.nightMode,
      allowOneHourNotifications:
          allowOneHourNotifications ?? this.allowOneHourNotifications,
      allowTwentyFourHourNotifications: allowTwentyFourHourNotifications ??
          this.allowTwentyFourHourNotifications,
      allowTenMinuteNotifications:
          allowTenMinuteNotifications ?? this.allowTenMinuteNotifications,
      allowStatusChanged: allowStatusChanged ?? this.allowStatusChanged,
      subscribeNewsAndEvents:
          subscribeNewsAndEvents ?? this.subscribeNewsAndEvents,
      subscribeSpaceX: subscribeSpaceX ?? this.subscribeSpaceX,
      subscribeNASA: subscribeNASA ?? this.subscribeNASA,
      subscribeArianespace: subscribeArianespace ?? this.subscribeArianespace,
      subscribeULA: subscribeULA ?? this.subscribeULA,
      subscribeRoscosmos: subscribeRoscosmos ?? this.subscribeRoscosmos,
      subscribeBlueOrigin: subscribeBlueOrigin ?? this.subscribeBlueOrigin,
      subscribeRocketLab: subscribeRocketLab ?? this.subscribeRocketLab,
      subscribeNorthrop: subscribeNorthrop ?? this.subscribeNorthrop,
      subscribeCAPE: subscribeCAPE ?? this.subscribeCAPE,
      subscribePLES: subscribePLES ?? this.subscribePLES,
      subscribeISRO: subscribeISRO ?? this.subscribeISRO,
      subscribeKSC: subscribeKSC ?? this.subscribeKSC,
      subscribeVAN: subscribeVAN ?? this.subscribeVAN,
      subscribeRussia: subscribeRussia ?? this.subscribeRussia,
      subscribeChina: subscribeChina ?? this.subscribeChina,
      subscribeWallops: subscribeWallops ?? this.subscribeWallops,
      subscribeNZ: subscribeNZ ?? this.subscribeNZ,
      subscribeJapan: subscribeJapan ?? this.subscribeJapan,
      subscribeFG: subscribeFG ?? this.subscribeFG,
      subscribeALL: subscribeALL ?? this.subscribeALL,
    );
  }
}
