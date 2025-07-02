import 'dart:math' as math;
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:get/get.dart';

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
      _subTitleController.forward();
    });

    // Navigate to onboarding after splash
    Future.delayed(const Duration(seconds: 6), () {
      Get.offAllNamed(AppRoutes.onboardingScreen);
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
                AnimatedBuilder(
                  animation: _subTitleController,
                  builder: (context, child) => Opacity(
                    opacity: _subTitleFade.value,
                    child: Transform.scale(
                      scale: _subTitleScale.value,
                      child: addText500(
                        'Apollo a day keeps the doctor away.',
                        color: AppColors.whiteColor,
                        fontSize: 14,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ).marginOnly(top: 6)
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
