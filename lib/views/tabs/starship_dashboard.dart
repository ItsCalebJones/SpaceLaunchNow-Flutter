import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/starshipdashboard/starship_event_page.dart';
import 'package:spacelaunchnow_flutter/views/starshipdashboard/starship_overview_page.dart';
import 'package:spacelaunchnow_flutter/views/starshipdashboard/starship_vehicle_page.dart';

class StarshipDashboardPage extends StatefulWidget {
  const StarshipDashboardPage(this._configuration, this.index);

  final AppConfiguration _configuration;
  final int index;

  @override
  _StarshipDashboardPageState createState() =>
      _StarshipDashboardPageState();
}

class _StarshipDashboardPageState extends State<StarshipDashboardPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController!.animateTo(widget.index);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  ThemeData get barTheme {
    var qdarkMode = MediaQuery.of(context).platformBrightness;
    if (qdarkMode == Brightness.dark) {
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
              tabs: const [
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
            title: Text(
              'Starship',
              style: Theme.of(context).textTheme.headline1!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                  color: barTheme.focusColor),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              StarshipOverviewPage(widget._configuration),
              StarshipEventPage(widget._configuration),
              StarshipVehiclePage(widget._configuration),
            ],
          ),
        ));
  }
}
