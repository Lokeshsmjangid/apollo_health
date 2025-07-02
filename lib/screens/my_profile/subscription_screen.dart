import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/level_up_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

    await _audioPlayer.play(AssetSource(sound));

  }

  final features = [
    ["Daily Quizzes", true, true],
    ["Prize-Winning Live Challenges", true, true],
    ["Daily Dose", true, true],
    ["Group Play Mode", true, true],
    ["Category Access", "Up to 5", "30+"],
    ["Questions per Quiz", "5", "5 or 10"],
    ["Wheel of Wellness", false, true],
    ["Medpardy Mode", false, true],
    ["Ad-Free Experience", false, true],
  ];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFF7B3EFF),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.notificationsBg,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // addHeight(52),

                backBar(
                  title: "Subscription",
                  onTap: () {
                    Get.back();
                  },
                ).marginSymmetric(horizontal: 16),
                addHeight(44),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            // Add your asset here
                            const SizedBox(height: 48),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        addText400("Features", fontFamily: 'Caprasimo',fontSize: 20,height: 22),
                                        addText500("",fontSize: 12,color: Color(0xff67656B)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        addText400("Starter", fontFamily: 'Caprasimo',fontSize: 20,height: 22,color: AppColors.primaryColor),
                                        addText500("Always Free",fontSize: 12,color: Color(0xff67656B)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            addText400("Premium", fontFamily: 'Caprasimo',height: 22,fontSize: 20,color: AppColors.primaryColor),
                                         
                                            Positioned(
                                                right: -10,
                                                child: Image.asset(
                                              AppAssets.premiumProfileIcon, height: 11,width: 11))
                                          ],
                                        ),
                                        addText500("\$5.99/month",fontSize: 12,color: Color(0xff67656B)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            addHeight(8),
                            const Divider(thickness: 1, color: AppColors.bottomSheetBGColor, height: 0).marginSymmetric(horizontal: 16),

                            addHeight(24),
                            Expanded(
                              child: ListView.builder(
                                itemCount: features.length,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, index) {
                                  final feature = features[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(child: addText400(feature[0] as String, fontSize: 14,height: 18)),
                                        Expanded(child: _buildFeatureIcon(feature[1])),
                                        Expanded(child: _buildFeatureIcon(feature[2])),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            // AppButton(
                            //   buttonText: 'Start Free 7-Day Trial',
                            // onButtonTap: (){},
                            //
                            //
                            // ).marginSymmetric(horizontal: 16),
                            // addHeight(36),
                          ],
                        ),
                      ),

                      Positioned(
                        top: -50,

                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Lottie.asset(
                                'assets/Lottie/Appolo strength.json',
                                repeat: true,
                                reverse: false,
                                animate: true,
                                width: 100,
                                height: 100
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeBottom: Platform.isIOS?true:false,
        removeTop: true,
        child: BottomAppBar(
          // color: AppColors.redColor,
          child: AppButton(
            buttonText: 'Start  7-Day Free Trial',
            onButtonTap: (){
              // effectSound(sound: AppAssets.actionButtonTapSound);
            },


          ).marginOnly(
              left: 16,right: 16,
              bottom: 32),
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(dynamic value) {
    if (value == true) {
      return Image.asset(AppAssets.starIcon,height: 20,);
    } else if (value == false) {
      return Icon(Icons.close, color: AppColors.purpleLightColor);
    } else {
      return Center(child: addText600(value.toString(),fontSize: 12,height: 21.12));
    }
  }
}
