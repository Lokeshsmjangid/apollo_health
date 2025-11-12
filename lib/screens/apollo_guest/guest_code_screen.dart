import 'package:apollo/controllers/guest_code_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/Apis/api_repository/guest_code_repo.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'guest_disclaimer_screen.dart';

class GuestCodeScreen extends StatelessWidget {
  GuestCodeScreen({super.key});

  final ctrl = Get.find<GuestCodeCtrl>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        // Keyboard ke hisab se bottom padding
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 12,
          right: 12,
        ),
        child: SafeArea(
          child: GetBuilder<GuestCodeCtrl>(
            builder: (logic) {
              // keyboard status check
              final isKeyboardOpen =
                  MediaQuery.of(context).viewInsets.bottom > 0;

              return AppButton(
                buttonText: 'Verify Code',
                onButtonTap:
                    logic.enabledButton == true
                        ? () {
                          // TODO: Your Verify Action
                          apolloPrint(
                            message: 'message:::-> ${logic.pinController.text}',
                          );

                          showLoader(true);
                          guestCodeApi(
                            mapData: {"code": logic.pinController.text.trim()},
                          ).then((value) {
                            showLoader(false);
                            if (value.status == true) {
                              Get.off(
                                () => GuestDisclaimerScreen(
                                  institutionalCode:
                                      logic.pinController.text.trim(),
                                ),
                              );
                            }
                          });
                        }
                        : () {
                          // logic.onButtonTap(logic.pinController.text.length);
                        },
                buttonColor:
                    logic.enabledButton == true
                        ? AppColors.primaryColor
                        : AppColors.buttonDisableColor,
              ).marginOnly(
                bottom:
                    isKeyboardOpen ? 0 : 24, // remove margin when keyboard open
              );
            },
          ),
        ),
      ),

      body: GetBuilder<GuestCodeCtrl>(
        builder: (logic) {
          return SafeArea(
            child: Column(
              children: [
                if (GetPlatform.isAndroid) addHeight(16),
                // AppBar
                backBar(
                  title: "Game Access",
                  backButtonColor: AppColors.blackColor,
                  titleColor: AppColors.blackColor,
                  trailing: true,
                  onTap: () {
                    Get.back();
                  },
                ),
                Expanded(
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          addHeight(32),

                          Align(
                            alignment: Alignment.center,
                            child: addText500(
                              "Enter 6-digit Institutional Code.",
                              fontSize: 16,
                              color: AppColors.blackColor,
                              height: 22,
                            ),
                          ),
                          addHeight(16),
                          Center(
                            child: PinCodeTextField( appContext: context,

                              length: 6,
                              controller: logic.pinController,
                              animationType: AnimationType.none,
                              autoFocus: true,
                              obscureText: false,
                              autoDismissKeyboard: true,
                              keyboardType: TextInputType.visiblePassword,
                              textCapitalization: TextCapitalization.characters,

                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp('[A-Z0-9]'),
                                ),
                              ],
                              pinTheme: PinTheme(

                                // for shape
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(24.0),
                                fieldHeight: 50,
                                fieldWidth: 52,
                                borderWidth: 1.0,
                                activeBorderWidth: 1.0,
                                selectedBorderWidth: 1.0,
                                inactiveBorderWidth: 1.0,

                                // Borders
                                inactiveColor: AppColors.primaryLightColor, // light lavender border
                                activeColor: AppColors.primaryColor,
                                selectedColor: AppColors.primaryColor,
                                errorBorderColor: AppColors.redColor,
                                disabledColor: AppColors.buttonDisableColor,

                                // Fill colors
                                inactiveFillColor: Colors.white,
                                activeFillColor: Colors.white,
                                selectedFillColor: Colors.white,
                              ),

                              textStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Manrope',
                              ),
                              animationDuration: const Duration(milliseconds: 200),

                              // Cursor
                              cursorColor: AppColors.primaryColor,
                              cursorHeight: 2,
                              cursorWidth: 10,
                              showCursor: true,
                              separatorBuilder: (context, index) => const SizedBox(width: 2),
                              backgroundColor: Colors.transparent,
                              enableActiveFill: true, // Keep fill enabled for solid background

                              onChanged: (value) => logic.onButtonTap(value),
                              onCompleted: (v) => apolloPrint(message: "Completed: $v"),

                            ),
                          ),

                          /*Center(
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: logic.pinController,
                        animationType: AnimationType.none,
                        autoDismissKeyboard: true,
                        autoFocus: true,
                        keyboardType: TextInputType.visiblePassword,
                        textCapitalization: TextCapitalization.characters,
                        obscureText: false,
                        inputFormatters: [
                          // FilteringTextInputFormatter.digitsOnly
                          FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]'))
                        ],
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          // Square shape
                          borderRadius: BorderRadius.circular(24),
                          // Slightly rounded corners
                          borderWidth: 1.0,
                          inactiveBorderWidth: 1.0,
                          activeBorderWidth: 1.0,
                          selectedBorderWidth: 1.0,
                          errorBorderWidth: 1.0,
                          disabledBorderWidth: 1.0,
                          fieldHeight: 48,
                          fieldWidth: 52,
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

                        separatorBuilder: (context, index) => SizedBox(width: 2),
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
                    ),*/
                          // addHeight(5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Visibility(
                              visible: logic.hasError,
                              child: addText400(
                                fontSize: 16,
                                logic.hasErrorText,
                                color: AppColors.redColor,
                              ),
                            ),
                          ),
                          addHeight(40),
                        ]))))]));
        },
      ).marginSymmetric(horizontal: 16),
    );
  }
}
