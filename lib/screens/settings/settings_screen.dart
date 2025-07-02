
import 'package:apollo/bottom_sheets/sign_out_bottom_sheet.dart';
import 'package:apollo/controllers/settings_ctrl.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/cms_pages/cms_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import 'notification_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
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
                      title: "Settings",
                      onTap: () {
                        Get.back();
                      },
                      isLogout: true,
                      onTapLogout: (){
                        // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                        showSignOutRequestSheet(context);
                      }
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
                            sectionTitle('Customization '),
                            toggleTile(
                              'Music',
                              logic.music, () {
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                    logic.music = !logic.music;
                                logic.update();
                              },
                            ),
                            toggleTile(
                              'Online Status',
                              logic.onlineStatus, () {
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                logic.onlineStatus = !logic.onlineStatus;
                                logic.update();
                              },
                            ),

                            SizedBox(height: 24,),
                            buildSupportOption(
                                SupportOption(
                                    title: 'Notifications',
                                    color: AppColors.settingTxtColor1,
                                    colorBG: AppColors.settingTxtColorBG1),
                                onTap: (){
                                  // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                  Get.to(()=>NotificationSettingsScreen());}),

                            SizedBox(height: 10,),

                            buildSupportOption(SupportOption(
                                title: 'About Us',
                                color: AppColors.settingTxtColor3,
                                colorBG: AppColors.settingTxtColorBG3),
                                onTap: (){
                                  // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                  Get.to(CmsScreen(appBar: 'About Us'));
                                }),

                            SizedBox(height: 24,),
                            sectionTitle('Feedback & Support'),

                            // SizedBox(height: 2,),
                            buildSupportOption(SupportOption(
                                title: 'Submit a Quiz Topic',
                                // subtitle: 'Got a health topic in mind? Message us—it could be in our next feature!',
                                color: AppColors.settingTxtColor2,
                                colorBG: AppColors.settingTxtColorBG2),
                                onTap: (){
                                  // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              Get.toNamed(AppRoutes.submitTopicScreen);
                                }),
                            SizedBox(height: 10,),
                            buildSupportOption(SupportOption(
                                title: 'Support',
                                color: AppColors.settingTxtColor4,
                                colorBG: AppColors.settingTxtColorBG4),onTap: (){
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              Get.toNamed(AppRoutes.needHelpScreen);
                            }),

                            SizedBox(height: 10,),

                            buildSupportOption(SupportOption(
                                title: 'Rate Us',
                                color: AppColors.settingTxtColor3,
                                colorBG: AppColors.settingTxtColorBG3)),
                            SizedBox(height: 10),

                            buildSupportOption(SupportOption(
                                title: 'Privacy Policy',
                                color: AppColors.settingTxtColor1,
                                colorBG: AppColors.settingTxtColorBG1,

                            ),onTap: (){
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              Get.to(CmsScreen(appBar: 'Privacy Policy'));
                            }),
                            SizedBox(height: 10,),

                            buildSupportOption(SupportOption(
                                title: 'Terms & Conditions',
                                color: AppColors.settingTxtColor5,
                                colorBG: AppColors.settingTxtColorBG5),
                                onTap: (){
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              Get.to(CmsScreen(appBar: 'Terms'));}),

                            const SizedBox(height: 30),
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
  Widget sectionTitle(String title, {String? subtitle, int? counter}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addText400(
                  title,
                  fontSize: 20,
                  fontFamily: 'Caprasimo',height: 27.16,
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

  Widget toggleTile(
      String title,
      bool value,
      void Function()? onChanged, {
        bool showInfo = false,
        String? subTitle,
        void Function()? onInfoTap,
      }) { return ListTile(
    visualDensity: VisualDensity(horizontal: -4,vertical: -4),
    contentPadding: EdgeInsets.zero,
    title: Row(
      children: [
        Image.asset(AppAssets.starIcon, height: 18, width: 18),
        addWidth(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  addText500(title, fontSize: 16,height: 22),
                  addWidth(8),
                  if (showInfo)
                    GestureDetector(
                      onTap: onInfoTap,
                      child: Icon(
                        Icons.info_outline,
                        size: 18,
                        color: AppColors.blackColor,
                      ),
                    ),
                ],
              ),
              if (subTitle != null)
                addText400(
                  subTitle,
                  fontSize: 12,
                  color: AppColors.blackColor,
                ),
            ],
          ),
        ),
      ],
    ),
    trailing: switchButton(value: value, onTap: onChanged),
  );}

  Widget divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Divider(thickness: 1, height: 0),
  );

  Widget buildSupportOption(SupportOption option,{VoidCallback? onTap}) {
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
            Image.asset(AppAssets.starIcon,height: 24,width: 24,color: option.color),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addText400(
                    option.title,
                    fontFamily: 'Caprasimo',
                    fontSize: 20,
                    height: 27.16,
                    color: option.color
                  ),
                  if (option.subtitle != null) ...[
                    // const SizedBox(height: 4),
                    addText400(
                      option.subtitle!, fontSize: 12,color: AppColors.blackColor
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 11),
            Icon(Icons.arrow_forward_ios_sharp,size: 16,color: option.color,)
          ],
        ),
      ),
    );
  }


}
