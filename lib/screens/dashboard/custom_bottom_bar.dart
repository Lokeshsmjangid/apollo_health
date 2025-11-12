import 'dart:convert';
import 'dart:io';

import 'package:apollo/controllers/bottom_bar_ctrl.dart';
import 'package:apollo/controllers/home_ctrl.dart';
import 'package:apollo/resources/Apis/api_repository/user_active_status_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> with WidgetsBindingObserver{


  @override
  void initState() {
    super.initState();
    // Future.microtask((){ /// jab user ka plan expire ho jaye or wo app close ker k wapas aata hai to yee localStore me user data ko update ker dega
    //   fetchDetails();
    // });
    WidgetsBinding.instance.addObserver(this); // Register observer
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Unregister observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        print('App Resumed (foreground)');
        await onlineStatusApi().then((value){
          if(value.data!=null){
            LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
            LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
            AuthData().getLoginData();
              setState(() {});
          }
        });
        // TODO: Add your logic here, e.g., refresh UI or resume timers
        break;

      case AppLifecycleState.inactive:
        print('App Inactive');
        // await onlineStatusApi();
        break;

      case AppLifecycleState.paused: // app moves to background state
        print('App Paused (background)');
        // App moved to background, pause animations or timers here
        break;

      case AppLifecycleState.detached: // its means kill state
        print('App Detached (terminated)');
        await onlineStatusApi().then((value){
          if(value.data!=null){
            LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
            LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
            AuthData().getLoginData();
              setState(() {});
          }
        });

        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        // throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomBarController>(builder: (logic) {
      return Scaffold(
          // extendBody: true,
          // resizeToAvoidBottomInset: false,
          body: logic.widgetOptions.elementAt(logic.selectedIndex),
          bottomNavigationBar: MediaQuery.removePadding(
            context: context,
            removeBottom: Platform.isIOS?true:false,
            removeTop: true,
            child: BottomAppBar(
              // color: Colors.transparent,
              elevation: 0,
              child: Container(
                height: 70,
                padding: EdgeInsets.only(left: 16,right: 16,bottom: 12),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(100),
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      logic,
                      index: 0,
                      icon: logic.selectedIndex == 0
                          ? AppAssets.homeFillIcon
                          : AppAssets.homeUnFillIcon,
                      label: "Home",
                    ),
                    _buildNavItem(
                      logic,
                      index: 1,
                      icon: logic.selectedIndex == 1
                          ? AppAssets.categoryFillIcon
                          : AppAssets.categoryUnFillIcon,
                      label: "Categories",
                    ),
                    _buildNavItem(
                      logic,
                      index: 2,
                      icon: logic.selectedIndex == 2
                          ? AppAssets.leaderBoardFillIcon
                          : AppAssets.leaderBoardUnFillIcon,
                      label: "Leaderboard",
                    ),
                    // _buildNavItem(
                    //   logic,
                    //   index: 3,
                    //   icon: logic.selectedIndex == 3
                    //       ? AppAssets.dealFillIcon
                    //       : AppAssets.dealSvgUnFillIcon,
                    //   label: "Deals",
                    // ),
                    _buildNavItem(
                      logic,
                      index: 3,
                      icon: logic.selectedIndex == 3
                          ? AppAssets.profileFillIcon
                          : AppAssets.profileUnFillIcon,
                      label: "Account",
                    ),
                  ],
                ),
                /*child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [


                    IconButton(onPressed: (){
                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                      // Get.find<HomeController>().stopBackgroundSound();
                      logic.selectedIndex = 0;
                      logic.update();
                      Get.find<HomeController>().playBackgroundSound();
                    },
                        icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          logic.selectedIndex == 0?AppAssets.homeFillIcon:AppAssets.homeUnFillIcon,
                          height: 24, width: 24,
                        ),
                        addHeight(2),
                        logic.selectedIndex ==0 ?
                        addText700('Home',fontSize: 10,color: AppColors.blackColor,maxLines: 1)
                        : addText500('Home',fontSize: 10,color: AppColors.textFieldHintColor,maxLines: 1)
                      ],
                    )),
                    addWidth(14),

                    IconButton(onPressed: (){
                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                      logic.selectedIndex = 1;
                      logic.update();
                      Get.find<HomeController>().stopBackgroundSound();
                    },
                        icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          logic.selectedIndex == 1?AppAssets.categoryFillIcon:AppAssets.categoryUnFillIcon,
                          height: 24, width: 24,
                        ),
                        addHeight(2),
                        logic.selectedIndex ==1? addText700('Categories',fontSize: 10,color: AppColors.blackColor,maxLines: 1)
                        : addText500('Categories',fontSize: 10,color: AppColors.textFieldHintColor,maxLines: 1)
                      ],
                    )),
                    addWidth(14),


                    IconButton(onPressed: (){
                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                      logic.selectedIndex = 2;
                      logic.update();
                      Get.find<HomeController>().stopBackgroundSound();
                    },
                        icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          logic.selectedIndex == 2?AppAssets.leaderBoardFillIcon:AppAssets.leaderBoardUnFillIcon,
                          height: 24, width: 24,),
                        addHeight(2),
                        logic.selectedIndex ==2
                            ? addText700('Leaderboard',fontSize: 10,color: AppColors.blackColor,maxLines: 1)
                            : addText500('Leaderboard',fontSize: 10,color: AppColors.textFieldHintColor,maxLines: 1)
                      ],
                    )),
                    addWidth(14),




                    IconButton(
                        visualDensity: VisualDensity(horizontal: -4),
                        onPressed: (){
                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                      logic.selectedIndex = 3;
                      logic.update();
                      Get.find<HomeController>().stopBackgroundSound();
                    }, icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          logic.selectedIndex == 3?AppAssets.dealFillIcon:AppAssets.dealSvgUnFillIcon,
                          // color: logic.selectedIndex == 3?AppColors.primaryColor:Color(0xff67656B),
                          height: 24, width: 24,
                        ),
                        addHeight(2),
                        logic.selectedIndex ==3
                            ? addText700('Deals',fontSize: 10,color: AppColors.blackColor,maxLines: 1)
                            : addText500('Deals',fontSize: 10,color: AppColors.textFieldHintColor,maxLines: 1)

                      ],
                    )),
                    addWidth(14),




                    IconButton(
                        onPressed: (){
                          // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                      logic.selectedIndex = 4;
                      logic.update();
                      Get.find<HomeController>().stopBackgroundSound();
                    },
                        icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          logic.selectedIndex == 4?AppAssets.profileFillIcon:AppAssets.profileUnFillIcon,
                          height: 24, width: 24,
                        ),
                        addHeight(2),
                        logic.selectedIndex ==4
                            ? addText700('Profile',fontSize: 10,color: AppColors.blackColor,maxLines: 1)
                            : addText500('Profile',fontSize: 10,color: AppColors.textFieldHintColor,maxLines: 1)

                      ],
                    ))
                  ],
                ),*/
              ),
            ),
          )
      );
    });
  }

  Widget _buildNavItem(BottomBarController logic,
      {required int index, required String icon, required String label}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          logic.selectedIndex = index;
          logic.update();
          if (index == 0) {
            Get.find<HomeController>().playBackgroundSound();
          } else {
            Get.find<HomeController>().stopBackgroundSound();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: 24,
              width: 24,
            ),
            SizedBox(height: 2),
            logic.selectedIndex == index
                ? addText700(label,
                fontSize: 10, color: AppColors.blackColor)
                : addText500(label,
                fontSize: 10,
                color: AppColors.textFieldHintColor),
          ],
        ),
      ),
    );
  }

}
