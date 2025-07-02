import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/screens/badge_screens/grandmaster_health_badge_screen.dart';
import 'package:apollo/screens/badge_screens/health_whiz_badge_screen.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

class GroupPlayResultScreen extends StatefulWidget {
  bool? isMadPardy;
  GroupPlayResultScreen({super.key,this.isMadPardy = false});

  @override
  State<GroupPlayResultScreen> createState() => _GroupPlayResultScreenState();
}

class _GroupPlayResultScreenState extends State<GroupPlayResultScreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Play audio if result > 60
    // if (widget.result != null && widget.result! > 60) {
      _playConfettiSound(sound: AppAssets.confettiWave);
      Future.delayed(Duration(seconds: 5),(){
      Get.to(()=>HealthWhizBadgeScreen());
    });
    // }
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
    // If isMadPardy is true, exclude the last player
    final playersToShow = widget.isMadPardy!
        ? _players.sublist(0, _players.length - 1)
        : _players;
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.primaryColor, // Purple background
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            child: Image.asset(
              AppAssets.notificationsBg,
              fit: BoxFit.cover,
              // color: ,
            ),
          ),
          Container(
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

                // Top Bar
                Row(
                  children: [
                    Image.asset(AppAssets.circleQuestionIcon, height: 24),
                    const SizedBox(width: 6),
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
                        child: Image.asset(AppAssets.closeIcon,height: 24,width: 24,)),
                  ],
                ).marginSymmetric(horizontal: 16),

                const SizedBox(height: 12),
                addText500(
                  'Game Completed',
                  color: AppColors.whiteColor,
                  fontSize: 16,
                ),
                const SizedBox(height: 8),
                addText400(
                  'Congratulations!',

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
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        ...playersToShow.asMap().entries.map((entry) => _buildPlayerTile(entry.key, entry.value,isMadPardy: widget.isMadPardy!)),


                        // Play Again Button
                        // const SizedBox(height: 24),
                        // AppButton(
                        //     onButtonTap: (){Get.back();},
                        //     buttonText: 'Play Again'),
                        //
                        // SizedBox(height: 34),
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
              // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
              if(widget.isMadPardy==false){
                Get.back();
              }else{
                // Get.offAll(DashBoardScreen());
                Get.back();
              }
            },
          ),
        ).marginOnly(left: 16,right: 16,bottom: 35),
      ),
    );
  }

  Widget _buildPlayerTile(int index, Map<String, dynamic> player,{bool isMadPardy = false}) {
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
                text: player['name'],
                style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
                children: [
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: '${player['score']}% Correct Answers',
                    style: TextStyle(
                        fontSize: 14, color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
          ),

          isMadPardy==false?Container(
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.yellowColor)
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text('${player['time']} sec',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ) : Column(
            children: [
              addText500('Score',fontSize: 12,),
              addText400('500',fontSize: 28,fontFamily: 'Caprasimo',color: AppColors.primaryColor)
            ],
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> _players = [
  {
    // 'badge':  Icon(Icons.shield, color: AppColors.yellowColor),,
    'name': 'Madelyn Dias',
    'score': 90,
    'time': 296,
  },
  {
    // 'badge': 'assets/images/silver_medal.png',
    'name': 'Justin Bator',
    'score': 90,
    'time': 208,
  },
  {
    // 'badge': 'assets/images/bronze_medal.png',
    'name': 'Zain Vaccaro',
    'score': 70,
    'time': 200,
  },
  {
    // 'badge': 'assets/images/transparent.png',
    'name': 'Skylar Geidt',
    'score': 60,
    'time': 200,
  },
];
