import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/dashboard/notice.dart';
import 'package:spacelaunchnow_flutter/models/dashboard/road_closure.dart';
import 'package:spacelaunchnow_flutter/models/dashboard/starship.dart';
import 'package:spacelaunchnow_flutter/models/event/event_list.dart';
import 'package:spacelaunchnow_flutter/models/launch/list/launch_list.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/widgets/ads/ad_widget.dart';
import 'package:spacelaunchnow_flutter/views/widgets/updates.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'custom_play_pause.dart';

class StarshipOverviewPage extends StatefulWidget {
  StarshipOverviewPage(this._configuration);

  final AppConfiguration _configuration;

  @override
  _StarshipOverviewPageState createState() => new _StarshipOverviewPageState();
}

class _StarshipOverviewPageState extends State<StarshipOverviewPage> {
  Starship? _starship;
  bool loading = false;
  bool usingCached = false;
  SLNRepository _repository = new Injector().slnRepository;
  GlobalKey _youTubeKey = GlobalKey(debugLabel: '_youTubeKey');

  @override
  void initState() {
    super.initState();
    Starship? starship =
        PageStorage.of(context)!.readState(context, identifier: 'starship');
    if (starship != null) {
      _starship = starship;
      usingCached = true;
    } else {
      lockedLoadNext();
    }
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
      PageStorage.of(context)!
          .writeState(context, _starship, identifier: 'starship');
    });
  }

  void onLoadContactsError([bool? search]) {
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
    } else if (_starship != null) {
      content.addAll(_buildDashboard());
    } else {
      content.add(new SizedBox(height: 200));
      content.add(Center(
        child: new Text("Unable to Load Dashboard"),
      ));
    }

    Widget widget;
    if (_starship != null && _starship!.liveStream!.length > 0) {
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId:
            YoutubePlayer.convertUrlToId(_starship!.liveStream!.first.url!)!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
        ),
      );
      widget = new YoutubePlayer(
        key: ObjectKey(_controller),
        controller: _controller,
        showVideoProgressIndicator: false,
        bottomActions: <Widget>[CustomPlayPauseButton()],
      );
    } else {
      widget = Container();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget,
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

  void loadNext({bool? force}) {
    loading = true;
    if ((!usingCached) || force!) {
      _repository
          .fetchStarshipDashboard()
          .then((response) => onLoadResponseComplete(response))
          .catchError((onError) {
        print(onError);
        onLoadContactsError();
      });
    }
  }

  List<Widget> _buildDashboard() {
    var dataUpcoming = [];

    dataUpcoming.addAll(_starship!.upcoming!.events!);
    dataUpcoming.addAll(_starship!.upcoming!.launches!);
    dataUpcoming.sort((a, b) => a.net.compareTo(b.net));
    print(dataUpcoming);

    final List<Widget> rows = <Widget>[
      new Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      _starship!.liveStream!.first.title!,
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      _starship!.liveStream!.first.description!,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: CupertinoButton(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: new Icon(
                        FontAwesomeIcons.youtube,
                      ),
                    ),
                    new Text(
                      'Open in YouTube',
                      style: TextStyle(),
                    ),
                  ],
                ),
                onPressed: () {
                  _openUrl(_starship!.liveStream!.first.url!);
                }, //
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding:
            const EdgeInsets.only(top: 4, left: 24, right: 24, bottom: 4.0),
        child: Divider(),
      ),
      new Container(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 24, right: 8.0, bottom: 8.0),
          child: new Text(
            "Up Next",
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 42),
          ),
        ),
      ),
      _addUpNext(dataUpcoming),
      ListAdWidget(AdSize.banner),
      buildUpdates(_starship!.updates!,
          context,
          "https://spacelaunchnow.me/starship#updates"),
      _addRoadClosure(),
      _addNotice(),
      ListAdWidget(AdSize.largeBanner),
      new SizedBox(
        height: 50,
      )
    ];
    return rows;
  }

  _openUrl(String url) async {
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

  _addUpNext(List dataUpcoming) {
    if (dataUpcoming != null && dataUpcoming.length > 0) {
      var next = dataUpcoming.first;
      if (next is EventList) {
        return _buildEventListTile(next);
      } else if (next is LaunchList) {
        return _buildLaunchListTile(next);
      } else {
        return new Container();
      }
    } else {
      return Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 24, right: 8.0, bottom: 8.0),
        child: new Text("No upcoming events.",
            style:
                Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 15.0)),
      );
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
          backgroundImage: new CachedNetworkImageProvider(launch.image!),
        ),
        title: new Text(launch.name!,
            style:
                Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 15.0)),
        subtitle: new Text(launch.location!),
        trailing: new Text(formatter.format(launch.net!),
            style: Theme.of(context).textTheme.caption),
      ),
    );
  }

  Widget _buildEventListTile(EventList event) {
    var formatter = new DateFormat.yMd();
    return new Padding(
      padding: const EdgeInsets.all(8),
      child: new ListTile(
        leading: new CircleAvatar(
          backgroundImage: new CachedNetworkImageProvider(event.featureImage!),
        ),
        title: new Text(event.name!,
            style:
                Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 15.0)),
        subtitle: new Text(event.location!),
        trailing: new Text(formatter.format(event.net!),
            style: Theme.of(context).textTheme.caption),
      ),
    );
  }

  void _navigateToLaunchDetails(
      {LaunchList? launch, Object? avatarTag, String? launchId}) {
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

  Widget _addRoadClosure() {
    var widgets = new List<Widget>();
    widgets.add(
      Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 24, right: 8.0, bottom: 8.0),
          child: new Text("Road Closures",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 42))),
    );

    if (_starship!.roadClosures!.length > 0) {
      for (RoadClosure item in _starship!.roadClosures!) {
        widgets.add(_buildRoadClosureTile(item));
      }
    } else {
      widgets.add(Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 4.0, left: 32.0, right: 32.0),
        child: new Text(
          "No road closures.",
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ));
    }

    return new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets);
  }

  Widget _buildRoadClosureTile(RoadClosure roadClosure) {
    var date_formatter = new DateFormat("EEEE, MMMM d, yyyy");
    var time_formatter = new DateFormat("h:mm a");

    return new Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 4.0, left: 32.0, right: 32.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Text(
              roadClosure.title!,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            new Text("Status: " + roadClosure.status!.name!),
            new Text(date_formatter.format(roadClosure.windowStart!)),
            new Text(time_formatter.format(roadClosure.windowStart!) +
                " - " +
                time_formatter.format(roadClosure.windowEnd!)),
            new Divider(),
          ],
        ));
  }

  Widget _addNotice() {
    var widgets = new List<Widget>();
    widgets.add(
      Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 24, right: 8.0, bottom: 8.0),
        child: new Text(
          "Notices",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 42),
        ),
      ),
    );
    if (_starship!.notices!.length > 0) {
      for (Notice item in _starship!.notices!) {
        widgets.add(_buildNoticeTile(item));
      }
    } else {
      widgets.add(Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 4.0, left: 32.0, right: 32.0),
        child: new Text(
          "No notices available.",
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ));
    }

    return new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets);
  }

  Widget _buildNoticeTile(Notice notice) {
    var date_formatter = new DateFormat("EEEE, MMMM d, yyyy");
    var time_formatter = new DateFormat("h:mm a");

    return new Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 4.0, left: 32.0, right: 32.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Text(
              notice.type!.name!,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(date_formatter.format(notice.date!)),
                      new Text(time_formatter.format(notice.date!)),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.open_in_browser),
                    onPressed: () {
                      _openUrl(notice.url!);
                    },
                  ),
                )
              ],
            ),
            new Divider(),
          ],
        ));
  }
}
