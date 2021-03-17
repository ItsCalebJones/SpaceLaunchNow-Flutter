import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launches.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/widgets/ads/ad_widget.dart';
import 'package:spacelaunchnow_flutter/views/widgets/ads/sln_ad_widget.dart';
import 'package:spacelaunchnow_flutter/views/widgets/countdown.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeListPage extends StatefulWidget {
  HomeListPage(this._configuration);

  final AppConfiguration _configuration;

  @override
  _HomeListPageState createState() => new _HomeListPageState();
}

class _HomeListPageState extends State<HomeListPage> {
  List<Launch> _launches = [];
  int nextOffset = 0;
  int totalCount = 0;
  int offset = 0;
  int limit = 5;
  bool loading = false;
  String lsps;
  String locations;
  bool subscribeALL;
  bool subscribeSpaceX;
  bool subscribeRussia;
  bool subscribeWallops;
  bool subscribeNZ;
  bool subscribeJapan;
  bool subscribeFG;
  bool subscribeCAPE;
  bool subscribePLES;
  bool subscribeISRO;
  bool subscribeKSC;
  bool subscribeVAN;
  bool subscribeChina;
  bool subscribeNASA;
  bool subscribeArianespace;
  bool subscribeULA;
  bool subscribeRoscosmos;
  bool subscribeRocketLab;
  bool subscribeBlueOrigin;
  bool subscribeNorthrop;
  SLNRepository _repository = new Injector().slnRepository;

