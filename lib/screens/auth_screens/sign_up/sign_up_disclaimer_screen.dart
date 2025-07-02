import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

/*
class SignUpDisclaimerScreen extends StatefulWidget {
  const SignUpDisclaimerScreen({super.key});

  @override
  State<SignUpDisclaimerScreen> createState() => _SignUpDisclaimerScreenState();
}

class _SignUpDisclaimerScreenState extends State<SignUpDisclaimerScreen> {

  bool isAcknowledge = false;
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
              child: Image.asset(AppAssets.disclaimerBg,fit: BoxFit.cover)),
          Column(
            children: [
              // addHeight(52),

              // AppBar
              backBar(
                title: "Disclaimer",
                backButtonColor: AppColors.blackColor,
                titleColor: AppColors.blackColor,
                onTap: () {
                  Get.back();
                },
              ),

              // image
              Lottie.asset('assets/Lottie/Apollo magic.json',
                  repeat: true, reverse: false, animate: true,
                  width: 300, height: 313
              ),

              addHeight(20),
              build_filled_box(),


              addHeight(16),
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      isAcknowledge = !isAcknowledge;
                      setState(() {});
                    },
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                        border: Border.all(color: isAcknowledge?AppColors.primaryColor:AppColors.blackColor,width: 1.5),
                        borderRadius: BorderRadius.circular(2)
                      ),
                      child: isAcknowledge?Center(
                        child: Image.asset(AppAssets.checkIcon).marginAll(3)
                      ):null,
                    ),
                  ),
                  addWidth(12),
                  addText600('I acknowledge and understand this disclaimer.',fontSize: 12,height: 21.12),

                ],
              ).marginSymmetric(horizontal: 16),


              addHeight(44),
              AppButton(buttonText: 'Start',
                buttonColor: isAcknowledge?AppColors.primaryColor:AppColors.buttonDisableColor,
                onButtonTap: (){
                  if(isAcknowledge){}

                },)
              
            ],
          ).marginSymmetric(horizontal: 16)


        ],

      ),
    );
  }

  Widget build_filled_box() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      decoration: BoxDecoration(color: AppColors.purpleLightColor,borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(AppAssets.bulbImg,height: 22,width: 16,),
          addWidth(18),
          Expanded(child: addText500(
              'This app is intended solely for educational and entertainment purposes. It is not a medical device, and does not provide medical advice, diagnosis, or treatment. If you have a medical condition or need medical advice, always check with a qualified healthcare professional.'
                  ,fontSize: 16,height: 22

          ))
          
        ],
      ),
    );

  }
}
*/


class SignUpDisclaimerScreen extends StatefulWidget {
  const SignUpDisclaimerScreen({super.key});

  @override
  State<SignUpDisclaimerScreen> createState() => _SignUpDisclaimerScreenState();
}

class _SignUpDisclaimerScreenState extends State<SignUpDisclaimerScreen> {
  bool isAcknowledge = false;
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
                    backBar(
                      title: "Disclaimer",
                      backButtonColor: AppColors.blackColor,
                      titleColor: AppColors.blackColor,
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
                    SizedBox(height: 44),
                    AppButton(
                      buttonText: 'Start',
                      buttonColor: isAcknowledge
                          ? AppColors.primaryColor
                          : AppColors.buttonDisableColor,
                      onButtonTap: () {
                        if (isAcknowledge) {
                          // effectSound(sound: AppAssets.actionButtonTapSound);
                          Get.offAll(()=>DashBoardScreen()); // or whatever the next route is
                        } else {
                          showToastError('"Please acknowledge the disclaimer first."');
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
