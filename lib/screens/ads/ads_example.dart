/*import 'dart:async';

import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomAdScreen extends StatefulWidget {
  @override
  _CustomAdScreenState createState() => _CustomAdScreenState();
}

class _CustomAdScreenState extends State<CustomAdScreen> {
  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;

  int _countdown = 10; // seconds for countdown
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _showInterstitialAd();
      if (_countdown == 0) {
        timer.cancel();
        Get.offAll(()=>DashBoardScreen());
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: ApiUrls.adUnitIdInterstitial, // test unit
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdReady = true;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
          _isAdReady = false;
        },

      ),
    );
  }

  void _showInterstitialAd() {
    if (_isAdReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          Get.back(); // Close this custom ad screen
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          print('Failed to show interstitial ad: $error');
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      _isAdReady = false;
    } else {
      print('Ad not ready, closing');
    }
  }

  // Allow user to skip countdown and show ad immediately.
  void _skipCountdown() {
    _timer.cancel();
    // Navigator.pop(context);
    apolloPrint(message: 'Skip Clip on Add');
    _showInterstitialAd();
  }

  @override
  void dispose() {
    _timer.cancel();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No app bar for fullscreen feel
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background - make it look like an ad placeholder
          Container(
            color: Colors.black87,
            child: Center(
              child: Text(
                'Your Ad is loading...',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),

          // Countdown timer widget
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: _skipCountdown,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  'Skip ($_countdown)',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),

          // Optional: progress bar at bottom showing countdown
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: LinearProgressIndicator(
              value: (_countdown) / 5,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}*/


// ---------************* above code for ads mob


