import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/event/event_detailed.dart';
import 'package:spacelaunchnow_flutter/models/event/event_list.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';

import 'event_detail_body.dart';
import 'header/event_detail_header.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key, this.eventList, this.eventId});
  final EventList? eventList;
  final int? eventId;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool loading = false;
  late Event event;
  final SLNRepository _repository = Injector().slnRepository;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    Event? event =
        PageStorage.of(context).readState(context, identifier: 'event_detail');
    if (event != null) {
      event = event;
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
      logger.d(onError);
      onLoadEventError();
    });
  }

  void onLoadEventComplete(Event localEvent, [bool reload = false]) {
    setState(() {
      loading = false;
      event = localEvent;
      PageStorage.of(context)
          .writeState(context, event, identifier: 'event_detail');
    });
  }

  void onLoadEventError([bool? search]) {
    logger.d("Error occurred");
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
      content = Scaffold(body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            EventDetailHeader(
              event,
              backEnabled: true,
            ),
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth < 600) {
                    return _buildBody();
                  }

                  return Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: _buildBody(),
                      ));
                }),
          ],
        ),
      ));
    }
    return content;
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top:48.0),
      child: EventDetailBodyWidget(
        event: event,
      ),
    );
  }
}
