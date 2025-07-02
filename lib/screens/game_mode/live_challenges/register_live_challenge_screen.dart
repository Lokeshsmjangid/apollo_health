import 'package:apollo/bottom_sheets/live_challenge_register_bottom_sheet.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'flip_card.dart';

class RegisterLiveChallengeScreen extends StatefulWidget {
  const RegisterLiveChallengeScreen({super.key});

  @override
  State<RegisterLiveChallengeScreen> createState() => _RegisterLiveChallengeScreenState();
}

class _RegisterLiveChallengeScreenState extends State<RegisterLiveChallengeScreen> {

  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> effectSound({required String sound}) async {
    await audioPlayer.play(AssetSource(sound));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor, // Purple background
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              AppAssets.liveChBg,
              fit: BoxFit.cover,
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 54),

              // Top Bar
              backBar(
                title: "Live Challenge",
                onTap: () {
                  Get.back();
                },
              ).marginSymmetric(horizontal: 16),
              // addHeight(10),


              // Emoji/Character
              Lottie.asset(
                  'assets/Lottie/Appolo stetoskope.json',
                  repeat: true,
                  reverse: false,
                  animate: true,
                  width: 230,
                  height: 241
              ),
              // White Box with Players
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16,right: 16, top: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: addText500('Reserve Your Spot to',fontSize: 16,color: AppColors.blackColor,height: 22)),
                      // addHeight(4),

                      Align(
                          alignment: Alignment.center,
                          child: addText400('Win a Cash Prize!',fontSize: 32,height: 40,color: AppColors.primaryColor,fontFamily: 'Caprasimo')),
                      addHeight(27),
                      buildUserInfo(
                          prize: 'US \$2,000',
                          date: 'December 01, 2025',
                          username: 'Madelyn Dias',
                          time: '8:00 PM EST (GMT-5)',
                      ),
                      addHeight(38),

                      // Play Again Button
                      AppButton(
                          buttonText: 'Register with Tokens (1,000 HP)',
                      onButtonTap: (){
                        // effectSound(sound: AppAssets.actionButtonTapSound);
                        showLiveChallengeRegisterSheet(context);
                      },
                      ),

                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1.5,
                              decoration: BoxDecoration(
                                  color: Color(0xffAAA4B3)
                              ),
                            ),
                          ),

                          addText400('or',fontSize: 12,color: Color(0xffAAA4B3)).marginSymmetric(horizontal: 12),

                          Expanded(
                            child: Container(
                              height: 1.5,
                              decoration: BoxDecoration(
                                  color: Color(0xffAAA4B3)
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      AppButton(
                        onButtonTap: (){
                          // effectSound(sound: AppAssets.actionButtonTapSound);
                          Get.toNamed(AppRoutes.liveChallengeQuizScreen);
                          // Get.to(QuizScreen());
                        },
                          buttonColor: AppColors.purpleLightColor,
                          buttonTxtColor: AppColors.primaryColor,
                          buttonText: 'Secure your spot for \$0.99.'),
                      const SizedBox(height: 10),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          addText500('Apollo Premium Member? ',fontSize: 16,height: 22),
                          addText500('Join Free',fontSize: 16,decoration:TextDecoration.underline,height: 22,color: AppColors.primaryColor)

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildUserInfo({
    required String username,
    required String date,
    required String time,
    required String prize,
  }) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Labels
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addText500("User Name:", fontSize: 16, color: AppColors.primaryColor,height: 22),
              SizedBox(height: 8),
              addText500("Date:", fontSize: 16, color: AppColors.primaryColor,height: 22),
              SizedBox(height: 8),
              addText500("Time:", fontSize: 16, color: AppColors.primaryColor,height: 22),
              SizedBox(height: 8),
              addText500("Prize Money:", fontSize: 16, color: AppColors.primaryColor,height: 22),
            ],
          ),
          const SizedBox(width: 39),
          // Values
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addText500(username, fontSize: 16, color: AppColors.blackColor,height: 22),
              const SizedBox(height: 8),
              addText500(date, fontSize: 16, color: AppColors.blackColor,height: 22),
              const SizedBox(height: 8),
              addText500(time, fontSize: 16, color: AppColors.blackColor,height: 22),
              const SizedBox(height: 8),
              addText500(prize, fontSize: 16, color: AppColors.blackColor,height: 22),
            ],
          ),
        ],
      ),
    );
  }
}
