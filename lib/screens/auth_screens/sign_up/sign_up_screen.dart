import 'package:apollo/controllers/sign_up_controller.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_column_animation.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: GetBuilder<SignUpCtrl>(builder: (logic) {
          return Column(
            children: [
              // addHeight(52),

              backBar(
                title: "Create an Account",
                backButtonColor: AppColors.blackColor,
                titleColor: AppColors.blackColor,
                onTap: () {
                  Get.back();
                },
              ),
              Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          addHeight(32),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: addText500("Email", fontSize: 16,
                                  color: AppColors.textColor)).marginOnly(
                              left: 12, bottom: 6),
                          CustomTextField(
                            controller: logic.emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => validateField(field: 'email', value: logic.emailCtrl.text),
                            hintText: 'Enter Email',
                            onChanged: (val){
                              if(logic.emailCtrl.text.isNotEmpty && logic.passCtrl.text.isNotEmpty && logic.confPassCtrl.text.isNotEmpty){
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
                                  color: AppColors.textColor)).marginOnly(
                              left: 12, bottom: 6),
                          CustomTextField(
                              hintText: 'Enter Password',
                              obscureText: logic.obscurePass,
                              controller: logic.passCtrl,
                              helperText: "Use at least 8 characters with one uppercase letter, one number, and one special character.",
                              validator: (value) => validateField(field: 'password', value: logic.passCtrl.text),
                              onChanged: (val){
                              if(logic.emailCtrl.text.isNotEmpty && logic.passCtrl.text.isNotEmpty && logic.confPassCtrl.text.isNotEmpty){
                                logic.isButtonDisable=false;
                                logic.update();
                              } else {
                                logic.isButtonDisable=true;
                                logic.update();
                              }
                            },
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  logic.onTapSuffix(isPass: true);
                                },
                                child: Container(
                                    height: !logic.obscurePass?24:16,
                                    width: !logic.obscurePass?24:16,
                                    child: Image.asset(logic.obscurePass?AppAssets.eyeIcon:AppAssets.eyeOffIcon))

                              ),

                          ),
                          addHeight(20),

                          Align(
                              alignment: Alignment.centerLeft,
                              child: addText500(
                                  "Confirm Password", fontSize: 16,
                                  color: AppColors.textColor)).marginOnly(
                              left: 12, bottom: 6),
                          CustomTextField(
                              hintText: 'Enter Password Again',
                              obscureText: logic.obscureCPass,
                              controller: logic.confPassCtrl,
                              validator: (value) => validateField(field: 'Confirm Password', value: logic.passCtrl.text,originalPassword: logic.confPassCtrl.text),
                              onChanged: (val){
                                if(logic.emailCtrl.text.isNotEmpty && logic.passCtrl.text.isNotEmpty && logic.confPassCtrl.text.isNotEmpty){
                                  logic.isButtonDisable=false;
                                  logic.update();
                                } else {
                                  logic.isButtonDisable=true;
                                  logic.update();
                                }
                              },
                              suffixIcon: GestureDetector(
                                  onTap: (){
                                    logic.onTapSuffix(isPass: false);
                                  },
                                  child: Container(
                                      height: !logic.obscureCPass?24:16,
                                      width: !logic.obscureCPass?24:16,
                                      child: Image.asset(
                                          logic.obscureCPass?AppAssets.eyeIcon:AppAssets.eyeOffIcon))

                              )),


                          addHeight(84),


                          AppButton(
                            buttonText: 'Sign up',
                            buttonColor: logic.isButtonDisable?AppColors.buttonDisableColor:AppColors.primaryColor,
                            onButtonTap: logic.isButtonDisable
                                ? (){} :
                                () {// effectSound(sound: AppAssets.actionButtonTapSound);

                              if(formKey.currentState?.validate()??false) {
                                showLoader(true);

                                Future.delayed(Duration(seconds: 3),(){
                                  showLoader(false);
                                  Get.toNamed(AppRoutes.signUpPersonalInfoScreen,arguments: {
                                    'email':logic.emailCtrl.text,
                                    'password':logic.confPassCtrl.text,
                                  });});

                              }}),

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
                              addText400(
                                  'or', fontSize: 12, color: Color(0xffAAA4B3))
                                  .marginSymmetric(horizontal: 12),

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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppAssets.googleIcon),
                              addWidth(24),
                              SvgPicture.asset(AppAssets.appleIcon),
                              addWidth(24),
                              SvgPicture.asset(AppAssets.facebookIcon),
                            ],
                          ),
                          addHeight(24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              addText400('Have an account? ', fontSize: 14),
                              GestureDetector(
                                  onTap: () {
                                    // effectSound(sound: AppAssets.actionButtonTapSound);
                                    Get.toNamed(AppRoutes.signInScreen);
                                  },
                                  child: addText500('Sign in', fontSize: 16,
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
