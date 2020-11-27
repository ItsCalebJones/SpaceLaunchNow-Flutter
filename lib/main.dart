import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/util/ads.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/tabs/launches.dart';
import 'package:spacelaunchnow_flutter/views/tabs/news_and_events.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/settings/settings_page.dart';
import 'package:spacelaunchnow_flutter/views/starshipdashboard/starship_overview_page.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:spacelaunchnow_flutter/views/tabs/starship_dashboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rate_my_app/rate_my_app.dart';

import 'views/homelist/home_list_page.dart';
import 'views/settings/product_store.dart';

RateMyApp _rateMyApp = RateMyApp(
  preferencesPrefix: 'rateMyApp_',
  minDays: 3,
  minLaunches: 3,
  remindDays: 5,
  remindLaunches: 10,
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(new SpaceLaunchNow());
}

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
        debugShowCheckedModeBanner: false,
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

  final List<String> _productLists = [
    '2020_super_fan',
    '2020_gse',
    '2020_launch_director',
    '2020_flight_controller',
    '2020_elon'
  ];
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];
  bool _purchaseRestored = false;

  bool _loading = true;

  GlobalKey stickyKey = new GlobalKey();

  PagesState(this._firebaseMessaging);

  FirebaseMessaging _firebaseMessaging;
  int pageIndex = 0;
  int newsAndEventsIndex = 0;
  int starshipIndex = 0;
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
    subscribeRussia: true,
    subscribeChina: true,
    subscribeWallops: true,
    subscribeNZ: true,
    subscribeJapan: true,
    subscribeFG: true,
  );
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _rateMyApp.init().then((_) {
      if (_rateMyApp.shouldOpenDialog) {
        // Or if you prefer to show a star rating bar :
        _rateMyApp.showStarRateDialog(
          context,
          title: 'Space Launch Now',
          message:
              'Have you enjoyed this app? Then take a little bit of your time to leave a rating:',
          onRatingChanged: (stars) {
            return [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  print('Thanks for the ' +
                      (stars == null ? '0' : stars.round().toString()) +
                      ' star(s) !');
                  // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                  _rateMyApp.doNotOpenAgain = true;
                  _rateMyApp.save().then((v) => Navigator.pop(context));
                },
              ),
            ];
          },
          ignoreIOS: false,
          dialogStyle: DialogStyle(
            titleAlign: TextAlign.center,
            messageAlign: TextAlign.center,
            messagePadding: EdgeInsets.only(bottom: 20),
          ),
          starRatingOptions: StarRatingOptions(),
        );
      }
    });

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
      bool subscribeChina = prefs.getBool("subscribeChina") ?? true;
      bool subscribeRussia = prefs.getBool("subscribeRussia") ?? true;
      bool subscribeWallops = prefs.getBool("subscribeWallops") ?? true;
      bool subscribeNZ = prefs.getBool("subscribeNZ") ?? true;
      bool subscribeJapan = prefs.getBool("subscribeJapan") ?? true;
      bool subscribeFG = prefs.getBool("subscribeFG") ?? true;

      _firebaseMessaging.unsubscribeFromTopic("flutter_production");
      _firebaseMessaging.unsubscribeFromTopic("flutter_debug");

      if (SpaceLaunchNow.isInDebugMode) {
        _firebaseMessaging.subscribeToTopic("flutter_debug_v2");
        _firebaseMessaging.subscribeToTopic("custom");
        _firebaseMessaging.unsubscribeFromTopic("flutter_production_v2");
      } else {
        _firebaseMessaging.subscribeToTopic("flutter_production_v2");
        _firebaseMessaging.unsubscribeFromTopic("flutter_debug_v2");
        _firebaseMessaging.subscribeToTopic("custom");
      }

      if (allowTenMinuteNotifications) {
        _firebaseMessaging.subscribeToTopic("tenMinutes");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("tenMinutes");
      }

      if (allowOneHourNotifications) {
        _firebaseMessaging.subscribeToTopic("oneHour");
        _firebaseMessaging.subscribeToTopic("webcastLive");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("oneHour");
        _firebaseMessaging.unsubscribeFromTopic("webcastLive");
      }

      if (allowTwentyFourHourNotifications) {
        _firebaseMessaging.subscribeToTopic("twentyFourHour");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("twentyFourHour");
      }

      if (subscribeNewsAndEvents) {
        _firebaseMessaging.subscribeToTopic("featured_news");
        _firebaseMessaging.subscribeToTopic("events");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("featured_news");
        _firebaseMessaging.unsubscribeFromTopic("events");
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

      if (subscribeRussia) {
        _firebaseMessaging.subscribeToTopic("russia");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("japan");
      }

      if (subscribeChina) {
        _firebaseMessaging.subscribeToTopic("china");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("china");
      }

      if (subscribeFG) {
        _firebaseMessaging.subscribeToTopic("frenchGuiana");
      } else {
        _firebaseMessaging.unsubscribeFromTopic("frenchGuiana");
      }

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          if (message.containsKey('launch_uuid')) {
            _showLaunchDialog(message);
          }

          if (message['data'].containsKey('notification_type')) {
            if (message['data']['notification_type'] == 'featured_news') {
              changeTab(2);
              newsAndEventsIndex = 0;
              _openBrowser(message['data']['item']['url']);
            } else if (message['data']['notification_type'] ==
                    'event_notification' ||
                message['data']['notification_type'] == 'event_webcast') {
              changeTab(2);
              newsAndEventsIndex = 1;
            }
          }
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          if (message.containsKey('launch_uuid')) {
            _navigateToLaunchDetails(message['launch_uuid']);
          }

          if (message.containsKey('notification_type')) {
            if (message['notification_type'] == 'featured_news') {
              final item = json.decode(message['data']['item']);
              setState(() {
                changeTab(2);
                newsAndEventsIndex = 0;
              });
              _openBrowser(item['url']);
            } else if (message['notification_type'] == 'event_notification' ||
                message['notification_type'] == 'event_webcast') {
              setState(() {
                changeTab(2);
                newsAndEventsIndex = 1;
              });
            }
          }
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          if (message.containsKey('launch_uuid')) {
            _navigateToLaunchDetails(message['launch_uuid']);
          }

          if (message.containsKey('notification_type')) {
            if (message['notification_type'] == 'featured_news') {
              final item = json.decode(message['item']);
              setState(() {
                changeTab(2);
                newsAndEventsIndex = 0;
              });
              _openBrowser(item['url']);
            } else if (message['notification_type'] == 'event_notification' ||
                message['notification_type'] == 'event_webcast') {
              setState(() {
                changeTab(2);
                newsAndEventsIndex = 1;
              });
            }
          } else {
            print("Didn't find anything.");
          }
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
          subscribeRussia: subscribeRussia,
          subscribeChina: subscribeChina,
          subscribeWallops: subscribeWallops,
          subscribeNZ: subscribeNZ,
          subscribeJapan: subscribeJapan,
          subscribeFG: subscribeFG,
          subscribeCAPE: subscribeCAPE,
          subscribePLES: subscribePLES,
          subscribeISRO: subscribeISRO,
          subscribeKSC: subscribeKSC,
          subscribeVAN: subscribeVAN));
    });
    initAds();
    asyncInitState();
  }

  void asyncInitState() async {
    await FlutterInappPurchase.instance.initConnection;
    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }
  }


  void showPendingUI() {
    setState(() {
    });
  }

  void _showAds(bool value) {
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('showAds', value));
    });
  }

  @override
  void dispose() async {
    Ads.dispose();
    super.dispose();
    await FlutterInappPurchase.instance.endConnection;
  }

  void hideAd() {
    Ads.hideBannerAd();
  }

  Future _getProduct() async {
    List<IAPItem> items = await FlutterInappPurchase.instance.getProducts(_productLists);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
      this._purchases = [];
    });
  }

  Future _getPurchaseHistory() async {
    List<PurchasedItem> items = await FlutterInappPurchase.instance.getPurchaseHistory();
    for (var item in items) {
      print('${item.toString()}');
      this._purchases.add(item);
    }

    setState(() {
      this._purchaseRestored = true;
      this._items = [];
      this._purchases = items;
      this._loading = false;
    });
  }

  ThemeData get theme {
    if (_configuration.nightMode) {
      return kIOSThemeDark;
    } else {
      return defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kIOSTheme;
    }
  }

  ThemeData get barTheme {
    bool qDarkmodeEnable;
    var qdarkMode = MediaQuery.of(context).platformBrightness;
    if (qdarkMode == Brightness.dark){
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

  void _showLaunchDialog(Map<String, dynamic> message) {
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
        return new HomeListPage(_configuration);
        break;

      case 1:
        checkAd();
        return new LaunchesTabPage(_configuration);
        break;

      case 2:
        checkAd();
        return new NewsAndEventsPage(_configuration, newsAndEventsIndex);
        break;

      case 3:
        checkAd();
        return new StarshipDashboardPage(_configuration, starshipIndex);
        break;

      case 4:
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

  void changeTab(int index) {
    setState(() {
      this.pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('counter') ?? 0);
    });
    return MaterialApp(
        title: 'Space Launch Now',
        theme: kIOSTheme,
        darkTheme: kIOSThemeDark,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/settings': (BuildContext context) =>
              new SettingsPage(_configuration, configurationUpdater),
        },
        home: new Scaffold(
            body: new PageStorage(
                bucket: pageStorageBucket, child: pageChooser()),
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
                        title: new Text("Home")),
                    new BottomNavigationBarItem(
                        title: new Text('Launches'),
                        icon: new Icon(MaterialCommunityIcons.clipboard)),
                    new BottomNavigationBarItem(
                        title: new Text('News'),
                        icon: new Icon(MaterialCommunityIcons.calendar)),
                    new BottomNavigationBarItem(
                        title: new Text('Starship'),
                        icon: new Icon(FontAwesomeIcons.spaceShuttle)),
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

  initAds() async {}


  void checkAd() async {
    if(!_purchaseRestored) {
      await _getPurchaseHistory();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_purchases.length > 0) {
      prefs.setBool("showAds", false);
    }
    showAds = prefs.getBool("showAds") ?? true;
    if (showAds && !_loading) {
      Ads.showBannerAd();
    } else if (!showAds) {
      Ads.hideBannerAd();
    }
  }

  _openBrowser(String url) async {
    print("Checking $url");
    if (await canLaunch(url)) {
      print("Launching $url");
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
