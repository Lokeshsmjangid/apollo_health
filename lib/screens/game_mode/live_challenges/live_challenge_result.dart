import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/Apis/api_models/live_challenge_final_result.dart';
import 'package:apollo/resources/Apis/api_repository/live_challenge_submit_form_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'live_challenge_result_with_country_score.dart';

class LiveChallengeResultScreen extends StatefulWidget {
  List<LiveChallengeFinalResult>? resultData;
  LiveChallengeResultScreen({super.key,this.resultData = const[]});

  @override
  State<LiveChallengeResultScreen> createState() => _LiveChallengeResultScreenState();
}

class _LiveChallengeResultScreenState extends State<LiveChallengeResultScreen> {

  final TextEditingController nameController = TextEditingController(text: AuthData().userModel?.firstName??'');
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool get isButtonEnabled => nameController.text.trim().isNotEmpty && addressController.text.trim().isNotEmpty && phoneController.text.trim().isNotEmpty;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    nameController.addListener(_onTextChanged);
    addressController.addListener(_onTextChanged);
    phoneController.addListener(_onTextChanged);
  }

  Future<void> _playConfettiSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    nameController.removeListener(_onTextChanged);
    addressController.removeListener(_onTextChanged);
    phoneController.dispose();
    super.dispose();
  }
  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,

      body: SizedBox.expand(
        child: Stack(
          children: [
            Container(
              color: AppColors.primaryColor,
            ),


            Positioned.fill( // Background image 1
              child: Image.asset(
                AppAssets.splashScreenBgImg,
                fit: BoxFit.cover,
              ),
            ),


            Positioned.fill(  // Background image 2 overlay
              child: Image.asset(
                'assets/Lottie/party.gif',
                fit: BoxFit.cover,
              ),
            ),

            SafeArea(
              bottom: false,
              child: Column(
                children: [

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
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
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
                                    CustomTextField(
                                        hintText: 'Full Name',
                                      controller: nameController,

                                    ),
                                    addHeight(10),
                                    CustomTextField(
                                        hintText: 'Address',
                                      controller: addressController,
                                    ),
                                    addHeight(10),
                                    CustomTextField(
                                      keyboardType: TextInputType.number,
                                      hintText: 'Phone number',
                                      controller: phoneController,
                                    ),
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
            buttonColor: isButtonEnabled
                ? AppColors.primaryColor : AppColors.buttonDisableColor,
            onButtonTap: isButtonEnabled?(){

              showLoader(true);
              liveChallengeFormApi(
                  name: nameController.text,
                  address: addressController.text,
                  mobile: phoneController.text).then((winnerDetail){
                showLoader(false);
                if(winnerDetail.status==true){
                  Get.off(LivePlayResultWithScoreScreen(resultData: widget.resultData));
                }else if(winnerDetail.status==false){
                  CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${winnerDetail.message}');
                }
              });
            }:(){},
            buttonText: 'Submit',
          ),
        ).marginOnly(left: 16,right: 16,bottom: 35),
      ),
    );
  }
}