import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/dashboard/starship.dart';
import 'package:spacelaunchnow_flutter/models/event/event_list.dart';
import 'package:spacelaunchnow_flutter/models/launch/list/launch_list.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/views/eventdetails/event_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';

class StarshipEventPage extends StatefulWidget {
  StarshipEventPage(this._configuration);

  final AppConfiguration _configuration;

  @override
  _StarshipEventPageState createState() => new _StarshipEventPageState();
}

class _StarshipEventPageState extends State<StarshipEventPage> {
  Starship _starship;
  bool loading = false;
  bool usingCached = false;
  SLNRepository _repository = new Injector().slnRepository;
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    Starship starship =
        PageStorage.of(context).readState(context, identifier: 'starship');
    if (starship != null) {
      _starship = starship;
      usingCached = true;
    } else {
      lockedLoadNext();
    }
    isSelected = [true, false];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onLoadResponseComplete(Starship starship, [bool reload = false]) {
    loading = false;
    usingCached = false;

    setState(() {
      _starship = starship;
      PageStorage.of(context)
          .writeState(context, _starship, identifier: 'starship');
    });
  }

  void onLoadContactsError([bool search]) {
    print("An error occured!");
    setState(() {
      loading = false;
    });
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
    return new Scaffold(
      body: _buildBody(),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return new Padding(
//      padding: const EdgeInsets.all(0.0),
//      child: new Column(
//        children: <Widget>[_buildBody()],
//      ),
//    );
//  }

  Widget _buildBody() {

    List<Widget> content = new List<Widget>();
    if (_starship == null || loading) {
      content.add(new SizedBox(height: 200));
      content.add(new Center(
        child: new CircularProgressIndicator(),
      ));
    } else if (_starship == null) {
      content.add(new SizedBox(height: 200));
      content.add(Center(
        child: new Text("Unable to Load Dashboard"),
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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Upcoming"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Previous"),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
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
          child: new ListView(
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            children: content,
          ),
        ),
      ],
    );
  }

  void lockedLoadNext() {
    if (loading == false) {
      loadNext(force: true);
    }
  }

  void loadNext({bool force}) {
    loading = true;
    if ((!usingCached) || force) {
      _repository
          .fetchStarshipDashboard()
          .then((response) => onLoadResponseComplete(response))
          .catchError((onError) {
        print(onError);
        onLoadContactsError();
      });
    }
  }

  List<Widget> _buildList() {
    var dataUpcoming = [];
    List<Widget> content = new List<Widget>();


    if (isSelected[0]) {
      dataUpcoming.addAll(_starship.upcoming.events);
      dataUpcoming.addAll(_starship.upcoming.launches);
      dataUpcoming.sort((a, b) => a.net.compareTo(b.net));
    } else {
      dataUpcoming.addAll(_starship.previous.events);
      dataUpcoming.addAll(_starship.previous.launches);
      dataUpcoming.sort((a, b) => b.net.compareTo(a.net));
    }
    print(dataUpcoming);
    for (Object item in dataUpcoming){
      content.add(_buildTile(item));
    }
    return content;
  }

  _openUrl(String url) async {
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

  _buildTile(Object item) {
      if (item is EventList) {
        return _buildEventListTile(item);
      } else if (item is LaunchList) {
        return _buildLaunchListTile(item);
      } else {
        return new Container();
      }
    }

  Widget _buildLaunchListTile(LaunchList launch) {
    var formatter = new DateFormat.yMd();
    return new Padding(
      padding: const EdgeInsets.all(8),
      child: new ListTile(
        onTap: () =>
            _navigateToLaunchDetails(launch: null, launchId: launch.id),
        leading: new CircleAvatar(
          backgroundImage: new CachedNetworkImageProvider(launch.image),
        ),
        title: new Text(launch.name,
            style:
                Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 15.0)),
        subtitle: new Text(launch.location),
        trailing: new Text(formatter.format(launch.net),
            style: Theme.of(context).textTheme.caption),
      ),
    );
  }

  Widget _buildEventListTile(EventList event) {
    var formatter = new DateFormat.yMd();
    return new Padding(
      padding: const EdgeInsets.all(8),
      child: new ListTile(
        onTap: () =>
            _navigateToEventDetails(event: null, eventId: event.id),
        leading: new CircleAvatar(
          backgroundImage: new CachedNetworkImageProvider(event.featureImage),
        ),
        title: new Text(event.name,
            style:
                Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 15.0)),
        subtitle: new Text(event.location),
        trailing: new Text(formatter.format(event.net),
            style: Theme.of(context).textTheme.caption),
      ),
    );
  }

  void _navigateToLaunchDetails(
      {LaunchList launch, Object avatarTag, String launchId}) {
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

  void _navigateToEventDetails(
      {EventList event, Object avatarTag, int eventId}) {
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
