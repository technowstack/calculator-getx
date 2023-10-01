// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, unnecessary_null_comparison, unused_local_variable, avoid_unnecessary_containers, deprecated_member_use, unnecessary_this, unnecessary_brace_in_string_interps, nullable_type_in_catch_clause

import 'package:calculator_getx/ads/unity.dart';
import 'package:calculator_getx/widgets/calc_buttons.dart';
import 'package:calculator_getx/widgets/math_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:startapp_sdk/startapp.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import '../controllers/calculator_controller.dart';
import '../ads/admob.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final calculatorCtrl = Get.put(CalculatorController());
  final bool _showBanner = true;

//startapp
  var startAppSdk = StartAppSdk();
  StartAppBannerAd? bannerAd;
  StartAppInterstitialAd? interstitialAd;

//admob
  late BannerAd _bannerAd;
  bool isAdloaded = false;

  @override
  void initState() {
    super.initState();

//startapp
    try {
      startAppSdk.loadBannerAd(StartAppBannerType.BANNER).then((bannerAd) {
        setState(() {
          this.bannerAd = bannerAd;
        });
      }).onError((error, stackTrace) {
        debugPrint("Error loading Banner ad: $error");
      });
    } catch (e) {
      return;
    }

    try {
      loadInterstitialAd();
    } on PlatformException catch (_) {
      return;
    }

//unity ads
    try {
      UnityAds.init(
        gameId: AdManagerUnity.gameId,
        onComplete: () => print('Initialization Complete'),
        onFailed: (error, message) =>
            print('Initialization Failed: $error $message'),
      );
    } catch (e) {
      return;
    }

//admob
    try {
      _bannerAd = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.mediumRectangle,
        request: AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            print('$BannerAd loaded.');
            setState(() {
              isAdloaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            print('$BannerAd loaded.');
          },
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad closed.'),
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) => print('Ad impression.'),
        ),
      );
      _bannerAd.load();
    } catch (e) {
      return;
    }
  }

  //startapp
  void loadInterstitialAd() {
    startAppSdk.loadInterstitialAd().then((interstitialAd) {
      setState(() {
        this.interstitialAd = interstitialAd;
      });
    }).onError<StartAppException>((ex, stackTrace) {
      debugPrint("Error loading Interstitial ad: ${ex.message}");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Interstitial ad: $error");
    });
  }

  //unity ads
  void loadVideoAd() async {
    UnityAds.showVideoAd(placementId: 'Interstitial_Android');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints:
                BoxConstraints(maxWidth: GetPlatform.isWeb ? 420 : 600),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  (_showBanner)
                      ? UnityBannerAd(
                          placementId: AdManagerUnity.bannerAdPlacementId,
                          onLoad: (placementId) =>
                              print('Banner loaded: $placementId'),
                          onClick: (placementId) =>
                              print('Banner clicked: $placementId'),
                          onFailed: (placementId, error, message) => print(
                              'Banner Ad $placementId failed: $error $message'),
                        )
                      : Container(),
                  GetBuilder<CalculatorController>(
                    builder: (controller) => IconButton(
                        icon: Icon(
                          controller.isDarkMode.value
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                        onPressed: () {
                          loadVideoAd();
                          if (interstitialAd != null) {
                            interstitialAd!.show().then((shown) {
                              if (shown) {
                                setState(() {
                                  // NOTE interstitial ad can be shown only once
                                  this.interstitialAd = null;

                                  // NOTE load again
                                  loadInterstitialAd();
                                });
                              }
                              return null;
                            }).onError((error, stackTrace) {
                              debugPrint(
                                  "Error showing Interstitial ad: $error");
                            });
                          }
                          controller.toggleDarkMode();
                        }),
                  ),
                  MathResults(),
                  CalculatorButtons(),
                  (isAdloaded == true)
                      ? Column(
                          children: [
                            SizedBox(
                                height: 50,
                                child: AdWidget(
                                    ad: BannerAd(
                                  adUnitId: AdmobManager.testerBannerId,
                                  request: AdRequest(),
                                  size: AdSize.banner,
                                  listener: BannerAdListener(),
                                )..load())),
                          ],
                        )
                      : Container(),
                  bannerAd != null ? StartAppBanner(bannerAd!) : Container(),
                  SizedBox(height: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
