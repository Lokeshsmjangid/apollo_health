import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:apollo/bottom_sheets/category_ready_more_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/group_play_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/group_play_rules_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/live_challenge_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/madlingo_rules_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/medlingo_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/medpardy_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/medpardy_play_rules_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/solo_play_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/solo_play_rules_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/unlock_exclusive_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/wheel%20_Of_Wellness_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/wheel_for_wellness_rules_bottom_sheet.dart';
import 'package:apollo/controllers/app_push_nottification.dart';
import 'package:apollo/controllers/bottom_bar_ctrl.dart';
import 'package:apollo/controllers/home_ctrl.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_repository/category_repo.dart';
import 'package:apollo/resources/Apis/api_repository/fetch_subscription_repo.dart';
import 'package:apollo/resources/Apis/api_repository/home_blur_status_repo.dart';
import 'package:apollo/resources/Apis/api_repository/one_day_pass_repo.dart';
import 'package:apollo/resources/Apis/api_repository/start_medlingo_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/ads/free_pass_ads_screen.dart';
import 'package:apollo/screens/app_subscriptions/premium_plan_ctrl.dart';
import 'package:apollo/screens/game_mode/live_challenges/challenges_list_screen.dart';
import 'package:apollo/screens/game_mode/medlingo/medlingo.dart';
import 'package:apollo/screens/game_mode/wheel_of_wellness/wheel_of_wellness_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../resources/Apis/api_models/category_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  CategoryModel model = CategoryModel();
  List<Category> categories = [];
  final GlobalKey _medpardyKey = GlobalKey();
  bool _showOverlay = true; // Control overlay visibility
  String generateRandomWord({int maxLength = 12}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    final random = Random();

    // Generate random length between 1 and maxLength (inclusive)
    final length = random.nextInt(maxLength) + 1;

    // Generate random word of that length
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      AuthData().getLoginData();
      getAllCategoryData();
    });
  }


  bool catLoading = false;

  getAllCategoryData() async {
    catLoading = true;
    setState(() {});
    await getAllCategoryApi().then((value) {
      model = value;
      if (model.data != null && model.data!.isNotEmpty) {
        categories.addAll(model.data!);
      }
      catLoading = false;
      if(mounted)
      setState(() {});
    });
  }


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
    return GetBuilder<HomeController>(builder: (logic) {
      return Scaffold(
          backgroundColor: AppColors.primaryLightColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () {
                logic.stopBackgroundSound();
                Get.toNamed(AppRoutes.myFriendsScreen)?.then((value) {
                  logic.playBackgroundSound();
                });
              },
              child: SvgPicture
                  .asset(AppAssets.homeFriendCircleIcon,)
                  .marginOnly(
                  left: 16, right: 8),
            ),
            centerTitle: true,
            actions: [

              GestureDetector(
                  onTap: () {
                    logic.stopBackgroundSound();
                    Get.find<AppPushNotification>().isNew.value = false;
                    Get.find<AppPushNotification>().update();
                    Get.toNamed(AppRoutes.notificationsScreen)?.then((value) {
                      logic.playBackgroundSound();
                    });
                  },
                  child: Obx(() {
                    return Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: AppColors.redColor
                      ),
                      child: Get
                          .find<AppPushNotification>()
                          .isNew
                          .value ? Stack(
                        children: [
                          Lottie.asset(
                              'assets/Lottie/Animation - 1751888767592.json',
                              delegates: LottieDelegates(
                                  values: [
                                    ValueDelegate.color(const ['**'], value: AppColors.primaryColor),
                                  ]
                              )
                          ),
                          Positioned(
                              top: 2,
                              right: 6,
                              child: Container(height: 8, width: 8,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.redColor,
                                    border: Border.all(
                                        width: 1, color: Colors.white)

                                ),))
                        ],
                      ) : Image.asset(AppAssets.bellIcon, color: AppColors
                          .primaryColor,),
                    );
                  })).marginSymmetric(horizontal: 12)
            ],

            title: addText400(
              "Game Modes",
              fontSize: 32,
              height: 40,
              color: AppColors.primaryColor,
              fontFamily: 'Caprasimo',

            ),),
          body: WillPopScope(
            onWillPop: willPop,
            child: Stack(
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
                            Expanded(child: SingleChildScrollView(
                              child: Column(
                                children: [


                                  gameModeGrid().marginSymmetric(horizontal: 16),

                                 /* addHeight(10),
                                  liveChallengeCard(onTapInfo: () {
                                    showLiveChallengesSheet(context);
                                  }),*/
                                  addHeight(10),
                                  liveMadlingoCard(
                                    isLocked: AuthData().isPremium==true || AuthData().isPremiumMedLingo==1?false:true,
                                      onTapInfo: () {
                                        showMedLingoSheet(context);
                                      },
                                      onTapFile: () {showMedlingoRulesSheet(context,);},
                                  ),
                                  addHeight(12)

                                ],
                              ),
                            ))
                          ])),
                  
                  // Overlay with hole over Medpardy card
                  if (_showOverlay && AuthData().userModel?.homeBlurStatus==1) _buildOverlayWithHole(context)
                ]),
          ));
    });
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
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.textFieldBorderColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
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
              Expanded(
                  child: addText500('Zain Vaccaro', fontSize: 16, height: 22)),

              GestureDetector(
                onTap: () {
                  // WinnertakeModeSheet(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.primaryLightColor)
                  ),
                  child: Row(
                    children: [
                      Image.asset(AppAssets.coinIcon, height: 20),
                      addWidth(6),
                      addText400('448 HP', fontSize: 12,)
                    ],
                  ),

                ),
              ),
              addWidth(12),
              GestureDetector(
                onTap: () {
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
                          child: Container(
                            height: 6, width: 6, decoration: BoxDecoration(
                              shape: BoxShape.circle, color: AppColors.redColor

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
          onTap: () {
            // Get.toNamed(AppRoutes.registerLiveChallengeScreen)?.then((value){
            //   _playBackgroundSound();
            // });
            Get.to(ChallengesListScreen())?.then((value) {
              Get.find<HomeController>().playBackgroundSound();
            });
            Get.find<HomeController>().stopBackgroundSound();
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
                    SvgPicture.asset(
                        AppAssets.liveChallengeSvgImg, fit: BoxFit.cover)
                    // Icon(Icons.info_outline, color: Colors.white),
                  ],
                ),
              ).marginOnly(top: 6),
              Positioned(
                right: 16,
                top: 16,
                child: GestureDetector(
                    onTap: onTapInfo,
                    child: Icon(Icons.info_outline, size: 20,
                      color: AppColors.apolloGreyColor,)),
              ),
            ],
          ),
        ),
      ],
    ).marginSymmetric(horizontal: 16);
  }

  Widget liveMadlingoCard({void Function()? onTapInfo,
    void Function()? onTapFile,bool isLocked = false}) { return Stack( children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
              color: AppColors.textFieldBorderColor,
              // color: AppColors.redColor,
              borderRadius: BorderRadius.circular(20)
          ),
        ).marginSymmetric(horizontal: 4),
        GestureDetector(
          onTap: () {
            if(isLocked){
              showCategoryReadyMoreSheet(context, isMadPardy: false,
                  onTapUpgrade: () {
                    Get.back();
                    PremiumPlanCtrl controller = Get.isRegistered<PremiumPlanCtrl>()
                        ? Get.find<PremiumPlanCtrl>()
                        : Get.put(PremiumPlanCtrl());
                    WidgetsBinding.instance.addPostFrameCallback((_)async {
                      controller.setupPurchaseListener();
                      await controller.initStoreInfo();

                      controller.restoreSubscription();
                    });
                    Get.find<HomeController>().stopBackgroundSound();
                    Get.toNamed(AppRoutes.subscriptionScreen)?.then((vald) {
                      Get.find<HomeController>().playBackgroundSound();
                      setState(() {});
                    });
                  },
                  onTap10MinFree: (){
                Get.back();
                Get.to(()=>FreePassAdsScreen(game: 'medlingo'));
                  },
                  onTapDayPass: () {
                    Get.back();
                    Get.find<HomeController>().stopBackgroundSound();

                    showLoader(true);
                    oneDayPassApi(type: 'medlingo').then((value){
                      showLoader(false);
                      if(value.status==true){
                        LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                        AuthData().getLoginData();
                        LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
                        setState(() {});
                        showLoader(true);
                        startMedLingoApi().then((val){
                          showLoader(false);
                          if(val.status==true && val.data!=null){
                            Get.toNamed(AppRoutes.medLingoWordGameScreen,arguments: {'word':val.data!.hiddenTerm!.toUpperCase(),
                              'imageUrl': val.data!.imageUrl??'',
                              'gameData': val.data}
                            // Get.to(()=>MedLingoWordGame(
                            //   word: val.data!.hiddenTerm!.toUpperCase(),
                            //   imageUrl: val.data!.imageUrl??'', // replace image
                            //   gameData: val.data,)
                            )?.then((value) { Get.find<HomeController>().playBackgroundSound();});
                          }else if(val.status==false){
                            CustomSnackBar().showSnack(Get.context!,message: '${val.message}',isSuccess: false);
                          }
                        });
                      } else if(value.status==false){
                        CustomSnackBar().showSnack(Get.context!,message: '${value.message}',isSuccess: false);
                      }
                    });

                  }
              );
            } else{


              Get.find<HomeController>().stopBackgroundSound();
              showLoader(true);
              startMedLingoApi().then((val){
                showLoader(false);
                if(val.status==true && val.data!=null){
                  Get.toNamed(AppRoutes.medLingoWordGameScreen,arguments: {'word':val.data!.hiddenTerm!.toUpperCase(),
                      'imageUrl': val.data!.imageUrl??'',
                      'gameData': val.data}
                  // Get.to(()=>MedLingoWordGame(
                  //   word: val.data!.hiddenTerm!.toUpperCase(),
                  //   imageUrl: val.data!.imageUrl??'', // replace with your actual image
                  //   gameData: val.data,)
                  )?.then((value) { Get.find<HomeController>().playBackgroundSound();});
                }else if(val.status==false){
                  CustomSnackBar().showSnack(Get.context!,message: '${val.message}',isSuccess: false);
                }
              });
            }
          },
          child: Stack(
            children: [
              Stack(
                children: [
                  Container(
                    height: 84,
                    // padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(20),
                      // border: Border.all(color: AppColors.blackColor),
                      image: DecorationImage(image: AssetImage(AppAssets.medlingoCoverImg),fit: BoxFit.fill)
                    ),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: addText400('MedLingo',
                              fontFamily: 'Caprasimo',
                              fontSize: 18,
                              color: AppColors.whiteColor).marginOnly(left: 16,top: 8),
                        ),


                        Spacer(),
                        // Stack(
                        //   clipBehavior: Clip.none,
                        //   children: [
                        //     // Container(
                        //     //     width: 190,height: 80,
                        //     //     child: SvgPicture.asset(AppAssets.medlingoSvgImg, fit: BoxFit.fill)),
                        //     // Positioned(
                        //     //     bottom: 0,
                        //     //     top: 0,
                        //     //     right: 60,
                        //     //     // right: 10,
                        //     //     child: SvgPicture.asset(AppAssets.medlingoMAskotSvgImg, fit: BoxFit.cover,height: 72,)),
                        //   ],
                        // ),


                      ],
                    ),
                  ).marginOnly(top: 6),
                  if(isLocked)
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),topRight: Radius.circular(28),
                            bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20),
                          ),
                          color: AppColors.blackColor.withOpacity(0.31),

                        ),
                        // child: Image.asset(AppAssets.lockIcon,height: 50,width: 50,),
                      )),
                  if(isLocked)
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.asset(
                          AppAssets.lockIcon, height: 50, width: 50,),
                      )),
                ],
              ),
              Positioned(
                right: 16,
                top: 16,
                child: GestureDetector(
                    onTap: onTapInfo,
                    child: Icon(Icons.info_outline, size: 20,
                      color: AppColors.apolloGreyColor,)),
              ),
              Positioned(
                // right: 16,
                left: 2,
                bottom: 4,
                child: GestureDetector(
                    onTap: onTapFile,
                    child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          shape: BoxShape.circle
                        ),
                        child: SvgPicture.asset(AppAssets.fileIcon, color: AppColors.apolloGreyColor,).marginAll(6))),
              ),

            ],
          ),
        )
  ]).marginSymmetric(horizontal: 16);}

  Widget gameCard({
    Key? key,
    required String title,
    required String imagePath,
    bool isLocked = false,
    VoidCallback? onTap,
    VoidCallback? onInfoTap,
    VoidCallback? onFileTap,
  }) { return GestureDetector(
      // onTap: onTap,
      onTap: () {
        // effectSound(sound: AppAssets.actionButtonTapSound);

        if (isLocked == false && title == 'Solo Play') {
          if (!catLoading) {
            Get.toNamed(AppRoutes.gMSoloPlayScreen,
                arguments: {'categories': categories})?.then((value) {
              Get.find<HomeController>().playBackgroundSound();
            });
            Get.find<HomeController>().stopBackgroundSound();
          }
        }
        else if (isLocked == false && title == "Group Play") {
          if (!catLoading) {
            Get.toNamed(AppRoutes.gMGroupPlayScreen,
                arguments: {'categories': categories})?.then((value) {
              Get.find<HomeController>().playBackgroundSound();
            });
            Get.find<HomeController>().stopBackgroundSound();
          }
        }
        else if (isLocked == true && title == "Medpardy") {
          showCategoryReadyMoreSheet(context, isMadPardy: true,
              onTapUpgrade: () {
                Get.back();
                PremiumPlanCtrl controller = Get.isRegistered<PremiumPlanCtrl>()
                    ? Get.find<PremiumPlanCtrl>()
                    : Get.put(PremiumPlanCtrl());
                WidgetsBinding.instance.addPostFrameCallback((_)async {
                  controller.setupPurchaseListener();
                  await controller.initStoreInfo();

                  controller.restoreSubscription();
                });
                Get.find<HomeController>().stopBackgroundSound();
                Get.toNamed(AppRoutes.subscriptionScreen)?.then((vald) {
                  Get.find<HomeController>().playBackgroundSound();
                  setState(() {});
                });
              },
              onTap10MinFree: (){Get.back();
            Get.to(()=>FreePassAdsScreen(game: 'medpardy'));
              },
              onTapDayPass: () {
                Get.back();
                Get.find<HomeController>().stopBackgroundSound();

                showLoader(true);
                oneDayPassApi(type: 'medpardy').then((value){
                  showLoader(false);
                  if(value.status==true){
                    LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                    AuthData().getLoginData();
                    LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
                    setState(() {});
                    Get.toNamed(AppRoutes.medpardyChooseFriendScreen)?.then((value) {
                      Get.find<HomeController>().playBackgroundSound();
                    });
                    CustomSnackBar().showSnack(Get.context!,message: 'You can use a Day Pass only once weekly per game mode.');
                  }
                  else if(value.status==false){
                    CustomSnackBar().showSnack(Get.context!,message: '${value.message}',isSuccess: false);
                  }
                });

              }
          );
        }
        else if (isLocked == true && title == "Wheel of Wellness") {
          showCategoryReadyMoreSheet(context,
              onTapUpgrade: () {
                Get.back();
                PremiumPlanCtrl controller = Get.isRegistered<PremiumPlanCtrl>()
                    ? Get.find<PremiumPlanCtrl>()
                    : Get.put(PremiumPlanCtrl());
                WidgetsBinding.instance.addPostFrameCallback((_)async {
                  controller.setupPurchaseListener();
                  await controller.initStoreInfo();

                  controller.restoreSubscription();
                });
                Get.find<HomeController>().stopBackgroundSound();
                Get.toNamed(AppRoutes.subscriptionScreen)?.then((vald) {
                  Get.find<HomeController>().playBackgroundSound();
                  setState(() {});
                });
              },
              onTap10MinFree: (){Get.back();
              Get.to(()=>FreePassAdsScreen(game: 'wow'));
              },
              onTapDayPass: () {
                Get.back();
                Get.find<HomeController>().stopBackgroundSound();
                showLoader(true);
                oneDayPassApi(type: 'wellness').then((value){
                  showLoader(false);
                  if(value.status==true){
                    LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                    AuthData().getLoginData();
                    LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
                    setState(() {});
                Get.to(WheelOfWellnessScreen())?.then((value) {
                      Get.find<HomeController>().playBackgroundSound();
                    });
                  }
                  else if(value.status==false){
                    CustomSnackBar().showSnack(Get.context!,message: '${value.message}',isSuccess: false);
                  }
                });

              }
          );
        }
        else if(isLocked == false && title == "Medpardy"){
          Get.toNamed(AppRoutes.medpardyChooseFriendScreen)?.then((value) {
            Get.find<HomeController>().playBackgroundSound();
          });
          Get.find<HomeController>().stopBackgroundSound();
        }
        else if (isLocked == false && title == "Wheel of Wellness") {
          Get.to(WheelOfWellnessScreen())?.then((value) {
            Get.find<HomeController>().playBackgroundSound();
          });
          Get.find<HomeController>().stopBackgroundSound();
        }
        else {
          showUnlockExclusiveSheet(context);
        }
      },
      child: IntrinsicHeight(
        child: Container(
          key: key,
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
                        image: AssetImage(imagePath), fit: BoxFit.cover)
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
                                fontSize: 18,
                                maxLines: 2,
                                fontFamily: 'Caprasimo',
                                color: AppColors.whiteColor)),

                      ],
                    ).marginOnly(top: 14, left: 12, right: 12),
                    // Image.asset(imagePath,fit: BoxFit.cover),
                  ],
                ),

              ).marginOnly(top: 6),

              if(isLocked)
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isLocked
                            ? AppColors.blackColor.withOpacity(0.31)
                            : null,

                      ),
                      // child: Image.asset(AppAssets.lockIcon,height: 50,width: 50,),
                    )),
              if(isLocked)
              Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        AppAssets.lockIcon, height: 50, width: 50,),
                    )),

              Positioned(
                top: 8, right: 6,
                child: GestureDetector(
                    onTap: onInfoTap,
                    child: Container(

                        decoration: BoxDecoration(
                          // color: Colors.red,
                            shape: BoxShape.circle),
                        child: Icon(Icons.info_outline, size: 20,
                          color: AppColors.apolloGreyColor,).marginAll(6))),
              ),
              Positioned(
                bottom: 6, left: 2,
                child: GestureDetector(
                    onTap: onFileTap,
                    child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.red,
                            shape: BoxShape.circle),
                        child: SvgPicture
                            .asset(
                          AppAssets.fileIcon, color: AppColors.apolloGreyColor,)
                            .marginAll(6))),
              ),

            ]))
      )); }

  Widget gameModeGrid() {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.zero,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 3 / 4.2,
      children: [
        gameCard(
            title: 'Solo Play',
            imagePath: AppAssets.soloPlayImg1Svg,
            onInfoTap: () {
              // effectSound(sound: AppAssets.actionButtonTapSound);
              showSoloPlaySheet(context);
            },
            onFileTap: () {
              // effectSound(sound: AppAssets.actionButtonTapSound);
              showSoloPlayRulesSheet(context);
            }),
        gameCard(
            title: 'Group Play',
            imagePath: AppAssets.groupPlayImg2,
            onInfoTap: () {
              // effectSound(sound: AppAssets.actionButtonTapSound);
              showGroupPlaySheet(context);
            },
            onFileTap: () {
              // effectSound(sound: AppAssets.actionButtonTapSound);
              showGroupPlayRulesSheet(context);
            }),
        gameCard(
            key: _medpardyKey,
            title: 'Medpardy',
            imagePath: AppAssets.medpardyImg1,
            isLocked: AuthData().isPremium==true || AuthData().isPremiumMedpardy==1 ? false : true,
            onInfoTap: () {
              // effectSound(sound: AppAssets.actionButtonTapSound);
              showMedpardySheet(context);
            },
            onFileTap: () {
              // effectSound(sound: AppAssets.actionButtonTapSound);
              showMedpardyPlayRulesSheet(context);
            }),
        gameCard(
            title: 'Wheel of Wellness',
            imagePath: AppAssets.wheelOfWellnessImg1,
            isLocked: AuthData().isPremium==true || AuthData().isPremiumWellness==1 ? false : true,
            onInfoTap: () {
              // effectSound(sound: AppAssets.actionButtonTapSound);
              showWheelOfWellnessSheet(context);
            },
            onFileTap: () {
              // effectSound(sound: AppAssets.actionButtonTapSound);
              showWheelForWellnessRulesSheet(context);
            }),
      ]);}

  Widget _buildOverlayWithHole(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          // Remove overlay when tapped anywhere
          setState(() {
            _showOverlay = false;
          });
          // showToast('msg--> ${AuthData().userModel?.homeBlurStatus}');
          showLoader(true);
          homeBlurApi(blurStatus: 0).then((blur){
            showLoader(false);
            if(blur.status==true){
              getSubscriptionDetailsApi().then((value){
                // apolloPrint(message: 'Subscription wali api call hui hain');
                if(value.userData!=null){
                  LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.userData));
                  LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.userData!.subscription==1?true:false);
                  AuthData().getLoginData();
                  setState(() {});
                }
              });
            }});
        },
        child: CustomPaint(
          painter: MedpardyOverlayPainter(
            medpardyKey: _medpardyKey,
            // screenHeight: MediaQuery.of(context).size.height/1.48,
            screenHeight: 631, /// ye wala bhi static kiya hai
          ),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }
}

