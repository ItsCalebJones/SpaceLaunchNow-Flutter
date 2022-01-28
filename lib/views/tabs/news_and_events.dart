import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/views/eventlist/event_list_page.dart';
import 'package:spacelaunchnow_flutter/views/newslist/news_list_page.dart';

import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/twitterlist/twitter_list_page.dart';

class NewsAndEventsPage extends StatefulWidget {
  NewsAndEventsPage(this._configuration, this.newsAndEventsIndex);

  final AppConfiguration _configuration;
  final int newsAndEventsIndex;

  @override
  _NewsAndEventsPageState createState() => new _NewsAndEventsPageState();
}

class _NewsAndEventsPageState extends State<NewsAndEventsPage> with SingleTickerProviderStateMixin {

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    _tabController!.animateTo(widget.newsAndEventsIndex);
  }

  @override
  void dispose() {
    _tabController!.dispose();
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
                  text: "News",
                ),
                Tab(
                  text: "Events",
                ),
                Tab(
                  text: "Twitter",
                )
              ],
            ),
            title: Text('News',
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 34, color: barTheme.focusColor),),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              new NewsListPage(widget._configuration),
              new EventListPage(widget._configuration),
              new TwitterFeedPage(widget._configuration),
            ],
          ),
        ));
  }
}
