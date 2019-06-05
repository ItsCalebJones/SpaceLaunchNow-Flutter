import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/util/ads.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/tabs/launches.dart';
import 'package:spacelaunchnow_flutter/views/tabs/news_and_events.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/settings/settings_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

void main() => runApp(new SpaceLaunchNow());

class SpaceLaunchNow extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  static bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Space Launch Now',
        home: new Pages(_firebaseMessaging),
        routes: <String, WidgetBuilder>{});
  }
}

class Pages extends StatefulWidget {
  FirebaseMessaging _firebaseMessaging;

  Pages(this._firebaseMessaging);

  @override
  createState() => new PagesState(_firebaseMessaging);
}

class PagesState extends State<Pages> {
  bool showAds = true;
  TabController controller;

  GlobalKey stickyKey = new GlobalKey();

  PagesState(this._firebaseMessaging);

  FirebaseMessaging _firebaseMessaging;
  int pageIndex = 0;
  AppConfiguration _configuration = new AppConfiguration(
    showAds: true,
    nightMode: false,
    allowOneHourNotifications: true,
    allowTwentyFourHourNotifications: true,
    allowTenMinuteNotifications: false,
    allowStatusChanged: true,
    subscribeNewsAndEvents: true,
    subscribeALL: true,
    subscribeSpaceX: true,
    subscribeNASA: true,
    subscribeArianespace: true,
    subscribeULA: true,
    subscribeRoscosmos: true,
    subscribeRocketLab: true,
    subscribeBlueOrigin: true,
    subscribeNorthrop: true,
    subscribeCAPE: true,
    subscribePLES: true,
    subscribeISRO: true,
    subscribeKSC: true,
    subscribeVAN: true,
    subscribeWallops: true,
    subscribeNZ: true,
    subscribeJapan: true,
    subscribeFG: true,
  );
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    Ads.init('ca-app-pub-9824528399164059/8172962746');

