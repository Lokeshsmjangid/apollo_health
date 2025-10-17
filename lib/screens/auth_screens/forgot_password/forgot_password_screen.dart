import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/Apis/api_repository/forgot_password_repo.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));}

  bool obscureText = false;
  bool isButtonDisable = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

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
              title: "Forgot Password",
              backButtonColor: AppColors.blackColor,
              titleColor: AppColors.blackColor,
              onTap: () {
                Get.back();
              },
            ),
            Expanded(child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    addHeight(32),

                    Align(
                        alignment: Alignment.centerLeft,
                        child: addText500("Please enter your linked email to reset the password.",height: 22,fontSize: 16,color: AppColors.blackColor)),
                    addHeight(16),


                    Align(
                        alignment: Alignment.centerLeft,
                        child: addText500("Email",fontSize: 16,color: AppColors.textColor,height: 22)).marginOnly(left: 12,bottom: 6),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Enter Email',
                      validator: (value)=> validateField(field: 'email', value: emailController.text),
                      onChanged: (val){
                        if(emailController.text.isNotEmpty){
                          isButtonDisable=false;
                        }else{
                          isButtonDisable=true;
                        }
                        setState(() {});
                      },
                    ),
                  addHeight(170),

                    AppButton(
                        buttonText: 'Reset Password',
                      buttonColor: isButtonDisable?AppColors.buttonDisableColor:AppColors.primaryColor,
                      onButtonTap: isButtonDisable?(){}:(){
                          if(formKey.currentState?.validate()??false){
                            showLoader(true);
                            forgotPasswordApi(email: emailController.text).then((value){
                              showLoader(false);
                              if(value.status==true){
                                CustomSnackBar().showSnack(Get.context!,message: '${value.message}');
                                Get.toNamed(AppRoutes.forgotPasswordOtpScreen,
                                    arguments: {'email':emailController.text,
                                      'password_reset_token':value.data?.passwordResetToken,
                                      'otp':value.data?.otp.toString(),

                                    });
                              }else if(value.status==false){
                                CustomSnackBar().showSnack(Get.context!,message: '${value.message}',isSuccess: false);
                              }
                            });



                          }
                      },
                    ),

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
