import 'dart:async';
import 'dart:io';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/main.dart';
import 'package:apollo/resources/Apis/api_repository/start_medlingo_repo.dart';
import 'package:apollo/resources/Apis/api_repository/start_solo_play_repo.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/game_mode/wheel_of_wellness/wheel_of_wellness_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

/*class FreePassAdsScreen extends StatefulWidget {
  String? game;
  int? catId;
  FreePassAdsScreen({super.key,this.game,this.catId});

  @override
  FreePassAdsScreenState createState() => FreePassAdsScreenState();
}

class FreePassAdsScreenState extends State<FreePassAdsScreen> {
  int _countdown = 10;
  Timer? _timer;
  bool _isAdReady = false;
  bool canPop = false;

  @override
  void initState() {
    super.initState();
    _initializeApplovinMax();
    _startCountdown();
  }

  void _initializeApplovinMax() {
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        if (ad.adUnitId == ApiUrls.adUnitIdInterstitial) {
          setState(() {
            _isAdReady = true;
          });
          print('Interstitial ad loaded from network: ${ad.networkName}');
        }
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        if (adUnitId == ApiUrls.adUnitIdInterstitial) {
          setState(() {
            _isAdReady = false;
          });
          print('Interstitial ad failed to load: ${error.message}');
        }
      },
      onAdDisplayedCallback: (ad) {
        print('Interstitial ad displayed');
      },
      onAdHiddenCallback: (ad) {
        if (ad.adUnitId == ApiUrls.adUnitIdInterstitial) {
          print('Interstitial ad dismissed');
          Get.back(); // Close screen on ad dismissal
        }
      },
      onAdDisplayFailedCallback: (ad, error) {
        print('Interstitial ad failed to show: ${error.message}');
      }, onAdClickedCallback: (MaxAd ad) {  },
    ));

    // Load your interstitial ad after setting listener
    AppLovinMAX.loadInterstitial(ApiUrls.adUnitIdInterstitial);
  }


  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_countdown == 0) {
        timer.cancel();

      }
      else if(_countdown==1 && widget.game=='category'){
        _timer?.cancel();
        apolloPrint(message: 'comming here--> ${widget.game}&&${widget.catId}');
        Get.back();
        showLoader(true);
        startSoloPlayApi(categoryId: '${widget.catId}',
            numberOfQuestions: 5,
            showExplanation: 1,
            highStakesMode: 0,
            randomMix: 0
        ).then((value){
          showLoader(false);
          if(value.status==true){
            if(value.data!=null && value.data!.isNotEmpty){
              Get.offNamed(AppRoutes.quizScreenNew,
                  arguments: {'screen': 'soloPlay', 'questions': value.data, 'gameData':value.gameData});
            }
          } else if(value.status==false){
            CustomSnackBar().showSnack(Get.context!,message: '${value.message}',isSuccess: false);
          }
        });
      }
      else if(_countdown==1 && widget.game=='medpardy'){
        _timer?.cancel();
        Get.offNamed(AppRoutes.medpardyChooseFriendScreen);
      }
      else if(_countdown==1 && widget.game=='wow'){
        _timer?.cancel();
        Get.off(WheelOfWellnessScreen());
      }
      else if(_countdown==1 && widget.game=='medlingo'){
        _timer?.cancel();
        showLoader(true);
        startMedLingoApi().then((val){
          showLoader(false);
          if(val.status==true && val.data!=null){
            Get.offNamed(AppRoutes.medLingoWordGameScreen,arguments: {'word':val.data!.hiddenTerm!.toUpperCase(),
              'imageUrl': val.data!.imageUrl??'',
              'gameData': val.data}
            );
          }else if(val.status==false){
            if(mounted){
              setState(() {
                canPop=true;
              });
            }
            Get.back();
            CustomSnackBar().showSnack(Get.context!,message: '${val.message}',isSuccess: false);
          }
        });
      }
      else if(_countdown==1 && (widget.game=='soloPlay' || widget.game=='groupPlay')){
        _timer?.cancel();
        if(mounted){
          setState(() {
            canPop=true;
          });
        }
        Get.back(result: widget.catId);
      }
      else {
        setState(() => _countdown--);
        _showInterstitialAdIfReady();
      }
    });
  }

  Future<void> _showInterstitialAdIfReady() async {
    bool? isReady = await AppLovinMAX.isInterstitialReady(ApiUrls.adUnitIdInterstitial);
    if (isReady == true && _isAdReady) {
      AppLovinMAX.showInterstitial(ApiUrls.adUnitIdInterstitial);
      setState(() => _isAdReady = false);
      // Load next ad
      AppLovinMAX.loadInterstitial(ApiUrls.adUnitIdInterstitial);
    } else {
      print('Interstitial ad not ready');
    }
  }

  // Skip countdown and show ad immediately
  void _skipCountdown() {
    if(_countdown<6){
      _timer?.cancel();
      if(widget.game=='category'){
        apolloPrint(message: 'comming here--> ${widget.game}&&${widget.catId}');
        Get.back();
        showLoader(true);
        startSoloPlayApi(categoryId: '${widget.catId}',
            numberOfQuestions: 5,
            showExplanation: 1,
            highStakesMode: 0,
            randomMix: 0
        ).then((value){
          showLoader(false);
          if(value.status==true){
            if(value.data!=null && value.data!.isNotEmpty){
              Get.offNamed(AppRoutes.quizScreenNew,
                  arguments: {'screen': 'soloPlay', 'questions': value.data, 'gameData':value.gameData});
            }
          } else if(value.status==false){
            CustomSnackBar().showSnack(Get.context!,message: '${value.message}',isSuccess: false);
          }
        });
      }
      else if(widget.game=='medpardy'){
        Get.offNamed(AppRoutes.medpardyChooseFriendScreen);
      }
      else if(widget.game=='wow'){
        Get.off(WheelOfWellnessScreen());
      }
      else if(widget.game=='medlingo'){

        showLoader(true);
        startMedLingoApi().then((val){
          showLoader(false);
          if(val.status==true && val.data!=null){
            Get.offNamed(AppRoutes.medLingoWordGameScreen,arguments: {'word':val.data!.hiddenTerm!.toUpperCase(),
              'imageUrl': val.data!.imageUrl??'',
              'gameData': val.data});
          }else if(val.status==false){
            if(mounted){
              setState(() {
                canPop=true;
              });
            }
            Get.back();
            CustomSnackBar().showSnack(Get.context!,message: '${val.message}',isSuccess: false);
          }
        });
      }
      else if(widget.game=='soloPlay' || widget.game=='groupPlay'){
        if(mounted){
          setState(() {
            canPop=true;
          });
        }
        Get.back(result: widget.catId);
      }}
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: Colors.black87,
              child: Center(
                child: Text(
                  'Your Ad is loading...',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),

            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: _countdown<6?_skipCountdown:(){},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      if(_countdown<6)
                      Text(
                        'Skip',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        '($_countdown)',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if(_countdown<6)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: LinearProgressIndicator(
                value: _countdown / 10,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

/// above code for applovin

class FreePassAdsScreen extends StatefulWidget {
  final String? game;
  final int? catId;

  const FreePassAdsScreen({super.key, this.game, this.catId});

  @override
  FreePassAdsScreenState createState() => FreePassAdsScreenState();
}

class FreePassAdsScreenState extends State<FreePassAdsScreen> {
  bool _isAdReady = false;
  bool _hasShownAd = false;
  bool canPop = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if(unityAdsInitialized){
        _loadUnityInterstitial();
      }else{
        _navigateAfterAd();
      }
    });
    // _initializeUnityAds());
  }

  /// ---------------- Initialize Unity Ads ----------------
  // void _initializeUnityAds() async {
  //   await UnityAds.init(
  //     gameId: Platform.isAndroid ? ApiUrls.gameIdAndroid : ApiUrls.gameIdIOS,
  //     testMode: true, // change to false in production
  //     onComplete: () {
  //       print('✅ Unity Ads Initialized');
  //       _loadUnityInterstitial();
  //     },
  //     onFailed: (error, message) {
  //       print('❌ Unity Init Failed: $error | $message');
  //       _navigateAfterAd(); // continue if ad init fails
  //     },
  //   );
  // }

  void _loadUnityInterstitial() {
    final placementId = Platform.isAndroid
        ? ApiUrls.unityInterstitialAndroid
        : ApiUrls.unityInterstitialIOS;

    UnityAds.load(
      placementId: placementId,
      onComplete: (id) {
        print("✅ Unity Interstitial Loaded: $id");
        setState(() => _isAdReady = true);
        _showInterstitialAd(); // show immediately once ready
      },
      onFailed: (id, error, message) {
        print("❌ Unity Interstitial Load Failed: $message");
        _navigateAfterAd();
      },
    );
  }

  /// ---------------- Show Ad ----------------
  void _showInterstitialAd() {
    if (_isAdReady && !_hasShownAd) {
      _hasShownAd = true;
      final placementId = Platform.isAndroid
          ? ApiUrls.unityInterstitialAndroid
          : ApiUrls.unityInterstitialIOS;

      UnityAds.showVideoAd(
        placementId: placementId,
        onStart: (id) => print("▶️ Unity Ad Started"),
        onClick: (id) => print("🖱 Ad Clicked"),
        onSkipped: (id) {
          print("⏭ Ad Skipped");
          _navigateAfterAd();
        },
        onComplete: (id) {
          print("✅ Ad Completed");
          _navigateAfterAd();
        },
        onFailed: (id, error, message) {
          print("❌ Ad Failed to Show: $message");
          _navigateAfterAd();
        },
      );
    } else {
      print("⚠️ Interstitial not ready");
      _navigateAfterAd();
    }
  }

  /// ---------------- Navigation Logic (moved from timer) ----------------
  void _navigateAfterAd() {
    if (widget.game == 'category') {
      apolloPrint(message: 'coming here → ${widget.game} && ${widget.catId}');
      Get.back();
      showLoader(true);
      startSoloPlayApi(
        categoryId: '${widget.catId}',
        numberOfQuestions: 5,
        showExplanation: 1,
        highStakesMode: 0,
        randomMix: 0,
      ).then((value) {
        showLoader(false);
        if (value.status == true && value.data != null && value.data!.isNotEmpty) {
          Get.offNamed(AppRoutes.quizScreenNew, arguments: {
            'screen': 'soloPlay',
            'questions': value.data,
            'gameData': value.gameData
          });
        } else {
          CustomSnackBar().showSnack(Get.context!,
              message: '${value.message}', isSuccess: false);
        }
      });
    } else if (widget.game == 'medpardy') {
      Get.offNamed(AppRoutes.medpardyChooseFriendScreen);
    } else if (widget.game == 'wow') {
      Get.off(WheelOfWellnessScreen());
    } else if (widget.game == 'medlingo') {
      showLoader(true);
      startMedLingoApi().then((val) {
        showLoader(false);
        if (val.status == true && val.data != null) {
          Get.offNamed(AppRoutes.medLingoWordGameScreen, arguments: {
            'word': val.data!.hiddenTerm!.toUpperCase(),
            'imageUrl': val.data!.imageUrl ?? '',
            'gameData': val.data
          });
        } else {
          if (mounted) setState(() => canPop = true);
          Get.back();
          CustomSnackBar().showSnack(Get.context!,
              message: '${val.message}', isSuccess: false);
        }
      });
    } else if (widget.game == 'soloPlay' || widget.game == 'groupPlay') {
      if (mounted) setState(() => canPop = true);
      Get.back(result: widget.catId);
    } else {
      print("⚠️ Unknown game type — returning to previous screen");
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: const Center(
          child: Text(
            'Your Ad is loading...',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}

