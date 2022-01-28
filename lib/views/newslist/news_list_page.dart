import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/news.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/widgets/ads/ad_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quiver/iterables.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsListPage extends StatefulWidget {
  NewsListPage(this._configuration);

  final AppConfiguration _configuration;

  @override
  _NewsListPageState createState() => new _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<News> _news = [];
  List<ListItem> _list = [];
  int limit = 50;
  bool loading = false;
  bool showAds = false;
  int filterIndex = 0;
  SLNRepository _repository = new Injector().slnRepository;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _squareAd;

  @override
  void initState() {
    super.initState();
    List<News>? news =
        PageStorage.of(context)!.readState(context, identifier: 'news');
    if (news != null) {
      _news = news;
    } else {
      _handleRefresh();
    }
    _squareAd = ListAdWidget(AdSize.mediumRectangle);
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
      if (response != null) {
        _news.addAll(response);
      }
      PageStorage.of(context)!.writeState(context, _news, identifier: 'news');
    });
  }

  void onLoadContactsError([bool? search]) {
    print("An error occured!");
    setState(() {
      loading = false;
    });
    if (search == true) {
      setState(() {
        _news.clear();
      });
    }
    Scaffold.of(context).showSnackBar(new SnackBar(
      duration: new Duration(seconds: 10),
      content: new Text('Unable to load news.'),
      action: new SnackBarAction(
        label: 'Refresh',
        onPressed: () {
          // Some code to undo the change!
          _handleRefresh();
        },
      ),
    ));
  }

  ThemeData get appBarTheme {
    if (widget._configuration.nightMode) {
      return kIOSThemeDark;
    } else {
      return kIOSTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_news.isEmpty && loading) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else if (_news.isEmpty) {
      content = new Center(
        child: new Text("No Events Loaded"),
      );
    } else {
      content = Scaffold(
        body: new ListView(
          shrinkWrap: true,
          children: _buildNewsList() as List<Widget>,
        ),
      );
    }
    return content;
  }

  Future<Null> _handleRefresh() async {
    _news.clear();
    limit = 30;
    loading = false;
    List<News> response = await _repository.fetchNews().catchError((onError) {
      print(onError);
      onLoadContactsError();
    });
    onLoadResponseComplete(response);
    return null;
  }

  _openBrowser(News news) async {
    var url = news.url!;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildBriefing() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 16.0, bottom: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Text("Latest News...",
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget?> _buildNewsList() {
    List<Widget?> content = new List<Widget?>();
    content.add(_buildBriefing());
    if (_news.length >= 5) {
      content.addAll(_buildBriefList(_news.sublist(0, 5)));
    }

    if (showAds) {
      content.add(_squareAd);
    }

    List<String> filters = ["All", "SpaceNews", "NASA", "NASA Spaceflight",
      "Teslarati", "Spaceflight Now", "Arstechnica"];
    content.add(
      SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.only(top:8,bottom:0,left:0,right:0),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            itemBuilder: (BuildContext context, int index) {
              var string = filters[index];
              return Container(
                margin: const EdgeInsets.only(left: 6.0),
                child: Padding(
                  padding: const EdgeInsets.only(top:0,bottom:0,left:4,right:4),
                  child: GestureDetector(
                    onTap: () => setFilter(index),
                    child: Chip(
                        label: new Text(string,
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(fontSize: 20, color: (filterIndex == index) ? Colors.white : Colors.white60)),
                        backgroundColor: (filterIndex == index) ? Colors.blue : Colors.grey[700],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    List<News> theRest = _news.sublist(6, _news.length);
    if (filterIndex == 0) {
      content.addAll(_buildList(theRest));
    } else {
      theRest = theRest.where((i) => i.newsSiteLong!.toLowerCase() == filters[filterIndex].toLowerCase()).toList();
      if (theRest.length > 0) {
        content.addAll(_buildList(theRest));
      } else {
        content.add(Container(
          height: 200,
          child: new Center(
            child: new Text("No Events Loaded"),
          ),
        ));
      }
    }

    return content;
  }

  List<Widget> _buildList(List<News> sublist) {
    var data = [];
    List<Widget> content = new List<Widget>();

    for (News item in sublist) {
      content.add(_buildNewsCard(item));
    }
    print(data);
    return content;
  }

  List<Widget> _buildBriefList(List<News> sublist) {
    List<Widget> content = new List<Widget>();

    sublist.asMap().forEach((key, value) {
      content.add(Divider());
      content.add(_buildMiniItem(key + 1, value));
    });
    return content;
  }

  Widget _buildNewsCard(News item) {
    Widget widget;

    widget = Padding(
      padding: const EdgeInsets.only(top:0, bottom:8, left:8, right:8),
      child: GestureDetector(
        onTap: () => _openBrowser(item),
        child: new Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: FadeInImage(
                  placeholder: new AssetImage('assets/placeholder.png'),
                  image: new CachedNetworkImageProvider(item.featureImage!),
                  fit: BoxFit.cover,
                  height: 175.0,
                  alignment: Alignment.center,
                  fadeInDuration: new Duration(milliseconds: 75),
                  fadeInCurve: Curves.easeIn,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
                child: new Text(item.title!,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
                child: new Text(item.summary!,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.left),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 4.0, bottom: 0, left: 16.0, right: 16.0),
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          new Text(item.newsSiteLong!),
                          new Text(" • "),
                          new Text(timeago.format(item.datePublished!))
                        ],
                      ),
                      new IconButton(
                        icon: Icon(Icons.share),
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
      ),
    );

    return widget;
  }

  Widget _buildMiniItem(int index, News item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7, // 60%
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      new Text(index.toString() + ". "),
                      new Text(item.newsSiteLong!),
                      new Text(" • "),
                      new Text(timeago.format(item.datePublished!))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 4.0, top: 4.0, bottom: 4.0),
                    child: new Text(item.title!,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3, // 20%
              child: new Container(
                width: MediaQuery.of(context).size.width,
                child: FadeInImage(
                  placeholder: new AssetImage('assets/placeholder.png'),
                  image: new CachedNetworkImageProvider(item.featureImage!),
                  fit: BoxFit.cover,
                  height: 80.0,
                  alignment: Alignment.center,
                  fadeInDuration: new Duration(milliseconds: 50),
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
      filterIndex = index;
    });
  }
}

class ListItem {
  String? type;
  News? news;
  StaggeredGridTile? tileSize;
}
