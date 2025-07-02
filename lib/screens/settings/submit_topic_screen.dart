
import 'package:apollo/bottom_sheets/sign_out_bottom_sheet.dart';
import 'package:apollo/controllers/settings_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notification_settings_screen.dart';

class SubmitTopicScreen extends StatelessWidget {
  const SubmitTopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,

      body: GetBuilder<SettingsCtrl>(
        builder: (logic) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppAssets.notificationsBg,
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // addHeight(52),
                    backBar(
                      title: "Submit a Topic",
                      onTap: () {
                        Get.back();
                      },
                    ).marginSymmetric(horizontal: 16),
                    addHeight(24),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 16,right: 16,top: 24),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            addText500(
                                'Have a health topic in mind? Send it in—it might be featured in our next quiz!',
                                fontSize: 16,height: 22),
                            addHeight(24),

                            CustomTextField(hintText: 'Enter Message',maxLines: 10,),
                            addHeight(24),


                            AppButton(buttonText: 'Submit',onButtonTap: (){
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                            },)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}
