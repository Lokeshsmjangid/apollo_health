import 'dart:io';

import 'package:apollo/bottom_sheets/badge_achieved_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/camera_gallery_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/delete_account_bottom_sheet.dart';
import 'package:apollo/controllers/edit_profile_ctrl.dart';
import 'package:apollo/controllers/my_profile_ctrl.dart';
import 'package:apollo/controllers/settings_ctrl.dart';
import 'package:apollo/controllers/sign_up_personal_info_ctrl.dart';
import 'package:apollo/custom_widgets/custom_dropdown.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'change_password_screen.dart';
import 'subscription_screen.dart';


class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: AppColors.primaryColor,
      body: SizedBox.expand(
        child: Stack(
          children: [

            Container(
              color: AppColors.primaryColor,
            ),
            Positioned.fill(
              child: Image.asset(
                AppAssets.notificationsBg,
                fit: BoxFit.cover,
              ),
            ),
            GetBuilder<EditProfileController>(builder: (logic) {
              return SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    backBar(
                      title: "Edit Profile",
                      onTap: () {
                        Get.back();
                      },
                    ).marginSymmetric(horizontal: 16),
                    addHeight(90),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [

                                addHeight(10),

                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: (){
                                      showCameraGallerySheet(
                                          context,
                                          onTapCamera: (){
                                        Navigator.pop(context); // Close the dialog
                                        logic.pickImage(ImageSource.camera); // Open the camera
                                      },
                                          onTapGallery: (){
                                            Navigator.pop(context); // Close the dialog
                                            logic.pickImage(ImageSource.gallery);
                                          });
                                      },
                                    child: addText500(
                                        'Upload Photo', fontSize: 16,
                                        height: 22,
                                        color: AppColors.primaryColor),
                                  ),
                                ),
                                addHeight(20),

                                buildSupportOption(
                                  onTap: () {
                                    // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                    Get.to(SubscriptionScreen());
                                  },
                                  SupportOption(
                                    title: 'Subscription',
                                    subtitle: 'Starter Plan',
                                    color: AppColors.settingTxtColor1,
                                    colorBG: AppColors.settingTxtColorBG1,
                                  ),
                                ),
                                addHeight(20),
                                // Now start the scrollable area
                                Expanded(
                                  child: RawScrollbar(
                                    thumbColor: AppColors.primaryLightColor,
                                    radius: Radius.circular(20),
                                    thickness: 4,
                                    thumbVisibility: true,
                                    child: LayoutBuilder(
                                        builder: (context, constraints)
                                         {
                                      return SingleChildScrollView(
                                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight: constraints.maxHeight,
                                          ),
                                          child: IntrinsicHeight(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              // padding: EdgeInsets.zero,
                                              children: [
                                                sectionTitle('Personal Info'),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: addText500(
                                                      "First Name", fontSize: 16,
                                                      color: AppColors.textColor),
                                                ).marginOnly(left: 12, bottom: 6),
                                                CustomTextField(
                                                  controller: logic.firstName,
                                                  hintText: 'Enter First Name',
                                                ),
                                                addHeight(20),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: addText500(
                                                      "Last Name", fontSize: 16,
                                                      color: AppColors.textColor),
                                                ).marginOnly(left: 12, bottom: 6),
                                                CustomTextField(
                                                  controller: logic.lastName,
                                                  hintText: 'Enter Last Name',
                                                ),
                                                addHeight(20),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: addText500(
                                                      "Age", fontSize: 16,
                                                      color: AppColors.textColor),
                                                ).marginOnly(left: 12, bottom: 6),
                                                CustomDropdownButton2<
                                                    AgeGroupModel>(
                                                  hintText: "Age Group",
                                                  items: logic.ageGroupList ?? [],
                                                  value: logic.ageGroup,
                                                  displayText: (age) => "${age
                                                      .age}",
                                                  onChanged: (value) {
                                                    logic.ageGroup = value;
                                                    logic.update();
                                                  },
                                                ),
                                                addHeight(20),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: addText500(
                                                      "Country", fontSize: 16,
                                                      color: AppColors.textColor),
                                                ).marginOnly(left: 12, bottom: 8),
                                                CustomTextField(
                                                  controller: logic.locationCtrl,
                                                  readOnly: true,
                                                  hintText: 'Country',
                                                  suffixIcon: SvgPicture.asset(
                                                      AppAssets.downArrowIcon,
                                                      width: 8,
                                                      height: 8,
                                                      color: AppColors
                                                          .blackColor),
                                                  onTap: () {
                                                    // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                                    logic.openLocationPicker(context);
                                                  },
                                                ),
                                                addHeight(20),
                                                sectionTitle('Account Settings'),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: addText500(
                                                      "Email", fontSize: 16,
                                                      color: AppColors.textColor),
                                                ).marginOnly(left: 12, bottom: 8),
                                                CustomTextField(
                                                  controller: logic.emailCtrl,
                                                  hintText: 'Enter your email',
                                                ),
                                                addHeight(14),
                                                buildSupportOption2(
                                                  needLeadingIcon: false,
                                                  SupportOption(
                                                    title: 'Change Password',
                                                    color: AppColors
                                                        .settingTxtColor3,
                                                    colorBG: AppColors
                                                        .settingTxtColorBG3,
                                                  ),
                                                  onTap: () {
                                                    // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                                    Get.to(() => ChangePasswordScreen());
                                                  },
                                                ),
                                                addHeight(10),
                                                divider(),
                                                addHeight(10),
                                                buildSupportOption2(
                                                  needLeadingIcon: false,
                                                  SupportOption(
                                                    title: 'Delete Account',
                                                    color: AppColors
                                                        .settingTxtColor5,
                                                    colorBG: AppColors
                                                        .settingTxtColorBG5,
                                                  ),
                                                  onTap: () {
                                                    // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                                    showDeleteAccountRequestSheet(context);
                                                  },
                                                ),
                                                addHeight(32),
                                              ],
                                            ).marginOnly(right: 12),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // profile image (unchanged)
                          Positioned(
                            top: -84,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                if(logic.selectedFile.isNotEmpty)
                                Container(
                                    height: 98,width: 98,
                                    // clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.primaryColor,width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(1000),
                                        child: Image.file(File(logic.selectedFile[0]!.path.toString()),fit: BoxFit.cover)),
                                  ),
                                if(logic.selectedFile.isEmpty)
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: AppColors.primaryColor,
                                  child: CircleAvatar(
                                    radius: 48,
                                    backgroundImage: AssetImage(AppAssets.profileImg),
                                    backgroundColor: AppColors.whiteColor,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    height: 25,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.whiteColor,
                                          width: 1.5),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Image.asset(
                                      AppAssets.flagIcon,
                                      fit: BoxFit.cover,
                                      cacheHeight: 25,
                                      cacheWidth: 35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget divider() =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Divider(
          thickness: 1, height: 0, color: AppColors.bottomSheetBGColor,),
      );

  Widget sectionTitle(String title, {String? subtitle, int? counter}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addText400(
                  title,
                  fontSize: 20,
                  fontFamily: 'Caprasimo',
                  color: AppColors.primaryColor,
                ),
                if (subtitle != null)
                  addText400(
                    subtitle,
                    fontSize: 12,
                    color: AppColors.blackColor,
                  ),
              ],
            ),
          ),
          if (counter != null)
            addText400(
              '$counter/5',
              fontSize: 20,
              fontFamily: 'Caprasimo',
              color: AppColors.primaryColor,
            ),
        ],
      ),
    );
  }

  Widget buildSupportOption(SupportOption option,
      {VoidCallback? onTap, bool needLeadingIcon = true, bool needLeadingTrailing = true,}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: option.colorBG,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(needLeadingIcon)
              Image.asset(AppAssets.starIcon, height: 24,
                  width: 24,
                  color: option.color),
            if(needLeadingIcon)
              const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addText400(
                      option.title,
                      fontFamily: 'Caprasimo',
                      fontSize: 20, height: 22,
                      color: option.color
                  ),
                  if (option.subtitle != null) ...[
                    // const SizedBox(height: 4),
                    addText400(
                      option.subtitle!, fontSize: 12,
                      color: AppColors.blackColor,
                    ),
                  ],
                ],
              ),
            ),
            if(needLeadingTrailing)
              const SizedBox(width: 12),
            if(needLeadingTrailing)
              Icon(
                Icons.arrow_forward_ios_sharp, size: 16, color: option.color,)
          ],
        ),
      ),
    );
  }

  Widget buildSupportOption2(SupportOption option,
      {VoidCallback? onTap, bool needLeadingIcon = true, bool needLeadingTrailing = true,}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: option.colorBG,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(needLeadingIcon)
              Image.asset(AppAssets.starIcon, height: 24,
                  width: 24,
                  color: option.color),
            if(needLeadingIcon)
              const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addText500(
                      option.title,
                      // fontFamily: 'Caprasimo',
                      fontSize: 16, height: 22,
                      color: option.color
                  ),
                  if (option.subtitle != null) ...[
                    // const SizedBox(height: 4),
                    addText400(
                      option.subtitle!, fontSize: 12,
                      color: AppColors.blackColor,
                    ),
                  ],
                ],
              ),
            ),
            if(needLeadingTrailing)
              const SizedBox(width: 12),
            if(needLeadingTrailing)
              Icon(
                Icons.arrow_forward_ios_sharp, size: 16, color: option.color,)
          ],
        ),
      ),
    );
  }
}


