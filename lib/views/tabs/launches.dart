import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/views/launchlist/previous_launches_list_page.dart';
import 'package:spacelaunchnow_flutter/views/launchlist/upcoming_launches_list_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/util/banner_constant.dart';

class LaunchesTabPage extends StatefulWidget {
  const LaunchesTabPage(this._configuration, {super.key});

  final AppConfiguration _configuration;

  @override
  State<LaunchesTabPage> createState() => _LaunchesTabPageState();
}

class _LaunchesTabPageState extends State<LaunchesTabPage>
    with SingleTickerProviderStateMixin {
  String myTitle = "Launches";
  bool searchActive = false;
  bool searchViewActive = false;
  String? searchQuery;
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  final bool _showAds = false;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd!.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Building!");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appBar(),
        body: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              TabBarView(
                children: [
                  Container(
                    constraints: const BoxConstraints.expand(),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        if (constraints.maxWidth < 600) {
                          return UpcomingLaunchListPage(
                              widget._configuration, searchQuery, searchActive);
                        }

                        return Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: UpcomingLaunchListPage(
                                widget._configuration, searchQuery, searchActive),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints.expand(),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        if (constraints.maxWidth < 600) {
                          return PreviousLaunchListPage(
                              widget._configuration, searchQuery, searchActive);
                        }

                        return Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: PreviousLaunchListPage(
                                widget._configuration, searchQuery, searchActive),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              if (_anchoredAdaptiveAd != null && _isLoaded)
                SizedBox(
                  width: _anchoredAdaptiveAd!.size.width.toDouble(),
                  height: _anchoredAdaptiveAd!.size.height.toDouble(),
                  child: AdWidget(ad: _anchoredAdaptiveAd!),
                )
            ]),
      ),
    );
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

  PreferredSizeWidget _appBar() {
    ColorScheme scheme = Theme.of(context).colorScheme;


    if (searchViewActive) {
      return AppBar(
        centerTitle: false,
        elevation: 20,
        leading: const Icon(Icons.search),
        title: TextField(
          style: const TextStyle(),
          onSubmitted: _search,
          decoration: const InputDecoration(
            hintText: "Example: SpaceX, Delta IV, JWST...",
            hintStyle: TextStyle(),
          ),
        ),
        bottom: const TabBar(
          tabs: [
            Tab(
              text: "Upcoming",
            ),
            Tab(
              text: "Previous",
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(
                    () {
                      searchViewActive = false;
                      searchQuery = null;
                      searchActive = false;
                    },
                  ))
        ],
      );
    } else {
      return AppBar(
          centerTitle: false,
          elevation: 20,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
              ),
              onPressed: () => setState(() => searchViewActive = true),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Upcoming",
              ),
              Tab(
                text: "Previous",
              ),
            ],
          ),
          title: Text(myTitle,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                  )
                )
              );
      }
    }

  _search(value) {
    if (value is String) {
      setState(() {
        searchActive = true;
        searchQuery = value;
      });
    }
  }
}
