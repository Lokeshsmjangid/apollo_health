import 'dart:developer';

import 'package:apollo/bottom_sheets/location_bottom_sheet.dart';
import 'package:apollo/controllers/sign_up_personal_info_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_column_animation.dart';
import 'package:apollo/custom_widgets/custom_dropdown.dart';
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

class SignUpPersonalInfoScreen extends StatefulWidget {
  const SignUpPersonalInfoScreen({super.key});

  @override
  State<SignUpPersonalInfoScreen> createState() =>
      _SignUpPersonalInfoScreenState();
}

class _SignUpPersonalInfoScreenState extends State<SignUpPersonalInfoScreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> effectSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));
  }


  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: GetBuilder<SignUpPersonalInfoController>(builder: (logic) {
        return SafeArea(
          child: Column(
            children: [
              // addHeight(52),
              // AppBar


              backBar(
                title: "Personal Info",
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
                              "First Name", fontSize: 16, height: 22,
                              color: AppColors.textColor)).marginOnly(
                          left: 12, bottom: 6),
                      CustomTextField(
                        hintText: 'Enter First Name',
                        controller: logic.firstName,
                        onChanged: (val) {
                          if (logic.firstName.text.isNotEmpty &&
                              logic.lastName.text.isNotEmpty &&
                              logic.location.text.isNotEmpty && logic.ageGroup!=null) {
                            logic.isButtonDisable = false;
                            logic.update();
                          } else {
                            logic.isButtonDisable = true;
                            logic.update();
                          }
                        },
                      ),
                      addHeight(20),

                      Align(
                          alignment: Alignment.centerLeft,
                          child: addText500(
                              "Last Name", fontSize: 16, height: 22,
                              color: AppColors.textColor)).marginOnly(
                          left: 12, bottom: 6),
                      CustomTextField(
                        hintText: 'Enter Last Name',
                        controller: logic.lastName,
                        onChanged: (val) {
                          if (logic.firstName.text.isNotEmpty &&
                              logic.lastName.text.isNotEmpty &&
                              logic.location.text.isNotEmpty && logic.ageGroup!=null) {
                            logic.isButtonDisable = false;
                            logic.update();
                          } else {
                            logic.isButtonDisable = true;
                            logic.update();
                          }
                        },
                      ),
                      addHeight(20),

                      Align(
                          alignment: Alignment.centerLeft,
                          child: addText500(
                              "Age", fontSize: 16,
                              height: 22,
                              color: AppColors.textColor)).marginOnly(
                          left: 12, bottom: 6),
                      CustomDropdownButton2<AgeGroupModel>(
                        hintText: "Age Group",
                        items: logic.ageGroupList ?? [],
                        value: logic.ageGroup,
                        displayText: (age) => "${age.age}",
                        icon: logic.isDropdownOpen
                            ? AppAssets.upArrowIcon
                            : AppAssets.downArrowIcon,
                        onChanged: (value) {
                          logic.ageGroup = value;
                          logic.isDropdownOpen = !logic.isDropdownOpen;
                          log('object11::${logic.isDropdownOpen}');
                          log('print11::${logic.isDropdownOpen}');
                          if(logic.firstName.text.isNotEmpty && logic.lastName.text.isNotEmpty && logic.location.text.isNotEmpty && logic.ageGroup!=null){
                            logic.isButtonDisable=false;

                          } else {
                            logic.isButtonDisable=true;

                          }
                          logic.update();
                        },
                        onTap: () {
                          logic.isDropdownOpen = !logic.isDropdownOpen;
                          logic.update();
                          log('object::${logic.isDropdownOpen}');
                        },
                        // borderRadius: 10,
                      ),
                      addHeight(20),

                      Align(
                          alignment: Alignment.centerLeft,
                          child: addText500(
                              "Country", fontSize: 16,
                              height: 22,
                              color: AppColors.textColor)).marginOnly(
                          left: 12, bottom: 6),
                      // CustomDropdownButton2<String>(
                      //   hintText: "Location",
                      //   items: logic.countries ?? [],
                      //   value: logic.selectedCountry,
                      //   displayText: (country) => country,
                      //   onChanged: (value) {
                      //     logic.selectedCountry = value;
                      //     logic.update();
                      //   },
                      //   searchController: logic.countrySearch,
                      //   // borderRadius: 10,
                      // ),

                      CustomTextField(
                        controller: logic.location,
                        fillColor: AppColors.whiteColor,
                        suffixIcon: SvgPicture.asset(AppAssets.downArrowIcon),
                        hintText: 'Select Country',
                        readOnly: true,
                        validator: (value) => validateField(field: 'country', value: logic.location.text),
                        onChanged: (val) {
                          if (logic.firstName.text.isNotEmpty &&
                              logic.lastName.text.isNotEmpty &&
                              logic.location.text.isNotEmpty && logic.ageGroup!=null) {
                            logic.isButtonDisable = false;
                            logic.update();
                          } else {
                            logic.isButtonDisable = true;
                            logic.update();
                          }
                        },
                        onTap: () {
                          logic.openLocationPicker(context);
                        },

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
      bottomSheet: GetBuilder<SignUpPersonalInfoController>(builder: (logic) {
        return Container(
          height: 84,
          decoration: BoxDecoration(
              color: AppColors.whiteColor
          ),
          width: double.infinity,
          child: AppButton(
            buttonText: 'Next',
            buttonColor: logic.isButtonDisable?AppColors.buttonDisableColor:AppColors.primaryColor,
            onButtonTap: logic.isButtonDisable?(){}:() {
            // effectSound(sound: AppAssets.actionButtonTapSound);
              if(formKey.currentState?.validate()??false) {
                Get.toNamed(AppRoutes.signUpDisclaimerScreen);
              }
          },).marginOnly(left: 16, right: 16, bottom: 30),
        );
      }),
    );
  }
}
