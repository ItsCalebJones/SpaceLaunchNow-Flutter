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
import 'package:spacelaunchnow_flutter/views/eventdetails/event_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';

class EventListPage extends StatefulWidget {
  const EventListPage(this._configuration);

  final AppConfiguration _configuration;

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<EventList> _upcomingEvents = [];
  List<EventList> _previousEvents = [];

  int limit = 20;
  bool loading = false;
  List<bool> isSelected = [true, false];

  final SLNRepository _repository = Injector().slnRepository;

  @override
  void initState() {
    super.initState();
    List<EventList>? upcomingEvents = PageStorage.of(context)!
        .readState(context, identifier: 'upcoming_events');
    List<EventList>? previousEvents = PageStorage.of(context)!
        .readState(context, identifier: 'previous_events');

    if (upcomingEvents != null && previousEvents != null) {
      _upcomingEvents = upcomingEvents;
      _previousEvents = previousEvents;
    } else {
      lockedLoadNext();
    }
    isSelected = [true, false];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void lockedLoadNext() {
    if (loading == false) {
      loadEvents();
    }
  }

  void loadEvents() {
    loading = true;
    _repository
        .fetchNextEvent(limit: limit.toString(), offset: "0")
        .then((events) => onLoadUpcomingEventsComplete(events))
        .catchError((onError) {
      print(onError);
      onLoadEventsError();
    });
    _repository
        .fetchPreviousEvent(limit: limit.toString(), offset: "0")
        .then((events) => onLoadPreviousEventsComplete(events))
        .catchError((onError) {
      print(onError);
      onLoadEventsError();
    });
  }

  Future<void> _handleRefresh() async {
    lockedLoadNext();
  }

  void onLoadUpcomingEventsComplete(Events events, [bool reload = false]) {
    loading = false;

    if (reload) {
      _upcomingEvents.clear();
    }

    setState(() {
      _upcomingEvents.addAll(events.events!);
      PageStorage.of(context)!
          .writeState(context, _upcomingEvents, identifier: 'upcoming_events');
    });
  }

  void onLoadPreviousEventsComplete(Events events, [bool reload = false]) {
    loading = false;

    if (reload) {
      _previousEvents.clear();
    }

    setState(() {
      _previousEvents.addAll(events.events!);
      PageStorage.of(context)!
          .writeState(context, _previousEvents, identifier: 'previous_events');
    });
  }

  void onLoadEventsError() {
    loading = false;
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 10),
      content: Text('Unable to load events.'),
      action: SnackBarAction(
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

  void _navigateToLaunchDetails(
      {Events? event, Object? avatarTag, String? launchId}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) {
          return LaunchDetailPage(
            widget._configuration,
            launch: null,
            avatarTag: avatarTag,
            launchId: launchId,
          );
        },
      ),
    );
  }

  List<Widget> _buildList() {
    var data = [];
    List<Widget> content = <Widget>[];

    if (isSelected[0]) {
      for (Object item in _upcomingEvents) {
        content.add(_buildEventListTile(item as EventList));
      }
    } else {
      for (Object item in _previousEvents) {
        content.add(_buildEventListTile(item as EventList));
      }
    }
    print(data);
    return content;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = <Widget>[];

    if (_upcomingEvents.isEmpty && _previousEvents.isEmpty && loading) {
      content.add(const SizedBox(height: 200));
      content.add(Center(
        child: const CircularProgressIndicator(),
      ));
    } else if (_upcomingEvents.isEmpty && _previousEvents.isEmpty) {
      content.add(SizedBox(height: 200));
      content.add(Center(
        child: Text("Unable to Load Dashboard"),
      ));
    } else {
      content.addAll(_buildList());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(8.0),
              textStyle: Theme.of(context).textTheme.subtitle1,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Upcoming"),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Previous"),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: isSelected,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            children: content,
          ),
        ),
      ],
    );
  }

  Widget _buildEventButtons(EventList event) {
    List<Widget> eventButtons = [];
    List<Widget> iconButtons = [];

    if (event.id != null) {
      eventButtons.add(
        CupertinoButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: const Icon(
                  Icons.explore,
                ),
              ),
              Text(
                'Explore',
                style: const TextStyle(),
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
      iconButtons.add(Padding(
          padding: const EdgeInsets.only(
              top: 4.0, bottom: 4.0, right: 8.0, left: 8.0),
          child: IconButton(
            icon: const Icon(Icons.live_tv),
            tooltip: 'Watch Event',
            onPressed: () {
              _openBrowser(event.videoUrl!);
            }, //
          )));
    }

    eventButtons.add(Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: iconButtons,
      ),
    ));

    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: eventButtons);
  }

  Widget _buildEventListTile(EventList event) {
    var formatter = DateFormat.yMd();
    String? location = "";

    if (event.location != null) {
      location = event.location;
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        onTap: () => _navigateToEventDetails(event: null, eventId: event.id),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(event.featureImage!),
        ),
        title: Text(event.name!,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontSize: 15.0)),
        subtitle: Text(location!),
        trailing: Text(formatter.format(event.net!),
            style: Theme.of(context).textTheme.caption),
      ),
    );
  }

  _openBrowser(String url) async {
    Uri? _url = Uri.tryParse(url);
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
      {EventList? event, Object? avatarTag, int? eventId}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) {
          return EventDetailPage(
            widget._configuration,
            eventList: event,
            eventId: eventId,
          );
        },
      ),
    );
  }
}
