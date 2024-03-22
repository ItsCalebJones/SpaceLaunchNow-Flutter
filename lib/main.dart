import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart'; // For standlone app
import 'package:logger/logger.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/util/app_icons.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/settings/settings_page.dart';
import 'package:spacelaunchnow_flutter/views/tabs/launches.dart';
import 'package:spacelaunchnow_flutter/views/tabs/news_and_events.dart';
import 'package:spacelaunchnow_flutter/views/tabs/starship_dashboard.dart';
import 'package:spacelaunchnow_flutter/views/widgets/custom_dialog_box.dart';
import 'package:url_launcher/url_launcher.dart';

import 'firebase_options.dart';
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    debugPrint("Handling a background message: ${message.messageId}");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  MobileAds.instance.initialize();

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: false,
  );
  runApp(const SpaceLaunchNow());
}

class SpaceLaunchNow extends StatelessWidget {

  const SpaceLaunchNow({super.key});

  static bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Space Launch Now',
        debugShowCheckedModeBanner: false,
        home: Pages(),
        routes: <String, WidgetBuilder>{});
  }
}

class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  createState() => PagesState();
}

class PagesState extends State<Pages> {
  bool showAds = true;
  TabController? controller;
  var logger = Logger();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final List<String> _productLists = [
    '2024_super_fan',
    '2024_gse',
    '2024_launch_director',
    '2024_flight_controller',
    '2024_elon',
  ];

  List<PurchasedItem> _purchases = [];
  bool _purchaseRestored = false;

  GlobalKey stickyKey = GlobalKey();

  PagesState();

