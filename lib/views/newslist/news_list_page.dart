import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/news.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsListPage extends StatefulWidget {
  NewsListPage(this._configuration);

  final AppConfiguration _configuration;

  @override
  _NewsListPageState createState() => new _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<News> _news = [];
  int limit = 20;
  bool loading = false;
  SLNRepository _repository = new Injector().slnRepository;

  @override
  void initState() {
    super.initState();
    List<News> news =
        PageStorage.of(context).readState(context, identifier: 'news');
    if (news != null) {
      _news = news;
    } else {
      _handleRefresh();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onLoadResponseComplete(List<News> response, [bool reload = false]) {
    limit = 30;
    if (reload) {
      _news.clear();
    }
    setState(() {
      if (response != null) {
        _news.addAll(response);
      }
      PageStorage.of(context).writeState(context, _news, identifier: 'news');
    });
  }

  void onLoadContactsError([bool search]) {
    print("An error occured!");
    setState(() {
      loading = false;
    });
    if (search == true) {
      setState(() {
        _news.clear();
      });
      Scaffold.of(context).showSnackBar(new SnackBar(
        duration: new Duration(seconds: 10),
        content: new Text('Unable to load launches matching search.'),
        action: new SnackBarAction(
          label: 'Refresh',
          onPressed: () {
            // Some code to undo the change!
            _handleRefresh();
          },
        ),
      ));
    }
  }

  ThemeData get appBarTheme {
    if (widget._configuration.nightMode) {
      return kIOSThemeDark;
    } else {
      return kIOSTheme;
    }
  }

  Widget _buildEventTile(BuildContext context, int index) {
    var news = _news[index];
    var formatter = new DateFormat('MMM yyyy');

    return new Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: new InkWell(
        borderRadius: BorderRadius.circular(2),
        onTap: () => _openBrowser(news),
        child: new Stack(
          children: <Widget>[
            new Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: news.featureImage,
                placeholder: (context, url) => Image.asset(
                      "assets/placeholder.png",
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            new Positioned.fill(
              child: new Stack(children: <Widget>[
                new Positioned.fill(
                  child: new LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    var diff = constraints.maxHeight - 60;
                    return Padding(
                      padding: EdgeInsets.only(top: diff),
                      child: new Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.65),
                        ),
                      ),
                    );
                  }),
                ),
                new Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          news.title,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0.5, 0.5),
                                blurRadius: 5.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              Shadow(
                                offset: Offset(0.5, 0.5),
                                blurRadius: 10.0,
                                color: Color.fromARGB(79, 0, 0, 255),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        new Text(news.newsSiteLong,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 5.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 8.0,
                                  color: Color.fromARGB(79, 0, 0, 255),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      elevation: 2,
      margin: EdgeInsets.all(8),
    );
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
      GridView listView = new GridView.builder(
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _news.length,
        itemBuilder: _buildEventTile,
      );

      content =
          new RefreshIndicator(onRefresh: _handleRefresh, child: listView);
    }

    return content;
  }


  Future<Null> _handleRefresh() async {
    _news.clear();
    limit = 30;
    loading = false;
    List<News> response =
        await _repository.fetchNews().catchError((onError) {
      onLoadContactsError();
    });
    onLoadResponseComplete(response);
    return null;
  }

  _openBrowser(News news) async {
    var url = news.url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