// import 'dart:async';
// import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
// import 'package:apollo/resources/Apis/api_constant.dart';
// import 'package:apollo/resources/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:applovin_max/applovin_max.dart';
//
// class CustomAdScreen extends StatefulWidget {
//   const CustomAdScreen({super.key});
//
//   @override
//   CustomAdScreenState createState() => CustomAdScreenState();
// }
//
// class CustomAdScreenState extends State<CustomAdScreen> {
//   int _countdown = 10;
//   Timer? _timer;
//   bool _isAdReady = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeApplovinMax();
//     _startCountdown();
//   }
//
//   void _initializeApplovinMax() {
//     AppLovinMAX.setInterstitialListener(InterstitialListener(
//       onAdLoadedCallback: (ad) {
//         if (ad.adUnitId == ApiUrls.adUnitIdInterstitial) {
//           setState(() {
//             _isAdReady = true;
//           });
//           print('Interstitial ad loaded from network: ${ad.networkName}');
//         }
//       },
//       onAdLoadFailedCallback: (adUnitId, error) {
//         if (adUnitId == ApiUrls.adUnitIdInterstitial) {
//           setState(() {
//             _isAdReady = false;
//           });
//           print('Interstitial ad failed to load: ${error.message}');
//         }
//       },
//       onAdDisplayedCallback: (ad) {
//         print('Interstitial ad displayed');
//       },
//       onAdHiddenCallback: (ad) {
//         if (ad.adUnitId == ApiUrls.adUnitIdInterstitial) {
//           print('Interstitial ad dismissed');
//           Get.back(); // Close screen on ad dismissal
//         }
//       },
//       onAdDisplayFailedCallback: (ad, error) {
//         print('Interstitial ad failed to show: ${error.message}');
//       },
//       onAdClickedCallback: (MaxAd ad) {  },
//     ));
//
//     // Load your interstitial ad after setting listener
//     AppLovinMAX.loadInterstitial(ApiUrls.adUnitIdInterstitial);
//   }
//
//
//   void _startCountdown() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
//       if (_countdown == 0) {
//         timer.cancel();
//         Get.offAll(() => DashBoardScreen());
//       } else {
//         setState(() => _countdown--);
//         _showInterstitialAdIfReady();
//       }
//     });
//   }
//
//   Future<void> _showInterstitialAdIfReady() async {
//     bool? isReady = await AppLovinMAX.isInterstitialReady(ApiUrls.adUnitIdInterstitial);
//     if (isReady == true && _isAdReady) {
//       AppLovinMAX.showInterstitial(ApiUrls.adUnitIdInterstitial);
//       setState(() => _isAdReady = false);
//       // Load next ad
//       AppLovinMAX.loadInterstitial(ApiUrls.adUnitIdInterstitial);
//     } else {
//       print('Interstitial ad not ready');
//     }
//   }
//
//   // Skip countdown and show ad immediately
//   void _skipCountdown() {
//     // _timer?.cancel();
//
//
//     apolloPrint(message: 'Skip Clip on Ad');
//     Get.back();
//     _showInterstitialAdIfReady();
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Container(
//             color: Colors.black87,
//             child: Center(
//               child: Text(
//                 'Your Ad is loading...',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 40,
//             right: 20,
//             child: GestureDetector(
//               onTap: _countdown<6?_skipCountdown:(){},
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   children: [
//                     if(_countdown<6)
//                       Text(
//                         'Skip',
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     Text(
//                       '($_countdown)',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           if(_countdown<6)
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: LinearProgressIndicator(
//               value: _countdown / 10,
//               backgroundColor: Colors.white12,
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

/// above code for appLovin
/*
import 'dart:async';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class CustomAdScreen extends StatefulWidget {
  const CustomAdScreen({super.key});

  @override
  CustomAdScreenState createState() => CustomAdScreenState();
}

class CustomAdScreenState extends State<CustomAdScreen> {
  int _countdown = 10;
  Timer? _timer;
  bool _isAdReady = false;
  bool _hasShownAd = false;

  @override
  void initState() {
    super.initState();
    Future.microtask((){
      _initializeUnityAds();
      _startCountdown();
    });
  }

  void _initializeUnityAds() {
    final gameId = Theme.of(context).platform == TargetPlatform.android
        ? ApiUrls.gameIdAndroid
        : ApiUrls.gameIdIOS;

    UnityAds.init(
      gameId: gameId,
      testMode:kDebugMode, // change to false in production
      onComplete: () {
        print('✅ Unity Ads Initialized');
        _loadUnityInterstitial();
      },
      onFailed: (error, message) {
        print('❌ Unity Init Failed: $error | $message');
      },
    );
  }

  void _loadUnityInterstitial() {
    final placementId =
    GetPlatform.isIOS ? "Interstitial_iOS" : "Interstitial_Android";

    UnityAds.load(
      placementId: placementId,
      onComplete: (id) {
        print('✅ Unity Interstitial Loaded: $id');
        setState(() => _isAdReady = true);
      },
      onFailed: (id, error, message) {
        print('❌ Interstitial Load Failed: $error | $message');
        setState(() => _isAdReady = false);
      },
    );
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_countdown == 0) {
        timer.cancel();
        Get.offAll(() => DashBoardScreen());
      } else {
        setState(() => _countdown--);
        _showInterstitialIfReady();
      }
    });
  }

  Future<void> _showInterstitialIfReady() async {
    if (_isAdReady && !_hasShownAd) {
      _hasShownAd = true;
      final placementId =
      GetPlatform.isIOS ? "Interstitial_iOS" : "Interstitial_Android";

      print('🎬 Showing Unity Interstitial...');
      await UnityAds.showVideoAd(
        placementId: placementId,
        onStart: (id) => print('▶️ Ad Started'),
        onClick: (id) => print('🖱 Ad Clicked'),
        onSkipped: (id) {
          print('⏭ Ad Skipped');
          _navigateToDashboard();
        },
        onComplete: (id) {
          print('✅ Ad Completed');
          _navigateToDashboard();
        },
        onFailed: (id, error, message) {
          print('❌ Ad Failed to Show: $error | $message');
          _navigateToDashboard();
        },
      );

      setState(() => _isAdReady = false);
      _loadUnityInterstitial(); // preload next ad
    }
  }

  void _skipCountdown() {
    apolloPrint(message: 'Skip Clicked');
    _showInterstitialIfReady();
  }

  void _navigateToDashboard() {
    _timer?.cancel();
    if (Get.isOverlaysClosed == false) {
      Get.offAll(() => DashBoardScreen());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black87,
            child: const Center(
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
              onTap: _countdown < 6 ? _skipCountdown : null,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    if (_countdown < 6)
                      const Text(
                        'Skip ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    Text(
                      '($_countdown)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_countdown < 6)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: LinearProgressIndicator(
                value: _countdown / 10,
                backgroundColor: Colors.white12,
                valueColor:
                const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ),
        ],
      ),
    );
  }
}
*/

// above code for unity ads with timmer working

import 'dart:async';
import 'dart:io';
import 'package:apollo/main.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';

class CustomAdScreen extends StatefulWidget {
  const CustomAdScreen({super.key});

  @override
  CustomAdScreenState createState() => CustomAdScreenState();
}

class CustomAdScreenState extends State<CustomAdScreen> {
  bool _isAdReady = false;
  bool _hasShownAd = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {

      if(unityAdsInitialized){
        _loadUnityInterstitial();
      }else{
        _navigateToDashboard();
      }

      // _initializeUnityAds();
    });
  }

  void _initializeUnityAds() {


    UnityAds.init(
      gameId: Platform.isAndroid ? ApiUrls.gameIdAndroid : ApiUrls.gameIdIOS,
      testMode: kDebugMode, // set to false for production
      onComplete: () {
        print('✅ Unity Ads Initialized');
        _loadUnityInterstitial();
      },
      onFailed: (error, message) {
        print('❌ Unity Init Failed: $error | $message');
        _navigateToDashboard();
      },
    );
  }

  void _loadUnityInterstitial() {
    final placementId = Platform.isAndroid
        ? ApiUrls.unityInterstitialAndroid
        : ApiUrls.unityInterstitialIOS;

    UnityAds.load(
      placementId: placementId,
      onComplete: (id) {
        print('✅ Interstitial Loaded: $id');
        setState(() => _isAdReady = true);
        _showInterstitial(); // show immediately when ready
      },
      onFailed: (id, error, message) {
        print('❌ Failed to load ad: $error | $message');
        _navigateToDashboard();
      },
    );
  }

  Future<void> _showInterstitial() async {
    if (_isAdReady && !_hasShownAd) {
      _hasShownAd = true;
      final placementId = Platform.isAndroid
          ? ApiUrls.unityInterstitialAndroid
          : ApiUrls.unityInterstitialIOS;
      print('🎬 Showing Unity Interstitial...');
      await UnityAds.showVideoAd(
        placementId: placementId,
        onStart: (id) => print('▶️ Ad Started'),
        onClick: (id) => print('🖱 Ad Clicked'),
        onSkipped: (id) {
          print('⏭ Ad Skipped');
          _navigateToDashboard();
        },
        onComplete: (id) {
          print('✅ Ad Completed');
          _navigateToDashboard();
        },
        onFailed: (id, error, message) {
          print('❌ Ad Failed: $error | $message');
          _navigateToDashboard();
        },
      );
    } else {
      print('⚠️ Ad not ready yet, navigating...');
      _navigateToDashboard();
    }
  }

  void _navigateToDashboard() {
    if (mounted) {
      Get.offAll(() => DashBoardScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: const Center(
          child: Text(
            'Your Ad is loading...',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
      ),
    );
  }
}

