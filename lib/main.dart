import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/util/ads.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/launchlist/previous_launches_list_page.dart';
import 'package:spacelaunchnow_flutter/views/launchlist/upcoming_launches_list_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/settings/settings_page.dart';
import 'package:flutter_iap/flutter_iap.dart';

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
      subscribeALL: true,
      subscribeSpaceX: true,
      subscribeNASA: true,
      subscribeArianespace: true,
      subscribeULA: true,
      subscribeRoscosmos: true,
      subscribeCASC: true,
      subscribeCAPE: true,
      subscribePLES: true,
      subscribeISRO: true,
      subscribeKSC: true,
      subscribeVAN: true);
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
      bool subscribeALL = prefs.getBool("subscribeALL") ?? true;
      bool subscribeSpaceX = prefs.getBool("subscribeSpaceX") ?? true;
      bool subscribeNASA = prefs.getBool("subscribeNASA") ?? true;
      bool subscribeArianespace = prefs.getBool("subscribeArianespace") ?? true;
      bool subscribeULA = prefs.getBool("subscribeULA") ?? true;
      bool subscribeRoscosmos = prefs.getBool("subscribeRoscosmos") ?? true;
      bool subscribeCASC = prefs.getBool("subscribeCASC") ?? true;
      bool subscribeCAPE = prefs.getBool("subscribeCAPE") ?? true;
      bool subscribePLES = prefs.getBool("subscribePLES") ?? true;
      bool subscribeISRO = prefs.getBool("subscribeISRO") ?? true;
      bool subscribeKSC = prefs.getBool("subscribeKSC") ?? true;
      bool subscribeVAN = prefs.getBool("subscribeVAN") ?? true;

      if (SpaceLaunchNow.isInDebugMode){
        _firebaseMessaging.subscribeToTopic("flutter_debug");
        _firebaseMessaging.unsubscribeFromTopic("flutter_production");
      } else {
        _firebaseMessaging.subscribeToTopic("flutter_production");
        _firebaseMessaging.unsubscribeFromTopic("flutter_debug");
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

      if (allowStatusChanged) {
        _firebaseMessaging.subscribeToTopic("netstampChanged");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("netstampChanged");
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

      if (subscribeCASC) {
        _firebaseMessaging.subscribeToTopic("casc");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("casc");
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

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) {
          print("onMessage: $message");
          _showItemDialog(message);
        },
        onLaunch: (Map<String, dynamic> message) {
          print("onLaunch: $message");
          final int launchId = int.parse(message['launch_id']);
          _navigateToLaunchDetails(launchId);
        },
        onResume: (Map<String, dynamic> message) {
          print("onResume: $message");
          final int launchId = int.parse(message['launch_id']);
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
          subscribeCASC: subscribeCASC,
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
    final int launchId = int.parse(message['launch_id']);
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
        return new UpcomingLaunchListPage(_configuration);
        break;

      case 2:
        checkAd();
        return new PreviousLaunchListPage(_configuration);
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
    return new MaterialApp(
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
                        icon: new Icon(Icons.home), title: new Text("Next")),
                    new BottomNavigationBarItem(
                        title: new Text('Upcoming'),
                        icon: new Icon(Icons.assignment)),
                    new BottomNavigationBarItem(
                        title: new Text('Previous'),
                        icon: new Icon(Icons.history)),
                    new BottomNavigationBarItem(
                        title: new Text('Settings'),
                        icon: new Icon(Icons.settings)),
                  ],
                ))));
  }

  void _navigateToLaunchDetails(int launchId) {
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
