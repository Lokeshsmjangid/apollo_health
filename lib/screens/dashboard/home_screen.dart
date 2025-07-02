
import 'package:apollo/bottom_sheets/badge_achieved_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/daily_dose_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/delete_account_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/group_play_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/group_play_request_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/high_stack_mode_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/leave_quiz_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/like_question_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/live_challenge_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/live_challenge_register_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/medpardy_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/ready_more_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/sign_out_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/solo_play_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/stuck_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/unlock_exclusive_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/wheel%20_Of_Wellness_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/winner_takes_all_one_table_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/winner_takes_mode_bottom_sheet.dart';
import 'package:apollo/controllers/bottom_bar_ctrl.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/screens/badge_screens/grandmaster_health_badge_screen.dart';
import 'package:apollo/screens/badge_screens/health_apprentice_badge_screen.dart';
import 'package:apollo/screens/game_mode/solo_play/quiz_screen_new.dart';
import 'package:apollo/screens/game_mode/wheel_of_wellness/wheel_of_wellness_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

    await _audioPlayer.play(AssetSource(sound));

  }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _playBackgroundSound();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopBackgroundSound();
  }


  Future<void> _playBackgroundSound() async {
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop); // Loop the sound
    await _backgroundPlayer.play(AssetSource(AppAssets.backGroundGameSound));
  }

  void stopBackgroundSound() {
    _backgroundPlayer.stop();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primaryLightColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: (){
                  Get.toNamed(AppRoutes.notificationsScreen);
                },
                icon: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SvgPicture.asset(
                      AppAssets.bellSvgFillIcon, // :AppAssets.bellSvgUnFillIcon---bellSvgFillIcon,
                      color:AppColors.primaryColor // :Color(0xff67656B),
                     , height: 24, width: 24,
                    ),
                    // if(logic.selectedIndex!=3)
                      Positioned(
                          top: 0,
                          right: 4,
                          child: Container(height: 6,width: 6,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,color: AppColors.redColor,
                                border: Border.all(width: 1,color: Colors.white)

                            ),))
                  ],
                ),
                addHeight(2),
                // logic.selectedIndex ==3
                //     ? addText700('Profile',fontSize: 10,color: AppColors.blackColor)
                //     : addText500('Profile',fontSize: 10,color: AppColors.textFieldHintColor)

              ],
            )),
          ],

          title:  addText400(
            "Game Modes",
            fontSize: 32,
            height: 40,
            color: AppColors.primaryColor,
            fontFamily: 'Caprasimo',

          ),),
      body: Stack(
        children: [
          // SizedBox(
          //     width: double.infinity,
          //     height: MediaQuery.sizeOf(context).height,
          //     child: Image.asset(AppAssets.homeEffectBg,fit: BoxFit.fill,)),SizedBox(
          //     width: double.infinity,
          //     height: MediaQuery.sizeOf(context).height,
          //     child: Image.asset(AppAssets.homeEffectBg,fit: BoxFit.fill,)),

          SafeArea(
            child: Column(
              children: [
                // userHeaderCard(),
                addHeight(12),
                Expanded( child: SingleChildScrollView(
                child: Column(
                  children: [


                    gameModeGrid().marginSymmetric(horizontal: 16),

                    addHeight(10),
                    liveChallengeCard(onTapInfo: (){
                      showLiveChallengesSheet(context);
                    }),
                    addHeight(12)

                  ],
                ),
              ))
              ]))]));
  }

  Widget userHeaderCard() {
    return Stack(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20)
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.textFieldBorderColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: (){
                  Get.find<BottomBarController>().selectedIndex = 3;
                  Get.find<BottomBarController>().update();
                },
                child: CircleAvatar(
                  radius: 24,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(AppAssets.profileImg),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(child: addText500('Zain Vaccaro', fontSize: 16,height: 22)),

              GestureDetector(
                onTap: (){
                  // WinnertakeModeSheet(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.primaryLightColor)
                  ),
                  child: Row(
                    children: [
                      Image.asset(AppAssets.coinIcon, height: 20),
                      addWidth(6),
                      addText400('448 HP',fontSize: 12,)
                    ],
                  ),

                ),
              ),
              addWidth(12),
              GestureDetector(
                onTap: (){
                  // showDailyDoseSheet(context);
                  Get.toNamed(AppRoutes.notificationsScreen);
                },
                child: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                  ),
                  child: Stack(
                    children: [
                      Image.asset(AppAssets.bellIcon),
                      Positioned(
                          top: 2,
                          right: 4,
                          child: Container(height: 6,width: 6,decoration: BoxDecoration(
                              shape: BoxShape.circle,color: AppColors.redColor

                          ),))
                    ],
                  ),

                ),
              ),
            ],
          ),
        ).marginOnly(top: 6),
      ],
    ).marginSymmetric(horizontal: 16);
  }

  Widget liveChallengeCard({void Function()? onTapInfo}) {
    return Stack(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
              color: AppColors.textFieldBorderColor,
              // color: AppColors.redColor,
              borderRadius: BorderRadius.circular(20)
          ),
        ).marginSymmetric(horizontal: 4),
        GestureDetector(
          onTap: (){
            Get.toNamed(AppRoutes.registerLiveChallengeScreen)?.then((value){
              _playBackgroundSound();
            });
            stopBackgroundSound();
          },
          child: Stack(
            children: [
              Container(
                height: 84,
                // padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                  // border: Border.all(color: AppColors.blackColor),
                  // image: DecorationImage(image: AssetImage(AppAssets.liveChallengeSvgImg),fit: BoxFit.fill)
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    addText400('Live Challenge',
                        fontFamily: 'Caprasimo',
                        fontSize: 18,
                        color: AppColors.whiteColor).marginOnly(left: 16),
                    Spacer(),
                    SvgPicture.asset(AppAssets.liveChallengeSvgImg,fit: BoxFit.cover)
                    // Icon(Icons.info_outline, color: Colors.white),
                  ],
                ),
              ).marginOnly(top: 6),
              Positioned(
                right: 16,
                top: 16,
                child: GestureDetector(
                    onTap: onTapInfo,
                    child: Icon(Icons.info_outline, size: 20,color: AppColors.whiteColor,)),
              ),
            ],
          ),
        ),
      ],
    ).marginSymmetric(horizontal: 16);
  }

  Widget gameCard({
    required String title,
    required String imagePath,
    bool isLocked = false,
    VoidCallback? onTap,
    VoidCallback? onInfoTap,
  }) {
    return GestureDetector(
      // onTap: onTap,
      onTap: (){
        // effectSound(sound: AppAssets.actionButtonTapSound);

        if(isLocked==false && title=='Solo Play'){
          Get.toNamed(AppRoutes.gMSoloPlayScreen)?.then((value){
            _playBackgroundSound();
          });
          stopBackgroundSound();
        }
        else if(isLocked==false && title=="Group Play"){
          Get.toNamed(AppRoutes.gMGroupPlayScreen)?.then((value){
            _playBackgroundSound();
          });
          stopBackgroundSound();
        }
        else if(isLocked==true && title=="Medpardy"){
          Get.toNamed(AppRoutes.medpardyChooseFriendScreen)?.then((value){
            _playBackgroundSound();
          });
          stopBackgroundSound();
        }
        else if(isLocked==true && title=="Wheel of Wellness"){
          Get.to(WheelOfWellnessScreen())?.then((value){
            _playBackgroundSound();
          });
          stopBackgroundSound();
        }
        else{
          showUnlockExclusiveSheet(context);
        }
      },
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.textFieldBorderColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                        image: AssetImage(imagePath),fit: BoxFit.cover)
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            constraints: BoxConstraints(maxWidth: 100),
                            alignment: Alignment.topLeft,
                            child: addText400(title,
                                fontSize: 18,maxLines: 2,fontFamily: 'Caprasimo',color: AppColors.whiteColor)),

                      ],
                    ).marginOnly(top: 14,left: 12,right: 12),
                    // Image.asset(imagePath,fit: BoxFit.cover),
                  ],
                ),

              ).marginOnly(top: 6),

              if(isLocked)
                Positioned(
                    top: 0,bottom: 0,left: 0,right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isLocked?AppColors.blackColor.withOpacity(0.31):null,

                      ),
                      // child: Image.asset(AppAssets.lockIcon,height: 50,width: 50,),
                    )),
              if(isLocked)
                Positioned(
                    top: 0,bottom: 0,left: 0,right: 0,
                    child: Center(
                      child: Image.asset(AppAssets.lockIcon,height: 50,width: 50,),
                    )),

              Positioned(
                top: 14,right: 12,
                child: GestureDetector(
                    onTap: onInfoTap,
                    child: Icon(Icons.info_outline, size: 20,color: AppColors.whiteColor,)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gameModeGrid() {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.zero,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 3/4.2,
      // clipBehavior: Clip.an,
      children: [
        gameCard(
            title: 'Solo Play',
            imagePath: AppAssets.soloPlayImg1Svg,
            onInfoTap: (){
              // effectSound(sound: AppAssets.actionButtonTapSound);
              showSoloPlaySheet(context);}),
        gameCard(
            title: 'Group Play',
            imagePath: AppAssets.groupPlayImg1,
            onInfoTap: (){
              // effectSound(sound: AppAssets.actionButtonTapSound);
              showGroupPlaySheet(context);}),
        gameCard(
            title: 'Medpardy',
            imagePath: AppAssets.medpardyImg1,
            isLocked: true,
            onInfoTap: (){
              // effectSound(sound: AppAssets.actionButtonTapSound);
              showMedpardySheet(context);
            }),
        gameCard(title: 'Wheel of Wellness', imagePath: AppAssets.wheelOfWellnessImg1, isLocked: true,
            onInfoTap: (){
              // effectSound(sound: AppAssets.actionButtonTapSound);
              showWheelOfWellnessSheet(context);}),
      ],
    );
  }

}
