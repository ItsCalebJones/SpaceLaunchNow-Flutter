import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/event/event_list.dart';
import 'package:spacelaunchnow_flutter/models/event/events.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/util/date_formatter.dart';
import 'package:spacelaunchnow_flutter/views/eventdetails/event_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';

class EventListPage extends StatefulWidget {
  const EventListPage(this._configuration, {super.key});

  final AppConfiguration _configuration;

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<EventList> _upcomingEvents = [];
  List<EventList> _previousEvents = [];

  int limit = 20;
  bool loading = false;
  List<bool> isSelected = [true, false];

  var logger = Logger();

  final SLNRepository _repository = Injector().slnRepository;

  @override
  void initState() {
    super.initState();
    List<EventList>? upcomingEvents = PageStorage.of(context)
        .readState(context, identifier: 'upcoming_events');
    List<EventList>? previousEvents = PageStorage.of(context)
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
      logger.d(onError);
      onLoadEventsError();
    });
    _repository
        .fetchPreviousEvent(limit: limit.toString(), offset: "0")
        .then((events) => onLoadPreviousEventsComplete(events))
        .catchError((onError) {
      logger.d(onError);
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
      PageStorage.of(context)
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
      PageStorage.of(context)
          .writeState(context, _previousEvents, identifier: 'previous_events');
    });
  }

  void onLoadEventsError() {
    loading = false;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 10),
      content: const Text('Unable to load events.'),
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

  List<Widget> _buildList() {
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
    return content;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = <Widget>[];

    if (_upcomingEvents.isEmpty && _previousEvents.isEmpty && loading) {
      content.add(const SizedBox(height: 200));
      content.add(const Center(
        child: CircularProgressIndicator(),
      ));
    } else if (_upcomingEvents.isEmpty && _previousEvents.isEmpty) {
      content.add(const SizedBox(height: 200));
      content.add(const Center(
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
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8.0),
              textStyle: Theme.of(context).textTheme.titleSmall,
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

  Widget _buildEventListTile(EventList event) {
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
                .titleMedium!
                .copyWith(fontSize: 15.0)),
        subtitle: Text(location!),
        trailing: Text(PrecisionFormattedDate.getShortPrecisionFormattedDate(event.datePrecision?.id ?? 0, event.date!),
            style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }

  void _navigateToEventDetails(
      {EventList? event, int? eventId}) {
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
