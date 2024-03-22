import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/views/eventlist/event_list_page.dart';
import 'package:spacelaunchnow_flutter/views/newslist/news_list_page.dart';

class NewsAndEventsPage extends StatefulWidget {
  const NewsAndEventsPage(this.newsAndEventsIndex, {super.key});
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
                  fontSize: 34),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              NewsListPage(),
              EventListPage(),
            ],
          ),
        ));
  }
}
