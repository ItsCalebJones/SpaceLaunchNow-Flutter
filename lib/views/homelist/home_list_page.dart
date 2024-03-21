import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launches.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/widgets/countdown.dart';
import 'package:spacelaunchnow_flutter/util/url_helper.dart';

class HomeListPage extends StatefulWidget {
  const HomeListPage(this._configuration, {super.key});

  final AppConfiguration _configuration;

  @override
  State<HomeListPage> createState() => _HomeListPageState();
}

class _HomeListPageState extends State<HomeListPage> {
  List<Launch> _launches = [];
  int nextOffset = 0;
  int totalCount = 0;
  int offset = 0;
  int limit = 3;
  bool loading = false;
  String? lsps;
  String? locations;
  late bool subscribeALL;
  late bool subscribeSpaceX;
  late bool subscribeRussia;
  late bool subscribeWallops;
  late bool subscribeNZ;
  late bool subscribeJapan;
  late bool subscribeFG;
  late bool subscribeCAPE;
  bool? subscribePLES;
  late bool subscribeISRO;
  bool? subscribeKSC;
  late bool subscribeVAN;
  late bool subscribeChina;
  late bool subscribeNASA;
  late bool subscribeArianespace;
  late bool subscribeULA;
  late bool subscribeRoscosmos;
  late bool subscribeRocketLab;
  late bool subscribeBlueOrigin;
  late bool subscribeNorthrop;
  final SLNRepository _repository = Injector().slnRepository;
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    logger.d("Init state of Upcoming!");

    List<Launch>? launches =
        PageStorage.of(context).readState(context, identifier: 'homeLaunches');
    if (launches != null) {
      _launches = launches;
    }

    if (launches != null) {
      _launches = launches;
    } else {
      logger.d("Loading!");
      lockedLoadNext();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }

  @override
  void didUpdateWidget(HomeListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void onLoadLaunchesComplete(Launches launches, [bool reload = false]) {
    loading = false;
    logger.d(
        "Next: $nextOffset Total: $totalCount");
    if (reload) {
      _launches.clear();
    }

    setState(() {
      _launches.addAll(launches.launches!);
      PageStorage.of(context)
          .writeState(context, _launches, identifier: 'homeLaunches');
    });
  }

  void onLoadContactsError([bool? search]) {
    logger.d("Error occured");
    loading = false;
    if (search == true) {
      setState(() {
        _launches.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 10),
        content: const Text('Unable to load launches.'),
        action: SnackBarAction(
          label: 'Refresh',
          onPressed: () {
            // Some code to undo the change!
            _handleRefresh();
          },
        ),
      ));
    }
  }

  Color? getPrimaryColor() {
    if (widget._configuration.nightMode) {
      return Colors.grey[800];
    } else {
      return Colors.blue[500];
    }
  }

