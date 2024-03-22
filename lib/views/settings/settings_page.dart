import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/util/url_helper.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/material/dialog';

  const SettingsPage(this.configuration, this.updater, {super.key});

  final AppConfiguration configuration;
  final ValueChanged<AppConfiguration> updater;


  @override
  State<SettingsPage> createState() => NotificationFilterPageState();
}

class NotificationFilterPageState extends State<SettingsPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  var logger = Logger();

  NotificationFilterPageState();

  final List<String> _productLists = [
    "2024_super_fan",
    "2024_gse",
    "2024_flight_controller",
    "2024_launch_director",
    "2024_elon",
  ];

  final List<String> _notFoundIds = [];
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];
  // final bool _isAvailable = false;
  bool _loading = true;

  StreamSubscription? purchaseUpdatedSubscription;
  StreamSubscription? purchaseErrorSubscription;
  StreamSubscription? connectionSubscription;

  @override
  initState() {
    super.initState();
    asyncInitState();
    init();
    
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      logger.d("$appName - $packageName $version $buildNumber");
    });
  }

  // Gets past purchases
  Future _getPurchaseHistory({bool initial = true}) async {
    logger.d("Starting thing");
    List<PurchasedItem>? items = await FlutterInappPurchase.instance.getPurchaseHistory();
    logger.d("Oh hi $items");
    for (var item in items!) {
      logger.d(item.toString());
      _purchases.add(item);
    }

    setState(() {
      _purchases = items;
    });

    if (!initial) {
      if (_purchases.isNotEmpty) {
        sendUpdates(widget.configuration.copyWith(showAds: false));
        _prefs.then((SharedPreferences prefs) {
          return (prefs.setBool('showAds', false));
        });
        const snackBar = SnackBar(
          content:
              Text('Purchase history restored - thank you for your support!'),
          duration: Duration(seconds: 5),
        );
        _snackBar(snackBar);
      } else {
        const snackBar = SnackBar(
          content: Text('Purchase history restored - no purchases found.'),
          duration: Duration(seconds: 5),
        );
        _snackBar(snackBar);
      }
    }
  }

  void _snackBar(SnackBar snackBar){
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void asyncInitState() async {
    await FlutterInappPurchase.instance.initialize();

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      logger.d('consumeAllItems: $msg');
    } catch (err) {
      logger.d('consumeAllItems error: $err');
    }

    connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      logger.d('connected: $connected');
    });

    purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      logger.d('purchase-updated: $productItem');
      if (productItem != null) {
        _getPurchaseHistory(initial: true);
      }
    });

    purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      logger.d('purchase-error: $purchaseError');
      if (!purchaseError!.message!.contains("Cancelled")) {
        var message = purchaseError.message;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $message'),
        ));
      }
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  init() async {
    logger.d("async call");
    await _getPurchaseHistory(initial: true);
    await _getProduct();
    setState(() {
      logger.d("setting loading false");
      _loading = false;
    });
  }

  Future _getProduct() async {
    logger.d("Looking for $_productLists");
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(_productLists);
    logger.d("Got some items $items");
    for (var item in items) {
      logger.d(item.toString());
      _items.add(item);
    }
    _items.sort(
        (a, b) => double.parse(a.price!).compareTo(double.parse(b.price!)));

    setState(() {
      _items = _items;
    });
  }

  void _requestPurchase(IAPItem item) {
    FlutterInappPurchase.instance.requestPurchase(item.productId!);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Sending purchase request to Apple.'),
    ));
  }

  // void _handleNightMode(bool value) {
  //   sendUpdates(widget.configuration.copyWith(nightMode: value));
  //   _prefs.then((SharedPreferences prefs) {
  //     return (prefs.setBool('nightMode', value));
  //   });
  // }

  void _handleDebugSupporter(bool value) {
    logger.d("Debug supporters: $value");
    sendUpdates(widget.configuration.copyWith(showAds: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('showAds', value));
    });
  }

  void _handleNews(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("featured_news");
      _firebaseMessaging.subscribeToTopic("events");
    } else {
      _firebaseMessaging.unsubscribeFromTopic("featured_news");
      _firebaseMessaging.unsubscribeFromTopic("events");
    }

    sendUpdates(widget.configuration.copyWith(subscribeNewsAndEvents: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('newsAndEvents', value));
    });
  }

  void _handleOneHour(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("oneHour");
    } else {
      _firebaseMessaging.unsubscribeFromTopic("oneHour");
    }
    sendUpdates(
        widget.configuration.copyWith(allowOneHourNotifications: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('allowOneHourNotifications', value));
    });
  }

  void _handleTwentyFourHour(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("twentyFourHour");
    } else {
      _firebaseMessaging.unsubscribeFromTopic("twentyFourHour");
    }
    _firebaseMessaging.subscribeToTopic("twentyFourHour");
    sendUpdates(
        widget.configuration.copyWith(allowTwentyFourHourNotifications: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('allowTwentyFourHourNotifications', value));
    });
  }

  void _handleTenMinute(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("tenMinutes");
    } else {
      _firebaseMessaging.unsubscribeFromTopic("tenMinutes");
    }
    sendUpdates(
        widget.configuration.copyWith(allowTenMinuteNotifications: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('allowTenMinuteNotifications', value));
    });
  }

  void _handleStatusChanged(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("netstampChanged");
    } else {
      _firebaseMessaging.unsubscribeFromTopic("netstampChanged");
    }
    sendUpdates(widget.configuration.copyWith(allowStatusChanged: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('allowStatusChanged', value));
    });
  }

  void _handleAll(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("all");
      setState(() {
        if (!widget.configuration.subscribeALL) {
          widget.configuration.subscribeALL = true;
          widget.configuration.subscribeSpaceX = true;
          widget.configuration.subscribeNASA = true;
          widget.configuration.subscribeULA = true;
          widget.configuration.subscribeBlueOrigin = true;
          widget.configuration.subscribeRocketLab = true;
          widget.configuration.subscribeNorthrop = true;
          widget.configuration.subscribeArianespace = true;

          widget.configuration.subscribeCAPE = true;
          widget.configuration.subscribeRoscosmos = true;
          widget.configuration.subscribeISRO = true;
          widget.configuration.subscribeVAN = true;
          widget.configuration.subscribeWallops = true;
          widget.configuration.subscribeNZ = true;
          widget.configuration.subscribeJapan = true;
          widget.configuration.subscribeFG = true;
          widget.configuration.subscribeChina = true;
          widget.configuration.subscribeRussia = true;

          _handleSpaceX(true);
          _handleNASA(true);
          _handleULA(true);
          _handleBlueOrigin(true);
          _handleRocketLab(true);
          _handleNorthrop(true);
          _handleArianespace(true);
          _handleCAPE(true);
          _handleRoscosmos(true);
          _handleISRO(true);
          _handleVAN(true);
          _handleWallops(true);
          _handleNZ(true);
          _handleJapan(true);
          _handleFG(true);
          _handleRussia(true);
          _handleChina(true);
        }
      });
    } else {
      _firebaseMessaging.unsubscribeFromTopic("all");
    }
    sendUpdates(widget.configuration.copyWith(subscribeALL: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeALL', value));
    });
  }

  void _handleULA(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("ula");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("ula");
    }
    sendUpdates(widget.configuration.copyWith(subscribeULA: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeULA', value));
    });
  }

  void _handleSpaceX(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("spacex");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("spacex");
    }
    sendUpdates(widget.configuration.copyWith(subscribeSpaceX: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeSpaceX', value));
    });
  }

  void _handleNASA(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("nasa");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("nasa");
    }
    sendUpdates(widget.configuration.copyWith(subscribeNASA: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeNASA', value));
    });
  }

  void _handleArianespace(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("arianespace");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("arianespace");
    }
    sendUpdates(widget.configuration.copyWith(subscribeArianespace: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeArianespace', value));
    });
  }

  void _handleBlueOrigin(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("blueOrigin");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("blueOrigin");
    }
    sendUpdates(widget.configuration.copyWith(subscribeBlueOrigin: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeBlueOrigin', value));
    });
  }

  void _handleRocketLab(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("rocketLab");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("rocketLab");
    }
    sendUpdates(widget.configuration.copyWith(subscribeRocketLab: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeRocketLab', value));
    });
  }

  void _handleNorthrop(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("northrop");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("northrop");
    }
    sendUpdates(widget.configuration.copyWith(subscribeNorthrop: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeNorthrop', value));
    });
  }

  void _handleRussia(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("russia");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("russia");
    }
    sendUpdates(widget.configuration.copyWith(subscribeRussia: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeRussia', value));
    });
  }

  void _handleISRO(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("isro");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("isro");
    }
    sendUpdates(widget.configuration.copyWith(subscribeISRO: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeISRO', value));
    });
  }

  void _handleVAN(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("van");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("van");
    }
    sendUpdates(widget.configuration.copyWith(subscribeVAN: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeVAN', value));
    });
  }

  void _handleKSC(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("ksc");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("ksc");
    }
    sendUpdates(widget.configuration.copyWith(subscribeKSC: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeKSC', value));
    });
  }

  void _handleChina(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("china");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("china");
    }
    sendUpdates(widget.configuration.copyWith(subscribeChina: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeChina', value));
    });
  }

  void _handleCAPE(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("cape");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("cape");
    }
    _handleKSC(value);
    sendUpdates(widget.configuration.copyWith(subscribeCAPE: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeCAPE', value));
    });
  }

  void _handlePLES(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("ples");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("ples");
    }
    sendUpdates(widget.configuration.copyWith(subscribePLES: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribePLES', value));
    });
  }

  void _handleRoscosmos(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("roscosmos");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("roscosmos");
    }
    _handlePLES(value);
    sendUpdates(widget.configuration.copyWith(subscribeRoscosmos: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeRoscosmos', value));
    });
  }

  void _handleWallops(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("wallops");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("wallops");
    }
    sendUpdates(widget.configuration.copyWith(subscribeWallops: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeWallops', value));
    });
  }

  void _handleNZ(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("newZealand");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("newZealand");
    }
    sendUpdates(widget.configuration.copyWith(subscribeNZ: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeNZ', value));
    });
  }

  void _handleJapan(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("japan");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("japan");
    }
    sendUpdates(widget.configuration.copyWith(subscribeJapan: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeJapan', value));
    });
  }

  void _handleFG(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("frenchGuiana");
    } else {
      _handleAll(value);
      _firebaseMessaging.unsubscribeFromTopic("frenchGuiana");
    }
    sendUpdates(widget.configuration.copyWith(subscribeFG: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeFG', value));
    });
  }

  void sendUpdates(AppConfiguration value) {
    widget.updater(value);
  }

  void _showAds(bool value) {
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('showAds', value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 20,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 34,
              ),
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth < 600) {
              return buildSettingsPane(context);
            }

            return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: buildSettingsPane(context),
                ));
          }),
    );
  }

  Widget buildSettingsPane(BuildContext context) {
    var theme = Theme.of(context);

    final List<Widget> rows = <Widget>[
      _buildProductList(),
      _buildDebug(),
      ListTile(
        title: Text('Notification Settings', style: theme.textTheme.headlineSmall),
        subtitle: const Text('Select what kind of notifications to receive.'),
      ),
      MergeSemantics(
        child: ListTile(
          title: const Text('Allow 24 Hour Notifications'),
          onTap: () {
            _handleTwentyFourHour(
                !widget.configuration.allowTwentyFourHourNotifications);
          },
          trailing: Switch(
            value: widget.configuration.allowTwentyFourHourNotifications,
            onChanged: _handleTwentyFourHour,
          ),
        ),
      ),
      MergeSemantics(
        child: ListTile(
          title: const Text('Allow One Hour Notifications'),
          onTap: () {
            _handleOneHour(!widget.configuration.allowOneHourNotifications);
          },
          trailing: Switch(
            value: widget.configuration.allowOneHourNotifications,
            onChanged: _handleOneHour,
          ),
        ),
      ),
      MergeSemantics(
        child: ListTile(
          title: const Text('Allow Ten Minute Notifications'),
          onTap: () {
            _handleTenMinute(!widget.configuration.allowTenMinuteNotifications);
          },
          trailing: Switch(
            value: widget.configuration.allowTenMinuteNotifications,
            onChanged: _handleTenMinute,
          ),
        ),
      ),
      MergeSemantics(
        child: ListTile(
          title: const Text('Allow Status Changed Notifications'),
          onTap: () {
            _handleTenMinute(!widget.configuration.allowStatusChanged);
          },
          trailing: Switch(
            value: widget.configuration.allowStatusChanged,
            onChanged: _handleStatusChanged,
          ),
        ),
      ),
      MergeSemantics(
        child: ListTile(
          title: const Text('Allow News and Events Notifications'),
          onTap: () {
            _handleNews(!widget.configuration.subscribeNewsAndEvents);
          },
          trailing: Switch(
            value: widget.configuration.subscribeNewsAndEvents,
            onChanged: _handleNews,
          ),
        ),
      ),
    ];
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          children: rows,
        ),
        ListTile(
          title: Text('Favorites Filters', style: theme.textTheme.headlineSmall),
          subtitle: const Text(
              'Select which agencies and locations you want follow and receive launch notifications.'),
        ),
        buildNotificationFilters(context),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('About', style: theme.textTheme.headlineSmall)],
        ),
        const Divider(),
        MergeSemantics(
          child: ListTile(
            title: const Text('Privacy Policy'),
            subtitle: const Text('View the Space Launch Now privacy policy here.'),
            onTap: () {
              openUrl("https://spacelaunchnow.me/app/privacy");
            },
          ),
        ),
        MergeSemantics(
          child: ListTile(
            title: const Text('Terms of Use'),
            subtitle: const Text(
                'By using this application you agree to the Terms of Use.'),
            onTap: () {
              openUrl("https://spacelaunchnow.me/app/tos");
            },
          ),
        ),
        MergeSemantics(
          child: ListTile(
            title: const Text('Restore Purchases'),
            subtitle: const Text('Click here to restore in app purchases.'),
            onTap: () async {
              _getPurchaseHistory(initial: false);
            },
          ),
        ),
        const SizedBox(height: 50)
      ],
    );
  }

  Widget _buildProductList() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Card(
            child: (ListTile(
                leading: CircularProgressIndicator(),
                title: Text('Loading In-App Products...')))),
      );
    }

    final ListTile productHeader = ListTile(
        title: Text('Become a Supporter',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        subtitle: const Text(
            'Help ensure continued support, timely bug fixes, and new features by making a one-time in app purchase to remove ads or become a monthly supporter on Patreon.'));
    List<ListTile> productList = <ListTile>[];

    if (_notFoundIds.isNotEmpty) {
      productList.add(const ListTile(
          title: Text('Error loading in-app-purchases.',
              style: TextStyle(fontWeight: FontWeight.bold))));
    }
    logger.d("oh $_items");
    logger.d(_items);
    productList.addAll(_items.map(
      (IAPItem product) {
        bool isNotFound = _purchases
            .where((element) => element.productId == product.productId)
            .toList()
            .isEmpty;
        logger.d(product);
        return ListTile(
            title: Text(
              product.title!,
            ),
            subtitle: Text(
              product.description!,
            ),
            trailing: !isNotFound
                ? const Icon(Icons.check)
                : TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green[800],
                    ),
                    child: Text(product.localizedPrice!),
                    onPressed: () {
                      _requestPurchase(product);
                    },
                  ));
      },
    ));
    List<Widget> purchaseWidget = [];
    if (kReleaseMode) {
      if (_purchases.isNotEmpty) {
        logger.d("Purchases found!");
        purchaseWidget.add(Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.5,
                    ),
                  ),
                  child: const Icon(Icons.check, color: Colors.white)),
            ),
            const Text("Purchase confirmed - ads disabled!")
          ],
        ));
        _showAds(false);
      } else {
        _showAds(true);
        logger.d("Purchases not found!");
      }
    }

    return Card(
        child: Column(
            children: <Widget>[productHeader, const Divider()] +
                productList +
                purchaseWidget));
  }

  Widget buildNotificationFilters(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          MergeSemantics(
            child: ListTile(
              title: const Text('Follow All Launches'),
              onTap: () {
                _handleAll(!widget.configuration.subscribeALL);
              },
              trailing: Switch(
                value: widget.configuration.subscribeALL,
                onChanged: _handleAll,
              ),
            ),
          ),
          ListTile(
            title: Text('Agencies', style: theme.textTheme.headlineSmall),
            subtitle: const Text('Select your favorite launch agencies.'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'NOTE: You will only receive notifications for launches matching both agency and location.'
                    ' Example - if you have Florida and SpaceX selected you will only receive notifications for SpaceX launches in Florida.',
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ),
          ),
          const Divider(),
          MergeSemantics(
            child: ListTile(
              title: const Text('SpaceX'),
              onTap: () {
                _handleSpaceX(!widget.configuration.subscribeSpaceX);
              },
              trailing: Switch(
                value: widget.configuration.subscribeSpaceX,
                onChanged: _handleSpaceX,
              ),
            ),
          ),
          MergeSemantics(
            child: ListTile(
              title: const Text('NASA'),
              onTap: () {
                _handleNASA(!widget.configuration.subscribeNASA);
              },
              trailing: Switch(
                value: widget.configuration.subscribeNASA,
                onChanged: _handleNASA,
              ),
            ),
          ),
          MergeSemantics(
            child: ListTile(
              title: const Text('ULA'),
              onTap: () {
                _handleULA(!widget.configuration.subscribeULA);
              },
              trailing: Switch(
                value: widget.configuration.subscribeULA,
                onChanged: _handleULA,
              ),
            ),
          ),
          MergeSemantics(
            child: ListTile(
              title: const Text('ROSCOSMOS'),
              onTap: () {
                _handleRoscosmos(!widget.configuration.subscribeRoscosmos);
              },
              trailing: Switch(
                value: widget.configuration.subscribeRoscosmos,
                onChanged: _handleRoscosmos,
              ),
            ),
          ),
          MergeSemantics(
            child: ListTile(
              title: const Text('Blue Origin'),
              onTap: () {
                _handleBlueOrigin(!widget.configuration.subscribeBlueOrigin);
              },
              trailing: Switch(
                value: widget.configuration.subscribeBlueOrigin,
                onChanged: _handleBlueOrigin,
              ),
            ),
          ),
          MergeSemantics(
            child: ListTile(
              title: const Text('Rocket Lab'),
              onTap: () {
                _handleRocketLab(!widget.configuration.subscribeRocketLab);
              },
              trailing: Switch(
                value: widget.configuration.subscribeRocketLab,
                onChanged: _handleRocketLab,
              ),
            ),
          ),
          MergeSemantics(
            child: ListTile(
              title: const Text('Northrop Grumman'),
              onTap: () {
                _handleNorthrop(!widget.configuration.subscribeNorthrop);
              },
              trailing: Switch(
                value: widget.configuration.subscribeNorthrop,
                onChanged: _handleNorthrop,
              ),
            ),
          ),
          MergeSemantics(
            child: ListTile(
              title: const Text('Arianespace'),
              onTap: () {
                _handleArianespace(!widget.configuration.subscribeArianespace);
              },
              trailing: Switch(
                value: widget.configuration.subscribeArianespace,
                onChanged: _handleArianespace,
              ),
            ),
          ),
          ListTile(
            title: Text('Locations', style: theme.textTheme.headlineSmall),
            subtitle: const Text('Select your favorite launch locations.'),
          ),
          const Divider(),
          MergeSemantics(
            child: ListTile(
              title: const Text('Florida'),
              onTap: () {
                _handleCAPE(!widget.configuration.subscribeCAPE);
              },
              trailing: Switch(
                value: widget.configuration.subscribeCAPE,
                onChanged: _handleCAPE,
              ),
            ),
          ),
          MergeSemantics(
            child: ListTile(
              title: const Text('Russia'),
              onTap: () {
                _handleRussia(!widget.configuration.subscribeRussia);
              },
              trailing: Switch(
                value: widget.configuration.subscribeRussia,
                onChanged: _handleRussia,
              ),
            ),
          ),
          MergeSemantics(
            child: ListTile(
              title: const Text('India'),
              onTap: () {
                _handleISRO(!widget.configuration.subscribeISRO);
              },
              trailing: Switch(
                value: widget.configuration.subscribeISRO,
                onChanged: _handleISRO,
              ),
            ),
          ),
          MergeSemantics(
            child: ListTile(
              title: const Text('China'),
              onTap: () {
                _handleChina(!widget.configuration.subscribeChina);
              },
              trailing: Switch(
                value: widget.configuration.subscribeChina,
                onChanged: _handleChina,
              ),
            ),
          ),
          MergeSemantics(
              child: ListTile(
            title: const Text('Vandenberg'),
            onTap: () {
              _handleVAN(!widget.configuration.subscribeVAN);
            },
            trailing: Switch(
              value: widget.configuration.subscribeVAN,
              onChanged: _handleVAN,
            ),
          )),
          MergeSemantics(
              child: ListTile(
            title: const Text('Wallops'),
            onTap: () {
              _handleWallops(!widget.configuration.subscribeWallops);
            },
            trailing: Switch(
              value: widget.configuration.subscribeWallops,
              onChanged: _handleWallops,
            ),
          )),
          MergeSemantics(
              child: ListTile(
            title: const Text('New Zealand'),
            onTap: () {
              _handleNZ(!widget.configuration.subscribeNZ);
            },
            trailing: Switch(
              value: widget.configuration.subscribeNZ,
              onChanged: _handleNZ,
            ),
          )),
          MergeSemantics(
              child: ListTile(
            title: const Text('Japan'),
            onTap: () {
              _handleJapan(!widget.configuration.subscribeJapan);
            },
            trailing: Switch(
              value: widget.configuration.subscribeJapan,
              onChanged: _handleJapan,
            ),
          )),
          MergeSemantics(
              child: ListTile(
            title: const Text('French Guiana'),
            onTap: () {
              _handleFG(!widget.configuration.subscribeFG);
            },
            trailing: Switch(
              value: widget.configuration.subscribeFG,
              onChanged: _handleFG,
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildDebug() {

    if (!kReleaseMode) {
      return MergeSemantics(
        child: Column(
          children: [
            ListTile(
              title: const Text('Show Ads?'),
              onTap: () {
                _handleDebugSupporter(!widget.configuration.showAds);
              },
              trailing: Switch(
                value: widget.configuration.showAds,
                onChanged: _handleDebugSupporter,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
