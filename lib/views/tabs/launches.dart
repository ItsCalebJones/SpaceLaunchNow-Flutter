import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/views/launchlist/previous_launches_list_page.dart';
import 'package:spacelaunchnow_flutter/views/launchlist/upcoming_launches_list_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';

class LaunchesTabPage extends StatefulWidget {
  LaunchesTabPage(this._configuration);

  final AppConfiguration _configuration;

  @override
  _LaunchesTabPageState createState() => new _LaunchesTabPageState();
}

class _LaunchesTabPageState extends State<LaunchesTabPage>
    with SingleTickerProviderStateMixin {
  String myTitle = "Space Launch Schedule";
  bool searchActive = false;
  bool searchViewActive = false;
  String searchQuery;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Building!");
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: _appBar(),
          body: TabBarView(
            children: [
              new UpcomingLaunchListPage(widget._configuration, searchQuery, searchActive),
              new PreviousLaunchListPage(widget._configuration, searchQuery, searchActive),
            ],
          ),
        ),
    );
  }

  PreferredSizeWidget _appBar() {
    if (searchViewActive) {
      return AppBar(
        leading: Icon(Icons.search),
        title: TextField(
          style: new TextStyle(color: Colors.white),
          onSubmitted: _search,
          decoration: InputDecoration(
            hintText: "Example: SpaceX, Delta IV, JWST...",
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
        bottom: TabBar(
          tabs: [
            Tab(text: "Upcoming",),
            Tab(text: "Previous",),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => setState((){
              searchViewActive = false;
              searchQuery = null;
              searchActive = false;
              },)
          )
        ],
      );
    } else {
      return AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => setState(() => searchViewActive = true),
          ),
        ],
        bottom: TabBar(
          tabs: [
            Tab( text: "Upcoming",),
            Tab( text: "Previous",),
          ],
        ),
        title: Text(myTitle),
      );
    }
  }

  _search(value) {
    if (value is String) {
      setState(() {
        searchActive = true;
        searchQuery = value;
      });
    }
  }
}
