import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsMethods with ChangeNotifier {
  //google adsense
  Future<InitializationStatus> initialization;

  AdsMethods(this.initialization);

  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-9151813879551485/1423541858'
      : 'ca-app-pub-3940256099942544/2934735716';

  String get interstitialAdUnitId => 'ca-app-pub-5844375764287739/2517216117';

  InterstitialAd? _interstitialAd;
  int numOfShow = 0;

  void createInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            numOfShow = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _interstitialAd = null;
            numOfShow+1;

            if(numOfShow <= 2) createInterstitial();
          }
      ),
    );
  }
  void showInterstitial() {
    if(_interstitialAd == null) return;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad){
        print('interstitial showed');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('interstitial disposed');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad load failed $error');
        ad.dispose();
        createInterstitial();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  BannerAdListener get adListener => _adListener;

  final BannerAdListener _adListener = BannerAdListener(
    onAdLoaded: (ad) => print('Ad Loaded: ${ad.adUnitId}'),
    onAdClosed: (ad) => print('Ad Loaded: ${ad.adUnitId}'),
    onAdFailedToLoad: (ad, error) =>
        print('Ad Loaded: ${ad.adUnitId}, $error.'),
    onAdOpened: (ad) => print('Ad Loaded: ${ad.adUnitId}'),
  );
}