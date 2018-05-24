import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/launchlist/previous_launches_list_page.dart';
import 'package:spacelaunchnow_flutter/views/launchlist/upcoming_launches_list_page.dart';
import 'package:spacelaunchnow_flutter/views/notifications/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/notifications/notification_filter_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new SpaceLaunchNow());

class SpaceLaunchNow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Pages();
  }
}

class Pages extends StatefulWidget {
  @override
  createState() => new PagesState();
}

class PagesState extends State<Pages> {
  int pageIndex = 1;
  AppConfiguration _configuration = new AppConfiguration(
      allowOneHourNotifications: true,
      allowTwentyFourHourNotifications: true,
      allowTenMinuteNotifications: true);
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      bool allowOneHourNotifications = prefs.getBool("allowOneHourNotifications") ?? true;
      bool allowTwentyFourHourNotifications = prefs.getBool("allowTwentyFourHourNotifications") ?? true;
      bool allowTenMinuteNotifications = prefs.getBool("allowTenMinuteNotifications") ?? true;
      configurationUpdater(_configuration.copyWith(
          allowOneHourNotifications: allowOneHourNotifications,
          allowTwentyFourHourNotifications: allowTwentyFourHourNotifications,
          allowTenMinuteNotifications: allowTenMinuteNotifications));
    });
  }

  void configurationUpdater(AppConfiguration value) {
    setState(() {
      _configuration = value;
    });
  }

  // Create all the pages once and return same instance when required
  final LaunchDetailPage _nextPage = new LaunchDetailPage();
  final UpcomingLaunchListPage _listPage = new UpcomingLaunchListPage();
  final PreviousLaunchListPage _previousListPage = new PreviousLaunchListPage();

  Widget pageChooser() {
    switch (this.pageIndex) {
      case 0:
        return _listPage;
        break;

      case 1:
        return _nextPage;
        break;

      case 2:
        return _previousListPage;
        break;

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
    ThemeData theme =
        defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : kDefaultTheme;
    return new MaterialApp(
        title: 'Space Launch Now',
        theme: theme,
        routes: <String, WidgetBuilder>{
          '/notifications': (BuildContext context) =>
              new NotificationFilterPage(_configuration, configurationUpdater),
        },
        home: new Scaffold(
            body: pageChooser(),
            floatingActionButton: new Builder(builder: (BuildContext context) {
              return new FloatingActionButton(
                  backgroundColor: Colors.blue[400],
                  child: const Icon(Icons.sort),
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/notifications'));
            }),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: new Theme(
                data: theme.copyWith(
                    // sets the background color of the `BottomNavigationBar`
                    canvasColor: theme.accentColor,
                    // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                    primaryColor: Colors.white,
                    textTheme: theme.textTheme.copyWith(
                        caption: new TextStyle(color: Colors.white70))),
                // sets the inactive color of the `BottomNavigationBar`
                child: new BottomNavigationBar(
                  currentIndex: pageIndex,
                  onTap: (int tappedIndex) {
                    //Toggle pageChooser and rebuild state with the index that was tapped in bottom navbar
                    setState(() {
                      this.pageIndex = tappedIndex;
                    });
                  },
                  items: <BottomNavigationBarItem>[
                    new BottomNavigationBarItem(
                        title: new Text('Upcoming'),
                        icon: new Icon(Icons.assignment)),
                    new BottomNavigationBarItem(
                        icon: new Icon(Icons.home),
                        title: new Text("Next Launch")),
                    new BottomNavigationBarItem(
                        title: new Text('Previous'),
                        icon: new Icon(Icons.history)),
                  ],
                ))));
  }
}

// TODO USE THIS
class GoogleTasksBottomAppBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: const Text('Tasks - Bottom App Bar')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.home),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        hasNotch: false,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
