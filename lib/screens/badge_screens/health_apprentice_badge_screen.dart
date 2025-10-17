
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class HealthApprenticeBadgeScreen extends StatefulWidget {
  const HealthApprenticeBadgeScreen({super.key});

  @override
  State<HealthApprenticeBadgeScreen> createState() => _HealthApprenticeBadgeScreenState();
}

class _HealthApprenticeBadgeScreenState extends State<HealthApprenticeBadgeScreen> {

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
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height,
            color: AppColors.primaryColor,
            child: null,
          ),

          SizedBox(
            width: double.infinity,
            child: Image.asset(
              AppAssets.notificationsBg,
              fit: BoxFit.cover,
            ),
          ),

          // if(result! > 60)
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              "assets/Lottie/party.gif",
              fit: BoxFit.fill,
              height: double.infinity,
            ),
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              addHeight(90),
              addText500(
                "New Badge!",
                fontSize: 16,
                color: Colors.white,
              ),


              addHeight(30),
              Image.asset(AppAssets.healthApprenticeBadge,height: 279,width: 294),

              Spacer(),
              addText400("Health\nApprentice ${AuthData().userModel?.firstName}",

                fontSize: 38,
                height: 43,
                color: Colors.white,
                textAlign: TextAlign.center,
                fontFamily: 'Caprasimo', // Use custom font if needed

              ),

              addHeight(30),
              Expanded(child: addText400(
                  textAlign: TextAlign.center,
                  "You’ve reached 5,000 HP, boosting your medical knowledge. Keep challenging yourself and unlock new achievements!",
                  color: Colors.white,fontSize: 16)),

              addHeight(110),

            ],
          ).marginSymmetric(horizontal: 20),
        ],
      ),
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeBottom: Platform.isIOS ? true : false,
        removeTop: true,
        child: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: AppButton(buttonText: 'Continue',
              onButtonTap: (){
            // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                Get.back();


              },
              buttonColor: AppColors.whiteColor,buttonTxtColor: AppColors.primaryColor),
        ).marginOnly(left: 16,right: 16,bottom: 35),
      ),
    );
  }
}
