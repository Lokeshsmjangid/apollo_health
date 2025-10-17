import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

/*
class NewPasswordSuccessScreen extends StatefulWidget {
  const NewPasswordSuccessScreen({super.key});

  @override
  State<NewPasswordSuccessScreen> createState() => _NewPasswordSuccessScreenState();
}

class _NewPasswordSuccessScreenState extends State<NewPasswordSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height,
              child: Image.asset(AppAssets.successNPBg,fit: BoxFit.cover,)),
          Positioned(
              top: 130,
              right: 12,
              left: 12,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  addHeight(30),
                  Lottie.asset('assets/Lottie/Appolo dance.json',
                      repeat: true, reverse: false, animate: true,
                      width: 308, height: 322
                  ),

                  addHeight(24),
                  addText400('Success!',fontSize: 38,height: 43,fontFamily: 'Caprasimo'),

                  addHeight(16),
                  addText500('Your password has been changed.',textAlign: TextAlign.center,fontSize: 16,height: 22).marginSymmetric(horizontal: 12),



                ],
              )
          )

        ],
      ),
      bottomSheet: Container(
        height: 90,
        decoration: BoxDecoration(
          color: AppColors.whiteColor
        ),
        width: double.infinity,
        child: AppButton(buttonText: 'Sign in',onButtonTap: (){
          Get.offAllNamed(AppRoutes.signInScreen);
        },).marginOnly(left: 16,right: 16,bottom: 34),
      ),
    );
  }
}
*/


class NewPasswordSuccessScreen extends StatefulWidget {
  const NewPasswordSuccessScreen({super.key});

  @override
  State<NewPasswordSuccessScreen> createState() => _NewPasswordSuccessScreenState();
}

class _NewPasswordSuccessScreenState extends State<NewPasswordSuccessScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

    await _audioPlayer.play(AssetSource(sound));

  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: width,
            child: Image.asset(
              AppAssets.successNPBg,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              // padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: BouncingScrollPhysics(),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Lottie.asset(
                    'assets/Lottie/Appolo dance.json',
                    repeat: true,
                    animate: true,
                    width: width * 0.8,
                    height: height * 0.35,
                  ),
                  SizedBox(height: 24),
                  addText400(
                    'Success!',
                    fontSize: 38,
                    height: 43,
                    fontFamily: 'Caprasimo',
                  ),
                  SizedBox(height: 16),
                  addText500(
                    'Your password has been changed.',
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    height: 22,
                  ).marginSymmetric(horizontal: 12),
                  SizedBox(height: 100), // space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: AppButton(
            buttonText: 'Sign in',
            onButtonTap: () {
              // effectSound(sound: AppAssets.actionButtonTapSound);
              Get.offAllNamed(AppRoutes.signInScreen);
            },
          ),
        ),
      ),
    );
  }
}
