import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spacelaunchnow_flutter/models/launches.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/launchlist/launches_list_page.dart';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Colors.grey[100],
  accentColor: Colors.redAccent,
);

final ThemeData kDefaultTheme = new ThemeData(
  primaryColorBrightness: Brightness.dark,
  primarySwatch: Colors.blue,
  accentColor: Colors.redAccent,
);

Future<Launches> fetchLaunches() async {
  final response =
      await http.get('https://launchlibrary.net/1.4/launch/next/100');
  final responseJson = json.decode(response.body);

  return new Launches.fromJson(responseJson);
}

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
  int pageIndex = 0;

  // Create all the pages once and return same instance when required
  final LaunchDetailPage _nextPage = new LaunchDetailPage();
  final LaunchListPage _listPage = new LaunchListPage();
  final LaunchListPage _previousListPage = new LaunchListPage();

  Widget pageChooser() {
    switch (this.pageIndex) {
      case 0:
        return _nextPage;
        break;

      case 1:
        return _listPage;
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
    return new MaterialApp(
        title: 'Space Launch Now',
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        home: new Scaffold(
            body: pageChooser(),
            bottomNavigationBar: new Theme(
                data: Theme.of(context).copyWith(
                    // sets the background color of the `BottomNavigationBar`
                    canvasColor: Colors.redAccent,
                    // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                    primaryColor: Colors.white,
                    textTheme: Theme.of(context).textTheme.copyWith(
                        caption: new TextStyle(
                            color: Colors
                                .white70))), // sets the inactive color of the `BottomNavigationBar`
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
                        title: new Text('Next'), icon: new Icon(Icons.home)),
                    new BottomNavigationBarItem(
                        title: new Text('Upcoming'),
                        icon: new Icon(Icons.time_to_leave)),
                    new BottomNavigationBarItem(
                        title: new Text('Previous'),
                        icon: new Icon(Icons.history))
                  ],
                ))));
  }
}