class MedpardyOverlayPainter extends CustomPainter {
  final GlobalKey medpardyKey;
  final double screenHeight;

  MedpardyOverlayPainter({required this.medpardyKey, required this.screenHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final medpardyPosition = _getMedpardyPosition();
    final medpardySize = _getMedpardySize();
    
    if (medpardyPosition == null || medpardySize == null) return;
    
    // Create overlay paint
    final overlayPaint = Paint()
      ..color = AppColors.blackColor.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    // Create a path that covers the entire screen
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Calculate hole position 80px from bottom
    // final holeY = screenHeight - (GetPlatform.isAndroid?81:141) - (medpardySize.height / 2);
    final holeY = screenHeight - 129 - (130.4); // chanage kiya hai static
    final adjustedHolePosition = Offset(medpardyPosition.dx, holeY);

    // Create a path for the hole (rounded rectangle matching Medpardy card)
    final holePath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: adjustedHolePosition,
          width: medpardySize.width,
          height: medpardySize.height,
        ),
        Radius.circular(16), // Same radius as the grid item
      ));

    // Subtract the hole from the overlay
    final finalPath = Path.combine(PathOperation.difference, overlayPath, holePath);

    // Draw the overlay with hole
    canvas.drawPath(finalPath, overlayPaint);
    
    // Draw the "Unlock to Play" text in the hole
    _drawUnlockText(canvas, adjustedHolePosition, medpardySize);
  }

  void _drawUnlockText(Canvas canvas, Offset position, Size size) {
    // Match MyProfileScreen tooltip style: small yellow rounded box above the hole
    final tooltipText = TextPainter(
      text: TextSpan(
        text: 'See a lock?🔒\nTap it and discover\nPremium features—free!',
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'Manrope',
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    tooltipText.layout();

    // Place tooltip 40px above the hole's top edge, centered horizontally
    // final holeTopY = position.dy - (size.height / 1.8);
    final holeTopY = position.dy - (136); // chanage kiya hai static
    final tooltipCenter = Offset(position.dx, holeTopY - 10);

    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: tooltipCenter,
        width: tooltipText.width + 24,
        height: tooltipText.height + 12,
      ),
      Radius.circular(8),
    );

    final tooltipPaint = Paint()
      ..color = Colors.yellow[700]!
      ..style = PaintingStyle.fill;

    // Optional subtle shadow similar to profile (approximation)
    final shadowPaint = Paint()
      ..color = Colors.black26
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    // Draw shadow then tooltip
    canvas.drawRRect(tooltipRect.shift(const Offset(0, 2)), shadowPaint);
    canvas.drawRRect(tooltipRect, tooltipPaint);

    // Draw text centered in tooltip
    final textOffset = Offset(
      tooltipCenter.dx - (tooltipText.width / 2),
      tooltipCenter.dy - (tooltipText.height / 2),
    );
    tooltipText.paint(canvas, textOffset);
  }

  Offset? _getMedpardyPosition() {
    final RenderBox? renderBox = medpardyKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      return Offset(
        position.dx + size.width / 2,
        position.dy + size.height / 2,
      );
    }
    return null;
  }

  Size? _getMedpardySize() {
    final RenderBox? renderBox = medpardyKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint to keep position updated
  }
}
