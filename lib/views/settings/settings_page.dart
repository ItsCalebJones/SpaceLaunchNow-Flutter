import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iap/flutter_iap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'product_store.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/material/dialog';

  SettingsPage(this.configuration, this.updater);

  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final AppConfiguration configuration;
  final ValueChanged<AppConfiguration> updater;

  @override
  NotificationFilterPageState createState() =>
      new NotificationFilterPageState(_firebaseMessaging);
}

class NotificationFilterPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  FirebaseMessaging _firebaseMessaging;

  NotificationFilterPageState(this._firebaseMessaging);

  List<String> _productIds = ["2018_founder"];

  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError = null;

  @override
  initState() {
    super.initState();
    init();
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_productIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
        await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }
    List<String> consumables = await ProductStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
          }
        }
      }
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    });
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  init() async {
    List<String> productIds = ["2018_founder"];

    IAPResponse response = await FlutterIap.fetchProducts(productIds);
    productIds = response.products
        .map((IAPProduct product) => product.productIdentifier)
        .toList();

    if (!mounted) return;

    setState(() {
      _productIds = productIds;
    });
  }

  void _handleNightMode(bool value) {
    sendUpdates(widget.configuration.copyWith(nightMode: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('nightMode', value));
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

  //TODO Careful here
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
    if (widget.updater != null) widget.updater(value);
  }

  void _becomeSupporter() {
    print("Becoming supporter!");
    FlutterIap.buy(_productIds.first).then((IAPResponse response) {
      String responseStatus = response.status.name;
      print(response);
      print("Response: $responseStatus");
      if (response.purchases != null) {
        List<String> purchasedIds = response.purchases
            .map((IAPPurchase purchase) => purchase.productIdentifier)
            .toList();
        if (purchasedIds.length > 0) {
          sendUpdates(widget.configuration.copyWith(showAds: false));
          _prefs.then((SharedPreferences prefs) {
            return (prefs.setBool('showAds', false));
          });
        }
      }
    }, onError: (error) {
      // errors caught outside the framework
      print("Error found $error");
      sendUpdates(widget.configuration.copyWith(showAds: true));
      _prefs.then((SharedPreferences prefs) {
        return (prefs.setBool('showAds', true));
      });
    });
  }

  void _showAds(bool value) {
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('showAds', value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: Text(
          "Settings",
          style: Theme.of(context)
              .textTheme
              .headline
              .copyWith(fontWeight: FontWeight.bold, fontSize: 32),
        ),
      ),
      body: buildSettingsPane(context),
    );
  }

  Widget buildSettingsPane(BuildContext context) {
    var theme = Theme.of(context);

    final List<Widget> rows = <Widget>[
      _buildProductList(),
      new ListTile(
        title: new Text('Appearance', style: theme.textTheme.title),
        subtitle: new Text('Change appereance settings.'),
      ),
      new MergeSemantics(
        child: new ListTile(
          title: const Text('Use Dark Theme'),
          onTap: () {
            _handleNightMode(!widget.configuration.nightMode);
          },
          trailing: new Switch(
            value: widget.configuration.nightMode,
            onChanged: _handleNightMode,
          ),
        ),
      ),
      new ListTile(
        title: new Text('Notification Settings', style: theme.textTheme.title),
        subtitle: new Text('Select what kind of notifications to receive.'),
      ),
      new MergeSemantics(
        child: new ListTile(
          title: const Text('Allow 24 Hour Notifications'),
          onTap: () {
            _handleTwentyFourHour(
                !widget.configuration.allowTwentyFourHourNotifications);
          },
          trailing: new Switch(
            value: widget.configuration.allowTwentyFourHourNotifications,
            onChanged: _handleTwentyFourHour,
          ),
        ),
      ),
      new MergeSemantics(
        child: new ListTile(
          title: const Text('Allow One Hour Notifications'),
          onTap: () {
            _handleOneHour(!widget.configuration.allowOneHourNotifications);
          },
          trailing: new Switch(
            value: widget.configuration.allowOneHourNotifications,
            onChanged: _handleOneHour,
          ),
        ),
      ),
      new MergeSemantics(
        child: new ListTile(
          title: const Text('Allow Ten Minute Notifications'),
          onTap: () {
            _handleTenMinute(!widget.configuration.allowTenMinuteNotifications);
          },
          trailing: new Switch(
            value: widget.configuration.allowTenMinuteNotifications,
            onChanged: _handleTenMinute,
          ),
        ),
      ),
      new MergeSemantics(
        child: new ListTile(
          title: const Text('Allow Status Changed Notifications'),
          onTap: () {
            _handleTenMinute(!widget.configuration.allowStatusChanged);
          },
          trailing: new Switch(
            value: widget.configuration.allowStatusChanged,
            onChanged: _handleStatusChanged,
          ),
        ),
      ),
      new MergeSemantics(
        child: new ListTile(
          title: const Text('Allow News and Events Notifications'),
          onTap: () {
            _handleNews(!widget.configuration.subscribeNewsAndEvents);
          },
          trailing: new Switch(
            value: widget.configuration.subscribeNewsAndEvents,
            onChanged: _handleNews,
          ),
        ),
      ),
    ];
    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        new Column(
          children: rows,
        ),
        new ListTile(
          title: new Text('Favorites Filters', style: theme.textTheme.title),
          subtitle: new Text(
              'Select which agencies and locations you want follow and receive launch notifications.'),
        ),
        buildNotificationFilters(context),
        new Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[new Text('About', style: theme.textTheme.title)],
          ),
        ),
        new Divider(),
        new MergeSemantics(
          child: new ListTile(
            title: new Text('Privacy Policy'),
            subtitle:
                new Text('View the Space Launch Now privacy policy here.'),
            onTap: () {
              _launchURL("https://spacelaunchnow.me/app/privacy");
            },
          ),
        ),
        new MergeSemantics(
          child: new ListTile(
            title: new Text('Terms of Use'),
            subtitle: new Text(
                'By using this application you agree to the Terms of Use.'),
            onTap: () {
              _launchURL("https://spacelaunchnow.me/app/tos");
            },
          ),
        ),
        new MergeSemantics(
          child: new ListTile(
            title: new Text('On the Web'),
            subtitle: new Text('Use Space Launch Now on the web!'),
            onTap: () {
              _launchURL("https://spacelaunchnow.me/");
            },
          ),
        ),
        new MergeSemantics(
          child: new ListTile(
            title: new Text('Restore Purchases'),
            subtitle: new Text('Click here to restore in app purchases.'),
            onTap: () async {
              FlutterIap.restorePurchases().then((IAPResponse response) {
                print(response);
                String responseStatus = response.status.name;
                print("Response: $responseStatus");
                if (response.purchases != null) {
                  List<String> purchasedIds = response.purchases
                      .map((IAPPurchase purchase) => purchase.productIdentifier)
                      .toList();
                  if (purchasedIds.length > 0) {
                    sendUpdates(widget.configuration.copyWith(showAds: false));
                    _prefs.then((SharedPreferences prefs) {
                      return (prefs.setBool('showAds', false));
                    });
                  }
                }
                final snackBar = new SnackBar(
                  content: new Text(
                      'Purchase history restored: ' + response.status.name),
                  duration: new Duration(seconds: 5),
                );
                // Find the Scaffold in the Widget tree and use it to show a SnackBar
                Scaffold.of(context).showSnackBar(snackBar);
              }, onError: (error) {
                // errors caught outside the framework
                print("Error found $error");
              });
            },
          ),
        ),
        new SizedBox(height: 50)
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Card _buildProductList() {
    if (_loading) {
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Loading In-App Products...'))));
    }

    if (!_isAvailable) {
      return Card();
    }
    final ListTile productHeader = ListTile(
        title: new Text('Become a Supporter',
            style: Theme.of(context).textTheme.headline),
        subtitle: new Text('Remove ads and support development.'));
    List<ListTile> productList = <ListTile>[];

    if (!_notFoundIds.isEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: Text(
              'This app needs special configuration to run. Please see example/README.md for instructions.')));
    }

    Map<String, PurchaseDetails> purchases =
    Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));

    productList.addAll(_products.map(
          (ProductDetails productDetails) {
        PurchaseDetails previousPurchase = purchases[productDetails.id];
        return ListTile(
            title: Text(
              productDetails.title,
            ),
            subtitle: Text(
              productDetails.description,
            ),
            trailing: previousPurchase != null
                ? Icon(Icons.check)
                : FlatButton(
              child: Text(productDetails.price),
              color: Colors.green[800],
              textColor: Colors.white,
              onPressed: () {
                PurchaseParam purchaseParam = PurchaseParam(
                    productDetails: productDetails,
                    applicationUserName: null,
                    sandboxTesting: true);
                    _connection.buyNonConsumable(purchaseParam: purchaseParam);
              },
            ));
      },
    ));

    if (_purchases.isNotEmpty){
      print("Purchases found!");
      _showAds(false);
    } else {
      _showAds(true);
      print("Purchases not found!");
    }

    return Card(
        child:
        Column(children: <Widget>[productHeader, Divider()] + productList));
  }

  Widget buildNotificationFilters(BuildContext context) {
    var theme = Theme.of(context);

    return new Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new MergeSemantics(
            child: new ListTile(
              title: const Text('Follow All'),
              onTap: () {
                _handleAll(!widget.configuration.subscribeALL);
              },
              trailing: new Switch(
                value: widget.configuration.subscribeALL,
                onChanged: _handleAll,
              ),
            ),
          ),
          new ListTile(
            title: new Text('Agencies', style: theme.textTheme.title),
            subtitle: new Text('Select your favorite launch agencies.'),
          ),
          new Divider(),
          new MergeSemantics(
            child: new ListTile(
              title: const Text('SpaceX'),
              onTap: () {
                _handleSpaceX(!widget.configuration.subscribeSpaceX);
              },
              trailing: new Switch(
                value: widget.configuration.subscribeSpaceX,
                onChanged: _handleSpaceX,
              ),
            ),
          ),
          new MergeSemantics(
            child: new ListTile(
              title: const Text('NASA'),
              onTap: () {
                _handleNASA(!widget.configuration.subscribeNASA);
              },
              trailing: new Switch(
                value: widget.configuration.subscribeNASA,
                onChanged: _handleNASA,
              ),
            ),
          ),
          new MergeSemantics(
            child: new ListTile(
              title: const Text('ULA'),
              onTap: () {
                _handleULA(!widget.configuration.subscribeULA);
              },
              trailing: new Switch(
                value: widget.configuration.subscribeULA,
                onChanged: _handleULA,
              ),
            ),
          ),
          new MergeSemantics(
            child: new ListTile(
              title: const Text('ROSCOSMOS'),
              onTap: () {
                _handleRoscosmos(!widget.configuration.subscribeRoscosmos);
              },
              trailing: new Switch(
                value: widget.configuration.subscribeRoscosmos,
                onChanged: _handleRoscosmos,
              ),
            ),
          ),
          new MergeSemantics(
            child: new ListTile(
              title: const Text('Blue Origin'),
              onTap: () {
                _handleBlueOrigin(!widget.configuration.subscribeBlueOrigin);
              },
              trailing: new Switch(
                value: widget.configuration.subscribeBlueOrigin,
                onChanged: _handleBlueOrigin,
              ),
            ),
          ),
          new MergeSemantics(
            child: new ListTile(
              title: const Text('Rocket Lab'),
              onTap: () {
                _handleRocketLab(!widget.configuration.subscribeRocketLab);
              },
              trailing: new Switch(
                value: widget.configuration.subscribeRocketLab,
                onChanged: _handleRocketLab,
              ),
            ),
          ),
          new MergeSemantics(
            child: new ListTile(
              title: const Text('Northrop Gruman'),
              onTap: () {
                _handleNorthrop(!widget.configuration.subscribeNorthrop);
              },
              trailing: new Switch(
                value: widget.configuration.subscribeNorthrop,
                onChanged: _handleNorthrop,
              ),
            ),
          ),
          new MergeSemantics(
            child: new ListTile(
              title: const Text('Arianespace'),
              onTap: () {
                _handleArianespace(!widget.configuration.subscribeArianespace);
              },
              trailing: new Switch(
                value: widget.configuration.subscribeArianespace,
                onChanged: _handleArianespace,
              ),
            ),
          ),
          new ListTile(
            title: new Text('Locations', style: theme.textTheme.title),
            subtitle: new Text('Select your favorite launch locations.'),
          ),
          new Divider(),
          new MergeSemantics(
            child: new ListTile(
              title: const Text('Florida'),
              onTap: () {
                _handleCAPE(!widget.configuration.subscribeCAPE);
              },
              trailing: new Switch(
                value: widget.configuration.subscribeCAPE,
                onChanged: _handleCAPE,
              ),
            ),
          ),
          new MergeSemantics(
            child: new ListTile(
              title: const Text('Russia'),
              onTap: () {
                _handleRussia(!widget.configuration.subscribeRussia);
              },
              trailing: new Switch(
                value: widget.configuration.subscribeRussia,
                onChanged: _handleRussia,
              ),
            ),
          ),
          new MergeSemantics(
            child: new ListTile(
              title: const Text('India'),
              onTap: () {
                _handleISRO(!widget.configuration.subscribeISRO);
              },
              trailing: new Switch(
                value: widget.configuration.subscribeISRO,
                onChanged: _handleISRO,
              ),
            ),
          ),
          new MergeSemantics(
            child: new ListTile(
              title: const Text('China'),
              onTap: () {
                _handleChina(!widget.configuration.subscribeChina);
              },
              trailing: new Switch(
                value: widget.configuration.subscribeChina,
                onChanged: _handleChina,
              ),
            ),
          ),
          new MergeSemantics(
              child: new ListTile(
            title: const Text('Vandenberg'),
            onTap: () {
              _handleVAN(!widget.configuration.subscribeVAN);
            },
            trailing: new Switch(
              value: widget.configuration.subscribeVAN,
              onChanged: _handleVAN,
            ),
          )),
          new MergeSemantics(
              child: new ListTile(
            title: const Text('Wallops'),
            onTap: () {
              _handleWallops(!widget.configuration.subscribeWallops);
            },
            trailing: new Switch(
              value: widget.configuration.subscribeWallops,
              onChanged: _handleWallops,
            ),
          )),
          new MergeSemantics(
              child: new ListTile(
            title: const Text('New Zealand'),
            onTap: () {
              _handleNZ(!widget.configuration.subscribeNZ);
            },
            trailing: new Switch(
              value: widget.configuration.subscribeNZ,
              onChanged: _handleNZ,
            ),
          )),
          new MergeSemantics(
              child: new ListTile(
            title: const Text('Japan'),
            onTap: () {
              _handleJapan(!widget.configuration.subscribeJapan);
            },
            trailing: new Switch(
              value: widget.configuration.subscribeJapan,
              onChanged: _handleJapan,
            ),
          )),
          new MergeSemantics(
              child: new ListTile(
            title: const Text('French Guiana'),
            onTap: () {
              _handleFG(!widget.configuration.subscribeFG);
            },
            trailing: new Switch(
              value: widget.configuration.subscribeFG,
              onChanged: _handleFG,
            ),
          ))
        ],
      ),
    );
  }
}
