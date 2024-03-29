import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/news.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/views/widgets/ads/ad_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:spacelaunchnow_flutter/util/url_helper.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<News> _news = [];
  List<News> _newsBySite = [];
  int limit = 50;
  bool loading = false;
  bool siteLoading = false;
  bool showAds = false;
  int filterIndex = 0;
  final SLNRepository _repository = Injector().slnRepository;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ListAdWidget? squareAd;
  var logger = Logger();

  List<String> filters = [
      "All",
      "SpaceNews",
      "NASA",
      "NASA Spaceflight",
      "Teslarati",
      "Spaceflight Now",
      "Arstechnica"
    ];

  @override
  void initState() {
    super.initState();
    List<News>? news =
        PageStorage.of(context).readState(context, identifier: 'news');
    if (news != null) {
      _news = news;
    } else {
      _handleRefresh();
    }

    List<News>? newsBySite = PageStorage.of(context).readState(context, identifier: 'newsBySite');
    if (newsBySite != null) {
      _newsBySite = newsBySite;
    }

    squareAd = const ListAdWidget(AdSize.mediumRectangle);
    _prefs.then((SharedPreferences prefs) =>
        {showAds = prefs.getBool("showAds") ?? true});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onLoadResponseComplete(List<News> response, [bool reload = false]) {
    limit = 50;
    if (reload) {
      _news.clear();
    }
    setState(() {
      _news.addAll(response);
      PageStorage.of(context).writeState(context, _news, identifier: 'news');
    });
  }

  void onLoadResponseCompleteNewsSite(List<News> response, [bool reload = false]) {
    limit = 50;
    if (reload) {
      _newsBySite.clear();
    }
    setState(() {
      _newsBySite.addAll(response);
      PageStorage.of(context).writeState(context, _newsBySite, identifier: 'newsBySite');
    });
  }

  void onLoadContactsError([bool? search]) {
    logger.d("An error occurred!");
    setState(() {
      loading = false;
      siteLoading = false;
    });
    if (search == true) {
      setState(() {
        _news.clear();
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 10),
      content: const Text('Unable to load news.'),
      action: SnackBarAction(
        label: 'Refresh',
        onPressed: () {
          // Some code to undo the change!
          _handleRefresh();
        },
      ),
    ));
    return;
  }
  
  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_news.isEmpty && loading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_news.isEmpty) {
      content = const Center(
        child: Text("No Events Loaded"),
      );
    } else {
      content = Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                return ListView(
                  shrinkWrap: true,
                  physics: const PageScrollPhysics(),
                  children: _buildNewsList(),
                );
              }

              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const PageScrollPhysics(),
                    children: _buildNewsList(),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    return content;
  }

  Future<void> _handleRefresh() async {
    _news.clear();
    limit = 30;
    loading = false;
    List<News> response = await _repository.fetchNews().catchError((onError) {
      logger.d(onError);
      onLoadContactsError();
      return <News>[];
    });
    onLoadResponseComplete(response);
  }

    Future<void> _handleGetNewsBySite(String newsSite) async {
    _newsBySite.clear();
    limit = 30;
    siteLoading = false;
    List<News> response = await _repository.fetchNewsBySite(newsSite).catchError((onError) {
      logger.d(onError);
      onLoadContactsError();
      return <News>[];
    });
    onLoadResponseCompleteNewsSite(response);
  }

  List<Widget> _buildNewsList() {
    List<Widget> content = <Widget>[];
    if (_news.length >= 5) {
      content.addAll(_buildBriefList(_news.sublist(0, 5)));
    }

    if (showAds) {
      content.add(squareAd!);
    }
    
    content.add(
      SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
          child: ListView.builder(
            physics: const PageScrollPhysics(), 
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            itemBuilder: (BuildContext context, int index) {
              var string = filters[index];
              return Container(
                margin: const EdgeInsets.only(left: 6.0),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, left: 4, right: 4),
                  child: GestureDetector(
                    onTap: () => setFilter(index),
                    child: Chip(
                      label: Text(string,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  fontSize: 20,
                                  color: (filterIndex == index)
                                      ? Colors.white
                                      : Colors.white60)),
                      backgroundColor: (filterIndex == index)
                          ? Colors.blue
                          : Colors.grey[700],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    content.add(const Divider());

    List<News> theRest = _news.sublist(6, _news.length);
    if (filterIndex == 0) {
      content.addAll(_buildList(theRest));
    } else {
      if (siteLoading){
        content.add(const SizedBox(
          height: 200,
          child: CircularProgressIndicator()
        ));
      } else if (_newsBySite.isNotEmpty) {
        content.addAll(_buildList(_newsBySite));
      } else {
        content.add(const SizedBox(
          height: 200,
          child: Center(
            child: Text("No Events Loaded"),
          ),
        ));
      }
    }

    return content;
  }

  List<Widget> _buildList(List<News> sublist) {
    var data = [];
    List<Widget> content = <Widget>[];

    for (News item in sublist) {
      content.add(_buildNewsCard(item));
    }
    logger.d(data);
    return content;
  }

  List<Widget> _buildBriefList(List<News> sublist) {
    List<Widget> content = <Widget>[];

    sublist.asMap().forEach((key, value) {
      content.add(_buildMiniItem(key + 1, value));
      content.add(const Divider());
    });
    return content;
  }

  Widget _buildNewsCard(News item) {
    Widget widget;

    widget = Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 8, left: 8, right: 8),
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FadeInImage(
                  placeholder: const AssetImage('assets/placeholder.png'),
                  image: CachedNetworkImageProvider(item.featureImage!),
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.width * 0.40,
                  alignment: Alignment.center,
                  fadeInDuration: const Duration(milliseconds: 75),
                  fadeInCurve: Curves.easeIn,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
                child: Text(item.title!,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 4.0, bottom: 0, left: 16.0, right: 16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                          Text("${item.newsSiteLong!}  • ${timeago.format(item.datePublished!)}",
                          style: Theme.of(context).textTheme.labelSmall),
                    ]),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
                child: Text(item.summary!,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.left),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, bottom: 16, left: 16, right: 16),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        color: Theme.of(context).colorScheme.secondary,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Icon(
                                FontAwesomeIcons.newspaper,
                              ),
                            ),
                            Text(
                              'Read ',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                        onPressed: () {
                          openUrl(item.url!);
                        }, //
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        tooltip: 'Share',
                        onPressed: () {
                          Share.share(item.url!);
                        }, //
                      )
                    ]),
              ),
            ],
          ),
        ),
    );

    return widget;
  }

  Widget _buildMiniItem(int index, News item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: () => openUrl(item.url!),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 7, // 60%
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0),
                      child: Text(
                          "${index.toString()}. ${item.newsSiteLong!} • ${timeago.format(item.datePublished!)}",
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 4.0, top: 4.0, bottom: 4.0),
                      child: Text(item.title!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3, // 20%
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/placeholder.png'),
                    image: CachedNetworkImageProvider(item.featureImage!),
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.center,
                    fadeInDuration: const Duration(milliseconds: 50),
                    fadeInCurve: Curves.easeIn,
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  setFilter(int index) {
    setState(() {
      siteLoading = true;
      filterIndex = index;
    });
    _handleGetNewsBySite(filters[index]);
  }
}

class ListItem {
  String? type;
  News? news;
  StaggeredGridTile? tileSize;
}
