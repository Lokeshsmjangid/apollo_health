import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/Apis/api_repository/update_password_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPasswordScreen extends StatefulWidget {
  String? rpToken;
   NewPasswordScreen({super.key,this.rpToken});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));
  }

  bool obscureText = true;
  bool obscureConText = true;
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
                          child: SizedBox(
                              height: obscureText?24:16,
                              width:  obscureText?24:16,
                              child: Image.asset(
                                  !obscureText?AppAssets.eyeIcon:AppAssets.eyeOffIcon))
                        )),
                    addHeight(16),

                    Align(
                        alignment: Alignment.centerLeft,
                        child: addText500("Confirm Password",fontSize: 16,color: AppColors.textColor)).marginOnly(left: 12,bottom: 6),
                    CustomTextField(
                        hintText: 'Enter Password Again',
                        obscureText: obscureConText,
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
                            obscureConText = !obscureConText;
                            setState(() {});
                          },
                          child: SizedBox(
                              height: obscureConText?24:16,
                              width:  obscureConText?24:16,
                              child: Image.asset(
                                  !obscureConText?AppAssets.eyeIcon:AppAssets.eyeOffIcon)),
                        )),
                    addHeight(30),
                    AppButton(
                      buttonText: 'Update Password',
                      buttonColor: isButtonDisable?AppColors.buttonDisableColor:AppColors.primaryColor,
                      onButtonTap: isButtonDisable?(){}:(){
                      // effectSound(sound: AppAssets.actionButtonTapSound);
                        if(formKey.currentState?.validate()??false) {
                          showLoader(true);
                          updatePasswordApi( rpToken: widget.rpToken,password: confirmController.text).then((value){
                            showLoader(false);
                            if(value.status==true){
                              CustomSnackBar().showSnack(Get.context!,isSuccess: true,message: '${value.message}');
                              Get.offAllNamed(AppRoutes.newPasswordSuccessScreen);
                            } else if(value.status==false){
                              CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${value.message}');
                            }
                          });

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