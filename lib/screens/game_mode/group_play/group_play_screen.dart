import 'dart:io';

import 'package:apollo/bottom_sheets/high_stack_mode_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/ready_more_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/winner_takes_all_one_table_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/winner_takes_mode_bottom_sheet.dart';
import 'package:apollo/controllers/gm_group_play_ctrl.dart';
import 'package:apollo/controllers/gm_solo_play_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'group_play_friends_screen.dart';

class GroupPlayScreen extends StatelessWidget {
  GroupPlayScreen({super.key});

  final ctrl = Get.find<GmGroupPlayController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: GetBuilder<GmGroupPlayController>(
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
                      title: "Group Play",
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
                            top: Radius.circular(16),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          children: [

                            sectionTitle('Game Settings'),
                            addHeight(4),
                            toggleTile(
                              'Winner-Take-All Mode',
                              logic.winnerTakes, () {
                                logic.winnerTakes = !logic.winnerTakes;
                                logic.update();
                                if(logic.winnerTakes){
                                  WinnerTakesAllOnOneTableSheet(context,
                                      onTapLetsGo: (){
                                    // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                    Get.back();
                                      },
                                      onTapPass: (){
                                        // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                    logic.winnerTakes = false;
                                    logic.update();
                                    Get.back();
                                  });
                                }
                              },
                              showInfo: true,
                              onInfoTap: () {
                                // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                WinnertakeModeSheet(context);
                              },
                            ),
                            addHeight(10),


                            sectionTitle('Question Mode'),

                            addHeight(16),
                            toggleTile(
                              'Random Mix',
                              subTitle: 'Questions from all categories',
                              logic.randomMix,
                                  () {
                                    // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                logic.randomMix = !logic.randomMix;
                                logic.update();
                              },
                            ),

                            addHeight(24),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: Color(0xffAAA4B3)
                                    ),
                                  ),
                                ),
                                addText400('or',fontSize: 12,color: Color(0xffAAA4B3)).marginSymmetric(horizontal: 12),

                                Expanded(
                                  child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: Color(0xffAAA4B3)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            addHeight(24),

                            sectionTitle('Select Categories',
                              subtitle: 'You can select up to 5 categories for the game.',
                              counter: logic.selectedCategories.length,
                            ),
                            const SizedBox(height: 16),
                            buildCategoryStack(context),

                            // const SizedBox(height: 80),
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

      bottomNavigationBar: MediaQuery.removePadding(
          context: context,
          removeBottom: Platform.isIOS ? true : false,
          removeTop: true,
          child: GetBuilder<GmGroupPlayController>(
              builder: (logic) {
                return BottomAppBar(
                  padding: EdgeInsets.zero,
                  color: AppColors.whiteColor,
                  child: AppButton(
                    buttonText: 'Next',
                    buttonColor: ctrl.selectedCategories.isNotEmpty
                        ? AppColors.primaryColor
                        : AppColors.buttonDisableColor,
                    onButtonTap: ctrl.selectedCategories.isNotEmpty ? () {
                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                      Get.to(()=>GroupPlayFriendsScreen());
                    } : () {},

                  ).marginOnly(
                      left: 16, right: 16,
                      bottom: 32, top: 7),
                );
              })),
      /*bottomSheet: GetBuilder<GmGroupPlayController>(
        builder: (logic) {
          return Container(
            height: 90,
            decoration: BoxDecoration(color: AppColors.whiteColor),
            width: double.infinity,
            child: AppButton(
              buttonText: 'Start Game',
              onButtonTap: ctrl.selectedCategories.isNotEmpty?(){

                Get.to(()=>GroupPlayFriendsScreen());
              }:(){},
              buttonColor:
                  ctrl.selectedCategories.isNotEmpty
                      ? AppColors.primaryColor
                      : AppColors.buttonDisableColor,
            ).marginOnly(left: 16, right: 16, bottom: 24, top: 5),
          );
        },
      ),*/
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
                fontSize: title == "Select Categories" ? 20 : 32,
                fontFamily: 'Caprasimo',
                height: title == "Select Categories" ?22:40,
                color: AppColors.primaryColor,
              ),
              if (subtitle != null)
                addHeight(6),
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
            fontFamily: 'Caprasimo',height: 22,
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

  Widget divider() => Divider(thickness: 1, height: 0);

  /* // old commented
  Widget categoryCard(Map<String, dynamic> category) {
    final isSelected = ctrl.selectedCategories.contains(category['title']);

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          ctrl.selectedCategories.remove(category['title']);
        } else {
          if (ctrl.selectedCategories.length < 5) ctrl.selectedCategories.add(
              category['title']);
        }
        ctrl.update();
      },
      child: Container(
        // margin: EdgeInsets.only(bottom: 12),

        decoration: BoxDecoration(
          color: category['color'],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          border: Border(
            top: BorderSide(color: category['border'], width: 6),
            // left: BorderSide(color: category['border'],),
            // right: BorderSide(color: category['border'],),
            // bottom: BorderSide(color: category['border']),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          child: Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              border: Border(
                top: BorderSide(color: category['border']),
                left: BorderSide(color: category['border'],),
                right: BorderSide(color: category['border'],),
                // bottom: BorderSide(color: category['border']),
              ),
            ),
            child: Row(
              children: [
                // Text block
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addText600(category['subtitle'], fontSize: 12,
                          color: AppColors.blackColor),
                      addHeight(2),
                      addText400(category['title'], fontSize: 18,
                        color: category['border'],
                        fontFamily: 'Caprasimo',),
                      addHeight(20),
                    ],
                  ),
                ),

                // Check indicator
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(14),


                  ),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.secondaryColor : AppColors
                          .buttonDisableColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: isSelected ? AppColors.primaryColor.withOpacity(
                              0.8) : AppColors.textColor, width: 2),
                    ),
                    child: isSelected
                        ? Icon(Icons.check, size: 18, color: Colors.white)
                        : SizedBox.shrink(),
                  ),
                ),
              ],
            ).marginAll(10),
          ),
        ),
      ),
    );
  }
*/

  Widget buildCategoryStack(BuildContext context) {
    return SizedBox(
      height: ctrl.categories.length * 95.0,
      child: Stack(
        children:
        ctrl.categories.asMap().entries.map((entry) {
          int index = entry.key;
          var category = entry.value;
          bool isSelected = ctrl.selectedCategories.contains(
            category['title'],
          );

          return Positioned(
            top: index * 94.0, // Controls the overlap
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // ctrl.effectSound(sound: AppAssets.actionButtonTapSound);
                if(category['isLock']==false){
                  if (isSelected) {
                    ctrl.selectedCategories.remove(category['title']);
                  } else if (ctrl.selectedCategories.length < 5) {
                    ctrl.selectedCategories.add(category['title']);
                  }
                  ctrl.update();
                } else{
                  showReadyMoreSheet(context,onTapUpgrade: (){
                    // ctrl.effectSound(sound: AppAssets.actionButtonTapSound);
                    Get.back();
                    Get.toNamed(AppRoutes.subscriptionScreen);
                  });
                }

              },
              child: categoryCard(category, isSelected),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget categoryCard(Map<String, dynamic> category, bool isSelected) {
    return Container(
      padding: EdgeInsets.only(left: 6,right: 6,top: 6), //


      // Main card
      decoration: BoxDecoration(
        color: category['color'],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(top: BorderSide(color: category['border'], width: 6)),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 12,right: 24,top: 12,bottom: 40),
        // inside border
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          border: Border(
            top: BorderSide(color: category['border']),
            left: BorderSide(color: category['border']),
            right: BorderSide(color: category['border']),
          ),
        ),
        child: Row(
          children: [
            // Text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addText600(category['subtitle'], fontSize: 12,
                      color: AppColors.blackColor,height: 21.12),
                  // const SizedBox(height: 4),
                  addText400(category['title'], fontSize: 20, fontFamily: 'Caprasimo', color: category['border'],height: 22),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Checkbox icon

              category['isLock']==true?Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Image.asset(AppAssets.lockIcon,height: 20,width: 20,color: category['border'],),
              ).marginOnly(bottom: 16):Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                    color:
                    isSelected
                        ? AppColors.secondaryColor.withOpacity(0.8)
                        : AppColors.buttonDisableColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: isSelected?Colors.transparent : AppColors.textFieldHintColor)
                ),
                child:
                isSelected
                    ? const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                )
                    : null,
              ),
            ).marginOnly(bottom: 16),
          ],
        ),
      ),
    );
  }
}
