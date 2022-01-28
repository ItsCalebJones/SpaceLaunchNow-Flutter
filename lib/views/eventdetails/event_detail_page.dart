

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
  EventDetailPage(this._configuration,
      {this.eventList, this.eventId});

  final AppConfiguration _configuration;
  final EventList? eventList;
  final int? eventId;



  @override
  _EventDetailPageState createState() => new _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {

  bool loading = false;
  Event? event;
  SLNRepository _repository = new Injector().slnRepository;

  @override
  void initState() {
    Event? _event = PageStorage.of(context)!.readState(context, identifier: 'event_detail');
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
    loading = true;
    var eventId;
    if (widget.eventList != null){
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
    loading = false;

    setState(() {
      event = _event;
      PageStorage.of(context)!.writeState(context, event,
          identifier: 'event_detail');
    });
  }

  void onLoadEventError([bool? search]) {
    print("Error occured");
    loading = false;
    if (search == true) {
      setState(() {
        event = null;
      });
      Scaffold.of(context).showSnackBar(new SnackBar(
        duration: new Duration(seconds: 10),
        content: new Text('Unable to load events.'),
        action: new SnackBarAction(
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
    if (event == null) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
        content = new Scaffold(body: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return new SingleChildScrollView(
                child: new ConstrainedBox(
                  constraints: new BoxConstraints(
                      minHeight: constraints.maxHeight),
                  child: new Container(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new EventDetailHeader(
                          event,
                          backEnabled: true,
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: new EventDetailBodyWidget(
                            event,
                            widget._configuration,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        )
      );
    }
    return content;
  }
}