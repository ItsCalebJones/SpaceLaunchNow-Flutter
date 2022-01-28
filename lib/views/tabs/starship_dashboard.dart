import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/views/eventlist/event_list_page.dart';
import 'package:spacelaunchnow_flutter/views/newslist/news_list_page.dart';

import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/starshipdashboard/starship_event_page.dart';
import 'package:spacelaunchnow_flutter/views/starshipdashboard/starship_overview_page.dart';
import 'package:spacelaunchnow_flutter/views/starshipdashboard/starship_vehicle_page.dart';
import 'package:spacelaunchnow_flutter/views/twitterlist/twitter_list_page.dart';
import 'package:spacelaunchnow_flutter/views/widgets/ads/ad_widget.dart';

class StarshipDashboardPage extends StatefulWidget {
  StarshipDashboardPage(this._configuration, this.index);

  final AppConfiguration _configuration;
  final int index;

  @override
  _StarshipDashboardPageState createState() => new _StarshipDashboardPageState();
}

class _StarshipDashboardPageState extends State<StarshipDashboardPage> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    _tabController.animateTo(widget.index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ThemeData get barTheme {
    var qdarkMode = MediaQuery.of(context).platformBrightness;
    if (qdarkMode == Brightness.dark){
      return kIOSThemeDarkBar;
    } else {
      return kIOSThemeBar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: barTheme.canvasColor,
            elevation: 0.0,
            centerTitle: false,
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: "Overview",
                ),
                Tab(
                  text: "Events",
                ),
                Tab(
                  text: "Vehicles",
                )
              ],
            ),
            title: Text('Starship',
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 34, color: barTheme.focusColor),),
          ),
          body: TabBarView(
                controller: _tabController,
                children: [
                  new StarshipOverviewPage(widget._configuration),
                  new StarshipEventPage(widget._configuration),
                  new StarshipVehiclePage(widget._configuration),
                ],
            ),
        )
    );
  }
}
