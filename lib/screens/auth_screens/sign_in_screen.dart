import 'package:apollo/controllers/login_controller.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_column_animation.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/badge_screens/health_apprentice_badge_screen.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {



  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: GetBuilder<LoginController>(builder: (logic) {
          return Column(
            children: [
              // addHeight(52),
              // AppBar
              backBar(
                title: "Sign in",
                backButtonColor: AppColors.blackColor,
                titleColor: AppColors.blackColor,
                onTap: () {
                  Get.back();
                },
              ),
              // addHeight(32),
              addHeight(32),
              Expanded(child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // addHeight(20),


                      Align(
                          alignment: Alignment.centerLeft,
                          child: addText500("Email", fontSize: 16,
                              color: AppColors.textColor,
                              height: 22)).marginOnly(left: 12, bottom: 6),
                      CustomTextField(
                        hintText: 'Enter Email',
                        controller: logic.emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => validateField(field: 'email', value: logic.emailCtrl.text),
                        onChanged: (val){
                          if(logic.emailCtrl.text.isNotEmpty && logic.passCtrl.text.isNotEmpty){
                            logic.isButtonDisable=false;
                            logic.update();
                          } else {
                            logic.isButtonDisable=true;
                            logic.update();
                          }
                        },
                      ),
                      addHeight(20),

                      Align(
                          alignment: Alignment.centerLeft,
                          child: addText500("Password", fontSize: 16,
                              color: AppColors.textColor,
                              height: 22)).marginOnly(left: 12, bottom: 6),
                      CustomTextField(
                          hintText: 'Enter Password',
                          obscureText: logic.obscureText,
                          controller: logic.passCtrl,
                          helperText: 'Use at least 8 characters with one uppercase letter, one number, and one special character.',
                          validator: (value) => validateField(field: 'password', value: logic.passCtrl.text),
                          suffixIcon: GestureDetector(
                            onTap: logic.onTapSuffix,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                                height: !logic.obscureText?24:16,
                                width: !logic.obscureText?24:16,
                                child: Image.asset(
                                logic.obscureText?AppAssets.eyeIcon : AppAssets.eyeOffIcon)
                                ),
                          ),
                        onChanged: (val){
                            if(logic.emailCtrl.text.isNotEmpty && logic.passCtrl.text.isNotEmpty){
                              logic.isButtonDisable=false;
                              logic.update();
                            } else {
                              logic.isButtonDisable=true;
                              logic.update();
                            }
                        },

                      ),
                      addHeight(28),

                      Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(

                            onTap: () {
                              // effectSound(sound: AppAssets.actionButtonTapSound);
                              Get.toNamed(AppRoutes.forgotPasswordScreen);
                            },
                            child: addText500(
                                'Forgot password?', fontSize: 16,
                                height: 22,
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline),
                          )),

                      addHeight(28),
                      AppButton(
                          buttonText: 'Sign in',
                          buttonColor: logic.isButtonDisable?AppColors.buttonDisableColor:AppColors.primaryColor,
                          onButtonTap: logic.isButtonDisable?(){}:() {
                            if (formKey.currentState?.validate() ?? false) {
                              showLoader(true);

                              Future.delayed(Duration(seconds: 3), () {
                                showLoader(false);
                                Get.offAll(() => DashBoardScreen());
                                CustomSnackBar().showSnack(context,
                                    message: 'You’ve successfully logged in.');
                              });
                            }
                          }),
                      addHeight(20),


                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                  color: Color(0xffAAA4B3)
                              ),
                            ),
                          ),

                          addText400('or', fontSize: 12, color: Color(0xffAAA4B3))
                              .marginSymmetric(horizontal: 8),

                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                  color: Color(0xffAAA4B3)
                              ),
                            ),
                          ),
                        ],
                      ),
                      addHeight(20),


                      // Social Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {},
                              child: SvgPicture.asset(AppAssets.googleIcon)),
                          addWidth(24),
                          SvgPicture.asset(AppAssets.appleIcon),
                          addWidth(24),
                          SvgPicture.asset(AppAssets.facebookIcon),
                        ],
                      ),
                      addHeight(26),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          addText400('Don’t have an account? ', fontSize: 14),
                          GestureDetector(
                              onTap: () {
                                // effectSound(sound: AppAssets.actionButtonTapSound);
                                Get.toNamed(AppRoutes.createAccountScreen);
                              },
                              child: addText500('Sign up', fontSize: 16,
                                  color: AppColors.primaryColor,
                                  decoration: TextDecoration.underline))
                        ],
                      ),
                      addHeight(40),

                    ],
                  ),
                ),
              ))

            ],
          );
        }).marginSymmetric(horizontal: 16),
      ),
    );
  }
}