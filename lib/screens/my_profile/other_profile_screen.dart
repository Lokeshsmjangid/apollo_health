
import 'package:apollo/resources/Apis/api_repository/add_friend_repo.dart';
import 'package:apollo/bottom_sheets/badge_achieved_bottom_sheet.dart';
import 'package:apollo/custom_widgets/online_status_dot_screen.dart';
import 'package:apollo/controllers/other_profile_ctrl.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
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
                  addHeight(10),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: backButton(
                                  onTap: (){Get.back();
                              },backButtonColor: AppColors.whiteColor).marginOnly(left: 16)),


                          if(AuthData().userModel?.roleId !=4 )
                          logic.isMyFriend ==null || logic.isMyFriend==true?SizedBox.shrink():Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: (){

                                  showLoader(true);
                                  addFriendApi(userId: logic.profileModel.data?.id).then((value){
                                  showLoader(false);
                                  if(value.status==true){
                                  logic.isMyFriend=true;
                                  logic.update();
                                  }else if(value.status==false){
                                  CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${value.message}');
                                  }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: addText400('Add',fontSize: 12,color: AppColors.blackColor).marginSymmetric(horizontal: 6,vertical: 4),
                                ).marginOnly(right: 10),
                              )),
                        ],
                      ),


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
                               // name and premium user symbol
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        addText700(
                                          titleCase(getTruncatedName('${logic.profileModel.data?.firstName ?? ''}',
                                              '${logic.profileModel.data?.lastName ?? ''}')),

                                          fontSize: 22,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          color: AppColors.blackColor,
                                        ),

                                        if(logic.profileModel.data?.subscription==1)
                                        Image.asset(
                                          AppAssets.premiumProfileIcon,
                                          height: 19,
                                          width: 19,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              addHeight(2),
                              Align(
                                  alignment: Alignment.center,
                                  child: addText400(
                                      '${logic.profileModel.data?.country??''} • Joined ${logic.profileModel.data?.joinDate??''}',
                                      fontSize: 12, color: AppColors.textColor)),
                              addHeight(10),

                              Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: (){
                                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                      Get.toNamed(AppRoutes.mutualFriendScreen,arguments: {'friend_id':logic.friendId});
                                    },
                                    child: addText500(
                                        '${logic.profileModel.data?.mutualFriendCount??0} Mutual Friends',
                                        decoration: TextDecoration.underline,
                                        fontSize: 16, color: AppColors.primaryColor),
                                  )),
                              addHeight(20),

                              // Stats
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildStatCard(AppAssets.friendsIcon, '${logic.profileModel.data?.friendCount??0}', 'Friends'),
                                  addWidth(13),
                                  _buildStatCard(AppAssets.coinIcon, '${logic.profileModel.data?.xp??0}', 'Total HP'),
                                ],
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

                              SingleChildScrollView(
                                // height: Platform.isIOS?170:130,
                                child: logic.profileModel.data!=null && logic.profileModel.data!.badges!.isNotEmpty
                                    ? ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: logic.profileModel.data?.badges?.length,
                                  itemBuilder: (context, index) {
                                    String? image;
                                    final badge = logic.profileModel.data?.badges?[index];
                                    String badgeTitle = '${badge?.badge}'.toLowerCase();
                                    switch (badge?.badge?.toLowerCase()) {
                                      case 'health apprentice':
                                        image = AppAssets.healthApprenticeBadge;
                                        break;
                                      case 'wellness watcher':
                                        image = AppAssets.wellnessWatcherBadge;
                                        break;
                                      case 'health pro':
                                        image = AppAssets.healthProBadge;
                                        break;
                                      case 'health whiz':
                                        image = AppAssets.healthBadge;
                                        break;
                                      case 'grandmaster of health':
                                        image = AppAssets.grandmasterOfHealthBadge;
                                        break;
                                    }
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity: VisualDensity(vertical: -3),
                                      leading: image!=null? Image.asset(image,height: 52,width: 41,): SizedBox.shrink(),
                                      title: addText400(badge?.badge??'',fontSize: 16,height: 27.16,fontFamily: 'Caprasimo'),
                                      subtitle: addText500(badge?.description??'',fontSize: 16,height: 22,color: AppColors.blackColor),
                                      trailing: addText400(badge?.createdAt??'',fontSize: 12),
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
                                    );
                                  },
                                )
                                    : Center(child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'No badges... ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'yet.',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic, // Only "yet." is italic
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                ),
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
                              buildProfileImage(
                                  networkImageUrl: logic.profileModel.data?.profileImage,),

                              Positioned(
                                right: 0,
                                bottom: 0,

                                child: Container(
                                    width: 42,height: 28,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.whiteColor,width: 2),
                                        borderRadius: BorderRadius.circular(5)

                                    ),
                                    child: ClipRRect(
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        borderRadius: BorderRadius.circular(3),
                                        child: CachedImageCircle2(imageUrl: '${logic.profileModel.data?.countryFlag}',fit: BoxFit.cover,isCircular: false))),
                              ),

                              // for online offline
                              if(logic.profileModel.data!=null && logic.profileModel.data!.onlineStatusVisible==1)
                              Positioned(
                                top: 10,
                                right: 10,
                                // bottom: 0,
                                child: OnlineStatusDot(lastActiveTime: DateTime.parse(logic.profileModel.data?.userActive??"")),

                                /*child: Container(
                                    height: 12,width: 12,
                                    decoration: BoxDecoration(
                                      color: logic.profileModel.data!.onlineStatusVisible==0?AppColors.redColor1:AppColors.green500Color,
                                      shape: BoxShape.circle)),*/
                              ),

                              // badge achieved
                              if(logic.profileModel.data!=null && logic.profileModel.data!.badgeAchived != null)
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
                                        child: addText400('${logic.profileModel.data!.badgeAchived}', fontFamily: 'Caprasimo', fontSize: 14,).marginSymmetric(horizontal: 14,vertical: 6),
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

  Widget buildProfileImage({
    required String? networkImageUrl,
    double size = 98,
    Color borderColor = Colors.deepPurple, // Replace with AppColors.primaryColor if needed
    double borderWidth = 2,
  }) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child:CachedImageCircle2(imageUrl: networkImageUrl)

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
