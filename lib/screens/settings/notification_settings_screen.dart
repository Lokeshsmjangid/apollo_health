
import 'package:apollo/bottom_sheets/sign_out_bottom_sheet.dart';
import 'package:apollo/controllers/settings_ctrl.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

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
                      title: "Notifications",
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
                        padding: const EdgeInsets.only(left: 16,right: 16,top: 20),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            toggleTile(
                              'All notifications',
                              logic.allNotifications, () {
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              logic.allNotifications = !logic.allNotifications;
                              if(logic.allNotifications==false){
                                logic.ddPush = false;
                                logic.ddEmail = false;
                                logic.luPush = false;
                                logic.luEmail = false;
                                logic.frPush = false;
                                logic.frEmail = false;
                                logic.dsPush = false;
                                logic.dsEmail = false;
                              }
                              logic.update();
                            },
                            ),


                            addHeight(16),
                            divider(),
                            addHeight(24),

                            sectionTitle('Daily Dose '),
                            addHeight(10),

                            toggleTile(
                              'Push',
                              logic.ddPush, () {
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              logic.ddPush = !logic.ddPush;
                              logic.update();
                            },
                            ),
                            toggleTile(
                              'Email',
                              logic.ddEmail, () {
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              logic.ddEmail = !logic.ddEmail;
                              logic.update();
                            },
                            ),

                            addHeight(18),
                            sectionTitle('Live Event Update'),
                            addHeight(10),

                            toggleTile(
                              'Push',
                              logic.luPush, () {
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              logic.luPush = !logic.luPush;
                              logic.update();
                            },
                            ),
                            toggleTile(
                              'Email',
                              logic.luEmail, () {
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              logic.luEmail = !logic.luEmail;
                              logic.update();
                            },
                            ),

                            addHeight(18),
                            sectionTitle('Friend/Group Play Request'),
                            addHeight(10),

                            toggleTile(
                              'Push',
                              logic.frPush, () {
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              logic.frPush = !logic.frPush;
                              logic.update();
                            },
                            ),
                            toggleTile(
                              'Email',
                              logic.frEmail, () {
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              logic.frEmail = !logic.frEmail;
                              logic.update();
                            },
                            ),

                            addHeight(18),
                            sectionTitle('Daily Streak Reminder'),
                            addHeight(10),

                            toggleTile(
                              'Push',
                              logic.dsPush, () {
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              logic.dsPush = !logic.dsPush;
                              logic.update();
                            },
                            ),
                            toggleTile(
                              'Email',
                              logic.dsEmail, () {
                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              logic.dsEmail = !logic.dsEmail;
                              logic.update();
                            },
                            ),


                            const SizedBox(height: 34),
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addText400(
                title,
                fontSize: 20,
                height: 22,
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
        Image.asset(AppAssets.starIcon, color: AppColors.yellowColor,height: 18, width: 18),
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

  Widget divider() => Divider(thickness: 1, height: 0,color: AppColors.bottomSheetBorderColor,);

  Widget buildSupportOption(SupportOption option,{VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: option.colorBG,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(AppAssets.starIcon,height: 24,color: option.color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addText400(
                    option.title,
                    fontFamily: 'Caprasimo',
                    fontSize: 20,
                    color: option.color
                  ),
                  if (option.subtitle != null) ...[
                    const SizedBox(height: 4),
                    addText400(
                      option.subtitle!, fontSize: 12,color: AppColors.blackColor
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.arrow_forward_ios_sharp,size: 16,color: option.color,)
          ],
        ),
      ),
    );
  }


}
