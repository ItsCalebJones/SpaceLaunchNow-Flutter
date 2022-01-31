import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget(this.size);

  final AdSize size;

  @override
  State<StatefulWidget> createState() => BannerAdState();
}

class BannerAdState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  final Completer<BannerAd> bannerCompleter = Completer<BannerAd>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _showAds = false;

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) =>
        {_showAds = prefs.getBool("showAds") ?? true});
    _bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? BannerAd.testAdUnitId
          : "ca-app-pub-9824528399164059/8172962746",
      request: const AdRequest(),
      size: widget.size,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          bannerCompleter.complete(ad as BannerAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('$BannerAd failedToLoad: $error');
          bannerCompleter.completeError(error);
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    Future<void>.delayed(const Duration(seconds: 1), () => _bannerAd?.load());
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BannerAd>(
      future: bannerCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<BannerAd> snapshot) {
        Widget? child;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            child = Container();
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              child = AdWidget(ad: _bannerAd!);
            } else {
              child = Text('Error loading $BannerAd');
            }
        }

        return SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: child,
        );
      },
    );
  }
}
