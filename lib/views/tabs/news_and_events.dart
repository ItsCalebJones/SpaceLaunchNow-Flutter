import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/views/eventlist/event_list_page.dart';
import 'package:spacelaunchnow_flutter/views/newslist/news_list_page.dart';

import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/twitterlist/twitter_list_page.dart';

class NewsAndEventsPage extends StatefulWidget {
  NewsAndEventsPage(this._configuration);

  final AppConfiguration _configuration;

  @override
  _NewsAndEventsPageState createState() => new _NewsAndEventsPageState();
}

class _NewsAndEventsPageState extends State<NewsAndEventsPage> {
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
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
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
            title: Text('Space Launch News'),
          ),
          body: TabBarView(
            children: [
              new NewsListPage(widget._configuration),
              new EventListPage(widget._configuration),
              new TwitterFeedPage(widget._configuration),
            ],
          ),
        ));
  }
}
