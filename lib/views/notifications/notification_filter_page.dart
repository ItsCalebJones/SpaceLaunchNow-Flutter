import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/views/notifications/app_settings.dart';

class NotificationFilterPage extends StatefulWidget {
  const NotificationFilterPage(this.configuration, this.updater);

  final AppConfiguration configuration;
  final ValueChanged<AppConfiguration> updater;

  @override
  NotificationFilterPageState createState() =>
      new NotificationFilterPageState();
}

class NotificationFilterPageState extends State<NotificationFilterPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _handleOneHour(bool value) {
    sendUpdates(
        widget.configuration.copyWith(allowOneHourNotifications: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('allowOneHourNotifications', value));
    });
  }

  void _handleTwentyFourHour(bool value) {
    sendUpdates(
        widget.configuration.copyWith(allowTwentyFourHourNotifications: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('allowTwentyFourHourNotifications', value));
    });
  }

  void _handleTenMinute(bool value) {
    sendUpdates(
        widget.configuration.copyWith(allowTenMinuteNotifications: value));
    _prefs.then((SharedPreferences prefs) {
      return (prefs.setBool('allowTenMinuteNotifications', value));
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
    ];
    rows.addAll(buildNotificationFilters(context));
    return new ListView(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      children: rows,
    );
  }

  List<Widget> buildNotificationFilters(BuildContext context) {
    var theme = Theme.of(context);

    final List<Widget> rows = <Widget>[
      new ListTile(
        title: new Text('Notification Filters', style: theme.textTheme.title),
      ),
      new ListTile(
        title: const Text('SpaceX'),
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
        title: const Text('NASA'),
        onTap: () {
          _handleOneHour(!widget.configuration.allowOneHourNotifications);
        },
        trailing: new Switch(
          value: widget.configuration.allowOneHourNotifications,
          onChanged: _handleOneHour,
        ),
      ),
      new ListTile(
        title: const Text('ULA'),
        onTap: () {
          _handleTenMinute(!widget.configuration.allowTenMinuteNotifications);
        },
        trailing: new Switch(
          value: widget.configuration.allowTenMinuteNotifications,
          onChanged: _handleTenMinute,
        ),
      ),
    ];
    return rows;
  }
}
