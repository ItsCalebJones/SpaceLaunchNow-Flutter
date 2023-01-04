import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/event/event_detailed.dart';
import 'package:spacelaunchnow_flutter/models/event/event_list.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';

import 'event_detail_body.dart';
import 'header/event_detail_header.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage(this._configuration,
      {Key? key, this.eventList, this.eventId})
      : super(key: key);

  final AppConfiguration _configuration;
  final EventList? eventList;
  final int? eventId;

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool loading = false;
  late Event event;
  final SLNRepository _repository = Injector().slnRepository;

  @override
  void initState() {
    super.initState();
    Event? _event =
        PageStorage.of(context)!.readState(context, identifier: 'event_detail');
    if (_event != null) {
      event = _event;
    } else {
      lockedLoadEvent();
    }
  }

  void lockedLoadEvent() {
    if (loading == false) {
      loadEvent();
    }
  }

  void loadEvent() {
    setState(() {
      loading = true;
    });
    int? eventId;
    if (widget.eventList != null) {
      eventId = widget.eventList!.id;
    } else {
      eventId = widget.eventId;
    }
    _repository
        .fetchEventById(eventId)
        .then((event) => onLoadEventComplete(event))
        .catchError((onError) {
      print(onError);
      onLoadEventError();
    });
  }

  void onLoadEventComplete(Event _event, [bool reload = false]) {
    setState(() {
      loading = false;
      event = _event;
      PageStorage.of(context)!
          .writeState(context, event, identifier: 'event_detail');
    });
  }

  void onLoadEventError([bool? search]) {
    print("Error occured");
    loading = false;
    if (search == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 10),
        content: const Text('Unable to load events.'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            // Some code to undo the change!
            loadEvent();
          },
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (loading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      content = Scaffold(body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                EventDetailHeader(
                  event,
                  backEnabled: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: EventDetailBodyWidget(
                    configuration: widget._configuration,
                    event: event,
                  ),
                ),
              ],
            ),
          ),
        );
      }));
    }
    return content;
  }
}
