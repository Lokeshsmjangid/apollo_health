
import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:apollo/resources/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/screens/ads/ads_example.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/Apis/api_models/live_challenge_final_result.dart';

class LivePlayResultWithScoreScreen extends StatefulWidget {
  List<LiveChallengeFinalResult>? resultData;

  LivePlayResultWithScoreScreen({super.key,this.resultData = const[]});

  @override
  State<LivePlayResultWithScoreScreen> createState() => _LivePlayResultWithScoreScreenState();
}

class _LivePlayResultWithScoreScreenState extends State<LivePlayResultWithScoreScreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();



  @override
  void initState() {
    super.initState();
      _playConfettiSound(sound: AppAssets.confettiWave);
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

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.primaryColor, // Purple background
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              AppAssets.notificationsBg,
              fit: BoxFit.cover,
              // color: ,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              "assets/Lottie/party.gif",
              fit: BoxFit.fill,
              height: double.infinity,
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [

                // addHeight(10),
                // Top Bar
                Row(
                  children: [
                    Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                        // color: Colors.red,
                          shape: BoxShape.circle
                        ),
                        child: Image.asset(AppAssets.circleQuestionIcon).marginAll(5)),
                    // const SizedBox(width: 6),
                    GestureDetector(
                        onTap: (){
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                          Get.toNamed(AppRoutes.howToLevelUpScreen);
                        },
                        child: addText500('Level up'.capitalize.toString(),
                            fontSize: 16, color: AppColors.whiteColor)),
                    const Spacer(),
                    GestureDetector(
                        onTap: (){

                          Share.share(
                              ''
                          );
                        },
                        child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                                // color: Colors.red,
                                shape: BoxShape.circle
                            ),
                            child: Image.asset(AppAssets.shareIcon).marginAll(5))),
                    // const SizedBox(width: 10),
                    GestureDetector(
                        onTap: (){

                          // Get.to(()=>DashBoardScreen());
                          Get.back();
                          Get.off(CustomAdScreen());
                        },
                        child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                                // color: Colors.red,
                                shape: BoxShape.circle
                            ),
                            child: Image.asset(AppAssets.closeIcon).marginAll(5))),
                  ],
                ).marginSymmetric(horizontal: 16),
                const SizedBox(height: 8),
                addText400(
                  // 'Congratulations!',
                  'Results Are In!',
                      fontSize: 34,height: 40,
                      color: Colors.white,fontFamily: 'Caprasimo'
                ),

                // const SizedBox(height: 14),

                // Emoji/Character
                Lottie.asset(
                  'assets/Lottie/Appolo strength.json',
                  repeat: true,
                  reverse: false,
                  animate: true,
                    width: 240,
                    height: 240
                ).marginSymmetric(horizontal: 20),
                // White Box with Players
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: widget.resultData!=null && widget.resultData!.isEmpty? Center(child: addText500('No players found'),):ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        ...widget.resultData!.asMap().entries.map((entry) => _buildPlayerTile(entry.key, entry.value)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
            buttonTxtColor: AppColors.whiteColor,
            buttonColor: AppColors.primaryColor,
            buttonText: 'Play Again',
            onButtonTap: (){
              Get.back();
              Get.off(CustomAdScreen());
            },
          ),
        ).marginOnly(left: 16,right: 16,bottom: 35),
      ),
    );
  }

  Widget _buildPlayerTile(int index, LiveChallengeFinalResult player) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.shield, color: index+1==1?AppColors.yellowColor:index+1==2
                  ?AppColors.buttonDisableColor:index+1==3?Color(0XFFC58219):Colors.transparent,size: 34,),
              addText400('${index+1}',fontSize: 14,fontFamily: 'Caprasimo')
            ],

          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: getTruncatedName('${player.firstName}', '${player.lastName}'),
                style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
                children: [
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: '${player.country}',
                    style: TextStyle(
                        fontSize: 14, color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
          ), Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              addHeight(4),
              addText400('${player.totalXp} HP',fontSize: 16,fontFamily: 'Caprasimo',color: AppColors.primaryColor),
              addHeight(6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4,vertical: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.yellowColor)
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 12),
                    const SizedBox(width: 2),
                    Text('${player.totalTime} sec',
                        style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}


