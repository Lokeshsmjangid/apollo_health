import 'dart:convert';

import 'package:apollo/controllers/email_verify_otp_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_repository/register_email_otp_verify_repo.dart';
import 'package:apollo/resources/Apis/api_repository/register_personal_info_repo.dart';

import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class EmailVerifyOtpScreen extends StatelessWidget {
  EmailVerifyOtpScreen({super.key});

  final ctrl = Get.find<EmailVerifyOtpCtrl>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: GetBuilder<EmailVerifyOtpCtrl>(builder: (logic) {
        return SafeArea(
          child: Column(
            children: [
              // addHeight(52),
              // AppBar
              addHeight(10),
              backBar(
                title: "Enter OTP",
                backButtonColor: AppColors.blackColor,
                titleColor: AppColors.blackColor,
                onTap: () {
                  Get.back();
                },
                isCancel: true
              ),
              Expanded(child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      addHeight(32),

                      // Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: addText500(
                      //         "We sent a one-time passcode (OTP) to ${AuthData().userModel?.email}. Enter the 5-digit code that was sent to your email.",
                      //         fontSize: 16, color: AppColors.blackColor,height: 22)),


                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.blackColor,
                                height: 22 / 16, // Convert height to line-height format
                                fontFamily: 'Manrope'
                            ),
                            children: [
                              const TextSpan(text: "We sent a one-time passcode (OTP) to "),
                              TextSpan(
                                text: AuthData().userModel?.email ?? "",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: ". Enter the 5-digit code that was sent to your email."),
                            ],
                          ),
                        ),
                      ),
                      addHeight(16),

                      Center(
                        child: PinCodeTextField(
                          appContext: context,
                          length: 5,
                          controller: logic.pinController,
                          animationType: AnimationType.none,
                          autoDismissKeyboard: true,
                          autoFocus: true,
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            // Square shape
                            borderRadius: BorderRadius.circular(30),
                            // Slightly rounded corners
                            borderWidth: 1.0,
                            inactiveBorderWidth: 1.0,
                            activeBorderWidth: 1.0,
                            selectedBorderWidth: 1.0,
                            errorBorderWidth: 1.0,
                            disabledBorderWidth: 1.0,
                            fieldHeight: 52,
                            fieldWidth: 60,
                            errorBorderColor: AppColors.redColor,
                            // Border colors
                            inactiveColor: AppColors.primaryLightColor,
                            // Border color for empty fields
                            activeColor: AppColors.primaryColor,
                            // Border color for focused field
                            selectedColor: AppColors.primaryColor,
                            // Border color for selected field
                            // errorColor: Colors.red,
                            disabledColor: AppColors.buttonDisableColor,
                            // Fill colors
                            inactiveFillColor: Colors.white,
                            // Background for empty fields
                            activeFillColor: AppColors.whiteColor,
                            // Background for filled fields
                            selectedFillColor: Colors
                                .transparent, // Background for selected field
                          ),
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Manrope'
                          ),

                          separatorBuilder: (context, index) => SizedBox(width: 4),
                          animationDuration: const Duration(milliseconds: 300),
                          cursorColor: AppColors.blackColor,
                          cursorHeight: 16,
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,

                          // Enable fill colors
                          showCursor: logic.hasError ? true : false,
                          onCompleted: (v) {
                            apolloPrint(message: "Completed OTP entry: $v");

                            // setState(() {
                            //   logic.hasError = false;
                            // });
                          },
                          onChanged: (value) {
                            logic.onButtonTap(value);
                          },
                          beforeTextPaste: (text) {
                            return true; // Allow pasting text
                          },
                        ),
                      ),
                      // addHeight(5),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Visibility(
                            visible: logic.hasError,
                            child: addText400(logic.hasErrorText, fontSize: 16,
                                color: AppColors.redColor)),
                      ),


                      addHeight(24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          addText400(
                              'Haven’t received the email? ',
                              fontSize: 14,
                              fontFamily: 'Manrope',
                              color: AppColors.blackColor),

                          Obx(() =>
                          logic.timerVal.value > 0
                              ? Row(
                            children: [
                              addText500(
                                  'Resend ',
                                  fontSize: 14,
                                  fontFamily: 'Manrope',
                                  decoration: TextDecoration.underline,
                                  color: AppColors.buttonDisableColor),
                              addText500(
                                  '(${logic.timerVal.value} Sec)',
                                  fontSize: 14,
                                  fontFamily: 'Manrope',
                                  // decoration: TextDecoration.underline,
                                  color: AppColors.blackColor),
                            ],
                          )
                              : GestureDetector(
                            onTap: () {
                              if (logic.timerVal.value < 1) {
                                logic.startATimerFunc();
                                logic.update();
                                showLoader(true);
                                registerPersonalInfoApi(
                                    firstName: AuthData().userModel?.firstName,
                                    lastName: AuthData().userModel?.lastName,
                                    ageGroup: AuthData().userModel?.ageGroup,
                                    country: AuthData().userModel?.country, countryFlag: AuthData().userModel?.countryFlag,
                                    type:'resend' ).then((value) {
                                  showLoader(false);
                                  if (value.status == true) {
                                    LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                                    AuthData().getLoginData();
                                    logic.pinController.clear();
                                    logic.startATimerFunc();
                                    CustomSnackBar().showSnack(Get.context!,message: '${value.message}');
                                    logic.otp = value.data?.otp.toString();
                                    logic.passwordResetToken = value.data?.passwordResetToken.toString();
                                    logic.update();

                                  } else if (value.status == false) {
                                    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${value.message}');
                                  }
                                });
                              }
                            },
                            child: addText500(
                                'Resend',
                                fontSize: 16,
                                fontFamily: 'Manrope',
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                                height: 0),
                          )),
                        ],
                      ),


                      addHeight(102),

                      AppButton(
                        buttonText: 'Verify Code',
                        onButtonTap: logic.enabledButton == true ? () {

                          showLoader(true);
                          registerEmailOtpVerifyApi( rpToken: logic.passwordResetToken,otp: logic.pinController.text).then((value){
                            showLoader(false);
                            if(value.status==true){
                              LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                              AuthData().getLoginData();
                              CustomSnackBar().showSnack(Get.context!,isSuccess: true,message: '${value.message}');
                              Get.offAllNamed(AppRoutes.signUpDisclaimerScreen);
                            } else if(value.status==false){
                              CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${value.message}');
                            }
                          });

                        } : () {
                          logic.onButtonTap(logic.pinController.text.length);
                        },
                        buttonColor: logic.enabledButton == true ? AppColors.primaryColor : AppColors.buttonDisableColor,
                      ),

                      addHeight(40),


                    ],
                  ),
                ),
              ))

            ],
          ),
        );
      }).marginSymmetric(horizontal: 16),
    );
  }
}
