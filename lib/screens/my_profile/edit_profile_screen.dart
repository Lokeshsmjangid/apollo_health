import 'package:apollo/resources/Apis/api_repository/profile_update_repo.dart';
import 'package:apollo/bottom_sheets/deactive_account_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/camera_gallery_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/delete_account_bottom_sheet.dart';
import 'package:apollo/controllers/sign_up_personal_info_ctrl.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/custom_widgets/custom_dropdown.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/controllers/edit_profile_ctrl.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/controllers/my_profile_ctrl.dart';
import 'package:apollo/controllers/settings_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'change_password_screen.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';



class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                    addHeight(10),
                    backBar(
                      trailing: true,
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

                                /*buildSupportOption(
                                  onTap: () {
                                    Get.to(()=>SubscriptionScreen())?.then((val){
                                      logic.update();
                                    });
                                  },
                                  SupportOption(
                                    title: 'Subscription',
                                    // title: 'Subscription ${AuthData().userModel?.subscription}',
                                    subtitle:
                                    // AuthData().userModel?.subscription==1
                                    AuthData().userModel?.subscriptionDetail?.planId == "monthly_plan"
                                        ? "Premium - Monthly"
                                        : AuthData().userModel?.subscriptionDetail?.planId == "yearly_plan"
                                        ? "Premium - Annual"
                                        : "Starter Plan",





                                    color: AppColors.settingTxtColor1,
                                    colorBG: AppColors.settingTxtColorBG1,
                                  ),
                                ),
                                addHeight(20),*/
                                // Now start the scrollable area
                                Expanded(
                                  child: RawScrollbar(
                                    thumbColor: AppColors.primaryLightColor,
                                    radius: Radius.circular(20),
                                    thickness: 4,
                                    thumbVisibility: true,
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          return SingleChildScrollView(
                                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                                        child: ConstrainedBox( constraints: BoxConstraints(
                                            minHeight: constraints.maxHeight,
                                          ),
                                          child: IntrinsicHeight(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,

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
                                                  textCapitalization: TextCapitalization.words,
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
                                                  textCapitalization: TextCapitalization.words,
                                                ),

                                                addHeight(20),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: addText500(
                                                      "Age", fontSize: 16,
                                                      color: AppColors.textColor),
                                                ).marginOnly(left: 12, bottom: 6),

                                                CustomDropdownButton2<AgeGroupModel>(
                                                  hintText: "Age Group",
                                                  items: logic.ageGroupList ?? [],
                                                  value: logic.ageGroup,
                                                  displayText: (age) => "${age.age}",
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
                                                  readOnly: true,
                                                ),
                                                addHeight(14),

                                                buildSupportOption2(
                                                  needLeadingIcon: false,
                                                  SupportOption(
                                                    title: 'Change Password',
                                                    color: AppColors.settingTxtColor3,
                                                    colorBG: AppColors.settingTxtColorBG3,
                                                  ),
                                                  onTap: () {

                                                    Get.to(() => ChangePasswordScreen());
                                                  },
                                                ), addHeight(10),

                                                divider(),
                                                addHeight(10),
                                                buildSupportOption2(
                                                  needLeadingIcon: false,
                                                  SupportOption(
                                                    title: 'Deactivate Account',
                                                    color: AppColors.settingTxtColor5,
                                                    colorBG: AppColors.settingTxtColorBG1,
                                                  ),
                                                  onTap: () {
                                                    showDeActiveAccountRequestSheet(context);
                                                  },
                                                ),

                                                addHeight(10),
                                                buildSupportOption2(
                                                  needLeadingIcon: false,
                                                  SupportOption(
                                                    title: 'Delete Account',
                                                    color: AppColors.settingTxtColor5,
                                                    colorBG: AppColors.settingTxtColorBG5,
                                                  ),
                                                  onTap: () {
                                                    showDeleteAccountRequestSheet(context);
                                                  },
                                                ), addHeight(32),

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

                          // profile image
                          Positioned(
                            top: -84,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                buildProfileImage(
                                    networkImageUrl: logic.profileImage, //'https://apollomedgames.com/public/user.png'
                                    selectedFiles: logic.selectedFile),
                                Positioned(
                                  // top: 0,
                                  right: 0,
                                  bottom: -4,

                                  child: Container(
                                      width: 42,height: 28,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.whiteColor,width: 2),
                                          borderRadius: BorderRadius.circular(5)

                                      ),
                                      child: ClipRRect(
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          borderRadius: BorderRadius.circular(3),
                                          child: Image.network(AuthData().userModel?.countryFlag??ApiUrls.emptyImgUrl,fit: BoxFit.cover))),
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

      bottomNavigationBar: MediaQuery.removePadding(
          context: context,
          removeBottom: Platform.isIOS ? true : false,
          removeTop: true,
          child: GetBuilder<EditProfileController>(
              builder: (logic) {
                return BottomAppBar(
                  padding: EdgeInsets.zero,
                  color: AppColors.whiteColor,
                  child: AppButton(
                    buttonText: 'Save',
                    buttonColor: AppColors.primaryColor,
                    onButtonTap: () {
                      showLoader(true);
                      profileUpdateApi(
                          firstName: logic.firstName.text, lastName: logic.lastName.text,
                          ageGroup: '${logic.ageGroup?.age}',
                          country: logic.locationCtrl.text, countryFlag: '${logic.countryFlag}',

                      ).then((value){
                        showLoader(false);
                        if(value.status==true){
                          CustomSnackBar().showSnack(Get.context!,message: '${value.message}');
                          Get.find<MyProfileCtrl>().updateProfile = true;
                          Get.find<MyProfileCtrl>().update();
                          LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                          AuthData().getLoginData();
                          LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
                          logic.profileImage = value.data?.profileImage;
                          logic.update();
                        }
                      });
                    },

                  ).marginOnly(left: 16, right: 16, bottom: 34),
                );})),
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
      {VoidCallback? onTap, bool needLeadingIcon = true, bool needLeadingTrailing = true,}) { return GestureDetector(
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
    ); }

  Widget buildSupportOption2(SupportOption option,
      {VoidCallback? onTap, bool needLeadingIcon = true, bool needLeadingTrailing = true,}) { return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: option.colorBG,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
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
    );}

  Widget buildProfileImage({
    required String? networkImageUrl,
    required List<File?> selectedFiles,
    double size = 98,
    Color borderColor = Colors.deepPurple, // Replace with AppColors.primaryColor if needed
    double borderWidth = 2,
  }) { return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: (selectedFiles.isEmpty || selectedFiles[0] == null)
            ? CachedImageCircle2(imageUrl: networkImageUrl)
            : Image.file(
          selectedFiles[0]!,
          fit: BoxFit.cover,
        ),
      ),
    );

  }
}
