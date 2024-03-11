import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/views/eventlist/event_list_page.dart';
import 'package:spacelaunchnow_flutter/views/newslist/news_list_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';

class NewsAndEventsPage extends StatefulWidget {
  const NewsAndEventsPage(this._configuration, this.newsAndEventsIndex, {super.key});

  final AppConfiguration _configuration;
  final int newsAndEventsIndex;

  @override
  State<NewsAndEventsPage> createState() => _NewsAndEventsPageState();
}

class _NewsAndEventsPageState extends State<NewsAndEventsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController!.animateTo(widget.newsAndEventsIndex);
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
                  text: "News",
                ),
                Tab(
                  text: "Events",
                ),
              ],
            ),
            title: Text(
              'News',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                  color: barTheme.focusColor),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              NewsListPage(widget._configuration),
              EventListPage(widget._configuration),
            ],
          ),
        ));
  }
}
