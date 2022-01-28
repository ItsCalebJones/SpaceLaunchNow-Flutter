import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListAdWidget extends StatefulWidget {
  ListAdWidget(this.size);

  final AdSize size;

  @override
  _ListAdWidgetState createState() => _ListAdWidgetState();
}

class _ListAdWidgetState extends State<ListAdWidget> with AutomaticKeepAliveClientMixin {
  BannerAd? _bannerAd;
  bool _isReady = false;
  bool _showAds = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) => {
      setState((){
        _showAds = prefs.getBool("showAds") ?? true;
        print("Show ads: $_showAds");
      })

    });
    Future.delayed(Duration(milliseconds: 250), createAd);
  }

  createAd() {
    _bannerAd = BannerAd(
      size: widget.size,
      adUnitId: Platform.isAndroid
          ?  BannerAd.testAdUnitId
          : "ca-app-pub-9824528399164059/8172962746",
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('${ad.runtimeType} loaded!');
          setState(() {
            _isReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('${ad.runtimeType} failed to load.\n$error');
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ListAdWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bannerAd?.dispose();
    _bannerAd = null;
    createAd();
    setState(() {
      _isReady = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isReady && _showAds) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: widget.size.width.toDouble(),
          height: widget.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    } else if (!_isReady && _showAds) {
      return Container(
        width: widget.size.width.toDouble(),
        height: widget.size.height.toDouble(),
      );
    } else {
      return Container();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
