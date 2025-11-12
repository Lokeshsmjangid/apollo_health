import 'dart:io';
import 'package:get/get.dart';
import 'resources/app_color.dart';
import 'resources/app_routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'resources/Apis/api_constant.dart';
import 'resources/dependencies.dart' as de;
import 'package:scaled_app/scaled_app.dart';
import 'package:apollo/resources/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:apollo/resources/notification_service.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

var referralCode = "";
bool unityAdsInitialized = false;
Future<void> main() async{

  ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: (deviceSize) {
      const double widthOfDesign = 375; // your Figma width
      const double tabletThreshold = 600.0;

      double scaleFactor = deviceSize.width / widthOfDesign;
      bool isTablet = deviceSize.shortestSide >= tabletThreshold;

      // Tablet UI ko thoda controlled scale dena
      if (isTablet) {
        scaleFactor *= 0.75; // tweak if needed: 0.7 - 0.85
      }

      return scaleFactor;
    },
    // scaleFactor: (deviceSize) {
    //   const double widthOfDesign = 375; // screen width used in your UI design
    //   return deviceSize.width / widthOfDesign;
    // },
  );

  if(Platform.isIOS){
    await Firebase.initializeApp();
  }
  else {
    await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: 'AIzaSyAf4dYqkNwXH5b7oau2lQ0Kk2JSe_3AF_Q',
      appId: '1:1029679126997:android:49144c4a734ee7c5d1855c',
      messagingSenderId: '1029679126997',
      projectId: 'apollo-medgames'));}

  await de.init();
  await GetStorage.init();

  // await AppLinksService.init(); // to use dynamic link
  initMessaging();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await _initializeUnityAdsGlobal();
  // MobileAds.instance.initialize();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      statusBarIconBrightness: Brightness.dark, // icons: dark → for light background
      statusBarBrightness: Brightness.light, // iOS specific
    ),
  );
  runApp(const MyApp());
}

Future<void> _initializeUnityAdsGlobal() async {
  final gameId = Platform.isAndroid
      ? ApiUrls.gameIdAndroid
      : ApiUrls.gameIdIOS;
  apolloPrint(message: "🔹 Initializing Unity Ads...");
  apolloPrint(message: "🔹 Platform: ${Platform.operatingSystem}");
  apolloPrint(message: "🔹 Game ID: $gameId");
  apolloPrint(message: "🔹 Test Mode: ${kDebugMode}");
  await UnityAds.init(
    gameId: gameId,
    testMode: kDebugMode, // false in production
    onComplete: () {
      apolloPrint(message: "✅ Unity Ads Initialized Successfully!");
      apolloPrint(message: "✅ Game ID: $gameId");
      apolloPrint(message: "✅ Platform: ${Platform.operatingSystem}");
      unityAdsInitialized = true;
    },
    onFailed: (error, message) {
      apolloPrint(message: "❌ Unity Ads Initialization Failed!");
      apolloPrint(message: "❌ Error Type: $error");     // e.g., 'INIT_FAILED'
      apolloPrint(message: "❌ Error Message: $message"); // detailed message
      apolloPrint(message: "❌ Game ID: $gameId");
      apolloPrint(message: "❌ Platform: ${Platform.operatingSystem}");
      apolloPrint(message: "❌ Check your Unity Dashboard & Game ID");
      unityAdsInitialized = false;
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  /// when use of ads make myapp to stateless
  String adId = "Fetching...";

  @override
  void initState() {
    super.initState();
    _fetchAdId();
  }

  Future<void> _fetchAdId() async {
    try {
      String? id;
      if (Platform.isIOS) {
        final status = await AppTrackingTransparency.requestTrackingAuthorization();
        apolloPrint(message: "Tracking authorization status: $status");
        id = await AppTrackingTransparency.getAdvertisingIdentifier();
      }
      else {
        id = await AdvertisingId.id(true); // true = limit ad tracking
      }
      setState(() {
        adId = id!;
      });
      apolloPrint(message: "Advertising ID: $id");
    }
    catch (e) {
      setState(() {
        adId = "Error: $e";
      });
      apolloPrint(message: "Error fetching ad ID: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light
        ));
    return GestureDetector(
      onTap: () {
        if (FocusManager.instance.primaryFocus?.hasFocus ?? false) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: GetMaterialApp(
        title: 'Apollo MedGames',
        locale: Get.deviceLocale,
        getPages: AppRoutes.getRoute,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splashMainScreen,
        defaultTransition: Transition.noTransition,
        theme: ThemeData(
            primarySwatch: primaryColorShades,
            fontFamily: 'Manrope',
            useMaterial3: false
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), // Set the desired text scaling factor here
            child: child!,
          );
        })
    );}}

// command to generate SHA key
// keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
// share url var url = '${ApiUrls.domain}refer/?promo-id=${ctrl.communityID}&promo-type=community';
// add to xcode associate domain-> applinks:apollomedgames.com