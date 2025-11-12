import 'package:apollo/resources/Apis/api_models/solo_play_models/solo_play_result_model.dart';
import 'package:apollo/screens/badge_screens/grandmaster_health_badge_screen.dart';
import 'package:apollo/screens/badge_screens/health_apprentice_badge_screen.dart';
import 'package:apollo/screens/badge_screens/wellness_watcher_badge_screen.dart';
import 'package:apollo/screens/badge_screens/health_whiz_badge_screen.dart';
import 'package:apollo/screens/badge_screens/health_pro_badge_screen.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/screens/ads/ads_example.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:apollo/resources/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';

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
  SoloResult? soloPlayResult;
  SoloResultScreen({super.key, this.result = 0,this.soloPlayResult});

  @override
  State<SoloResultScreen> createState() => _SoloResultScreenState();
}

class _SoloResultScreenState extends State<SoloResultScreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isNewBadge = false;

  @override
  void initState() {
    super.initState();
    _startPeriodicTimer();
    if (widget.soloPlayResult != null && widget.soloPlayResult!.percentage! > 60) {
      _playConfettiSound(sound: AppAssets.confettiWave);
    }

    Future.delayed(Duration(seconds: 5),(){
      if (widget.soloPlayResult != null ) {
        int hP = widget.soloPlayResult!.totalXp!;
        switch (hP) {
          case 5000:
            isNewBadge = true;
            setState(() {});
            Get.to(()=>HealthApprenticeBadgeScreen());
            break;
          case 10000:
            isNewBadge = true;
            setState(() {});
            Get.to(()=>WellnessWatcherBadgeScreen());
            break;
          case 15000:
            isNewBadge = true;
            setState(() {});
            Get.to(()=>HealthProBadgeScreen());
            break;
          case 25000:
            isNewBadge = true;
            setState(() {});
            Get.to(()=>HealthWhizBadgeScreen());
            break;
          case 50000:
            isNewBadge = true;
            setState(() {});
            Get.to(()=>GrandmasterHealthBadgeScreen());
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playConfettiSound({required String sound}) async {
    // if(AuthData().musicONOFF) {
      await _audioPlayer.play(AssetSource(sound));
    // }
  }



  // for remove all screens and to back to home
  Timer? _timer;
  int _counter = 10;
  void _startPeriodicTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _counter--; // Update your logic here
      });
      if(_counter==0){
        if(AuthData().isPremium) {
          Get.back();
        } else{
          Get.to(()=>CustomAdScreen());
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    final isBigResult = widget.soloPlayResult!=null?widget.soloPlayResult!.percentage! > 60:false;

    return PopScope(
      canPop: false,
      child: Scaffold(
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
                child: SizedBox(
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
                  addHeight(10),
                  Row(
                    children: [
                      Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                              // color: Colors.red,
                              shape: BoxShape.circle
                          ),
                          child: Image.asset(AppAssets.circleQuestionIcon).marginAll(6)),
                      // const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                          _timer?.cancel();
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
                            Share.share(AuthData().userModel?.roleId==4?shareTextGuest:shareText);
                          },
                          child: Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                  // color: Colors.red,
                                  shape: BoxShape.circle
                              ),
                              child: Image.asset(AppAssets.shareIcon).marginAll(6))),
                      // const SizedBox(width: 10),
                      GestureDetector(
                          onTap: (){
                            if(AuthData().isPremium){
                              Get.back();
                            }else {
                              Get.to(()=>CustomAdScreen());
                            }},
                          child: Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                  // color: Colors.red,
                                  shape: BoxShape.circle
                              ),
                              child: Image.asset(AppAssets.closeIcon).marginAll(6))),
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
                    "${widget.soloPlayResult?.percentage}%",
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
                        "${widget.soloPlayResult?.xp} HP",
                        fontSize: 20,
                        height: 22,
                        color: Colors.white,
                      ),
                      if (isNewBadge) ...[
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
                if(AuthData().isPremium){
                  Get.back();
                }else {
                  Get.off(CustomAdScreen());
                }
              },
            ),
          ).marginOnly(left: 16,right: 16,bottom: 35),
        ),
      ),
    );
  }
}
