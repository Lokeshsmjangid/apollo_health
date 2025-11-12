
import 'package:apollo/resources/Apis/api_repository/fetch_subscription_repo.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

class SplashMainScreen extends StatefulWidget {
  const SplashMainScreen({super.key});

  @override
  State<SplashMainScreen> createState() => _SplashMainScreenState();
}

class _SplashMainScreenState extends State<SplashMainScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;

  late AnimationController _subTitleController;
  late Animation<double> _subTitleScale;
  late Animation<double> _subTitleFade;

  @override
  void initState() {

    super.initState();
    AuthData().getLoginData();

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
    _logoController.forward();

    // SubTitle animation
    _subTitleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _subTitleScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _subTitleController, curve: Curves.easeOutBack),
    );
    _subTitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _subTitleController, curve: Curves.easeIn),
    );
    // Start subtitle after logo finishes
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _subTitleController.forward();
      }
    });

    // Navigate to onboarding after splash
    Future.delayed(const Duration(milliseconds: 2200), () {
      // if (mounted) {
        navigateUser();
      // }
    });
  }


  void navigateUser() async {
    if (AuthData().isLogin) {
      final user = AuthData().userModel;
      if(user?.status == 1){
        apolloPrint(message: 'Is User Login---00---> ${user?.email}');

        if(user?.disclaimerStatus==1){
          // Check for notifications before navigating to dashboard

          await checkNotificationOnAppStart();
        }
        else{
          Get.offAllNamed(AppRoutes.signUpDisclaimerScreen);
        }
      }
      else {
        apolloPrint(message: 'Is User Login but personal details not filled---11---> ${user?.email}');
        Get.offAllNamed(AppRoutes.signUpPersonalInfoScreen,arguments: {'goBack': 'splash'});
      }
    }
    else {
      apolloPrint(message: 'Is User Login---12---> ${AuthData().isLogin}');
      Get.offNamed(AppRoutes.onboardingScreen);
    }
  }

  // Check for notifications when app is launched from terminated state
  Future<void> checkNotificationOnAppStart() async {
    try {
      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      
      if (initialMessage != null) {
        // If there's a notification, handle it first
        apolloPrint(message: 'Notification found on app start: ${initialMessage.data}');
        // Navigate to dashboard first, then handle notification
        if(AuthData().userModel?.roleId !=4)
        fetchDetails();


        Get.offAll(() => DashBoardScreen());
        // Wait a bit for dashboard to be ready, then handle notification
        Future.delayed(const Duration(milliseconds: 500), () {
          handleNotificationNavigation(initialMessage.data);
        });
      } else {
        // No notification, just go to dashboard
        if(AuthData().userModel?.roleId !=4)
        fetchDetails();
        Get.offAll(() => DashBoardScreen());
      }
    } catch (e) {
      apolloPrint(message: 'Error checking notification: $e');
      // If there's an error, just go to dashboard
      if(AuthData().userModel?.roleId !=4)
      fetchDetails();
      Get.offAll(() => DashBoardScreen());
    }
  }

  void handleNotificationNavigation(Map<String, dynamic> data) {
    try {
      apolloPrint(message: 'Handling notification navigation: $data');
      if (data['title'] == 'Friend Request'){
        Get.toNamed(AppRoutes.playRequestScreen);
      } else if(data['title'] == "Group Play Invite"){
        Get.toNamed(AppRoutes.groupPlayRequestScreen, arguments: {
          'group_game_id': int.parse(data['group_game_id']),
          'sender_id': int.parse(data['sender_id'])
        });
      }
    } catch (e) {
      apolloPrint(message: 'Error in notification navigation: $e');
    }
  }


  fetchDetails() {

    getSubscriptionDetailsApi().then((value){
      // apolloPrint(message: 'Subscription wali api call hui hain');
      if(value.data!=null){
        LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
        LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
        setState(() {});
        AuthData().getLoginData();

      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _subTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset(
            AppAssets.splashScreenBgImg,
            fit: BoxFit.fill,
          ),

          // Logo animation
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                addHeight(18),
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) => Opacity(
                    opacity: _logoFade.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: SvgPicture.asset(AppAssets.textLogo),
                    ),
                  ),
                ),
                // AnimatedBuilder(
                //   animation: _subTitleController,
                //   builder: (context, child) => Opacity(
                //     opacity: _subTitleFade.value,
                //     child: Transform.scale(
                //       scale: _subTitleScale.value,
                //       child:
                //       addText500(
                //         'Apollo a day keeps the doctor away.',
                //         color: AppColors.whiteColor,
                //         fontSize: 14,
                //         textAlign: TextAlign.center,
                //       ).marginOnly(top: 6),
                    // ),
                  // ),
                // ).marginOnly(top: 6)
              ],
            ),
          ),

          // Subtitle animation
          // Align(
          //   alignment: Alignment.center,
          //   child: ,
          // ),
        ],
      ),
    );
  }
}
