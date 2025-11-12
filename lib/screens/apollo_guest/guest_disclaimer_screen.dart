import 'dart:convert';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_repository/guest_login_repo.dart';
import 'package:apollo/resources/Apis/api_repository/register_disclaimer_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/cms_pages/cms_page_webview.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:app_set_id/app_set_id.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class GuestDisclaimerScreen extends StatefulWidget {
  String institutionalCode;

  GuestDisclaimerScreen({super.key,required this.institutionalCode});

  @override
  State<GuestDisclaimerScreen> createState() => _GuestDisclaimerScreenState();
}

class _GuestDisclaimerScreenState extends State<GuestDisclaimerScreen> {
  bool isAcknowledge = false;
  bool isTp = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {await _audioPlayer.play(AssetSource(sound));}

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.disclaimerBg,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(GetPlatform.isAndroid)
                      addHeight(16),
                    backBar(
                      title: "Disclaimer",
                      backButtonColor: AppColors.blackColor,
                      titleColor: AppColors.blackColor,
                      trailing: true,
                      isBack: true,
                      onTap: () => Get.back(),
                    ),
                    SizedBox(height: 12),
                    Lottie.asset(
                      'assets/Lottie/Apollo magic.json',
                      repeat: true,
                      animate: true,
                      width: width * 0.8,
                      height: height * 0.3,
                    ),
                    SizedBox(height: 20),
                    buildFilledBox(),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            isAcknowledge = !isAcknowledge;
                            setState(() {});
                          },
                          child: Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: isAcknowledge
                                      ? AppColors.primaryColor
                                      : AppColors.blackColor,
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: isAcknowledge
                                ? Center(
                              child:
                              Image.asset(AppAssets.checkIcon).marginAll(3),
                            )
                                : null,
                          ),
                        ),
                        addWidth(12),
                        Expanded(
                          child: addText600(
                            'I acknowledge and understand this disclaimer.',
                            fontSize: 12,
                            height: 21.12,
                          ),
                        ),
                      ],
                    ).marginSymmetric(horizontal: 12),
                    addHeight(2),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            isTp = !isTp;
                            setState(() {});
                          },
                          child: Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: isTp
                                      ? AppColors.primaryColor
                                      : AppColors.blackColor,
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: isTp
                                ? Center(
                              child:
                              Image.asset(AppAssets.checkIcon).marginAll(3),
                            )
                                : null,
                          ),
                        ),
                        addWidth(12),
                        Expanded(
                          child: Row(
                            children: [
                              addText600(
                                'I accept the ',
                                fontSize: 12,
                                height: 21.12,
                              ),

                              GestureDetector(
                                onTap: (){
                                  Get.to(()=>CmsView(page: 'terms'));
                                },
                                child: addText600(
                                  'Terms',
                                  fontSize: 12,
                                  height: 21.12,
                                  color: AppColors.primaryColor,
                                  decoration: TextDecoration.underline
                                ),
                              ),
                              addText600(
                                ' and ',
                                fontSize: 12,
                                height: 21.12,
                              ),

                              GestureDetector(
                                onTap: (){
                                  Get.to(()=>CmsView(page: 'privacy'));
                                },
                                child: addText600(
                                  'Privacy Policy',
                                  fontSize: 12,
                                  height: 21.12,
                                  color: AppColors.primaryColor,
                                  decoration: TextDecoration.underline
                                ),
                              ),
                              addText600('.',
                                fontSize: 12,
                                height: 21.12,
                              ),
                            ],
                          ),
                        )
                      ],
                    ).marginSymmetric(horizontal: 12),
                    SizedBox(height: 44),

                    AppButton(
                      buttonText: 'Start',
                      buttonColor: isAcknowledge && isTp
                          ? AppColors.primaryColor
                          : AppColors.buttonDisableColor,
                      onButtonTap: () async{
                        if (isAcknowledge && isTp) {
                          String? deviceToken = await FirebaseMessaging.instance.getToken();
                          deviceToken ??= await FirebaseMessaging.instance.getToken();
                          String? guestId = await AppSetId().getIdentifier();

                          apolloPrint(message: 'fcmToken::-> $deviceToken');
                          apolloPrint(message: 'guestId::-> $guestId');
                          apolloPrint(message: 'guestId::-> ${widget.institutionalCode}');


                          showLoader(true);
                          guestLoginApi(mapData: {
                            "code": widget.institutionalCode,
                            "device_token": deviceToken,
                            "user_unique_token": guestId,
                            "disclaimer_status": isAcknowledge==true?1:0,
                            "term_and_privacy": isTp==true?1:0
                          }).then((value){
                            showLoader(false);
                            if(value.status==true){
                              LocalStorage().setValue(LocalStorage.USER_TOKEN, value.token.toString());
                              LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                              LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
                              AuthData().getLoginData();
                              Get.offAll(()=>DashBoardScreen());
                              CustomSnackBar().showSnack(Get.context!, message: 'Welcome! You’ve successfully logged in as a guest. Enjoy exploring the app.');}
                          });

                        } else {
                          // showToastError('"Please acknowledge the disclaimer first."');
                          CustomSnackBar().showSnack(
                              context,
                              isSuccess: false,
                              message: 'Please acknowledge the disclaimer and accept the Terms and Privacy Policy first.');
                        }
                      },
                    ),
                    SizedBox(height: 30), // space for keyboard-safe bottom padding
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilledBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purpleLightColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AppAssets.bulbImg,
            height: 22,
            width: 16,
          ),
          addWidth(18),
          Expanded(
            child: addText500(
              'This app is intended solely for educational and entertainment purposes. It is not a medical device, and does not provide medical advice, diagnosis, or treatment. If you have a medical condition or need medical advice, always check with a qualified healthcare professional.',
              fontSize: 16,
              height: 22,
            ),
          ),
        ],
      ),
    );
  }
}
