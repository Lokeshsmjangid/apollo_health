import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

import 'live_challenge_result_precentage.dart';

class LiveChallengeResultScreen extends StatefulWidget {
  double? result;
  LiveChallengeResultScreen({super.key,this.result=0});

  @override
  State<LiveChallengeResultScreen> createState() => _LiveChallengeResultScreenState();
}

class _LiveChallengeResultScreenState extends State<LiveChallengeResultScreen> {


  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Play audio if result > 60
    if (widget.result != null && widget.result! > 60) {
      _playConfettiSound(sound: AppAssets.confettiWave);
    }
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
      // Set to true so keyboard pushes up the form area
      resizeToAvoidBottomInset: true,
      // backgroundColor: AppColors.primaryColor,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Background color (fallback)
            Container(
              color: AppColors.primaryColor,
            ),

            // Background image 1
            Positioned.fill(
              child: Image.asset(
                AppAssets.splashScreenBgImg,
                fit: BoxFit.cover,
              ),
            ),

            // Background image 2 overlay
            Positioned.fill(
              child: Image.asset(
                'assets/Lottie/party.gif',
                fit: BoxFit.cover,
              ),
            ),

            // Main Content
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Top Bar
                  /*Row(
                    children: [
                      const Icon(Icons.add, color: Colors.white),
                      const SizedBox(width: 4),
                      addText500('Invite a friend', fontSize: 16,
                          height: 22,
                          color: AppColors.whiteColor),
                      const Spacer(),
                      GestureDetector(
                          onTap: (){
                            Share.share('Check out Apollo MedGames!');
                          },
                          child: Image.asset(AppAssets.shareIcon,height: 24,width: 24,)),
                      const SizedBox(width: 10),
                      GestureDetector(
                          onTap: (){
                            Get.to(()=>DashBoardScreen());
                          },
                          child: Image.asset(AppAssets.closeIcon,height: 24,width: 24,)),
                    ],
                  ).marginSymmetric(horizontal: 16),*/

                  const SizedBox(height: 8),
                  addText400(
                      'Congratulations!',
                      fontSize: 34,height: 40,
                      color: Colors.white,fontFamily: 'Caprasimo'
                  ),

                  const SizedBox(height: 10),

                  addText500(
                    'You are a winner of today\'s live challenge',
                    color: AppColors.whiteColor,
                    fontSize: 14,
                  ).marginSymmetric(horizontal: 24),

                  // Animation
                  Lottie.asset(
                      'assets/Lottie/Appolo dance.json',
                      repeat: true,
                      reverse: false,
                      animate: true,
                      width: 240,
                      height: 240
                  ).marginSymmetric(horizontal: 20),

                  // Player List & Buttons
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16,right: 16, top: 24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      // Make only this area scrollable!
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            // This ensures the scroll area expands if keyboard is open
                            // padding: EdgeInsets.only(
                            //   bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                            // ),
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: IntrinsicHeight(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    addText500(
                                      'Enter your contact information here to receive your prize',
                                      fontSize: 16,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    CustomTextField(hintText: 'Full Name'),
                                    addHeight(10),
                                    CustomTextField(hintText: 'Address'),
                                    addHeight(10),
                                    CustomTextField(
                                      keyboardType: TextInputType.number,
                                      hintText: 'Phone number',
                                    ),
                                    // This extra space ensures the last field is visible above keyboard
                                    const SizedBox(height: 40),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeBottom: Platform.isIOS ? true : false,
        removeTop: true,
        child: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: AppButton(
            onButtonTap: (){

              Get.off(()=>LiveChallengeResultPrecentageScreen(result: widget.result));
            },
            buttonText: 'Submit',
          ),
        ).marginOnly(left: 16,right: 16,bottom: 35),
      ),
    );
  }
}






/*

import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

import 'live_challenge_result_precentage.dart';

class LiveChallengeResultScreen extends StatefulWidget {
  double? result;
  LiveChallengeResultScreen({super.key,this.result=0});

  @override
  State<LiveChallengeResultScreen> createState() => _LiveChallengeResultScreenState();
}

class _LiveChallengeResultScreenState extends State<LiveChallengeResultScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryColor,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Background color (fallback)
            Container(
              color: AppColors.primaryColor,
            ),

            // Background image 1
            Positioned.fill(
              child: Image.asset(
                AppAssets.splashScreenBgImg,
                fit: BoxFit.cover,
              ),
            ),

            // Background image 2 overlay
            Positioned.fill(
              child: Image.asset(
                'assets/Lottie/party.gif',
                fit: BoxFit.cover,
              ),
            ),

            // Main Content
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // const SizedBox(height: 54),

                  // Top Bar
                  Row(
                    children: [
                      const Icon(Icons.add, color: Colors.white),
                      const SizedBox(width: 4),
                      addText500('Invite a friend', fontSize: 16,
                          height: 22,
                          color: AppColors.whiteColor),
                      const Spacer(),
                      GestureDetector(
                          onTap: (){
                            Share.share('Check out Apollo MedGames!');
                          },
                          child: Image.asset(AppAssets.shareIcon,height: 24,width: 24,)),
                      const SizedBox(width: 10),
                      GestureDetector(
                          onTap: (){
                            Get.to(()=>DashBoardScreen());
                          },
                          child: Image.asset(AppAssets.closeIcon,height: 24,width: 24,)),
                    ],
                  ).marginSymmetric(horizontal: 16),

                  const SizedBox(height: 8),
                  addText400(
                      'Congratulations!',

                      fontSize: 34,height: 40,
                      color: Colors.white,fontFamily: 'Caprasimo'
                  ),

                  const SizedBox(height: 10),

                  addText500(
                    'You are a winner of today\'s live challenge',
                    color: AppColors.whiteColor,
                    fontSize: 14,
                  ).marginSymmetric(horizontal: 24),

                  // const SizedBox(height: 20),

                  // Animation
                  Lottie.asset(
                      'assets/Lottie/Appolo dance.json',
                      repeat: true,
                      reverse: false,
                      animate: true,
                      width: 240,
                      height: 240
                  ).marginSymmetric(horizontal: 20),

                  // Player List & Buttons
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16,right: 16, top: 24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: ListView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom*0.98,
                        ),
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                        children: [
                          addText500('Enter your contact information here to receive your prize',fontSize: 16,textAlign: TextAlign.center),

                          const SizedBox(height: 20),

                          CustomTextField(hintText: 'Full Name'),
                          addHeight(10),

                          CustomTextField(hintText: 'Address'),
                          addHeight(10),

                          CustomTextField(
                              keyboardType: TextInputType.number,
                              hintText: 'Phone number'),
                          const SizedBox(height: 40),


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
        bottomNavigationBar: MediaQuery.removePadding(
          context: context,
          removeBottom: Platform.isIOS ? true : false,
          removeTop: true,
          child: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            child: AppButton(
                onButtonTap: (){
                  Get.off(()=>LiveChallengeResultPrecentageScreen(result: widget.result));
                },
                buttonText: 'Submit'),
          ).marginOnly(left: 16,right: 16,bottom: 35),
        )
    );
  }
}
*/
