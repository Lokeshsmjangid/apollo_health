import 'dart:async';
import 'dart:io';

import 'package:apollo/controllers/bottom_bar_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/Apis/api_models/group_play_result_model.dart';
import 'package:apollo/resources/Apis/api_repository/group_play_result_update_repo.dart';
import 'package:apollo/resources/Apis/api_repository/group_point_distribute_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/ads/ads_example.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

class GroupPlayResultScreen extends StatefulWidget {
  bool? isPlayRequest;
  bool? isMadPardy;
  int? gameId;
  List<GroupUser> users;
  GroupPlayResultScreen({super.key,this.isPlayRequest,this.isMadPardy = false,this.users = const[],this.gameId});

  @override
  State<GroupPlayResultScreen> createState() => _GroupPlayResultScreenState();
}

class _GroupPlayResultScreenState extends State<GroupPlayResultScreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();
  int seconds = 5;
  Timer? _timer;


  @override
  void initState() {
    super.initState();
      _playConfettiSound(sound: AppAssets.confettiWave);

    // }
    startTimer();
  }

  Future<void> _playConfettiSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerNew?.cancel();

    _audioPlayer.dispose();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });

        if ((seconds) % 2 == 0) {

          groupPlayResultUpdateApi(gameId: widget.gameId).then((value){

            if(value.users!=null && value.users!.isNotEmpty){
              widget.users = value.users!;


              final allPerfect = value.users!.every((user) => user.gameComplete == 1);
              if(allPerfect){
                _timer?.cancel();
                _startPeriodicTimer();
                groupPointDistributionApi(gameId: widget.gameId).then((vall){});
              }
            }
            setState(() {});

          });
        }
      } else {
        _timer?.cancel();
      }
    });
  }


  // for remove all screens and to back to home
  Timer? _timerNew;
  int _counter = 10;
  void _startPeriodicTimer() {
    _timerNew = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _counter--; // Update your logic here
      });
      if(_counter==0){
        if(AuthData().isPremium){
          Get.find<BottomBarController>().selectedIndex=0;
          Get.find<BottomBarController>().update();
          Get.offAll(()=>DashBoardScreen());
        }else {
          Get.to(()=>CustomAdScreen());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      child: Scaffold(
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

                  addHeight(10),
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
                          child: Image.asset(AppAssets.circleQuestionIcon).marginAll(6)),
                      // const SizedBox(width: 6),
                      GestureDetector(
                          onTap: (){
                            // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                            _timerNew?.cancel();
                            Get.toNamed(AppRoutes.howToLevelUpScreen);
                          },
                          child: addText500('Level up'.capitalize.toString(),
                              fontSize: 16, color: AppColors.whiteColor)),
                      const Spacer(),
                      GestureDetector(
                          onTap: (){

                            // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                            Share.share(
                                shareText                            );
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
                            // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                            Get.to(()=>DashBoardScreen());
                          },
                          child: Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                  // color: Colors.red,
                                  shape: BoxShape.circle
                              ),
                              child: Image.asset(AppAssets.closeIcon).marginAll(6))),
                    ],
                  ).marginSymmetric(horizontal: 16),

                  // const SizedBox(height: 12),
                  // addText500(
                  //   'Game Completed',
                  //   color: AppColors.whiteColor,
                  //   fontSize: 16,
                  // ),
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
                      child: widget.users.isEmpty? Center(child: addText500('No players found'),):ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ...widget.users.asMap().entries.map((entry) => _buildPlayerTile(entry.key, entry.value,isMadPardy: widget.isMadPardy!)),


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
                  if(widget.isPlayRequest==true){ // because of notification play request

                    Get.find<BottomBarController>().selectedIndex=0;
                    Get.find<BottomBarController>().update();
                    Get.offAll(DashBoardScreen());
                  }
                  else{
                    Get.back();
                    Get.back();
                    // Get.to(()=>CustomAdScreen());
                  }

                }else{Get.back();}
              },
            ),
          ).marginOnly(left: 16,right: 16,bottom: 35),
        ),
      ),
    );
  }

  Widget _buildPlayerTile(int index,
      GroupUser player,
      {bool isMadPardy = false}) {
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
                    text: player.gameExit==1?'Did Not Finish':'${player.percentage}% Correct',
                    style: TextStyle(
                        fontSize: 14, color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
          ),

          /*isMadPardy==false?Container(
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.yellowColor)
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text('${player.totalTimeTaken} sec',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ) : */Column(
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
                    Text('${player.totalTimeTaken} sec',
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


