import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/event/event_list.dart';
import 'package:spacelaunchnow_flutter/models/event/events.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/util/ads.dart';
import 'package:spacelaunchnow_flutter/views/eventdetails/event_detail_page.dart';
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
  List<EventList> _events = [];
  int nextOffset = 0;
  int totalCount = 0;
  int offset = 0;
  int limit = 10;
  bool loading = false;
  bool searchActive = false;
  SLNRepository _repository = new Injector().slnRepository;

  @override
  void initState() {
    super.initState();
    List<EventList> events =
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
        content: new Text('Unable to load events.'),
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
    var event = _events[index];
    var formatter = new DateFormat("h:mm a 'on' EEEE, MMMM d, yyyy");

    return new Padding(
      padding:
      const EdgeInsets.only(top: 0.0, bottom: 4.0, left: 8.0, right: 8.0),
      child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: event.featureImage,
                imageBuilder: (context, imageProvider) => Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/placeholder.png'),
                      fit: BoxFit.cover,
                      // ...
                    ),
                    // ...
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/placeholder.png'),
                      fit: BoxFit.cover,
                      // ...
                    ),
                    // ...
                  ),
                )
              ),
              new Text(event.name, textAlign: TextAlign.center, style: Theme
                  .of(context)
                  .textTheme
                  .title),
              new Text(event.location,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle),
              new Text("Type: " + event.type.name,
                  style: Theme
                      .of(context)
                      .textTheme
                      .caption),
              new Text(formatter.format(event.date.toLocal()),
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
                    maxLines: 5,
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
    limit = 10;
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

  Widget _buildEventButtons(EventList event) {
    List<Widget> eventButtons = [];
    List<Widget> iconButtons = [];

    if (event.id != null) {
      eventButtons.add(
        new CupertinoButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: new Icon(
                  Icons.explore,
                ),
              ),
              new Text(
                'Explore',
                style: TextStyle(),
              ),
            ],
          ),
          onPressed: () {
            _navigateToEventDetails(event: event, eventId: event.id);
          }, //
        ),
      );
    }

    if (event.videoUrl != null) {
      iconButtons.add(new Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0, left: 8.0),
          child: new IconButton(
            icon: Icon(Icons.live_tv),
            tooltip: 'Watch Event',
            onPressed: () {
              _openBrowser(event.videoUrl);
            }, //
          )));
    }

    eventButtons.add(Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: iconButtons,
      ),
    ));

    return new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: eventButtons);
  }

  _openBrowser(String url) async {
    Uri _url = Uri.tryParse(url);
    if (_url != null && _url.host.contains("youtube.com") && Platform.isIOS) {
      final String _finalUrl = _url.host + _url.path + "?" + _url.query;
      if (await canLaunch('youtube://$_finalUrl')) {
        await launch('youtube://$_finalUrl', forceSafariVC: false);
      }
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void _navigateToEventDetails(
      {EventList event, Object avatarTag, int eventId}) {
    Ads.hideBannerAd();
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new EventDetailPage(widget._configuration,
            eventList: event,
            eventId: eventId,);
        },
      ),
    );
  }
}
