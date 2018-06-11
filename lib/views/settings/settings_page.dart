import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iap/flutter_iap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  void _handleNightMode(bool value) {
    sendUpdates(widget.configuration.copyWith(nightMode: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('nightMode', value));
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
      _firebaseMessaging.unsubscribeFromTopic("arianespace");
    }
    sendUpdates(widget.configuration.copyWith(subscribeArianespace: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeArianespace', value));
    });
  }

  void _handleCASC(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("casc");
    } else {
      _firebaseMessaging.unsubscribeFromTopic("casc");
    }
    sendUpdates(widget.configuration.copyWith(subscribeCASC: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeCASC', value));
    });
  }

  void _handleISRO(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("isro");
    } else {
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
      _firebaseMessaging.unsubscribeFromTopic("ksc");
    }
    sendUpdates(widget.configuration.copyWith(subscribeKSC: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeKSC', value));
    });
  }

  void _handleCAPE(bool value) {
    if (value) {
      _firebaseMessaging.subscribeToTopic("cape");
    } else {
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
      _firebaseMessaging.unsubscribeFromTopic("roscosmos");
    }
    _handlePLES(value);
    sendUpdates(widget.configuration.copyWith(subscribeRoscosmos: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeRoscosmos', value));
    });
  }

  void sendUpdates(AppConfiguration value) {
    if (widget.updater != null) widget.updater(value);
  }

  void _becomeSupporter(){
    FlutterIap.buy("two_dollar_sku").then((IAPResponse response) {
      String responseStatus = response.status;
      print("Response: $responseStatus");
      if (response.products != null && response.products.length > 0){
        sendUpdates(widget.configuration.copyWith(showAds: false));
        _prefs.then((SharedPreferences prefs) {
          return (prefs.setBool('showAds', false));
        });
      }
    }, onError: (error) {
      // errors caught outside the framework
      print("Error found $error");
    });
  }

  void _removeAds (bool value){
    if (!value){
      FlutterIap.restorePurchases().then((IAPResponse response) {
        if (response.products != null && response.products.length > 0) {
          sendUpdates(widget.configuration.copyWith(showAds: value));
          _prefs.then((SharedPreferences prefs) {
            return (prefs.setBool('showAds', value));
          });
        } else {
          final snackBar = new SnackBar(
            content: new Text('Become a Supporter:'),
            duration: new Duration(seconds: 5),
            action: new SnackBarAction(
                label: "Yes, please!",
                onPressed: () {
                  _becomeSupporter();
                }
            ),
          );
          // Find the Scaffold in the Widget tree and use it to show a SnackBar
          Scaffold.of(context).showSnackBar(snackBar);
        }
      });
    } else {
      sendUpdates(widget.configuration.copyWith(showAds: value));
      _prefs.then((SharedPreferences prefs) {
        return (prefs.setBool('showAds', value));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new PlatformAdaptiveAppBar(
        text: "Settings",
        color: Theme.of(context).primaryColor,
        platform: Theme.of(context).platform,
      ),
      body: buildSettingsPane(context),
    );
  }

  Widget buildSettingsPane(BuildContext context) {
    var theme = Theme.of(context);

    final List<Widget> rows = <Widget>[
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
          trailing: new CupertinoSwitch(
            value: widget.configuration.nightMode,
            onChanged: _handleNightMode,
          ),
        ),
      ),
      new MergeSemantics(
        child: new ListTile(
          title: const Text('Show Ads'),
          onTap: () {
            _removeAds(!widget.configuration.showAds);
          },
          trailing: new CupertinoSwitch(
            value: widget.configuration.showAds,
            onChanged: _removeAds,
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
          trailing: new CupertinoSwitch(
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
          trailing: new CupertinoSwitch(
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
          trailing: new CupertinoSwitch(
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
          trailing: new CupertinoSwitch(
            value: widget.configuration.allowStatusChanged,
            onChanged: _handleStatusChanged,
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
          title: new Text('Notification Filters', style: theme.textTheme.title),
          subtitle: new Text(
              'Select which agencies you want to receive launch notifications.'),
        ),
        buildNotificationFilters(context)
      ],
    );
  }

  Widget buildNotificationFilters(BuildContext context) {
    var theme = Theme.of(context);

    return new Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 50.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text("All"),
                    new CupertinoSwitch(
                      value: widget.configuration.subscribeALL,
                      onChanged: _handleAll,
                    )
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Text("SpaceX"),
                    new CupertinoSwitch(
                      value: widget.configuration.subscribeSpaceX,
                      onChanged: _handleSpaceX,
                    )
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text("NASA"),
                    new CupertinoSwitch(
                      value: widget.configuration.subscribeNASA,
                      onChanged: _handleNASA,
                    )
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Text("ULA"),
                    new CupertinoSwitch(
                      value: widget.configuration.subscribeULA,
                      onChanged: _handleULA,
                    )
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text("Roscosmos"),
                    new CupertinoSwitch(
                      value: widget.configuration.subscribeRoscosmos,
                      onChanged: _handleRoscosmos,
                    )
                  ],
                ),
              ]),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text("CASC"),
                  new CupertinoSwitch(
                    value: widget.configuration.subscribeCASC,
                    onChanged: _handleCASC,
                  )
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text("KSC, FL"),
                  new CupertinoSwitch(
                    value: widget.configuration.subscribeCAPE,
                    onChanged: _handleCAPE,
                  )
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text("Arianespace"),
                  new CupertinoSwitch(
                    value: widget.configuration.subscribeArianespace,
                    onChanged: _handleArianespace,
                  )
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text("ISRO"),
                  new CupertinoSwitch(
                    value: widget.configuration.subscribeISRO,
                    onChanged: _handleISRO,
                  )
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text("Vandenberg"),
                  new CupertinoSwitch(
                    value: widget.configuration.subscribeVAN,
                    onChanged: _handleVAN,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
