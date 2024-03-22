
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/dashboard/notice.dart';
import 'package:spacelaunchnow_flutter/models/dashboard/road_closure.dart';
import 'package:spacelaunchnow_flutter/models/dashboard/starship.dart';
import 'package:spacelaunchnow_flutter/models/event/event_list.dart';
import 'package:spacelaunchnow_flutter/models/launch/list/launch_list.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/util/url_helper.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/widgets/ads/ad_widget.dart';
import 'package:spacelaunchnow_flutter/views/widgets/updates.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'custom_play_pause.dart';

class StarshipOverviewPage extends StatefulWidget {
  const StarshipOverviewPage(this._configuration, {super.key});

  final AppConfiguration _configuration;

  @override
  State<StarshipOverviewPage> createState() => _StarshipOverviewPageState();
}

class _StarshipOverviewPageState extends State<StarshipOverviewPage> {
  Starship? _starship;
  bool loading = false;
  bool usingCached = false;
  final SLNRepository _repository = Injector().slnRepository;
  // final GlobalKey _youTubeKey = GlobalKey(debugLabel: '_youTubeKey');

  @override
  void initState() {
    super.initState();
    Starship? starship =
        PageStorage.of(context).readState(context, identifier: 'starship');
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
      PageStorage.of(context)
          .writeState(context, _starship, identifier: 'starship');
    });
  }

  void onLoadContactsError(onError, [bool? search]) {
    var logger = Logger();
    logger.d(onError);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:_buildBody()
      )
    );
  }

  Widget _buildBody() {
    List<Widget> content = <Widget>[];
    if (_starship == null || loading) {
      content.add(const SizedBox(height: 200));
      content.add(const Center(
        child: CircularProgressIndicator(),
      ));
    } else if (_starship == null) {
      content.add(const SizedBox(height: 200));
      content.add(const Center(
        child: Text("Unable to Load Dashboard"),
      ));
    } else if (_starship != null) {
      content.addAll(_buildDashboard());
    } else {
      content.add(const SizedBox(height: 200));
      content.add(const Center(
        child: Text("Unable to Load Dashboard"),
      ));
    }

    Widget widget;
    if (_starship != null && _starship!.liveStream!.isNotEmpty) {
      YoutubePlayerController controller = YoutubePlayerController(
        initialVideoId:
            YoutubePlayer.convertUrlToId(_starship!.liveStream!.first.url!)!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
        ),
      );
      widget = YoutubePlayer(
        key: ObjectKey(controller),
        controller: controller,
        showVideoProgressIndicator: false,
        bottomActions: const <Widget>[CustomPlayPauseButton()],
      );
    } else {
      widget = Container();
    }

    if (loading){
      return const Center(
        child: CircularProgressIndicator(),
      );
    } 

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget,
        LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: content
                );
              }

              return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Card(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: content
                ),
                    )
            )
          );
        })
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
        onLoadContactsError(onError);
      });
    }
  }

  List<Widget> _buildDashboard() {
    var dataUpcoming = [];
    var logger = Logger();

    dataUpcoming.addAll(_starship!.upcoming!.events!);
    dataUpcoming.addAll(_starship!.upcoming!.launches!);
    dataUpcoming.sort((a, b) => a.net.compareTo(b.net));
    logger.d(dataUpcoming);

    final List<Widget> rows = <Widget>[
      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  _starship!.liveStream!.first.title!,
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  _starship!.liveStream!.first.description!,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: CupertinoButton(
              color: Colors.red,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Icon(
                      FontAwesomeIcons.youtube,
                    ),
                  ),
                  Text(
                    'Open in YouTube',
                    style: TextStyle(),
                  ),
                ],
              ),
              onPressed: () {
                openUrl(_starship!.liveStream!.first.url!);
              }, //
            ),
          ),
        ],
      ),
      const Padding(
        padding: EdgeInsets.only(top: 4, left: 24, right: 24, bottom: 4.0),
        child: Divider(),
      ),
      Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 24, right: 8.0, bottom: 8.0),
        child: Text(
          "Up Next",
          textAlign: TextAlign.left,
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      _addUpNext(dataUpcoming),
      const Center(child: ListAdWidget(AdSize.banner)),
      buildUpdates(_starship!.updates!, context,
          "https://spacelaunchnow.me/starship#updates"),
      _addRoadClosure(),
      _addNotice(),
      const Center(child: ListAdWidget(AdSize.largeBanner)),
      const SizedBox(
        height: 50,
      )
    ];
    return rows;
  }

  _addUpNext(List dataUpcoming) {
    if (dataUpcoming.isNotEmpty) {
      var next = dataUpcoming.first;
      if (next is EventList) {
        return _buildEventListTile(next);
      } else if (next is LaunchList) {
        return _buildLaunchListTile(next);
      } else {
        return Container();
      }
    } else {
      return Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 24, right: 8.0, bottom: 8.0),
        child: Text("No upcoming events.",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 15.0)),
      );
    }
  }

  Widget _buildLaunchListTile(LaunchList launch) {
    var formatter = DateFormat.yMd();
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        onTap: () =>
            _navigateToLaunchDetails(launch: null, launchId: launch.id),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(launch.image!),
        ),
        title: Text(launch.name!,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 15.0)),
        subtitle: Text(launch.location!),
        trailing: Text(formatter.format(launch.net!),
            style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }

  Widget _buildEventListTile(EventList event) {
    var formatter = DateFormat.yMd();
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(event.featureImage!),
        ),
        title: Text(event.name!,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 15.0)),
        subtitle: Text(event.location!),
        trailing: Text(formatter.format(event.net!),
            style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }

  void _navigateToLaunchDetails(
      {LaunchList? launch, Object? avatarTag, String? launchId}) {
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

  Widget _addRoadClosure() {
    var widgets = <Widget>[];
    widgets.add(
      Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 24, right: 8.0, bottom: 8.0),
          child: Text("Road Closures",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 42))),
    );

    if (_starship!.roadClosures!.isNotEmpty) {
      for (RoadClosure item in _starship!.roadClosures!) {
        widgets.add(_buildRoadClosureTile(item));
      }
    } else {
      widgets.add(Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 4.0, left: 32.0, right: 32.0),
        child: Text(
          "No road closures.",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets);
  }

  Widget _buildRoadClosureTile(RoadClosure roadClosure) {
    var dateFormatter = DateFormat("EEEE, MMMM d, yyyy");
    var timeFormatter = DateFormat("h:mm a");

    return Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 4.0, left: 32.0, right: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              roadClosure.title!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text("Status: ${roadClosure.status!.name!}"),
            Text(dateFormatter.format(roadClosure.windowStart!)),
            Text("${timeFormatter.format(roadClosure.windowStart!)} - ${timeFormatter.format(roadClosure.windowEnd!)}"),
            const Divider(),
          ],
        ));
  }

  Widget _addNotice() {
    var widgets = <Widget>[];
    widgets.add(
      Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 24, right: 8.0, bottom: 8.0),
        child: Text(
          "Notices",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 42),
        ),
      ),
    );
    if (_starship!.notices!.isNotEmpty) {
      for (Notice item in _starship!.notices!) {
        widgets.add(_buildNoticeTile(item));
      }
    } else {
      widgets.add(Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 4.0, left: 32.0, right: 32.0),
        child: Text(
          "No notices available.",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets);
  }

  Widget _buildNoticeTile(Notice notice) {
    var dateFormatter = DateFormat("EEEE, MMMM d, yyyy");
    var timeFormatter = DateFormat("h:mm a");

    return Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 4.0, left: 32.0, right: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              notice.type!.name!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(dateFormatter.format(notice.date!)),
                      Text(timeFormatter.format(notice.date!)),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.open_in_browser),
                    onPressed: () {
                      openUrl(notice.url!);
                    },
                  ),
                )
              ],
            ),
            const Divider(),
          ],
        ));
  }
}
