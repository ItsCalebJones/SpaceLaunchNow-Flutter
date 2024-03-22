import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/starshipdashboard/starship_event_page.dart';
import 'package:spacelaunchnow_flutter/views/starshipdashboard/starship_overview_page.dart';
import 'package:spacelaunchnow_flutter/views/starshipdashboard/starship_vehicle_page.dart';

class StarshipDashboardPage extends StatefulWidget {
  const StarshipDashboardPage(this._configuration, this.index, {super.key});

  final AppConfiguration _configuration;
  final int index;

  @override
  State<StarshipDashboardPage> createState() =>
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 20,
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
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 34),
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
