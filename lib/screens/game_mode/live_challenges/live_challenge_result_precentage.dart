import 'dart:io';
import 'dart:async';
import 'package:apollo/resources/utils.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:apollo/resources/Apis/api_models/livec_chalenge_score_model.dart';

class LiveChallengeResultPrecentageScreen extends StatefulWidget {
  LiveChallengeScore? result;
  LiveChallengeResultPrecentageScreen({super.key,this.result});

  @override
  State<LiveChallengeResultPrecentageScreen> createState() => _LiveChallengeResultPrecentageScreenState();
}

class _LiveChallengeResultPrecentageScreenState extends State<LiveChallengeResultPrecentageScreen> {

  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {await audioPlayer.play(AssetSource(sound));}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startPeriodicTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timerNew?.cancel();
    super.dispose();
  }
  Timer? _timerNew;
  int _counter = 10;
  void _startPeriodicTimer() {
    _timerNew = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _counter--;
      });
      if(_counter==0){
        Get.offAll(()=>DashBoardScreen());
      }
    });
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

          if(widget.result!.percentage! > 60)
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                "assets/Lottie/party.gif",
                fit: BoxFit.fill,
                height: double.infinity,
              ),
            ),


          // Confetti Effect (Optional: Use confetti package for animation)
          SafeArea(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [

                addHeight(10),
                Row(
                  children: [
                    Image.asset(AppAssets.circleQuestionIcon, height: 24),
                    const SizedBox(width: 6),
                    GestureDetector(
                        onTap: (){
                          // effectSound(sound: AppAssets.actionButtonTapSound);
                          Get.toNamed(AppRoutes.howToLevelUpScreen);
                        },
                        child: addText500('Level up'.capitalize.toString(),
                        fontSize: 16, color: AppColors.whiteColor)),
                    const Spacer(),
                    GestureDetector(
                        onTap: (){
                          // effectSound(sound: AppAssets.actionButtonTapSound);
                          Share.share(
                              shareText                          );
                        },
                        child: Image.asset(AppAssets.shareIcon,height: 24,width: 24,)),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: (){
                          // effectSound(sound: AppAssets.actionButtonTapSound);
                          Get.to(()=>DashBoardScreen());
                        },
                        child: Image.asset(AppAssets.closeIcon, height: 24)),
                  ],
                ),
                addHeight(24),
                addText400(
                  widget.result!.percentage! > 60?"Great job!":"You're learning!",
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

                // const SizedBox(height: 30),
                addText400(
                  "${widget.result?.percentage!.toStringAsFixed(0)}%",
                    fontSize: 110,
                    color: Colors.white,
                    fontFamily: 'Caprasimo',

                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppAssets.coinIcon,height: 24,),
                    SizedBox(width: 6),
                    Text("${widget.result!.totalXp} HP", style: TextStyle(color: Colors.white)),

                  ],
                ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                buttonTxtColor: AppColors.primaryColor,
                buttonColor: AppColors.whiteColor,
                buttonText: 'Play Another Game',
                onButtonTap: (){
                  // effectSound(sound: AppAssets.actionButtonTapSound);
                  Get.to(()=>DashBoardScreen());
                },
              ),
            ],
          ),
        ).marginOnly(left: 16,right: 16,bottom: 35),
      ),
    );
  }
}
