import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SLNAd{
  Function callback;
  bool showAds;
  BannerAd bannerAd;
  AdSize size;
  bool isReady = false;

  SLNAd(this.size, {this.callback});



  create() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    showAds = _prefs.getBool("showAds") ?? true;
    print("Show ads: $showAds");
    bannerAd = _buildBanner(size);
  }

  BannerAd _buildBanner(AdSize size){
    BannerAd _bannerAd;

    _bannerAd = BannerAd(
      size: size,
      adUnitId: Platform.isAndroid
          ?  BannerAd.testAdUnitId
          : "ca-app-pub-9824528399164059/8172962746",
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (ad) {
          print('${ad.runtimeType} loaded!');
          isReady = true;
          if (callback != null){
          callback();
          }
        },
        onAdFailedToLoad: (ad, error) {
          print('${ad.runtimeType} failed to load.\n$error');
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();

    return _bannerAd;
  }
}

class AdWidgetBuilder extends StatefulWidget {
  AdWidgetBuilder(this.ad);

  final SLNAd ad;

  @override
  _AdWidgetBuilderState createState() => _AdWidgetBuilderState();
}

class _AdWidgetBuilderState extends State<AdWidgetBuilder> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    print("disposed");
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AdWidgetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ad.isReady && widget.ad.showAds) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: widget.ad.size.width.toDouble(),
          height: widget.ad.size.height.toDouble(),
          child: AdWidget(ad: widget.ad.bannerAd),
        ),
      );
    } else {
      return Container();
    }
  }
}
