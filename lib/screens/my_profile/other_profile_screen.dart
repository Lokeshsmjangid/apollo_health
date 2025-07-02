import 'package:apollo/bottom_sheets/badge_achieved_bottom_sheet.dart';
import 'package:apollo/controllers/my_profile_ctrl.dart';
import 'package:apollo/controllers/other_profile_ctrl.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtherProfileScreen extends StatelessWidget {
  const OtherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.notificationsBg,
              fit: BoxFit.cover,
            ),
          ),
          GetBuilder<OtherProfileCtrl>(builder: (logic) {
            return SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // addHeight(58),


                      Align(
                          alignment: Alignment.centerLeft,
                          child: backButton(
                              onTap: (){
                            Get.back();
                          },backButtonColor: AppColors.whiteColor).marginOnly(left: 16)),


                  addHeight(82),
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
                          padding: const EdgeInsets.only(left: 16,right: 16,top: 24),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              // addHeight(16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  addText700('Leslie Alexander', fontSize: 26, color: AppColors.blackColor),
                                  addWidth(4),
                                  Image.asset(
                                    AppAssets.premiumProfileIcon, height: 24,width: 24,),


                                ],
                              ),

                              addHeight(2),
                              Align(
                                  alignment: Alignment.center,
                                  child: addText400(
                                      'Middleburg, VA, USA • Joined August, 2025',
                                      fontSize: 12, color: AppColors.textColor)),

                              addHeight(10),
                              Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: (){
                                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                      Get.toNamed(AppRoutes.mutualFriendScreen);
                                    },
                                    child: addText500(
                                        '3 Mutual Friends',
                                        decoration: TextDecoration.underline,
                                        fontSize: 16, color: AppColors.primaryColor),
                                  )),
                              addHeight(20),

                              // Stats
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildStatCard(AppAssets.friendsIcon, '21', 'Friends'),
                                  addWidth(13),
                                  _buildStatCard(AppAssets.coinIcon, '448000', 'Total HP'),
                                ],
                              ),

                              const SizedBox(height: 32),

                              Row(
                                children: [
                                  addText400('Highest Badge Achieved',fontSize: 20, height: 22,fontFamily: 'Caprasimo', color: AppColors.primaryColor),
                                  SizedBox(width: 6),
                                  GestureDetector(
                                      onTap: (){
                                        // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                        showBadgeAchievedSheet(context);
                                      },
                                      child: Icon(Icons.info_outline, size: 16)),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Badges
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: logic.badges.length,
                                itemBuilder: (context, index) {
                                  final badge = logic.badges[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: VisualDensity(vertical: -3),
                                    leading: Image.asset(badge.icon,height: 52,width: 41,),
                                    title: addText400(badge.title,fontSize: 16,height: 27.16,fontFamily: 'Caprasimo'),
                                    subtitle: addText500(badge.description,fontSize: 16,height: 22,color: AppColors.blackColor),
                                    trailing: addText400(badge.date,fontSize: 12),
                                  );
                                },
                              ),

                              addHeight(90)
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
                              CircleAvatar(
                                  radius: 50, backgroundColor: AppColors.primaryColor,
                                  child: CircleAvatar(
                                    radius: 48,
                                    backgroundImage: AssetImage(AppAssets.profileImg),
                                    backgroundColor: AppColors.whiteColor,)),
                              Positioned(
                                // top: 0,
                                right: 0,
                                bottom: 0,

                                child: Container(
                                    height: 25,width: 35,

                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.whiteColor,width: 1.5),
                                      borderRadius: BorderRadius.circular(6)

                                    ),
                                    child: Image.asset(AppAssets.flagIcon,fit: BoxFit.cover,cacheHeight: 25,cacheWidth: 35,)),
                              ),

                              // for online offline
                              Positioned(
                                top: 10,
                                right: 10,
                                // bottom: 0,

                                child: Container(
                                    height: 12,width: 12,

                                    decoration: BoxDecoration(
                                      color: AppColors.green500Color,
                                      shape: BoxShape.circle)),
                              ),

                              // badge achieved
                              Positioned(
                                top: -20,
                                // bottom: 0,

                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [

                                    Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.yellowColor,
                                          borderRadius: BorderRadius.circular(6),
                                            boxShadow: [BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4.0,
                                )]

                                        ),
                                      child: addText400('Health Apprentice', fontFamily: 'Caprasimo', fontSize: 14,).marginSymmetric(horizontal: 14,vertical: 6),
                                    ),

                                    Positioned(
                                        left: -14,
                                        top: 2,

                                        bottom: 2,
                                        child: Image.asset(AppAssets.premiumTagLeftIcon,height: 10,color: AppColors.yellowColor,)),
                                    Positioned(
                                        right: -14,
                                        top: 2,

                                        bottom: 2,
                                        child: Image.asset(AppAssets.premiumTagRightIcon,height: 10,color: AppColors.yellowColor,))

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatCard(String icon, String value, String label,
      {VoidCallback? onTap,bool isBgColor = true}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: isBgColor ? Color(0XFF9266D9) : null,
            borderRadius: BorderRadius.circular(16),
            border: !isBgColor ? Border.all(color: AppColors.primaryColor) : null
        ),
        height: 68,
        width: 150,
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(icon, height: 32, width: 32,),
            addWidth(12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addText400(value, fontSize: 18,
                    fontFamily: 'Caprasimo',
                    color: isBgColor ? AppColors.whiteColor : AppColors
                        .primaryColor),
                addText400(label, fontSize: 12,
                    color: isBgColor ? AppColors.whiteColor : AppColors
                        .blackColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildStarIcon(Color background, IconData icon, {Color iconColor = Colors.brown}) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: background,
      child: Image.asset(AppAssets.starIcon,color: AppColors.settingTxtColor1,).marginAll(8),
    );
  }

  static Widget _buildDayCircle(String letter) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
      child: addText400(letter, fontSize: 12,color: AppColors.blackColor),
    );
  }

}
