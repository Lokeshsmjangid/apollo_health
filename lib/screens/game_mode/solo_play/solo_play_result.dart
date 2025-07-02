import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/screens/badge_screens/grandmaster_health_badge_screen.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

/*class SoloResultScreen extends StatelessWidget {
  double? result;
 SoloResultScreen({super.key,this.result=0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height,
            color: AppColors.primaryColor,
            child: null,
          ),

          Container(
            width: double.infinity,
            child: Image.asset(
              AppAssets.notificationsBg,
              fit: BoxFit.cover,
            ),
          ),

          if(result! > 60)
          Container(
            width: double.infinity,
            child: Image.asset(
              AppAssets.soloPlayResultImg,
              fit: BoxFit.cover,
            ),
          ),


          // Confetti Effect (Optional: Use confetti package for animation)
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [

              addHeight(52),
              Row(
                children: [
                  Image.asset(AppAssets.circleQuestionIcon, height: 20),
                  const SizedBox(width: 4),
                  GestureDetector(
                      onTap: (){
                        Get.toNamed(AppRoutes.howToLevelUpScreen);
                      },
                      child: addText500('Level up', fontSize: 16, height: 22,color: AppColors.whiteColor)),
                  const Spacer(),
                  Image.asset(AppAssets.shareIcon, height: 24, width: 24),
                  const SizedBox(width: 10),
                  Image.asset(AppAssets.closeIcon, height: 24, width: 24),
                ],
              ),

              addHeight(34),
              addText400(
                  result! > 60?"Great job!":"You're learning!",
                  fontSize: 38,
                  height: 43,
                  fontFamily: 'Caprasimo',
                  color: Colors.white),


              // Circular Mascot (Replace with your actual image/animation)
              Lottie.asset(
                  'assets/Lottie/Appolo dance.json',
                  repeat: true,
                  reverse: false,
                  animate: true,
                  width: 296,
                  height: 310
              ),

              addHeight(57),
              addText400("${result?.toStringAsFixed(0)}%",
                  fontSize: 120,
                  color: Colors.white,height: 22,
                  fontFamily: 'Caprasimo', // Use custom font if needed

              ),
              addHeight(30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.coinIcon,height: 24),
                  SizedBox(width: 8),
                  addText500("+120 HP", fontSize: 16,height: 22,color: Colors.white),
                  SizedBox(width: 20),

                  if(result! > 60)
                  Icon(Icons.shield, color: AppColors.yellowColor),
                  if(result! > 60)
                  SizedBox(width: 8),
                  if(result! > 60)
                  Text("New Badge", style: TextStyle(color: Colors.white)),
                ],
              ),
              addHeight(36),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(buttonText: 'Play Again',
                      onButtonTap: (){
                        CustomSnackBar().showSuccessSnackBar(context,message: "Are you sure?");
                      },
                      buttonColor: AppColors.whiteColor,buttonTxtColor: AppColors.primaryColor),

                  // addHeight(5),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Challenge a Friend",
                      style: TextStyle(color: Colors.white,fontFamily: 'Manrope',fontSize: 16),
                    ),
                  )
                ],
              ),


            ],
          ).marginSymmetric(horizontal: 16),

          // Bottom Buttons


        ],
      ),
    );
  }
}*/



class SoloResultScreen extends StatefulWidget {
  final double? result;
  SoloResultScreen({super.key, this.result = 0});

  @override
  State<SoloResultScreen> createState() => _SoloResultScreenState();
}

class _SoloResultScreenState extends State<SoloResultScreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Play audio if result > 60
    if (widget.result != null && widget.result! > 60) {
      _playConfettiSound(sound: AppAssets.confettiWave);
    }

    Future.delayed(Duration(seconds: 5),(){
      Get.to(()=>GrandmasterHealthBadgeScreen());
    });
  }

  Future<void> _playConfettiSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBigResult = widget.result! > 60;

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

          if (isBigResult)
            Positioned.fill(
              child: Container(
                width: double.infinity,
                child: Image.asset(
                  "assets/Lottie/party.gif",
                  fit: BoxFit.fill,
                  height: double.infinity,
                ),
              ),
            ),


          SafeArea(
            // bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Row
                // SizedBox(height: 16),
                Row(
                  children: [
                    Image.asset(AppAssets.circleQuestionIcon, height: 20),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                        Get.toNamed(AppRoutes.howToLevelUpScreen);
                      },
                      child: addText500('Level up'.capitalize.toString(),
                          fontSize: 16,
                          height: 22,
                          color: AppColors.whiteColor),
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: (){
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                          Share.share('Check out Apollo MedGames!');
                        },
                        child: Image.asset(AppAssets.shareIcon,height: 24,width: 24,)),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: (){
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                          Get.to(()=>DashBoardScreen());
                        },
                        child: Image.asset(AppAssets.closeIcon, height: 24, width: 24)),
                  ],
                ),

                SizedBox(height: 24),
                addText400(
                  isBigResult ? "Great job!" : "You're learning!",
                  fontSize: 32,
                  height: 43,
                  fontFamily: 'Caprasimo',
                  color: Colors.white,
                ),

                // SizedBox(height: 24),

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

                // SizedBox(height: 24),

                addText400(
                  "${widget.result?.toStringAsFixed(0)}%",
                  fontSize: 100,
                  color: Colors.white,
                  fontFamily: 'Caprasimo',
                ),

                // SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     addText400('Your Score', fontSize: 12,color: AppColors.whiteColor,),
                //     SizedBox(width: 4),
                //     addText400(
                //       "3250",
                //       fontSize: 16,
                //       color: AppColors.whiteColor,
                //       fontFamily: 'Caprasimo',
                //     ),
                //   ],
                // ),
                SizedBox(height: 20),

                // Reward Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppAssets.coinIcon, height: 24),
                    SizedBox(width: 8),
                    addText500(
                      "+120 HP",
                      fontSize: 16,
                      height: 22,
                      color: Colors.white,
                    ),
                    if (isBigResult) ...[
                      SizedBox(width: 20),
                      Icon(Icons.shield, color: AppColors.yellowColor),
                      SizedBox(width: 8),
                      Text(
                        "New Badge",
                        style: TextStyle(color: Colors.white),
                      ),
                    ]
                  ],
                ),

                /*SizedBox(height: 30),

                // Buttons
                AppButton(
                  buttonText: 'Play Again',
                  onButtonTap: () {
                    Get.back();
                  },
                  buttonColor: AppColors.whiteColor,
                  buttonTxtColor: AppColors.primaryColor,
                ),

                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Challenge a Friend",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Manrope',
                      fontSize: 16,
                    ),
                  ),
                ),

                SizedBox(height: 30),*/
              ],
            ).marginSymmetric(horizontal: 16),
          ),
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
            buttonText: 'Play Again',
            onButtonTap: (){
              // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
              Get.back();
            },
          ),
        ).marginOnly(left: 16,right: 16,bottom: 35),
      ),
    );
  }
}