    _prefs.then((SharedPreferences prefs) {
      bool showAds = prefs.getBool("showAds") ?? true;
      bool nightMode = prefs.getBool("nightMode") ?? false;
      bool allowOneHourNotifications =
          prefs.getBool("allowOneHourNotifications") ?? true;
      bool allowTwentyFourHourNotifications =
          prefs.getBool("allowTwentyFourHourNotifications") ?? true;
      bool allowTenMinuteNotifications =
          prefs.getBool("allowTenMinuteNotifications") ?? false;
      bool allowStatusChanged = prefs.getBool("allowStatusChanged") ?? true;
      bool subscribeNewsAndEvents = prefs.getBool("newsAndEvents") ?? true;
      bool subscribeALL = prefs.getBool("subscribeALL") ?? true;
      bool subscribeSpaceX = prefs.getBool("subscribeSpaceX") ?? true;
      bool subscribeNASA = prefs.getBool("subscribeNASA") ?? true;
      bool subscribeArianespace = prefs.getBool("subscribeArianespace") ?? true;
      bool subscribeULA = prefs.getBool("subscribeULA") ?? true;
      bool subscribeRoscosmos = prefs.getBool("subscribeRoscosmos") ?? true;
      bool subscribeRocketLab = prefs.getBool("subscribeRocketLab") ?? true;
      bool subscribeBlueOrigin = prefs.getBool("subscribeBlueOrigin") ?? true;
      bool subscribeNorthrop = prefs.getBool("subscribeNorthrop") ?? true;
      bool subscribeCAPE = prefs.getBool("subscribeCAPE") ?? true;
      bool subscribePLES = prefs.getBool("subscribePLES") ?? true;
      bool subscribeISRO = prefs.getBool("subscribeISRO") ?? true;
      bool subscribeKSC = prefs.getBool("subscribeKSC") ?? true;
      bool subscribeVAN = prefs.getBool("subscribeVAN") ?? true;

      bool subscribeWallops = prefs.getBool("subscribeWallops") ?? true;
      bool subscribeNZ = prefs.getBool("subscribeNZ") ?? true;
      bool subscribeJapan = prefs.getBool("subscribeJapan") ?? true;
      bool subscribeFG = prefs.getBool("subscribeFG") ?? true;

      if (SpaceLaunchNow.isInDebugMode) {
        _firebaseMessaging.subscribeToTopic("flutter_debug_v2");
        _firebaseMessaging.unsubscribeFromTopic("flutter_production_v2");
      } else {
        _firebaseMessaging.subscribeToTopic("flutter_production_v2");
        _firebaseMessaging.unsubscribeFromTopic("flutter_debug_v2");
      }

      if (allowTenMinuteNotifications) {
        _firebaseMessaging.subscribeToTopic("tenMinutes");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("tenMinutes");
      }

      if (allowOneHourNotifications) {
        _firebaseMessaging.subscribeToTopic("oneHour");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("oneHour");
      }

      if (allowTwentyFourHourNotifications) {
        _firebaseMessaging.subscribeToTopic("twentyFourHour");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("twentyFourHour");
      }

      if (subscribeNewsAndEvents) {
        _firebaseMessaging.subscribeToTopic("featured_news");
        _firebaseMessaging.subscribeToTopic("event_notification");
        _firebaseMessaging.subscribeToTopic("event_webcast");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("featured_news");
        _firebaseMessaging.unsubscribeFromTopic("event_notification");
        _firebaseMessaging.unsubscribeFromTopic("event_webcast");
      }

      if (allowStatusChanged) {
        _firebaseMessaging.subscribeToTopic("netstampChanged");
        _firebaseMessaging.subscribeToTopic("success");
        _firebaseMessaging.subscribeToTopic("failure");
        _firebaseMessaging.subscribeToTopic("partial_failure");
        _firebaseMessaging.subscribeToTopic("inFlight");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("netstampChanged");
        _firebaseMessaging.unsubscribeFromTopic("success");
        _firebaseMessaging.unsubscribeFromTopic("failure");
        _firebaseMessaging.unsubscribeFromTopic("partial_failure");
        _firebaseMessaging.unsubscribeFromTopic("inFlight");
      }

      if (subscribeALL) {
        _firebaseMessaging.subscribeToTopic("all");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("all");
      }

      if (subscribeNASA) {
        _firebaseMessaging.subscribeToTopic("nasa");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("nasa");
      }

      if (subscribeArianespace) {
        _firebaseMessaging.subscribeToTopic("arianespace");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("arianespace");
      }

      if (subscribeSpaceX) {
        _firebaseMessaging.subscribeToTopic("spacex");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("spacex");
      }

      if (subscribeBlueOrigin) {
        _firebaseMessaging.subscribeToTopic("blueOrigin");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("blueOrigin");
      }

      if (subscribeRocketLab) {
        _firebaseMessaging.subscribeToTopic("rocketLab");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("rocketLab");
      }

      if (subscribeNorthrop) {
        _firebaseMessaging.subscribeToTopic("northrop");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("northrop");
      }

      if (subscribeKSC) {
        _firebaseMessaging.subscribeToTopic("ksc");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("ksc");
      }

      if (subscribeCAPE) {
        _firebaseMessaging.subscribeToTopic("cape");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("cape");
      }

      if (subscribePLES) {
        _firebaseMessaging.subscribeToTopic("ples");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("ples");
      }

      if (subscribeVAN) {
        _firebaseMessaging.subscribeToTopic("van");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("van");
      }

      if (subscribeRoscosmos) {
        _firebaseMessaging.subscribeToTopic("roscosmos");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("roscosmos");
      }

      if (subscribeULA) {
        _firebaseMessaging.subscribeToTopic("ula");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("ula");
      }

      if (subscribeWallops) {
        _firebaseMessaging.subscribeToTopic("wallops");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("wallops");
      }

      if (subscribeNZ) {
        _firebaseMessaging.subscribeToTopic("newZealand");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("newZealand");
      }

      if (subscribeJapan) {
        _firebaseMessaging.subscribeToTopic("japan");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("japan");
      }

      if (subscribeFG) {
        _firebaseMessaging.subscribeToTopic("frenchGuiana");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("frenchGuiana");
      }

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) {
          print("onMessage: $message");
          _showItemDialog(message);
        },
        onLaunch: (Map<String, dynamic> message) {
          print("onLaunch: $message");
          final String launchId = message['launch_uuid'];
          _navigateToLaunchDetails(launchId);
        },
        onResume: (Map<String, dynamic> message) {
          print("onResume: $message");
          final String launchId = message['launch_uuid'];
          _navigateToLaunchDetails(launchId);
        },
      );
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
      _firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        print("Push Messaging token: $token");
      });

      configurationUpdater(_configuration.copyWith(
          showAds: showAds,
          nightMode: nightMode,
          allowOneHourNotifications: allowOneHourNotifications,
          allowTwentyFourHourNotifications: allowTwentyFourHourNotifications,
          allowTenMinuteNotifications: allowTenMinuteNotifications,
          allowStatusChanged: allowStatusChanged,
          subscribeALL: subscribeALL,
          subscribeSpaceX: subscribeSpaceX,
          subscribeNASA: subscribeNASA,
          subscribeArianespace: subscribeArianespace,
          subscribeULA: subscribeULA,
          subscribeRoscosmos: subscribeRoscosmos,
          subscribeRocketLab: subscribeRocketLab,
          subscribeBlueOrigin: subscribeBlueOrigin,
          subscribeNorthrop: subscribeNorthrop,
          subscribeCAPE: subscribeCAPE,
          subscribePLES: subscribePLES,
          subscribeISRO: subscribeISRO,
          subscribeKSC: subscribeKSC,
          subscribeVAN: subscribeVAN));
    });
    initAds();
  }

  @override
  void dispose() {
    Ads.dispose();
    super.dispose();
  }

  void hideAd() {
    Ads.hideBannerAd();
  }

  ThemeData get theme {
    if (_configuration.nightMode) {
      return kIOSThemeDark;
    } else {
      return defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme;
    }
  }

  ThemeData get barTheme {
    if (_configuration.nightMode) {
      return kIOSThemeDarkBar;
    } else {
      return kIOSThemeBar;
    }
  }

  Widget _buildDialog(BuildContext context, Map<String, dynamic> message) {
    return new AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(message['launch_name']),
          new Text(message['launch_location']),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        new FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _showItemDialog(Map<String, dynamic> message) {
    final String launchId = message['launch_uuid'];
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, message),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToLaunchDetails(launchId);
      }
    });
  }

  void configurationUpdater(AppConfiguration value) {
    setState(() {
      _configuration = value;
    });
  }

  // Create all the pages once and return same instance when required
  PageStorageBucket pageStorageBucket = PageStorageBucket();

  Widget pageChooser() {
    switch (this.pageIndex) {
      case 0:
        checkAd();
        return new LaunchDetailPage(_configuration);
        break;

      case 1:
        checkAd();
        return new LaunchesTabPage(_configuration);
        break;

      case 2:
        checkAd();
        return new NewsAndEventsPage(_configuration);
        break;

      case 3:
        if (Ads.isBannerShowing()) {
          Ads.hideBannerAd();
        }
        return new SettingsPage(_configuration, configurationUpdater);

      default:
        return new Container(
          child: new Center(
              child: new Text('No page found by page chooser.',
                  style: new TextStyle(fontSize: 30.0))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('counter') ?? 0);
    });
    return MaterialApp(
        title: 'Space Launch Now',
        theme: theme,
        routes: <String, WidgetBuilder>{
          '/settings': (BuildContext context) =>
              new SettingsPage(_configuration, configurationUpdater),
        },
        home: new Scaffold(
            body: new PageStorage(
                bucket: pageStorageBucket, child: pageChooser()),
//            floatingActionButton: new Builder(builder: (BuildContext context) {
//              return new FloatingActionButton(
//                  backgroundColor: Colors.blue[400],
//                  child: const Icon(Icons.sort),
//                  onPressed: () =>
//                      Navigator.of(context).pushNamed('/notifications'));
//            }),
//            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: new Theme(
                data: barTheme,
                // sets the inactive color of the `BottomNavigationBar`
                child: new BottomNavigationBar(
                  key: stickyKey,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: pageIndex,
                  onTap: (int tappedIndex) {
                    //Toggle pageChooser and rebuild state with the index that was tapped in bottom navbar
                    setState(() {
                      this.pageIndex = tappedIndex;
                    });
                  },
                  items: <BottomNavigationBarItem>[
                    new BottomNavigationBarItem(
                        icon: new Icon(MaterialCommunityIcons.home),
                        title: new Text("Next")),
                    new BottomNavigationBarItem(
                        title: new Text('Launches'),
                        icon: new Icon(MaterialCommunityIcons.rocket)),
                    new BottomNavigationBarItem(
                        title: new Text('News'),
                        icon: new Icon(MaterialCommunityIcons.calendar)),
                    new BottomNavigationBarItem(
                        title: new Text('Settings'),
                        icon: new Icon(MaterialCommunityIcons.settings)),
                  ],
                ))));
  }

  void _navigateToLaunchDetails(String launchId) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new LaunchDetailPage(_configuration, launchId: launchId);
        },
      ),
    );
  }

  initAds() async {
//    IAPResponse response = await FlutterIap.restorePurchases();
//    List<IAPProduct> productIds = response.products;
//    if (!mounted) return;
//
//    setState(() {
//      if (productIds.length <= 0 && _configuration.showAds) {
//        Ads.showBannerAd();
//      } else {
//        Ads.hideBannerAd();
//      }
//    });
  }

  void checkAd() {
    if (_configuration.showAds) {
      Ads.showBannerAd();
    } else if (!_configuration.showAds) {
      Ads.hideBannerAd();
    }
  }
}
