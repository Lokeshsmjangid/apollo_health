import 'dart:io';

import 'package:apollo/controllers/bottom_bar_ctrl.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
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
                height: 68,
                padding: EdgeInsets.only(left: 16,right: 16,bottom: 12),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(100),
                  color: AppColors.whiteColor,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    IconButton(onPressed: (){
                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                      logic.selectedIndex = 0;
                      logic.update();
                    }, icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          logic.selectedIndex == 0?AppAssets.homeFillIcon:AppAssets.homeUnFillIcon,
                          height: 24, width: 24,
                        ),
                        // addHeight(2),
                        // logic.selectedIndex ==0 ?
                        // addText700('Home',fontSize: 10,color: AppColors.blackColor)
                        // : addText500('Home',fontSize: 10,color: AppColors.textFieldHintColor)
                      ],
                    )),
                    addWidth(14),

                    IconButton(onPressed: (){
                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                      logic.selectedIndex = 1;
                      logic.update();
                    }, icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          logic.selectedIndex == 1?AppAssets.categoryFillIcon:AppAssets.categoryUnFillIcon,
                          height: 24, width: 24,
                        ),
                        // addHeight(2),
                        // logic.selectedIndex ==1? addText700('Categories',fontSize: 10,color: AppColors.blackColor)
                        // : addText500('Categories',fontSize: 10,color: AppColors.textFieldHintColor)
                      ],
                    )),
                    addWidth(14),

                    IconButton(onPressed: (){
                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                      logic.selectedIndex = 2;
                      logic.update();
                    }, icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          logic.selectedIndex == 2?AppAssets.leaderBoardFillIcon:AppAssets.leaderBoardUnFillIcon,
                          height: 24, width: 24,),
                        addHeight(2),
                        // logic.selectedIndex ==2
                        //     ? addText700('Leaderboard',fontSize: 10,color: AppColors.blackColor)
                        //     : addText500('Leaderboard',fontSize: 10,color: AppColors.textFieldHintColor)
                      ],
                    )),
                    addWidth(14),

                    IconButton(onPressed: (){
                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                      logic.selectedIndex = 3;
                      logic.update();
                    }, icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            SvgPicture.asset(
                              logic.selectedIndex == 3?AppAssets.dealFillIcon:AppAssets.dealSvgUnFillIcon,
                              // color: logic.selectedIndex == 3?AppColors.primaryColor:Color(0xff67656B),
                              height: 24, width: 24,
                            ),
                            // if(logic.selectedIndex!=3)
                            //   Positioned(
                            //       top: 0,
                            //       right: 4,
                            //       child: Container(height: 6,width: 6,
                            //         decoration: BoxDecoration(
                            //           shape: BoxShape.circle,color: AppColors.redColor,
                            //         border: Border.all(width: 1,color: Colors.white)
                            //
                            //       ),))
                          ],
                        ),
                        addHeight(2),
                        // logic.selectedIndex ==3
                        //     ? addText700('Profile',fontSize: 10,color: AppColors.blackColor)
                        //     : addText500('Profile',fontSize: 10,color: AppColors.textFieldHintColor)

                      ],
                    )),
                    addWidth(14),


                    IconButton(
                        onPressed: (){
                          // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                      logic.selectedIndex = 4;
                      logic.update();
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
                        // logic.selectedIndex ==3
                        //     ? addText700('Profile',fontSize: 10,color: AppColors.blackColor)
                        //     : addText500('Profile',fontSize: 10,color: AppColors.textFieldHintColor)

                      ],
                    ))
                  ],
                ),
              ),
            ),
          )
      );
    });
  }




}
