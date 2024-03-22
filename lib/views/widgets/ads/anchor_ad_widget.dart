import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacelaunchnow_flutter/util/banner_constant.dart';


class AnchorAdWidget extends StatefulWidget {
  const AnchorAdWidget(this.size, {super.key});
  final AnchoredAdaptiveBannerAdSize size;

  @override
  State<AnchorAdWidget> createState() => _AnchorAdWidgetState();
}

class _AnchorAdWidgetState extends State<AnchorAdWidget>
    with AutomaticKeepAliveClientMixin {
  BannerAd? _bannerAd;
  bool _isReady = false;
  bool _showAds = false;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) => {
          setState(() {
            _showAds = prefs.getBool("showAds") ?? true;
            logger.d("Show ads: $_showAds");
          })
        });
    Future.delayed(const Duration(milliseconds: 250), createAd);
  }

  createAd() {
    _bannerAd = BannerAd(
      size: widget.size,
      adUnitId: Platform.isAndroid
          ? testAdUnit
          : "ca-app-pub-9824528399164059/8172962746",
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          logger.d('${ad.runtimeType} loaded!');
          setState(() {
            _isReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          logger.d('${ad.runtimeType} failed to load.\n$error');
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
  void didUpdateWidget(covariant AnchorAdWidget oldWidget) {
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
    super.build(context);
    if (_isReady && _showAds) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: widget.size.width.toDouble(),
          height: widget.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    } else if (!_isReady && _showAds) {
      return SizedBox(
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
