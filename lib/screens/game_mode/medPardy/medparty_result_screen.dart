import 'package:apollo/resources/Apis/api_models/medpardy_models/medpardy_result_model.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:apollo/resources/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';

class MedpardyResultScreen extends StatefulWidget {
  List<MedpardyResult> userList;

  MedpardyResultScreen({super.key,this.userList = const[]});

  @override
  State<MedpardyResultScreen> createState() => _MedpardyResultScreenState();
}

class _MedpardyResultScreenState extends State<MedpardyResultScreen> {
  // final List<Player> userList = [
  //   Player(
  //     firstName: 'Virendra',
  //     lastName: 'Sharma',
  //     gameExit: 0,
  //     percentage: 90,
  //     totalXp: 1200,
  //     totalTimeTaken: 120,
  //   ),
  //   Player(
  //     firstName: 'Alina',
  //     lastName: 'Das',
  //     gameExit: 0,
  //     percentage: 85,
  //     totalXp: 1150,
  //     totalTimeTaken: 150,
  //   ),
  //   Player(
  //     firstName: 'Ravi',
  //     lastName: 'Kumar',
  //     gameExit: 1,
  //     percentage: 60,
  //     totalXp: 900,
  //     totalTimeTaken: 180,
  //   ),
  //   // Aur aise jitne players show karne hain add karen
  // ];

  final AudioPlayer _audioPlayer = AudioPlayer();


  @override
  void initState() {
    super.initState();
    _playConfettiSound(sound: AppAssets.confettiWave);
    _startPeriodicTimer();
  }

  Future<void> _playConfettiSound({required String sound}) async {
    // if(AuthData().musicONOFF) {
      await _audioPlayer.play(AssetSource(sound));
    // }
  }

  @override
  void dispose() {
    _timerNew?.cancel();
    _audioPlayer.dispose();
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
                            Get.toNamed(AppRoutes.howToLevelUpScreen)?.then((valuee){
                              _startPeriodicTimer();
                            });
                          },
                          child: addText500('Level up'.capitalize.toString(),
                              fontSize: 16, color: AppColors.whiteColor)),
                      const Spacer(),
                      GestureDetector(
                          onTap: (){

                            // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                            Share.share(
                                AuthData().userModel?.roleId==4?shareTextGuest:shareText                      );
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
                            Get.offAll(DashBoardScreen());
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

                  // const SizedBox(height: 12),
                  // addText500(
                  //   'Game Completed',
                  //   color: AppColors.whiteColor,
                  //   fontSize: 16,
                  // ),
                  const SizedBox(height: 8),
                  addText400(
                    // 'Congratulations!',
                      'All Results Are In!',
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
                      child: widget.userList.isEmpty? Center(child: addText500('No participants found'),):ListView(
                        padding: EdgeInsets.zero,
                        children: [

                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     addText500('Note:'),
                          //     Expanded(child: addText400(
                          //         'This code is static because the score calculation will be done according to the rules you have provided.\nThanks🙂',fontSize: 12))
                          //   ],
                          // ),

                          ...widget.userList.asMap().entries.map((entry) => _buildPlayerTile(entry.key, entry.value)),


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
                Get.offAll(DashBoardScreen());
              },
            ),
          ).marginOnly(left: 16,right: 16,bottom: 35),
        ),
      ),
    );
  }

  Widget _buildPlayerTile(int index, MedpardyResult player) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.shield,
                color: index + 1 == 1
                    ? AppColors.yellowColor
                    : index + 1 == 2
                    ? AppColors.buttonDisableColor
                    : index + 1 == 3
                    ? Color(0XFFC58219)
                    : Colors.transparent,
                size: 34,
              ),
              addText400('${index + 1}', fontSize: 14, fontFamily: 'Caprasimo'),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '${player.player}',
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                children: [
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: '${player.percentage}% Correct',
                    style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              addHeight(4),
              addText400(
                '${player.ernPoint}',
                fontSize: 16,
                fontFamily: 'Caprasimo',
                color: AppColors.primaryColor,
              ),
              addHeight(6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.yellowColor),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      '${player.totalTimeTakenSeconds} sec',
                      style: const TextStyle(fontSize: 10),
                    ),
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


class Player {
  final String firstName;
  final String lastName;
  final int gameExit;
  final int percentage;
  final int totalXp;
  final int totalTimeTaken;

  Player({
    required this.firstName,
    required this.lastName,
    required this.gameExit,
    required this.percentage,
    required this.totalXp,
    required this.totalTimeTaken,
  });
}
