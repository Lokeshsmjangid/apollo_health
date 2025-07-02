import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_column_animation.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';

import 'new_password_success_screen.dart';

class NewPasswordScreen extends StatefulWidget { const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));
  }



  bool obscureText = false;
  bool isButtonDisable = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // addHeight(52),
            // AppBar


            backBar(
              title: "New Password",
              backButtonColor: AppColors.blackColor,
              titleColor: AppColors.blackColor,
              onTap: () {
                Get.back();
              },
            ),
            Expanded(child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    addHeight(32),

                    Align(
                        alignment: Alignment.centerLeft,
                        child: addText500(
                            "Create a new password you haven’t used before.",
                            fontSize: 16, height: 22,color: AppColors.blackColor)),
                    addHeight(16),

                    Align(
                        alignment: Alignment.centerLeft,
                        child: addText500("Password",fontSize: 16,color: AppColors.textColor)).marginOnly(left: 12,bottom: 6),
                    CustomTextField(
                        hintText: 'Enter Password',
                        obscureText: obscureText,
                        controller: passController,
                        helperText: 'Use at least 8 characters with one uppercase letter, one number, and one special character.',
                        validator: (value) => validateField(field: 'password', value: passController.text),
                        onChanged: (val){
                          if(passController.text.isNotEmpty && confirmController.text.isNotEmpty){
                            isButtonDisable=false;
                          } else {
                            isButtonDisable=true;
                          }
                          setState(() {});
                        },
                        suffixIcon: GestureDetector(
                          onTap: (){
                            obscureText = !obscureText;
                            setState(() {});
                          },
                          child: obscureText
                              ? Image.asset(AppAssets.eyeIcon,height: 24,
                            width: 24,).marginAll(2)
                              : Image.asset(AppAssets.eyeOffIcon,height: 24,
                            width: 24,),
                        )),
                    addHeight(16),

                    Align(
                        alignment: Alignment.centerLeft,
                        child: addText500("Confirm Password",fontSize: 16,color: AppColors.textColor)).marginOnly(left: 12,bottom: 6),
                    CustomTextField(
                        hintText: 'Enter Password Again',
                        obscureText: obscureText,
                        controller: confirmController,
                        validator: (value) => validateField(
                            field: 'confirm password',
                            value: passController.text,
                            originalPassword: confirmController.text),
                        onChanged: (val){
                          if(passController.text.isNotEmpty && confirmController.text.isNotEmpty){
                            isButtonDisable=false;
                          } else {
                            isButtonDisable=true;
                          }
                          setState(() {});
                        },
                        suffixIcon: GestureDetector(
                          onTap: (){
                            obscureText = !obscureText;
                            setState(() {});
                          },
                          child: obscureText
                              ? Image.asset(AppAssets.eyeIcon,height: 24,
                            width: 24,).marginAll(2)
                              : Image.asset(AppAssets.eyeOffIcon,height: 24,
                              width: 24,),
                        )),
                    addHeight(30),
                    AppButton(
                      buttonText: 'Update Password',
                      buttonColor: isButtonDisable?AppColors.buttonDisableColor:AppColors.primaryColor,
                      onButtonTap: isButtonDisable?(){}:(){
                      // effectSound(sound: AppAssets.actionButtonTapSound);
                        if(formKey.currentState?.validate()??false) {
                          Get.offAllNamed(AppRoutes.newPasswordSuccessScreen);
                        }
                    },),



                    addHeight(40),




                  ],
                ),
              ),
            ))

          ],
        ).marginSymmetric(horizontal: 16),
      ),
    );
  }
}