  @override
  void initState() {
    super.initState();
    print("Initing state of Upcoming!");

    List<Launch> launches =
        PageStorage.of(context).readState(context, identifier: 'homeLaunches');
    if (launches != null) {
      _launches = launches;
    }

    if (launches != null) {
      _launches = launches;
    } else {
      print("Loading!");
      lockedLoadNext();
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(HomeListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void onLoadLaunchesComplete(Launches launches, [bool reload = false]) {
    loading = false;
    print(
        "Next: " + nextOffset.toString() + " Total: " + totalCount.toString());
    if (reload) {
      _launches.clear();
    }
    setState(() {
      _launches.addAll(launches.launches);
      PageStorage.of(context)
          .writeState(context, _launches, identifier: 'homeLaunches');
    });
  }

  void onLoadContactsError([bool search]) {
    print("Error occured");
    loading = false;
    if (search == true) {
      setState(() {
        _launches.clear();
      });
      Scaffold.of(context).showSnackBar(new SnackBar(
        duration: new Duration(seconds: 10),
        content: new Text('Unable to load launches.'),
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

  Color getPrimaryColor() {
    if (widget._configuration.nightMode) {
      return Colors.grey[800];
    } else {
      return Colors.blue[500];
    }
  }

  Widget _buildLaunchTile(BuildContext context, Launch launch) {
    var formatter = new DateFormat("EEEE, MMMM d, yyyy");
    var title = "";

    if (launch.launchServiceProvider != null &&
        launch.rocket.configuration.name != null) {
      title = launch.launchServiceProvider.name +
          " | " +
          launch.rocket.configuration.name;
    } else {
      title = launch.name;
    }

    var url =
        "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/static/home/img/placeholder.jpg";
    if (launch.launchServiceProvider != null) {
      if (launch.launchServiceProvider.nationURL != null &&
          launch.launchServiceProvider.nationURL.length > 0) {
        url = launch.launchServiceProvider.nationURL;
      } else if (launch.launchServiceProvider.imageURL != null &&
          launch.launchServiceProvider.imageURL.length > 0) {
        url = launch.launchServiceProvider.imageURL;
      }
    } else if (launch.pad.location.mapImage != null &&
        launch.pad.location.mapImage.length > 0) {
      url = launch.pad.location.mapImage;
    }

    return new Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 8.0, right: 8.0),
      child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
//                color: getPrimaryColor(),
                child: Row(
                  children: <Widget>[
                    new Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 4.0, top: 8.0, bottom: 8.0),
                        child: new Container(
                          width: 75.0,
                          height: 75.0,
                          padding: const EdgeInsets.all(2.0),
                          // borde width
                          decoration: new BoxDecoration(
                            color: Theme.of(context)
                                .highlightColor, // border color
                            shape: BoxShape.circle,
                          ),
                          child: new CircleAvatar(
                            foregroundColor: Colors.white,
                            backgroundImage: new NetworkImage(url),
                            radius: 50.0,
                            backgroundColor: Colors.white,
                          ),
                        )),
                    Flexible(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 8.0),
                            child: new Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.title.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: new Text(launch.pad.location.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.body2),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: new Text(
                                formatter.format(launch.net.toLocal()),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.body2),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: FadeInImage(
                  placeholder: new AssetImage('assets/placeholder.png'),
                  image:
                      new CachedNetworkImageProvider(_getLaunchImage(launch)),
                  fit: BoxFit.cover,
                  height: 175.0,
                  alignment: Alignment.center,
                  fadeInDuration: new Duration(milliseconds: 75),
                  fadeInCurve: Curves.easeIn,
                ),
              ),
              _buildCountDown(launch),
              _getMission(launch),
              _getMissionDescription(launch),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                  child: _buildLaunchButtons(launch),
                ),
              )
            ],
          )),
    );
  }

  void _navigateToLaunchDetails(
      {Launch launch, Object avatarTag, String launchId}) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new LaunchDetailPage(
            widget._configuration,
            launch: null,
            launchId: launchId,
          );
        },
      ),
    );
  }

  Widget _buildCountDown(Launch mLaunch) {
    return new Countdown(mLaunch);
  }

  Widget _buildLaunchButtons(Launch launch) {
    List<Widget> eventButtons = [];
    List<Widget> iconButtons = [];

    if (launch != null) {
      eventButtons.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
          child: new CupertinoButton(
            color: Theme.of(context).accentColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.explore,
                ),
                new Text(
                  'Explore',
                  style: TextStyle(),
                ),
              ],
            ),
            onPressed: () {
              _navigateToLaunchDetails(launch: launch, launchId: launch.id);
            }, //
          ),
        ),
      );
    }

    if (launch.vidURLs != null && launch.vidURLs.length > 0) {
      iconButtons.add(new Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0),
          child: new IconButton(
            icon: Icon(Icons.live_tv),
            tooltip: 'Watch Launch',
            onPressed: () {
              _openUrl(launch.vidURLs.first.url);
            }, //
          )));
    }

    if (launch.slug != null) {
      iconButtons.add(new Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0),
          child: new IconButton(
            icon: Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () {
              Share.share("https://spacelaunchnow.me/launch/" + launch.slug);
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

  @override
  Widget build(BuildContext context) {
    List<Widget> content = new List<Widget>();
    print("Upcoming build!");


    Widget view = new Scaffold(
      body: _buildBody(),
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _handleRefresh();
              });
            },
          )
        ],
        title: new Text(
          'Home',
          style: Theme.of(context)
              .textTheme
              .headline
              .copyWith(fontWeight: FontWeight.bold, fontSize: 34),
        ),
      ),
    );
    return view;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void lockedLoadNext() {
    if (loading == false) {
      loadNext();
    }
  }

  Future<Null> loadNext() async {
    loading = true;
    print("Checking Filters!");
    await checkFilters();
    print("Loading Next!");
    if (totalCount == 0 || nextOffset != null) {
      _repository
          .fetchUpcomingHome(
              limit: limit.toString(),
              offset: nextOffset.toString(),
              lsps: lsps,
              locations: locations)
          .then((launches) => onLoadLaunchesComplete(launches))
          .catchError((onError) {
        print(onError);
        onLoadContactsError();
      });
    }
  }

  Future<Null> _handleRefresh() async {
    setState(() {});
    _launches.clear();
    totalCount = 0;
    limit = 5;
    nextOffset = 0;
    loading = true;
    await checkFilters();
    Launches responseLaunches = await _repository
        .fetchUpcomingHome(
            limit: limit.toString(),
            offset: nextOffset.toString(),
            lsps: lsps,
            locations: locations)
        .catchError((onError) {
      onLoadContactsError();
    });
    onLoadLaunchesComplete(responseLaunches);
    return null;
  }

  String _buildLSPFilter() {
    var lsp_ids = List<int>();
    if (subscribeNASA) {
      lsp_ids.add(44);
    }

    if (subscribeArianespace) {
      lsp_ids.add(115);
    }

    if (subscribeSpaceX) {
      lsp_ids.add(121);
    }

    if (subscribeULA) {
      lsp_ids.add(124);
    }

    if (subscribeRoscosmos) {
      lsp_ids.add(111);
      lsp_ids.add(163);
      lsp_ids.add(63);
    }

    if (subscribeISRO) {
      lsp_ids.add(31);
    }

    if (subscribeBlueOrigin) {
      lsp_ids.add(141);
    }

    if (subscribeRocketLab) {
      lsp_ids.add(147);
    }

    if (subscribeNorthrop) {
      lsp_ids.add(257);
    }
    String lsp_string_list = "";
    var index = 0;
    for (var id in lsp_ids) {
      lsp_string_list = lsp_string_list + id.toString();
      index = index + 1;
      if (index != lsp_ids.length) {
        lsp_string_list = lsp_string_list + ",";
      }
    }
    return lsp_string_list;
  }

  String _buildLocationFilter() {
    var locationIds = List<int>();
    if (subscribeChina) {
      locationIds.add(17);
      locationIds.add(19);
      locationIds.add(8);
      locationIds.add(16);
    }

    if (subscribeISRO) {
      locationIds.add(14);
    }

    if (subscribeCAPE) {
      locationIds.add(27);
      locationIds.add(12);
    }

    if (subscribeRussia) {
      locationIds.add(15);
      locationIds.add(5);
      locationIds.add(6);
      locationIds.add(18);
    }

    if (subscribeVAN) {
      locationIds.add(11);
    }

    if (subscribeWallops) {
      locationIds.add(21);
    }

    if (subscribeNZ) {
      locationIds.add(10);
    }

    if (subscribeJapan) {
      locationIds.add(24);
      locationIds.add(26);
    }

    if (subscribeFG) {
      locationIds.add(13);
    }
    String stringList = "";
    var index = 0;
    for (var id in locationIds) {
      stringList = stringList + id.toString();
      index = index + 1;
      if (index != locationIds.length) {
        stringList = stringList + ",";
      }
    }
    return stringList;
  }

  checkFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    subscribeALL = prefs.getBool("subscribeALL") ?? true;

    subscribeSpaceX = prefs.getBool("subscribeSpaceX") ?? true;
    subscribeNASA = prefs.getBool("subscribeNASA") ?? true;
    subscribeArianespace = prefs.getBool("subscribeArianespace") ?? true;
    subscribeRoscosmos = prefs.getBool("subscribeRoscosmos") ?? true;
    subscribeULA = prefs.getBool("subscribeULA") ?? true;
    subscribeRocketLab = prefs.getBool("subscribeRocketLab") ?? true;
    subscribeBlueOrigin = prefs.getBool("subscribeBlueOrigin") ?? true;
    subscribeNorthrop = prefs.getBool("subscribeNorthrop") ?? true;
    subscribeCAPE = prefs.getBool("subscribeCAPE") ?? true;
    subscribePLES = prefs.getBool("subscribePLES") ?? true;
    subscribeISRO = prefs.getBool("subscribeISRO") ?? true;

    subscribeKSC = prefs.getBool("subscribeKSC") ?? true;
    subscribeVAN = prefs.getBool("subscribeVAN") ?? true;
    subscribeChina = prefs.getBool("subscribeChina") ?? true;

    subscribeRussia = prefs.getBool("subscribeRussia") ?? true;
    subscribeWallops = prefs.getBool("subscribeWallops") ?? true;
    subscribeNZ = prefs.getBool("subscribeNZ") ?? true;
    subscribeJapan = prefs.getBool("subscribeJapan") ?? true;

    subscribeFG = prefs.getBool("subscribeFG") ?? true;
    if (!subscribeALL) {
      lsps = _buildLSPFilter();
      locations = _buildLocationFilter();
    }
  }

  String _getLaunchImage(Launch launch) {
    if (launch.image != null) {
      return launch.image;
    } else if (launch.infographic != null) {
      return launch.infographic;
    } else if (launch.rocket.configuration.image != null &&
        launch.rocket.configuration.image.length > 0) {
      return launch.rocket.configuration.image;
    } else if (launch.launchServiceProvider.imageURL != null &&
        launch.launchServiceProvider.imageURL.length > 0) {
      return launch.launchServiceProvider.imageURL;
    } else if (launch.launchServiceProvider.nationURL != null &&
        launch.launchServiceProvider.nationURL.length > 0) {
      return launch.launchServiceProvider.nationURL;
    } else if (launch.pad != null &&
        launch.pad.mapImage != null &&
        launch.pad.mapImage.length > 0) {
      return launch.pad.mapImage;
    } else {
      return "";
    }
  }

  Widget _getMission(Launch launch) {
    if (launch.mission != null) {
      return Padding(
        padding: const EdgeInsets.only(
            top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
        child: new Text(launch.mission.name,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontWeight: FontWeight.bold)),
      );
    } else {
      return new Container();
    }
  }

  Widget _getMissionDescription(Launch launch) {
    if (launch.mission != null) {
      return Container(
        padding: const EdgeInsets.only(
            top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
        child: new Text(launch.mission.description,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.left),
      );
    } else {
      return new Container();
    }
  }

  Widget _buildBody() {

    List<Widget> content = new List<Widget>();
    if (_launches.isEmpty || loading) {
      content.add(new SizedBox(height: 200));
      content.add(new Center(
        child: new CircularProgressIndicator(),
      ));
    } else if (_launches.isEmpty) {
      content.add(new SizedBox(height: 200));
      content.add(Center(
        child: new Text("No Launches Loaded"),
      ));
    } else {
      _launches.asMap().forEach(
          (index, item) => {content.addAll(_map_launch_to_tile(index, item))});

      content.add(new SizedBox(height: 50));
    }
    return Stack(
        children:  <Widget>[
          new ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _launches.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildLaunchTile(context, _launches[index]);
            }),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListAdWidget(AdSize.banner),
          ),
        ]
    );
  }


  Iterable<Widget> _map_launch_to_tile(int index, Launch item) {
    List<Widget> content = new List<Widget>();
    index += 1;

    // if (index == 2) {
    //   content.add(_bannerAd);
    // }

    content.add(_buildLaunchTile(context, item));

    // if (index != 0 && index % 3 == 0) {
    //   content.add(_bannerAd);
    // }

    return content;
  }
}
