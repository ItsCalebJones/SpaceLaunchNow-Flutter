import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/views/notifications/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationFilterPage extends StatefulWidget {
  const NotificationFilterPage(this.configuration, this.updater, this._firebaseMessaging);

  final FirebaseMessaging _firebaseMessaging;
  final AppConfiguration configuration;
  final ValueChanged<AppConfiguration> updater;


  @override
  NotificationFilterPageState createState() =>
      new NotificationFilterPageState(_firebaseMessaging);
}

class NotificationFilterPageState extends State<NotificationFilterPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  FirebaseMessaging _firebaseMessaging;

  NotificationFilterPageState(this._firebaseMessaging);

  void _handleOneHour(bool value) {
    _firebaseMessaging.subscribeToTopic("allow_one_hour");
    sendUpdates(
        widget.configuration.copyWith(allowOneHourNotifications: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('allowOneHourNotifications', value));
    });
  }

  void _handleTwentyFourHour(bool value) {
    _firebaseMessaging.subscribeToTopic("allow_twenty_four");
    sendUpdates(
        widget.configuration.copyWith(allowTwentyFourHourNotifications: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('allowTwentyFourHourNotifications', value));
    });
  }

  void _handleTenMinute(bool value) {
    _firebaseMessaging.subscribeToTopic("allow_ten_minute");
    sendUpdates(
        widget.configuration.copyWith(allowTenMinuteNotifications: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('allowTenMinuteNotifications', value));
    });
  }

  void _handleStatusChanged(bool value) {
    _firebaseMessaging.subscribeToTopic("allow_netstamp_changed");
    sendUpdates(widget.configuration.copyWith(allowStatusChanged: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('allowStatusChanged', value));
    });
  }

  void _handleAll(bool value) {

    sendUpdates(widget.configuration.copyWith(subscribeALL: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeALL', value));
    });
  }

  void _handleULA(bool value) {
    sendUpdates(widget.configuration.copyWith(subscribeULA: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeULA', value));
    });
  }

  void _handleSpaceX(bool value) {
    sendUpdates(widget.configuration.copyWith(subscribeSpaceX: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeSpaceX', value));
    });
  }

  void _handleNASA(bool value) {
    sendUpdates(widget.configuration.copyWith(subscribeNASA: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeNASA', value));
    });
  }

  void _handleArianespace(bool value) {
    sendUpdates(widget.configuration.copyWith(subscribeArianespace: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeArianespace', value));
    });
  }

  void _handleCASC(bool value) {
    sendUpdates(widget.configuration.copyWith(subscribeCASC: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeCASC', value));
    });
  }

  void _handleISRO(bool value) {
    sendUpdates(widget.configuration.copyWith(subscribeISRO: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeISRO', value));
    });
  }

  void _handleVAN(bool value) {
    sendUpdates(widget.configuration.copyWith(subscribeVAN: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeVAN', value));
    });
  }

  void _handleKSC(bool value) {
    sendUpdates(widget.configuration.copyWith(subscribeKSC: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeKSC', value));
    });
  }

  void _handleCAPE(bool value) {
    _handleKSC(value);
    sendUpdates(widget.configuration.copyWith(subscribeCAPE: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeCAPE', value));
    });
  }

  void _handlePLES(bool value) {
    sendUpdates(widget.configuration.copyWith(subscribePLES: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribePLES', value));
    });
  }

  void _handleRoscosmos(bool value) {
    sendUpdates(widget.configuration.copyWith(subscribeRoscosmos: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('subscribeRoscosmos', value));
    });
  }

  void sendUpdates(AppConfiguration value) {
    if (widget.updater != null) widget.updater(value);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Notifications'),
      ),
      body: buildSettingsPane(context),
    );
  }

  Widget buildSettingsPane(BuildContext context) {
    var theme = Theme.of(context);

    final List<Widget> rows = <Widget>[
      new ListTile(
        title: new Text('Notification Settings', style: theme.textTheme.title),
      ),
      new ListTile(
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
      new ListTile(
        title: const Text('Allow One Hour Notifications'),
        onTap: () {
          _handleOneHour(!widget.configuration.allowOneHourNotifications);
        },
        trailing: new Switch(
          value: widget.configuration.allowOneHourNotifications,
          onChanged: _handleOneHour,
        ),
      ),
      new ListTile(
        title: const Text('Allow Ten Minute Notifications'),
        onTap: () {
          _handleTenMinute(!widget.configuration.allowTenMinuteNotifications);
        },
        trailing: new Switch(
          value: widget.configuration.allowTenMinuteNotifications,
          onChanged: _handleTenMinute,
        ),
      ),
      new ListTile(
        title: const Text('Allow Status Changed Notifications'),
        onTap: () {
          _handleTenMinute(!widget.configuration.allowStatusChanged);
        },
        trailing: new Switch(
          value: widget.configuration.allowStatusChanged,
          onChanged: _handleStatusChanged,
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
      padding: const EdgeInsets.all(8.0),
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
                    new Switch(
                      value: widget.configuration.subscribeALL,
                      onChanged: _handleAll,
                    )
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Text("SpaceX"),
                    new Switch(
                      value: widget.configuration.subscribeSpaceX,
                      onChanged: _handleSpaceX,
                    )
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text("NASA"),
                    new Switch(
                      value: widget.configuration.subscribeNASA,
                      onChanged: _handleNASA,
                    )
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Text("ULA"),
                    new Switch(
                      value: widget.configuration.subscribeULA,
                      onChanged: _handleULA,
                    )
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text("Roscosmos"),
                    new Switch(
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
                  new Switch(
                    value: widget.configuration.subscribeCASC,
                    onChanged: _handleCASC,
                  )
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text("Cape Canav. | KSC"),
                  new Switch(
                    value: widget.configuration.subscribeCAPE,
                    onChanged: _handleCAPE,
                  )
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text("Plesetsk Cosmo."),
                  new Switch(
                    value: widget.configuration.subscribePLES,
                    onChanged: _handlePLES,
                  )
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text("ISRO"),
                  new Switch(
                    value: widget.configuration.subscribeISRO,
                    onChanged: _handleISRO,
                  )
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text("Vandenberg"),
                  new Switch(
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
