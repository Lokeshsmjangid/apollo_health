import 'dart:io';

import 'package:apollo/bottom_sheets/badge_achieved_bottom_sheet.dart';
import 'package:apollo/controllers/bottom_bar_ctrl.dart';
import 'package:apollo/controllers/edit_profile_ctrl.dart';
import 'package:apollo/controllers/my_profile_ctrl.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/screens/badge_screens/grandmaster_health_badge_screen.dart';
import 'package:apollo/screens/badge_screens/health_apprentice_badge_screen.dart';
import 'package:apollo/screens/badge_screens/health_pro_badge_screen.dart';
import 'package:apollo/screens/badge_screens/health_whiz_badge_screen.dart';
import 'package:apollo/screens/badge_screens/wellness_watcher_badge_screen.dart';
import 'package:apollo/screens/game_mode/wheel_of_wellness/wheel_of_wellness_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();

  static Widget _buildStarIcon(Color background, IconData icon, {Color? iconColor}) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: background,
      child: Image.asset(AppAssets.starIcon,color: iconColor??AppColors.settingTxtColor1,).marginAll(8),
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

class _MyProfileScreenState extends State<MyProfileScreen> {
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
          GetBuilder<MyProfileCtrl>(builder: (logic) {
            return SafeArea(
              child: Column(
                children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                              onPressed: (){
                                // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                Get.toNamed(AppRoutes.subscriptionScreen);
                              }, icon: SvgPicture.asset(AppAssets.waveCheckIcon,color: AppColors.whiteColor,height: 24,width: 24)),

                          IconButton(
                              visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                              onPressed: (){
                                // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                Get.toNamed(AppRoutes.settingsScreen);
                                // Get.to(()=>WellnessWatcherBadgeScreen());
                              }, icon: Image.asset(AppAssets.settingsIcon,height: 24,width: 24)),
                        ],
                      ).marginSymmetric(horizontal: 16),

                  addHeight(68),
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
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: [
                              // addHeight(16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  addText700('Zain Vaccaro', fontSize: 26, color: AppColors.blackColor),
                                  addWidth(4),
                                  Image.asset(
                                    AppAssets.premiumProfileIcon, height: 19,width: 19,),

                                  addWidth(12),
                                  GestureDetector(
                                    onTap: (){
                                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                      Get.toNamed(AppRoutes.editProfileScreen)?.then((val){
                                        setState(() {});
                                      });
                                    },
                                    child: Image.asset(
                                      AppAssets.editProfileIcon, height: 24,),
                                  )
                                ],
                              ),

                              addHeight(2),
                              Align(
                                  alignment: Alignment.center,
                                  child: addText400(
                                      'United States • Joined August, 2025',
                                      fontSize: 12, color: AppColors.textColor)),
                              addHeight(20),

                              // Stats
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildStatCard(AppAssets.coinIcon, '448897', 'Total HP'),
                                  addWidth(13),
                                  _buildStatCard(AppAssets.globeIcon, '1,438', 'Global Rank'),
                                ],
                              ),

                              addHeight(12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildStatCard(
                                      onTap: (){
                                        // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                        Get.toNamed(AppRoutes.myFriendsScreen);
                                      },
                                      isBgColor: false, AppAssets.usersIcon, '150', 'Friends'),
                                  addWidth(13),
                                  _buildStatCard(
                                      onTap: (){
                                        // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                      },
                                      isBgColor: false, AppAssets.chartBarIcon, '3', 'Friend Rank'),
                                ],
                              ),

                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xF2F3E7FF), // Light purple
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    addText400(
                                        "Daily Streak",fontSize: 20, height: 22,fontFamily: 'Caprasimo', color: AppColors.primaryColor

                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MyProfileScreen._buildStarIcon(AppColors.yellowColor, Icons.star),addWidth(4),
                                        MyProfileScreen._buildStarIcon(AppColors.yellowColor, Icons.star),addWidth(4),
                                        MyProfileScreen._buildStarIcon(AppColors.yellowColor, Icons.star),addWidth(4),
                                        MyProfileScreen._buildStarIcon(AppColors.yellowColor, Icons.star),addWidth(4),
                                        MyProfileScreen._buildStarIcon(Color(0xffDDCFF2), Icons.star, iconColor: AppColors.primaryColor),addWidth(4),
                                        MyProfileScreen._buildDayCircle("F"),addWidth(4),
                                        MyProfileScreen._buildDayCircle("S"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),

                              Row(
                                children: [
                                  addText400('Badges Achieved',fontSize: 20, height: 22,fontFamily: 'Caprasimo', color: AppColors.primaryColor),
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
                              Container(
                                height: Platform.isIOS?170:130,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: logic.badges.length,
                                  itemBuilder: (context, index) {
                                    final badge = logic.badges[index];
                                    return ListTile(
                                      onTap: (){
                                        // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                        // if(badge.title=="Health Apprentice"){
                                        //   Get.to(HealthApprenticeBadgeScreen());
                                        // }else if(badge.title=="Wellness Watcher"){
                                        //   Get.to(WellnessWatcherBadgeScreen());
                                        // } else if(badge.title=="Health Pro"){
                                        //   Get.to(HealthProBadgeScreen());
                                        // } else if(badge.title=="Health Whiz"){
                                        //   Get.to(()=>HealthWhizBadgeScreen());
                                        // } else if(badge.title=="Grandmaster of Health"){
                                        //   Get.to(()=>GrandmasterHealthBadgeScreen());
                                        // }
                                      },
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity: VisualDensity(vertical: -3),
                                      leading: Image.asset(badge.icon,height: 52,width: 41,),
                                      title: addText400(badge.title,fontSize: 16,height: 27.16,fontFamily: 'Caprasimo'),
                                      subtitle: addText500(badge.description,fontSize: 16,height: 22,color: AppColors.blackColor),
                                      trailing: addText400(badge.date,fontSize: 12),
                                    );
                                  },
                                ),
                              ),

                              addHeight(12)
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
                              if(Get.find<EditProfileController>().selectedFile.isNotEmpty)
                                Container(
                                  height: 98,width: 98,
                                  // clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor,width: 2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: Image.file(File(Get.find<EditProfileController>().selectedFile[0]!.path.toString()),fit: BoxFit.cover)),
                                ),
                              if(Get.find<EditProfileController>().selectedFile.isEmpty)
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
            color: isBgColor ? AppColors.primaryColor : null,
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

                    color: isBgColor ? AppColors.whiteColor : AppColors.primaryColor),
                addText400(label, fontSize: 12,
                    decoration: label.toLowerCase()=="friends"?TextDecoration.underline:null,
                    color: isBgColor ? AppColors.whiteColor : label.toLowerCase()=="friends"?AppColors.primaryColor:AppColors.blackColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
