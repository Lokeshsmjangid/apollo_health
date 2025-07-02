import 'package:apollo/bottom_sheets/live_challenge_register_bottom_sheet.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'live_challenge_result.dart';

class TimerLiveChallengeScreen extends StatefulWidget {
  const TimerLiveChallengeScreen({super.key});

  @override
  State<TimerLiveChallengeScreen> createState() => _TimerLiveChallengeScreenState();
}

class _TimerLiveChallengeScreenState extends State<TimerLiveChallengeScreen> {

  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

    await audioPlayer.play(AssetSource(sound));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor, // Purple background
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,

        title:  addText400(
          "Live Challenge",
          fontSize: 32,
          height: 40,
          color: AppColors.whiteColor,
          fontFamily: 'Caprasimo',

        ),
      actions: [
        IconButton(onPressed: (){
          // effectSound(sound: AppAssets.actionButtonTapSound);
          Get.to(()=>DashBoardScreen());
        }, icon: Image.asset(AppAssets.closeIcon,height: 24))
      ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage( AppAssets.liveChBg,), fit: BoxFit.cover)
        ),
        child: Stack(
          // clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Image.asset(
                AppAssets.liveChBg,
                fit: BoxFit.cover,
              ),
            ),

            SafeArea(
              bottom: false,
              child: Column(
                children: [

                  // Emoji/Character
                  GestureDetector(
                    onTap: (){
                      // Get.to(()=>LiveChallengeResultScreen());
                    },
                    child: Lottie.asset(
                        'assets/Lottie/Appolo stetoskope.json',
                        repeat: true,
                        reverse: false,
                        animate: true,
                        width: 230,
                        height: 241
                    ),
                  ),
                  // White Box with Players
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 40,right: 40, top: 32),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: BouncingScrollPhysics(),
                        children: [


                          Align(
                              alignment: Alignment.center,
                              child: addText400(
                                  'You Have Registered!',fontSize: 32,height: 40,
                                  textAlign: TextAlign.center,
                                  color: AppColors.primaryColor,fontFamily: 'Caprasimo')),
                          addHeight(24),
                          Align(
                              alignment: Alignment.center,
                              child: addText500(
                                  'The event will occur on \nDecember 01, 2025 at 8:00 PM EST (GMT-5).',fontSize: 16,color: AppColors.blackColor,
                                  textAlign: TextAlign.center,height: 22
                              )).marginSymmetric(horizontal: 20),

                          addHeight(30),
                          Align(
                              alignment: Alignment.center,
                              child: addText700(
                                  'Time left until event:',fontSize: 24,color: AppColors.blackColor,
                                  textAlign: TextAlign.center,height: 1.4
                              )).marginSymmetric(horizontal: 20),


                          addHeight(24),
                          buildCountdownTimer(
                            days: 1,
                            hours: 6,
                            minutes: 15,
                          ),
                          addHeight(30)

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCountdownTimer({
    required int days,
    required int hours,
    required int minutes,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _timeBox(value: days, label: "Days"),
            const SizedBox(width: 35),
            _timeBox(value: hours, label: "Hours"),
            const SizedBox(width: 35),
            _timeBox(value: minutes, label: "Min"),
          ],
        ),
      ],
    );
  }

  Widget _timeBox({required int value, required String label}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.yellowColor,
            border: Border.all(color: AppColors.brownColor, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: addText400(
            value.toString().padLeft(2, '0'),

              fontSize: 32,
              height: 40,
              fontFamily: 'Caprasimo',
              color: AppColors.blackColor,

          ),
        ),
        const SizedBox(height: 4),
        addText400(
          label,
            fontSize: 12,
            color: AppColors.blackColor,

        ),
      ],
    );
  }
}