  Widget _buildLaunchTile(BuildContext context, Launch launch) {
    var formatter = DateFormat("EEEE, MMMM d, yyyy");
    String? title = "";

    if (launch.launchServiceProvider != null &&
        launch.rocket!.configuration!.name != null) {
      title = "${launch.launchServiceProvider!.name!} | ${launch.rocket!.configuration!.name!}";
    } else {
      title = launch.name;
    }

    String? url =
        "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/static/home/img/placeholder.jpg";
    if (launch.launchServiceProvider != null) {
      if (launch.launchServiceProvider!.nationURL != null &&
          launch.launchServiceProvider!.nationURL!.isNotEmpty) {
        url = launch.launchServiceProvider!.nationURL;
      } else if (launch.launchServiceProvider!.imageURL != null &&
          launch.launchServiceProvider!.imageURL!.isNotEmpty) {
        url = launch.launchServiceProvider!.imageURL;
      }
    } else if (launch.pad!.location!.mapImage != null &&
        launch.pad!.location!.mapImage!.isNotEmpty) {
      url = launch.pad!.location!.mapImage;
    }

    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 8.0, right: 8.0),
      child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 4.0, top: 8.0, bottom: 8.0),
                      child: Container(
                        width: 75.0,
                        height: 75.0,
                        padding: const EdgeInsets.all(2.0),
                        // border width
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .highlightColor, // border color
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          foregroundColor: Colors.white,
                          backgroundImage: NetworkImage(url!),
                          radius: 50.0,
                          backgroundColor: Colors.white,
                        ),
                      )),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 8.0),
                          child: Text(
                            title!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Text(launch.pad!.location!.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Text(formatter.format(launch.net!.toLocal()),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FadeInImage(
                  placeholder: const AssetImage('assets/placeholder.png'),
                  image: CachedNetworkImageProvider(_getLaunchImage(launch)!),
                  fit: BoxFit.cover,
                  height: 250.0,
                  alignment: Alignment.center,
                  fadeInDuration: const Duration(milliseconds: 75),
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
      {Launch? launch, String? launchId}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) {
          return LaunchDetailPage(
            widget._configuration,
            launch: null,
            launchId: launchId,
          );
        },
      ),
    );
  }

  Widget _buildCountDown(Launch mLaunch) {
    return Countdown(mLaunch);
  }

  Widget _buildLaunchButtons(Launch launch) {
    List<Widget> eventButtons = [];
    List<Widget> iconButtons = [];

    eventButtons.add(
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 4.0, top: 4.0),
        child: CupertinoButton(
          color: Theme.of(context).colorScheme.secondary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.explore,
              ),
              Text(
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

    if (launch.vidURLs != null && launch.vidURLs!.isNotEmpty) {
      iconButtons.add(Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0),
          child: IconButton(
            icon: const Icon(Icons.live_tv),
            tooltip: 'Watch Launch',
            onPressed: () {
              openUrl(launch.vidURLs!.first.url!);
            }, //
          )));
    }

    if (launch.slug != null) {
      iconButtons.add(Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0),
          child: IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () {
              Share.share("https://spacelaunchnow.me/launch/${launch.slug!}");
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


  ThemeData get barTheme {
    var qDarkMode = MediaQuery.of(context).platformBrightness;
    if (qDarkMode == Brightness.dark) {
      return kIOSThemeDarkBar;
    } else {
      return kIOSThemeBar;
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Upcoming build!");

    Widget view = Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth < 600) {
              return _buildBody();
            }

            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: _buildBody(),
              ),
            );
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: barTheme.canvasColor,
        centerTitle: false,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: barTheme.focusColor,
            ),
            onPressed: () {
              setState(() {
                _handleRefresh();
              });
            },
          )
        ],
        title: Text(
          'Home',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 34,
              color: barTheme.focusColor),
        ),
      ),
    );
    return view;
  }

  void lockedLoadNext() {
    if (loading == false) {
      loadNext();
    }
  }

  Future<void> loadNext() async {
    loading = true;
    logger.d("Checking Filters!");
    await checkFilters();
    logger.d("Loading Next!");
    if (totalCount == 0) {
      _repository
          .fetchUpcomingHome(
              limit: limit.toString(),
              offset: nextOffset.toString(),
              lsps: lsps,
              locations: locations)
          .then((launches) => onLoadLaunchesComplete(launches))
          .catchError((onError) {
        logger.d(onError);
        onLoadContactsError();
      });
    }
  }

  Future<void> _handleRefresh() async {
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
  }

  String _buildLSPFilter() {
    var lspIds = <int>[];
    if (subscribeNASA) {
      lspIds.add(44);
    }

    if (subscribeArianespace) {
      lspIds.add(115);
    }

    if (subscribeSpaceX) {
      lspIds.add(121);
    }

    if (subscribeULA) {
      lspIds.add(124);
    }

    if (subscribeRoscosmos) {
      lspIds.add(111);
      lspIds.add(163);
      lspIds.add(63);
    }

    if (subscribeISRO) {
      lspIds.add(31);
    }

    if (subscribeBlueOrigin) {
      lspIds.add(141);
    }

    if (subscribeRocketLab) {
      lspIds.add(147);
    }

    if (subscribeNorthrop) {
      lspIds.add(257);
    }
    String lspStringList = "";
    var index = 0;
    for (var id in lspIds) {
      lspStringList = lspStringList + id.toString();
      index = index + 1;
      if (index != lspIds.length) {
        lspStringList = "$lspStringList,";
      }
    }
    return lspStringList;
  }

  String _buildLocationFilter() {
    var locationIds = <int>[];
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
        stringList = "$stringList,";
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

  String? _getLaunchImage(Launch launch) {
    if (launch.image != null) {
      return launch.image;
    } else if (launch.infographic != null) {
      return launch.infographic;
    } else if (launch.rocket!.configuration!.image != null &&
        launch.rocket!.configuration!.image!.isNotEmpty) {
      return launch.rocket!.configuration!.image;
    } else if (launch.launchServiceProvider!.imageURL != null &&
        launch.launchServiceProvider!.imageURL!.isNotEmpty) {
      return launch.launchServiceProvider!.imageURL;
    } else if (launch.launchServiceProvider!.nationURL != null &&
        launch.launchServiceProvider!.nationURL!.isNotEmpty) {
      return launch.launchServiceProvider!.nationURL;
    } else if (launch.pad != null &&
        launch.pad!.mapImage != null &&
        launch.pad!.mapImage!.isNotEmpty) {
      return launch.pad!.mapImage;
    } else {
      return "";
    }
  }

  Widget _getMission(Launch launch) {
    if (launch.mission != null) {
      return Padding(
        padding: const EdgeInsets.only(
            top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
        child: Text(launch.mission!.name!,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold)),
      );
    } else {
      return Container();
    }
  }

  Widget _getMissionDescription(Launch launch) {
    if (launch.mission != null) {
      return Container(
        padding: const EdgeInsets.only(
            top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
        child: Text(launch.mission!.description!,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left),
      );
    } else {
      return Container();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    late bool showAds;
    await SharedPreferences.getInstance().then((SharedPreferences prefs) =>
        {showAds = prefs.getBool("showAds") ?? true});

    if (!showAds) {
      return;
    }

    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      logger.d('Unable to get height of anchored banner.');
      return;
    }

    var testAdUnit = "ca-app-pub-3940256099942544/6300978111";

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? testAdUnit
          : "ca-app-pub-9824528399164059/8172962746",
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          logger.d('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          logger.d('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  Widget _buildBody() {
    List<Widget> content = <Widget>[];
    if (_launches.isEmpty || loading) {
      content.add(const SizedBox(height: 200));
      content.add(const Center(
        child: CircularProgressIndicator(),
      ));
    } else if (_launches.isEmpty) {
      content.add(const SizedBox(height: 200));
      content.add(const Center(
        child: Text("No Launches Loaded"),
      ));
    } else {
      _launches.asMap().forEach(
          (index, item) {content.addAll(mapLaunchToTile(index, item));});

      // content.add(const SizedBox(height: 400));
    }
    return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          ListView.separated(
            physics: const BouncingScrollPhysics().applyTo(const ClampingScrollPhysics()),
            padding: const EdgeInsets.fromLTRB(2, 2, 2, 64),
            itemCount: _launches.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildLaunchTile(context, _launches[index]);
            },
            separatorBuilder: (context, index) {
              return Container(height: 5);
            },
          ),
          if (_anchoredAdaptiveAd != null && _isLoaded)
            SizedBox(
                width: _anchoredAdaptiveAd!.size.width.toDouble(),
                height: _anchoredAdaptiveAd!.size.height.toDouble(),
                child: AdWidget(ad: _anchoredAdaptiveAd!)),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: ListAdWidget(AdSize.banner),
          // ),
        ]);
  }

  Iterable<Widget> mapLaunchToTile(int index, Launch item) {
    List<Widget> content = <Widget>[];
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
