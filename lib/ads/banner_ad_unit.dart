import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdUnit extends StatefulWidget {
  const BannerAdUnit({super.key});

  @override
  State<BannerAdUnit> createState() => _BannerAdUnitState();
}

class _BannerAdUnitState extends State<BannerAdUnit> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  final adUnitId = "ca-app-pub-5931956401636205/8044457304";

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      loadAd();
    }
    return _bannerAd != null
        ? Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(
              ad: _bannerAd!,
            ),
          )
        : const SizedBox(
            width: 468,
            height: 60,
            child: Center(
              child: Text("Ad is loading... Thanks for your patience!"),
            ),
          );
  }
}
