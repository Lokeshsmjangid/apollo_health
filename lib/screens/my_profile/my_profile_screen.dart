
import 'dart:io';
import 'package:apollo/bottom_sheets/badge_achieved_bottom_sheet.dart';
import 'package:apollo/controllers/edit_profile_ctrl.dart';
import 'package:apollo/controllers/my_profile_ctrl.dart';
import 'package:apollo/resources/Apis/api_repository/blurStatusProfile_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/ads/ads_example.dart';
import 'package:apollo/screens/app_subscriptions/premium_plan_ctrl.dart';
import 'package:apollo/screens/app_subscriptions/premium_plan_screen.dart';
import 'package:apollo/screens/my_profile/hp_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();

  static Widget _buildStarIcon(Color background, IconData icon, {Color? iconColor,String date=''}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: background,
          child: Image.asset(AppAssets.starIcon,color: iconColor??AppColors.settingTxtColor1,).marginAll(8),
        ),
        addText400(date,fontSize: 12)
      ],
    );
  }

  static Widget _buildDayCircle(String letter,{String date=''}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white,
          child: addText400(letter, fontSize: 12,color: AppColors.blackColor),
        ),
        addText400(date,fontSize: 12)
      ],
    );
  }

}

class _MyProfileScreenState extends State<MyProfileScreen> {

  // bool _showBlur = true;  // Show blur initially
  // final GlobalKey _hpKey = GlobalKey();
  // Rect? _hpRect;
  PremiumPlanCtrl planCtrl=Get.find<PremiumPlanCtrl>();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   apolloPrint(message: 'blur stats:::${AuthData().userModel?.blurStatus}');
    //
    //   setState(() {
    //     _showBlur = AuthData().userModel?.blurStatus==1?true:false;
    //     _hpRect = _getWidgetRect(_hpKey);
    //   });
    // });
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      planCtrl.setupPurchaseListener();
      await planCtrl.initStoreInfo();
      // await planCtrl.checkSubscription();

