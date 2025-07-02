import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

class WheelOfWellnessResult extends StatefulWidget {
  String? showText;
  String? correctAns;
  int hP;
  WheelOfWellnessResult({super.key,this.showText,this.correctAns,this.hP=0});

  @override
  State<WheelOfWellnessResult> createState() => _WheelOfWellnessResultState();
}

class _WheelOfWellnessResultState extends State<WheelOfWellnessResult> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playConfettiSound(sound: AppAssets.confettiWave);
  }

  Future<void> _playConfettiSound({required String sound}) async {
    if(widget.showText != 'gameOver') {
      await _audioPlayer.play(AssetSource(sound));
    }
  }

  Future<void> effectSound({required String sound}) async {

      await _audioPlayer.play(AssetSource(sound));

  }



  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.notificationsBg,
              fit: BoxFit.cover,
            ),
          ),
          if(widget.showText=='terrific')
          Container(
            width: double.infinity,
            child: Image.asset(
              AppAssets.confettiGif,
              fit: BoxFit.fill,
              height: double.infinity,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(AppAssets.circleQuestionIcon, height: 24),
                    const SizedBox(width: 6),
                    GestureDetector(
                        onTap: (){
                          Get.toNamed(AppRoutes.howToLevelUpScreen);
                        },
                        child: addText500('Level up'.capitalize.toString(), fontSize: 16, color: AppColors.whiteColor)),
                    const Spacer(),
                    GestureDetector(
                        onTap: (){
                          Share.share('Check out Apollo MedGames!');
                        },
                        child: Image.asset(AppAssets.shareIcon,height: 24,width: 24,)),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: Image.asset(AppAssets.closeIcon, height: 24)),
                  ],
                ),
                addHeight(24),

                addText400(
                  widget.showText=='terrific'?"Great job!": "You're learning!",
                  fontSize: 32,
                  fontFamily: 'Caprasimo',
                  color: Colors.white,
                ),
                FittedBox(
                  child: Lottie.asset(
                      'assets/Lottie/Appolo dance.json',
                      repeat: true,
                      reverse: false,
                      animate: true,
                      // width: 310,
                      // height: 240
                  ),
                ).marginSymmetric(horizontal: 20),

                addText500('The word is:',color: AppColors.whiteColor,fontSize: 20,height: 28),
                addText400('${widget.correctAns?.toUpperCase()}',fontFamily: 'Caprasimo',color: AppColors.whiteColor,fontSize: 32,height: 40),
                addHeight(12),

                // Question
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.yellowColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: addText400(
                      "High blood pressure that can damage the heart and body",
                      textAlign: TextAlign.center,
                      fontSize: 12, color: AppColors.whiteColor,height: 18
                  ).marginSymmetric(horizontal: 18),
                ).marginSymmetric(horizontal: 26),
                
                addHeight(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppAssets.coinIcon, height: 24, width: 24),
                    addWidth(8),
                    addText500(widget.showText=='gameOver'?'+0 HP':'+2,040 HP',color: AppColors.whiteColor)
                  ],
                )

              ],
            ).marginSymmetric(horizontal: 16),
          )
        ],
      ),
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeBottom: Platform.isIOS ? true : false,
        removeTop: true,
        child: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: AppButton(
            buttonTxtColor: AppColors.primaryColor,
            buttonColor: AppColors.whiteColor,
            buttonText: 'Play Another Game',
            onButtonTap: (){
              // effectSound(sound: AppAssets.actionButtonTapSound);
                Get.back();
                Get.back();
            }),
        ).marginOnly(left: 16,right: 16,bottom: 35)));
  }
}


