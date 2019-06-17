import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/event.dart';
import 'package:spacelaunchnow_flutter/models/events.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';

class EventListPage extends StatefulWidget {
  EventListPage(this._configuration);

  final AppConfiguration _configuration;

  @override
  _EventListPageState createState() => new _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<Event> _events = [];
  int nextOffset = 0;
  int totalCount = 0;
  int offset = 0;
  int limit = 5;
  bool loading = false;
  bool searchActive = false;
  SLNRepository _repository = new Injector().slnRepository;

  @override
  void initState() {
    super.initState();
    List<Event> events =
    PageStorage.of(context).readState(context, identifier: 'events');
    if (events != null) {
      _events = events;
    } else {
      lockedLoadNext();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onLoadEventsComplete(Events events, [bool reload = false]) {
    loading = false;
    nextOffset = events.nextOffset;
    totalCount = events.count;
    print(
        "Next: " + nextOffset.toString() + " Total: " + totalCount.toString());
    if (reload) {
      _events.clear();
    }
    setState(() {
      _events.addAll(events.events);
      PageStorage.of(context)
          .writeState(context, _events, identifier: 'events');
    });
  }

  void onLoadContactsError([bool search]) {
    print("Error occured");
    loading = false;
    if (search == true) {
      setState(() {
        _events.clear();
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
      return kIOSThemeDarkAppBar;
    } else {
      return kIOSThemeAppBar;
    }
  }

  Widget _buildEventTile(BuildContext context, int index) {
    var event = _events[index];
    var formatter = new DateFormat.jm().add_yMMMMEEEEd();

    return new Padding(
      padding:
      const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
      child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: <Widget>[
              Container(
                child: FadeInImage(
                  placeholder: new AssetImage('assets/placeholder.png'),
                  image: new CachedNetworkImageProvider(event.featureImage),
                  fit: BoxFit.fitWidth,
                  fadeInDuration: new Duration(milliseconds: 75),
                  fadeInCurve: Curves.easeIn,
                ),
              ),
              new Text(event.name, style: Theme
                  .of(context)
                  .textTheme
                  .title),
              new Text(event.location,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle),
              new Text("Type: " + event.type,
                  style: Theme
                      .of(context)
                      .textTheme
                      .caption),
              new Text(formatter.format(event.date),
                  style: Theme
                      .of(context)
                      .textTheme
                      .caption),
              Container(
                padding: const EdgeInsets.only(
                    top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
                child: new Text(event.description,
                    style: Theme
                        .of(context)
                        .textTheme
                        .body1,
                    textAlign: TextAlign.left),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                  child: _buildEventButtons(event),
                ),
              )
            ],
          )),
    );
  }

  void _navigateToLaunchDetails(
      {Events event, Object avatarTag, String launchId}) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new LaunchDetailPage(
            widget._configuration,
            launch: null,
            avatarTag: avatarTag,
            launchId: launchId,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_events.isEmpty && loading) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else if (_events.isEmpty) {
      content = new Center(
        child: new Text("No Events Loaded"),
      );
    } else {
      ListView listView = new ListView.builder(
        itemCount: _events.length,
        itemBuilder: _buildEventTile,
      );

      content =
      new RefreshIndicator(onRefresh: _handleRefresh, child: listView);
    }

    return content;
  }

  void notifyThreshold() {
    lockedLoadNext();
  }

  void lockedLoadNext() {
    if (loading == false) {
      loadNext();
    }
  }

  void loadNext() {
    loading = true;
    if (totalCount == 0 || nextOffset != null) {
      _repository
          .fetchNextEvent(
          limit: limit.toString(), offset: nextOffset.toString())
          .then((events) => onLoadEventsComplete(events))
          .catchError((onError) {
        print(onError);
        onLoadContactsError();
      });
    }
  }

  Future<Null> _handleRefresh() async {
    _events.clear();
    loading == false;
    totalCount = 0;
    limit = 0;
    nextOffset = 0;
    searchActive = false;
    loading = true;
    Events responseEvents = await _repository
        .fetchNextEvent(limit: limit.toString(), offset: nextOffset.toString())
        .catchError((onError) {
      onLoadContactsError();
    });
    onLoadEventsComplete(responseEvents);
    return null;
  }

  Widget _buildEventButtons(Event event) {
    List<Widget> eventButtons = [];

    if (event.newsUrl != null) {
      eventButtons.add(new Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: new RaisedButton(
          child: const Text(
            'Explore',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
          elevation: 4.0,
          splashColor: Colors.blueGrey,
          onPressed: () {
            _openBrowser(event.newsUrl);
          }, //
        ),
      )
      );
    }
    if (event.videoUrl != null) {
      eventButtons.add(new Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: new RaisedButton(
            child: const Text(
              'Watch',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.redAccent,
            elevation: 4.0,
            splashColor: Colors.blueGrey,
            onPressed: () {
              _openBrowser(event.videoUrl);
            }, //
          )
      ));
    }
    return new Row(children: eventButtons);
  }

  _openBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
