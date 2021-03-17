import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/util/app_icons.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/tabs/launches.dart';
import 'package:spacelaunchnow_flutter/views/tabs/news_and_events.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/settings/settings_page.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:spacelaunchnow_flutter/views/tabs/starship_dashboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:firebase_core/firebase_core.dart';

import 'views/homelist/home_list_page.dart';

RateMyApp _rateMyApp = RateMyApp(
  preferencesPrefix: 'rateMyApp_',
  minDays: 3,
  minLaunches: 3,
  remindDays: 5,
  remindLaunches: 10,
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: false,
  );

  runApp(new SpaceLaunchNow());
}

class SpaceLaunchNow extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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
    '2021_super_fan',
    '2021_gse',
    '2021_launch_director',
    '2021_flight_controller',
    '2021_elon'
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

    // _rateMyApp.init().then((_) {
    //   if (_rateMyApp.shouldOpenDialog) {
    //     // Or if you prefer to show a star rating bar :
    //     _rateMyApp.showStarRateDialog(
    //       context,
    //       title: 'Space Launch Now',
    //       message:
    //           'Have you enjoyed this app? Then take a little bit of your time to leave a rating:',
    //       onRatingChanged: (stars) {
    //         return [
    //           FlatButton(
    //             child: Text('OK'),
    //             onPressed: () {
    //               print('Thanks for the ' +
    //                   (stars == null ? '0' : stars.round().toString()) +
    //                   ' star(s) !');
    //               // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
    //               _rateMyApp.doNotOpenAgain = true;
    //               _rateMyApp.save().then((v) => Navigator.pop(context));
    //             },
    //           ),
    //         ];
    //       },
    //       ignoreIOS: false,
    //       dialogStyle: DialogStyle(
    //         titleAlign: TextAlign.center,
    //         messageAlign: TextAlign.center,
    //         messagePadding: EdgeInsets.only(bottom: 20),
    //       ),
    //       starRatingOptions: StarRatingOptions(),
    //     );
    //   }
    // });

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


    startBackground();
    requestiOSPermissions();

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });

    asyncInitState();
    checkAd();
  }

  void startBackground() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage?.data['launch_uuid'] != null) {
      _navigateToLaunchDetails(initialMessage.data['launch_uuid']);

      if (initialMessage.data.containsKey('notification_type')) {
        if (initialMessage.data['notification_type'] == 'featured_news') {
          changeTab(2);
          newsAndEventsIndex = 0;
          _openBrowser(initialMessage.data['item']['url']);
        } else if (initialMessage.data['notification_type'] ==
            'event_notification' ||
            initialMessage.data['notification_type'] == 'event_webcast') {
          changeTab(2);
          newsAndEventsIndex = 1;
        }
      }
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == 'chat') {
        _navigateToLaunchDetails(initialMessage.data['launch_uuid']);

        if (initialMessage.data.containsKey('notification_type')) {
          if (initialMessage.data['notification_type'] == 'featured_news') {
            changeTab(2);
            newsAndEventsIndex = 0;
            _openBrowser(initialMessage.data['item']['url']);
          } else if (initialMessage.data['notification_type'] ==
              'event_notification' ||
              initialMessage.data['notification_type'] == 'event_webcast') {
            changeTab(2);
            newsAndEventsIndex = 1;
          }
        }
      }
    });
  }

  void requestiOSPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
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
    super.dispose();
    await FlutterInappPurchase.instance.endConnection;
  }

  void hideAd() {
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

  Widget  pageChooser() {
    switch (this.pageIndex) {
      case 0:
        return new HomeListPage(_configuration);
        break;

      case 1:
        return new LaunchesTabPage(_configuration);
        break;

      case 2:
        return new NewsAndEventsPage(_configuration, newsAndEventsIndex);
        break;

      case 3:
        return new StarshipDashboardPage(_configuration, starshipIndex);
        break;

      case 4:
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
                        icon: new Icon(FontAwesomeIcons.home),
                        title: new Text("Home")),
                    new BottomNavigationBarItem(
                        title: new Text('Launches'),
                        icon: new Icon(MaterialCommunityIcons.clipboard_text)),
                    new BottomNavigationBarItem(
                        title: new Text('News'),
                        icon: new Icon(FontAwesomeIcons.newspaper)),
                    new BottomNavigationBarItem(
                        title: new Text('Starship'),
                        icon: Icon(CustomSLN.starship)),
                    new BottomNavigationBarItem(
                        title: new Text('Settings'),
                        icon: new Icon(MaterialIcons.settings)),
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


  void checkAd() async {
    if(!_purchaseRestored) {
      await _getPurchaseHistory();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(kReleaseMode) {
      print("\n\n\n\nRelease mode!\n\n\n\n\n\n\n");
      if (_purchases.length > 0) {
        prefs.setBool("showAds", false);
      }
    } else{
      print("\n\n\n\nIDK mode!\n\n\n\n\n\n\n");
    }

    showAds = prefs.getBool("showAds") ?? true;
    print("Show ads: $showAds");
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
