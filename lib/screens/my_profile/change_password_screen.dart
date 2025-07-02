import 'package:apollo/controllers/change_password_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_column_animation.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
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

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {


  final formKey = GlobalKey<FormState>();
  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> effectSound({required String sound}) async {
    await audioPlayer.play(AssetSource(sound));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SizedBox.expand(
          child: GetBuilder<ChangePasswordCtrl>(builder: (logic) {
            return Column(
              children: [
                // addHeight(52),
                // AppBar


                backBar(
                  title: "Change Password",
                  backButtonColor: AppColors.blackColor,
                  titleColor: AppColors.blackColor,
                  onTap: () {
                    Get.back();
                  },
                ),
                Expanded(
                    child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: IntrinsicHeight(
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .stretch,
                                    children: [
                                      addHeight(32),

                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: addText500(
                                              "Please enter a new password—make sure it's different from your previous passwords.",
                                              fontSize: 16,
                                              height: 22,
                                              color: AppColors.blackColor)),
                                      addHeight(16),

                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: addText500(
                                              "Old Password", fontSize: 16,
                                              color: AppColors.textColor))
                                          .marginOnly(
                                          left: 12, bottom: 6),
                                      CustomTextField(
                                          hintText: 'Enter Old Password',
                                          obscureText: logic.obscureOldPass,
                                          controller: logic.oldPassCtrl,
                                          validator: (value) => validateField(field: 'old password', value: logic.oldPassCtrl.text),
                                          onChanged: (val){
                                            if(logic.oldPassCtrl.text.isNotEmpty && logic.newPassCtrl.text.isNotEmpty && logic.confPassCtrl.text.isNotEmpty){
                                              logic.isButtonDisable=false;
                                              logic.update();
                                            } else {
                                              logic.isButtonDisable=true;
                                              logic.update();
                                            }
                                          },
                                          suffixIcon: GestureDetector(
                                              onTap: () {
                                                logic.obscureOldPass = !logic.obscureOldPass;
                                                logic.update();
                                              },
                                              child: Container(
                                                height: !logic.obscureOldPass
                                                    ? 24
                                                    : 16,
                                                width: !logic.obscureOldPass
                                                    ? 24
                                                    : 16,
                                                child: Image.asset(
                                                    logic.obscureOldPass ? AppAssets
                                                        .eyeIcon : AppAssets
                                                        .eyeOffIcon),
                                              )

                                          )),
                                      addHeight(16),

                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: addText500(
                                              "New Password", fontSize: 16,
                                              color: AppColors.textColor))
                                          .marginOnly(
                                          left: 12, bottom: 6),
                                      CustomTextField(
                                          hintText: 'Enter New Password',
                                          obscureText: logic.obscureNewPass,
                                          controller: logic.newPassCtrl,
                                          helperText: "Use at least 8 characters with one uppercase letter, one number, and one special character.",
                                          validator: (value) => validateField(field: 'new password', value: logic.newPassCtrl.text),
                                          onChanged: (val){
                                            if(logic.oldPassCtrl.text.isNotEmpty && logic.newPassCtrl.text.isNotEmpty && logic.confPassCtrl.text.isNotEmpty){
                                              logic.isButtonDisable=false;
                                              logic.update();
                                            } else {
                                              logic.isButtonDisable=true;
                                              logic.update();
                                            }
                                          },
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              logic.obscureNewPass = !logic.obscureNewPass;
                                              logic.update();
                                            },
                                            child: SizedBox(
                                              height: !logic.obscureNewPass ? 24 : 16,
                                              width: !logic.obscureNewPass ? 24 : 16,
                                              child: Image.asset(
                                                  logic.obscureNewPass ? AppAssets
                                                      .eyeIcon : AppAssets
                                                      .eyeOffIcon),
                                            ),
                                          )),
                                      addHeight(16),

                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: addText500(
                                              "Confirm Password", fontSize: 16,
                                              color: AppColors.textColor))
                                          .marginOnly(
                                          left: 12, bottom: 6),
                                      CustomTextField(
                                          hintText: 'Enter Password Again',
                                          obscureText: logic.obscureConfPass,
                                          controller: logic.confPassCtrl,
                                          validator: (value) => validateField(field: 'confirm password', value: logic.newPassCtrl.text,originalPassword: logic.confPassCtrl.text),
                                          onChanged: (val){
                                            if(logic.oldPassCtrl.text.isNotEmpty && logic.newPassCtrl.text.isNotEmpty && logic.confPassCtrl.text.isNotEmpty){
                                              logic.isButtonDisable=false;
                                              logic.update();
                                            }
                                            else {
                                              logic.isButtonDisable=true;
                                              logic.update();
                                            }
                                          },
                                          suffixIcon: GestureDetector(
                                              onTap: () {
                                                logic.obscureConfPass =
                                                !logic.obscureConfPass;
                                                logic.update();
                                              },
                                              child: SizedBox(
                                                height: !logic.obscureConfPass
                                                    ? 24
                                                    : 16,
                                                width: !logic.obscureConfPass
                                                    ? 24
                                                    : 16,
                                                child: Image.asset(
                                                    logic.obscureConfPass ? AppAssets
                                                        .eyeIcon : AppAssets
                                                        .eyeOffIcon),
                                              )
                                          )),

                                      addHeight(30),

                                      AppButton(
                                          buttonText: 'Update Password',
                                          buttonColor: logic.isButtonDisable?AppColors.buttonDisableColor:AppColors.primaryColor,
                                          onButtonTap: logic.isButtonDisable
                                              ? (){}
                                              : () {
                                            // effectSound(sound: AppAssets.actionButtonTapSound);
                                            if(formKey.currentState?.validate()??false){
                                              CustomSnackBar().showSnack(context, message: 'Password changed successfully.');
                                              Get.back();
                                            }
                                          }
                                          ),
                                      addHeight(40),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }))

              ],
            );
          }).marginSymmetric(horizontal: 16),
        ),
      ),
    );
  }
}
