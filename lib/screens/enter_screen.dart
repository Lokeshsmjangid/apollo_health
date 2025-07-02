/*
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_column_animation.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({super.key});

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLightColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height,
            child: Image.asset(AppAssets.enterScreenBg,fit: BoxFit.cover,)),
          Positioned(
            top: 130,
            right: 18,
            left: 18,
            child: AnimatedColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/Lottie/Appolo stetoskope.json',
                  repeat: true,
                  reverse: false,
                  animate: true,
                   width: 300,
                   height: 313
                ),

                // addHeight(18),
                addText400('Let’s Get Started!',fontSize: 38,fontFamily: 'Caprasimo',height: 43),

                addHeight(24),
                addText500('Log in to personalize your experience and track your progress.',textAlign: TextAlign.center,fontSize: 16,
                    height: 22).marginSymmetric(horizontal: 12),

                addHeight(69),
                AppButton(buttonText: 'Create an Account',onButtonTap: (){
                  Get.toNamed(AppRoutes.createAccountScreen);
                },),
                addHeight(13),

                AppButton(
                  buttonText: 'Sign in',
                  buttonColor: AppColors.whiteColor,
                  buttonTxtColor: AppColors.primaryColor,
                  onButtonTap: (){
                    print('object');
                    Get.toNamed(AppRoutes.signInScreen);
                  },
                ),

              ],
            )
          )

        ],
      ),
    );
  }
}
*/


import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({super.key});

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  final AudioPlayer effectPlayer = AudioPlayer();


  Future<void> effectSound({required String sound}) async {
    await effectPlayer.play(AssetSource(sound));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLightColor,
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(
              AppAssets.enterScreenBg,
              fit: BoxFit.cover,
            ),
          ),

          /// Foreground Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/Lottie/Appolo stetoskope.json',
                    width: 300,
                    height: 313,
                  ),

                  addText400(
                    'Let’s Get Started!',
                    fontSize: 38,
                    fontFamily: 'Caprasimo',
                    height: 43,
                  ),

                  addHeight(24),

                  addText500(
                    'Log in to personalize your experience and track your progress.',
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    height: 22,
                  ).marginSymmetric(horizontal: 12),

                  addHeight(69),

                  AppButton(
                    buttonText: 'Create an Account',
                    onButtonTap: () {
                      // effectSound(sound: AppAssets.actionButtonTapSound);
                      Get.toNamed(AppRoutes.createAccountScreen);
                    },
                  ),

                  addHeight(13),

                  AppButton(
                    buttonText: 'Sign in',
                    buttonColor: AppColors.whiteColor,
                    buttonTxtColor: AppColors.primaryColor,
                    onButtonTap: () {
                      // effectSound(sound: AppAssets.actionButtonTapSound);
                      Get.toNamed(AppRoutes.signInScreen);
                    },
                  ),

                  addHeight(24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