  int pageIndex = 0;
  int newsAndEventsIndex = 0;
  int starshipIndex = 0;
  AppConfiguration _configuration = AppConfiguration(
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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();

    logger.d(_productLists);

    _rateMyApp.init().then((_) {
      if (_rateMyApp.shouldOpenDialog) {
        _rateMyApp.showRateDialog(
          context,
          title: 'Rate this app',
          message:
              'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
          rateButton: 'RATE',
          noButton: 'NO THANKS',
          laterButton: 'MAYBE LATER',
          listener: (button) {
            switch (button) {
              case RateMyAppDialogButton.rate:
                debugPrint('Clicked on "Rate".');
                break;
              case RateMyAppDialogButton.later:
                debugPrint('Clicked on "Later".');
                break;
              case RateMyAppDialogButton.no:
                debugPrint('Clicked on "No".');
                break;
            }

            return true;
          },
          ignoreNativeDialog: false,
          dialogStyle: const DialogStyle(),
          onDismissed: () =>
              _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      logger.d(message);
      if (message != null) {
        logger.d("Received a new message!");
        if (message.data['launch_uuid'] != null) {
          _navigateToLaunchDetails(message.data['launch_uuid']);
        }

        if (message.data.containsKey('notification_type')) {
          if (message.data['notification_type'] == 'featured_news') {
            changeTab(2);
            newsAndEventsIndex = 0;
            _openBrowser(message.data['item']['url']);
          } else if (message.data['notification_type'] ==
                  'event_notification' ||
              message.data['notification_type'] == 'event_webcast') {
            changeTab(2);
            newsAndEventsIndex = 1;
          }
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.d(message);
      if (message.notification != null) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: message.notification?.title,
                descriptions: message.notification?.body,
                text: "Okay",
              );
            });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint('A new onMessageOpenedApp event was published!');
      }
      if (message.data['launch_uuid'] != null) {
        _navigateToLaunchDetails(message.data['launch_uuid']);
      }

      if (message.data.containsKey('notification_type')) {
        if (message.data['notification_type'] == 'featured_news') {
          changeTab(2);
          newsAndEventsIndex = 0;
          _openBrowser(message.data['item']['url']);
        } else if (message.data['notification_type'] == 'event_notification' ||
            message.data['notification_type'] == 'event_webcast') {
          changeTab(2);
          newsAndEventsIndex = 1;
        }
      }
    });

    _prefs.then((SharedPreferences prefs) {
      bool showAds = prefs.getBool("showAds") ?? true;
      bool appInitialized = prefs.getBool("appInitialized") ?? false;
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

      logger.d(
          "Initialized: $appInitialized - Debug: ${SpaceLaunchNow.isInDebugMode}");
      _firebaseMessaging.unsubscribeFromTopic("flutter_production");
      _firebaseMessaging.unsubscribeFromTopic("flutter_debug");
      _firebaseMessaging.unsubscribeFromTopic("flutter_production_v2");
      _firebaseMessaging.unsubscribeFromTopic("flutter_debug_v2");

      if (SpaceLaunchNow.isInDebugMode) {
        _firebaseMessaging.subscribeToTopic("flutter_debug_v3");
        _firebaseMessaging.unsubscribeFromTopic("flutter_production_v3");
        _firebaseMessaging.subscribeToTopic("custom");
      } else {
        _firebaseMessaging.subscribeToTopic("flutter_production_v3");
        _firebaseMessaging.unsubscribeFromTopic("flutter_debug_v3");
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
      prefs.setBool("appInitialized", true);

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
    asyncInitState();
    checkAd();
  }

  void startBackground() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    logger.d(initialMessage);

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage?.data['launch_uuid'] != null) {
      _navigateToLaunchDetails(initialMessage!.data['launch_uuid']);

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
      logger.d(message);
      if (message.data['type'] == 'chat') {
        _navigateToLaunchDetails(initialMessage!.data['launch_uuid']);

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

    logger.d('User granted permission: ${settings.authorizationStatus}');
  }

  void asyncInitState() async {
    initializeDateFormatting(await findSystemLocale(), null);
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      var result = await FlutterInappPurchase.instance.initialize();
      logger.d(result);
      // refresh items for android
      try {
        String? msg = await (FlutterInappPurchase.instance.consumeAll()
        as FutureOr<String?>);
        logger.d('consumeAllItems: $msg');
      } catch (err) {
        logger.d('consumeAllItems error: $err');
      }
    }
  }

  void showPendingUI() {
    setState(() {});
  }



  @override
  void dispose() async {
    super.dispose();
  }


  Future _getPurchaseHistory() async {
    List<PurchasedItem>? items = await FlutterInappPurchase.instance.getPurchaseHistory();
    for (var item in items!) {
      _purchases.add(item);
    }

    setState(() {
      _purchaseRestored = true;
      _purchases = items;
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


  void configurationUpdater(AppConfiguration value) {
    setState(() {
      _configuration = value;
    });
  }

  // Create all the pages once and return same instance when required
  PageStorageBucket pageStorageBucket = PageStorageBucket();

  Widget pageChooser() {
    switch (pageIndex) {
      case 0:
        return const HomeListPage();

      case 1:
        return const LaunchesTabPage();

      case 2:
        return NewsAndEventsPage(newsAndEventsIndex);

      case 3:
        return StarshipDashboardPage(starshipIndex);

      case 4:
        return SettingsPage(_configuration, configurationUpdater);

      default:
        return const Center(
            child: Text('No page found by page chooser.',
                style: TextStyle(fontSize: 30.0)));
    }
  }

  void changeTab(int index) {
    setState(() {
      pageIndex = index;
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
              SettingsPage(_configuration, configurationUpdater),
        },
        home: Scaffold(
            body: PageStorage(bucket: pageStorageBucket, child: pageChooser()),
            bottomNavigationBar: NavigationBar(
              elevation: 20,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              selectedIndex: pageIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  pageIndex = index;
                });
              },
              destinations: const [
              NavigationDestination(
                  icon: Icon(FontAwesomeIcons.house), label: 'Explore'),
              NavigationDestination(
                  icon: Icon(MaterialCommunityIcons.clipboard_text),
                  label: 'Launches'),
              NavigationDestination(
                  icon: Icon(FontAwesomeIcons.newspaper), label: 'News'),
              NavigationDestination(icon: Icon(CustomSLN.starship), label: 'Starship'),
              NavigationDestination(icon: Icon(MaterialIcons.settings), label: 'Settings'),
            ],
          ),
      )
    );
  }

  void _navigateToLaunchDetails(String? launchId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) {
          return LaunchDetailPage(launchId: launchId);
        },
      ),
    );
  }

  void checkAd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool initialRestoreAttempted =
        prefs.getBool("initialRestoreAttempted") ?? false;

    if (!_purchaseRestored && !initialRestoreAttempted) {
      await _getPurchaseHistory();
      prefs.setBool("initialRestoreAttempted", true);
    }

    if (kReleaseMode) {
      debugPrint("\n\n\n\nRelease mode!\n\n\n\n\n\n\n");
      if (_purchases.isNotEmpty) {
        prefs.setBool("showAds", false);
      }
    } else {
      debugPrint("\n\n\n\nIDK mode!\n\n\n\n\n\n\n");
    }

    showAds = prefs.getBool("showAds") ?? true;
    debugPrint("Show ads: $showAds");
  }

  _openBrowser(String url) async {
    debugPrint("Checking $url");
    var url0 = Uri.parse(url);
    if (await canLaunchUrl(url0)) {
      debugPrint("Launching $url");
      await launchUrl(url0);
    } else {
      throw 'Could not launch $url';
    }
  }
}