      planCtrl.restoreSubscription();
    });
  }

  // Rect? _getWidgetRect(GlobalKey key) {
  //   final box = key.currentContext?.findRenderObject() as RenderBox?;
  //   if (box == null || !box.hasSize) return null;
  //   final offset = box.localToGlobal(Offset.zero);
  //   // Move hole 20 pixels up
  //   final adjustedOffset = Offset(offset.dx, offset.dy - MediaQuery.sizeOf(context).height*0.2);
  //
  //   return adjustedOffset & box.size;
  //   // return offset & box.size;
  // }
  // Exit from app
  int time = 0;
  bool back = false;
  int duration = 1000;
  Future<bool> willPop() async{
    int now = DateTime.now().millisecondsSinceEpoch;
    if(back && time >= now){
      back = false;
      exit(0);
    }
    else{
      time =  DateTime.now().millisecondsSinceEpoch+ duration;
      print("again tap");
      back = true;
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Press again the button to exit")));
      showToastBack(context,'Press back again to exit.');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: WillPopScope(
        onWillPop: willPop,
        child: Stack(
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

                    addHeight(10),

                    Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           /*IconButton(
                                visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                                onPressed: (){
                                  // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                  Get.toNamed(AppRoutes.settingsScreen);
                                  // Get.to(()=>WellnessWatcherBadgeScreen());
                                }, icon: Image.asset(AppAssets.settingsIcon,height: 24,width: 24)),*/
                            /*IconButton(
                                visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                                onPressed: (){
                                  Get.toNamed(AppRoutes.editProfileScreen)?.then((val) {
                                    if (logic.updateProfile) {
                                      logic.getProfile();
                                    }
                                  });
                                }, icon: Image.asset(
                              AppAssets.editProfileIcon,
                              height: 26,color: AppColors.whiteColor,
                            )),*/

                            GestureDetector(
                              onTap: (){
                                Get.toNamed(AppRoutes.settingsScreen)?.then((btmSetstate){
                                  setState(() {});
                                });
                              },
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    // color: Colors.red,
                                    shape: BoxShape.circle
                                ),
                                child: Image.asset(
                                  AppAssets.settingsIcon,color: AppColors.whiteColor,
                                ).marginAll(6),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Get.toNamed(AppRoutes.editProfileScreen)?.then((val) {
                                  if (logic.updateProfile) {
                                    logic.getProfile();
                                  }
                                  setState(() {});
                                });
                              },
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    // color: Colors.red,
                                    shape: BoxShape.circle
                                ),
                                child: Image.asset(
                                  AppAssets.editProfileIcon,color: AppColors.whiteColor,
                                ).marginAll(6),
                              ),
                            )
                          ],
                        ).marginSymmetric(horizontal: 16),

                    addHeight(68),
                    Expanded(
                      child:
                      // logic.isDataLoading ? buildCpiLoader() :
                      Stack(
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
                            child: Column(
                              // physics: NeverScrollableScrollPhysics(),
                              // padding: EdgeInsets.zero,
                              children: [
                                // addHeight(16),
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

                                          if(AuthData().isPremium)
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
                                        '${AuthData().userModel?.country??""} • Joined ${logic.profileModel.data?.joinDate??''}',
                                        fontSize: 12, color: AppColors.textColor)),
                                // addHeight(2),
                                Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: (){
                                        Get.to(()=>PremiumPlanScreen())?.then((value){
                                          logic.update();
                                          setState(() {});
                                        });
                                        // Get.to(()=>SubscriptionScreen())?.then((val){
                                        //   logic.update();
                                        // });
                                      },

                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                                        decoration: BoxDecoration(
                                          // color: Colors.red,
                                          borderRadius: BorderRadius.circular(4)
                                        ),
                                        child: addText500(
                                            'Subscription - ${AuthData().userModel?.subscriptionDetail?.planId == "monthly_plan"
                                                ? "Premium Plan"
                                                : AuthData().userModel?.subscriptionDetail?.planId == "yearly_plan"
                                                ? "Premium Plan"
                                                : "Starter Plan"}',
                                            fontSize: 14, color: AppColors.primaryColor,decoration: TextDecoration.underline),
                                      ),
                                    )),
                                addHeight(10),

                               Expanded(
                                 child: SingleChildScrollView(
                                   physics: BouncingScrollPhysics(),
                                   child: Column(
                                     children: [
                                       // Stats
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           _buildStatCard(
                                             onTap: (){
                                               Get.to(()=>HpHistoryScreen());
                                             },
                                             cardKey: logic.hpKey,
                                             AppAssets.coinIcon, '${logic.profileModel.data?.xp??0}', 'Total HP',
                                           ),
                                           addWidth(13),
                                           _buildStatCard(AppAssets.globeIcon, '${logic.profileModel.data?.rank??0}', 'Global Rank'),
                                         ],
                                       ),

                                       addHeight(12),

                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           _buildStatCard(
                                               onTap: (){
                                                 Get.toNamed(AppRoutes.myFriendsScreen)?.then((val){
                                                   logic.getProfile();
                                                 });
                                               },
                                               isBgColor: false, AppAssets.usersIcon, '${logic.profileModel.data?.friendCount??0}', 'Friends'),
                                           addWidth(13),
                                           _buildStatCard(
                                               onTap: (){},
                                               isBgColor: false, AppAssets.chartBarIcon, '${logic.profileModel.data?.friendRank??0}', 'Friend Rank'),
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
                                             GestureDetector(
                                               onTap: (){
                                                 // Get.to(()=>CustomAdScreen());
                                               },
                                               child: addText400("Daily Streak",fontSize: 20, height: 22,fontFamily: 'Caprasimo',
                                                   color: AppColors.primaryColor),
                                             ),
                                             if(logic.profileModel.data!=null)
                                               const SizedBox(height: 8),
                                             if(logic.profileModel.data!=null)
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                 children: List.generate(logic.profileModel.data!.streakCalendar!.length,(index){
                                                   final streak = logic.profileModel.data!.streakCalendar![index];
                                                   return DateTime.parse('${streak.date}').day==DateTime.now().day
                                                       ? MyProfileScreen._buildStarIcon(date: '${DateTime.parse('${streak.date}').day}',AppColors.purple100Color, Icons.star,iconColor: AppColors.primaryColor).marginOnly(right: 4)
                                                       : streak.active==true? MyProfileScreen._buildStarIcon(date: '${DateTime.parse('${streak.date}').day}',AppColors.yellowColor, Icons.star,).marginOnly(right: 4)
                                                       : MyProfileScreen._buildDayCircle("${streak.weekDay}",date: '${DateTime.parse('${streak.date}').day}');
                                                 }),
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
                                       // SizedBox(
                                       //   height: Platform.isIOS?170:130,
                                       //   child:
                                       logic.profileModel.data!=null && logic.profileModel.data!.badges!.isNotEmpty
                                           ? ListView.builder(
                                         padding: EdgeInsets.zero,
                                         shrinkWrap: true,
                                         physics: NeverScrollableScrollPhysics(),
                                         itemCount: logic.profileModel.data?.badges?.length,
                                         // itemCount: 10,
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
                                             leading: image!=null? Image.asset(image,height: 52,width: 41,): SizedBox.shrink(),
                                             title: addText400(badge?.badge??'',fontSize: 16,height: 27.16,fontFamily: 'Caprasimo'),
                                             subtitle: addText500(badge?.description??'',fontSize: 16,height: 22,color: AppColors.blackColor),
                                             trailing: addText400(badge?.createdAt??'',fontSize: 12),
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
                                       // ),
                                       addHeight(36)
                                     ],
                                   ),
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
                                    networkImageUrl: logic.profileModel.data?.profileImage??'https://apollomedgames.com/public/user.png',
                                    selectedFiles: Get.find<EditProfileController>().selectedFile),
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
                                          child: Image.network('${AuthData().userModel?.countryFlag}',fit: BoxFit.cover))),
                                ),

                                // badge achieved
                                if(logic.profileModel.data!=null && logic.profileModel.data!.badgeAchived != null)
                                Positioned(
                                  top: -20,
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

                          // Blur overlay on top except Total HP card
                          if (logic.showBlur!=null && logic.showBlur==true && logic.hpRect != null)
                            Positioned.fill(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  logic.showBlur = false;
                                  setState(() {});
                                  blurProfileApi(blurStatus: 0).then((blur){
                                    if(blur.status==true){
                                      // logic.showBlur = false;
                                      // setState(() {});
                                     //  AuthData().userModel?.blurStatus=0;
                                     //  LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(AuthData().userModel?.toJson()) ?? '');
                                     //
                                     // setState(() {
                                     //   Future.delayed(Duration(seconds: 2),(){
                                     //     AuthData().getLoginData();
                                     //   });
                                     // });
                                    }});},
                                child: Stack(
                                  children: [
                                    // BackdropFilter(
                                    //   filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    //   child: Container(color: Colors.black.withOpacity(0.8)),
                                    // ),
                                    CustomPaint(
                                      size: Size.infinite,
                                      painter: HoleBlurPainter(holeRect: logic.hpRect!),
                                    ),

                                    // to shows "Tap here" text above the hole
                                    Positioned(
                                      left: logic.hpRect!.left,
                                      top: logic.hpRect!.top - 40,
                                      width: logic.hpRect!.width,
                                      child: Center(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.yellow[700],
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                                            ],
                                          ),
                                          child: addText500(
                                            "Tap here to see HP history",
                                            fontSize: 12,color: AppColors.whiteColor,textAlign: TextAlign.center
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
      ),
    );
  }

  Widget buildProfileImage({
  void Function()? onTap,
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
    );}

  Widget _buildStatCard(String icon, String value, String label,
      {VoidCallback? onTap,bool isBgColor = true, Key? cardKey}) { return GestureDetector(
      onTap: onTap,
      child: Container(
        key: cardKey,
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
    );}


  // Profile Shimmer
  _buildProfileShimmer(){
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          _buildCircle(height: 100, width: 100),
          const SizedBox(height: 16),
          _buildRect(height: 20, width: 160),
          const SizedBox(height: 8),
          _buildRect(height: 14, width: 120),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatCard1(),
              const SizedBox(width: 12),
              _buildStatCard1(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatCard1(),
              const SizedBox(width: 12),
              _buildStatCard1(),
            ],
          ),
          const SizedBox(height: 24),
          _buildRect(height: 20, width: 180),
          const SizedBox(height: 16),
          SizedBox(
            height: 70,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) => _buildCircle(height: 32, width: 32),
            ),
          ),
          const SizedBox(height: 24),
          _buildRect(height: 20, width: 180),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  _buildRect(height: 52, width: 41),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRect(height: 16, width: 140),
                        const SizedBox(height: 4),
                        _buildRect(height: 14, width: 200),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildRect(height: 12, width: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildRect({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      color: Colors.white,
    );
  }

  Widget _buildStatCard1() {
    return Container(
      height: 68,
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildCircle(height: 32, width: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRect(height: 14, width: 60),
              const SizedBox(height: 4),
              _buildRect(height: 12, width: 50),
            ],
          )
        ],
      ),
    );
  }

}
class HoleBlurPainter extends CustomPainter {
  final Rect holeRect;

  HoleBlurPainter({required this.holeRect});

  @override
  void paint(Canvas canvas, Size size) {
    Path background = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    Path hole = Path()..addRRect(RRect.fromRectAndRadius(holeRect, const Radius.circular(16)));
    Path overlay = Path.combine(PathOperation.difference, background, hole);

    Paint paint = Paint()..color = Colors.black.withOpacity(0.8);

    canvas.drawPath(overlay, paint);
  }

  @override
  bool shouldRepaint(covariant HoleBlurPainter oldDelegate) {
    return oldDelegate.holeRect != holeRect;
  }
}


// Wo Error nhi hai sir
//
// uss ka matlab hai ki Testing ke liye koi bhi banner available nhi hai