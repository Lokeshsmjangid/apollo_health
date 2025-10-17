import 'dart:io';

import 'package:apollo/bottom_sheets/category_ready_more_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/high_stack_mode_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/unlock_premium_hsm_bottom_sheet.dart';
import 'package:apollo/controllers/gm_solo_play_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_models/category_model.dart';
import 'package:apollo/resources/Apis/api_repository/category_one_dp_repo.dart';
import 'package:apollo/resources/Apis/api_repository/start_solo_play_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/ads/free_pass_ads_screen.dart';
import 'package:apollo/screens/app_subscriptions/premium_plan_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SoloPlayScreen extends StatelessWidget {
  SoloPlayScreen({super.key});

  final ctrl = Get.find<GmSoloPlayController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryColor,
      body: GetBuilder<GmSoloPlayController>(
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
                    addHeight(10),
                    backBar(
                      title: "Solo Play",
                      onTap: () {
                        Get.back();
                        if(ctrl.categories.isNotEmpty){
                          ctrl.categories.forEach((category) {
                            if (category.adPass == true) {
                              category.adPass = false;
                            }
                          });
                        }
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
                          // physics: BouncingScrollPhysics(),
                          children: [
                            addHeight(8), // 24-16(padding)
                            sectionTitle('Game Settings'),
                            addHeight(12),
                            // numberOfQuestionsSelector(),
                            //
                            // addHeight(4),
                            toggleTile(
                              'Show Explanation',
                              logic.showExplanation, () {
                                // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                              logic.showExplanation = !logic.showExplanation;
                              logic.update();
                            },
                            ),
                            toggleTile('High Stakes Mode',
                              logic.highStakes, () {
                                // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                logic.highStakes = !logic.highStakes;
                                logic.update();
                                if(AuthData().isPremium==false && logic.highStakes){
                                  showUnlockPremiumHSMSheet(context,
                                      onTapUpgrade: (){
                                      Get.back();
                                      PremiumPlanCtrl controller = Get.isRegistered<PremiumPlanCtrl>()
                                          ? Get.find<PremiumPlanCtrl>()
                                          : Get.put(PremiumPlanCtrl());
                                      WidgetsBinding.instance.addPostFrameCallback((_)async {
                                        controller.setupPurchaseListener();
                                        await controller.initStoreInfo();

                                        controller.restoreSubscription();
                                      });
                                      Get.toNamed(AppRoutes.subscriptionScreen);
                                  },
                                      onTapNotNow: (){
                                        if(logic.highStakes==true){
                                          logic.highStakes = false;
                                          logic.update();
                                        }
                                    Get.back();});
                                }
                              },
                              showInfo: true,
                              onInfoTap: () {
                                // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                HighStakeModeSheet(context);
                              },
                            ),

                            addHeight(24),
                            divider(),
                            /*addHeight(24),

                            sectionTitle('Question Mode'),
                            addHeight(16),
                            toggleTile(
                              'Random Mix',
                              subTitle: 'Play a shuffled category round.',
                              logic.randomMix, () {
                              logic.randomMix = !logic.randomMix;
                              if(logic.randomMix){
                                logic.selectedCategories.clear();
                                logic.selectedCategories = logic.pickRandomCategoryIds(logic.categories.length>=5?5:logic.categories.length);
                              }
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
                                addText400(
                                    'or', fontSize: 12, color: Color(0xffAAA4B3))
                                    .marginSymmetric(horizontal: 12),

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
                            */
                            addHeight(24),

                            sectionTitle(
                              'Select Categories',
                              subtitle:
                              'Choose up to 5 categories to play.',
                              counter: logic.selectedCategories.length,
                            ),

                            const SizedBox(height: 16),
                            logic.categories.isNotEmpty?buildCategoryStack(context,logic.randomMix)
                                : Center(child: addText500('No categories found.'))
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
          child: GetBuilder<GmSoloPlayController>(
              builder: (logic) {
            return BottomAppBar(
              padding: EdgeInsets.zero,
              color: AppColors.whiteColor,
              child: AppButton(
                buttonText: 'Start Game',
                buttonColor: ctrl.selectedCategories.isNotEmpty
                    ? AppColors.primaryColor
                    : AppColors.buttonDisableColor,
                onButtonTap: ctrl.selectedCategories.isNotEmpty ? () {


                  apolloPrint(message:
                  'quesCount::${ctrl.selectedCount.name=='five'?5:10}::\n'
                  'showExplanation::${ctrl.showExplanation==true?1:0}::\n'
                  'highStakesMode::${ctrl.highStakes==true?1:0}::\n'
                  'randomMix::${ctrl.randomMix==true?1:0}::\n'
                      '<--${ctrl.selectedCategories.join(',')}-->');

                  showLoader(true);
                  startSoloPlayApi(categoryId: ctrl.selectedCategories.join(','),
                      numberOfQuestions: ctrl.selectedCount.name=='five'?5:10,
                    showExplanation: ctrl.showExplanation==true?1:0,
                    highStakesMode: ctrl.highStakes==true?1:0,
                    randomMix: ctrl.randomMix==true?1:0

                  ).then((value){
                    showLoader(false);
                    if(value.status==true){
                      if(value.data!=null && value.data!.isNotEmpty){
                        Get.toNamed(AppRoutes.quizScreenNew, arguments: {'screen': 'soloPlay',
                          'questions': value.data,
                          'gameData':value.gameData});
                      }
                    } else if(value.status==false){
                      CustomSnackBar().showSnack(Get.context!,message: '${value.message}',isSuccess: false);
                    }
                  });


                } : () {},

              ).marginOnly(
                  left: 16, right: 16,
                  bottom: 32, top: 7),
            );
          })),


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
                // fontSize: title == "Select Categories" ? 20 : 26,
                fontSize: 26,
                fontFamily: 'Caprasimo',
                height: title == "Select Categories" ? 22 : 40,
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
            fontFamily: 'Caprasimo', height: 22,
            color: AppColors.primaryColor,
          ),
      ],
    );
  }

  Widget numberOfQuestionsSelector() {
    return Row(
      children: [
        Row(
          children: [
            Image.asset(AppAssets.starIcon, height: 18, width: 18),
            addWidth(8),
            addText500("No. of Questions", fontSize: 16),
          ],
        ),
        Spacer(),
        radioButtonTile(label: '5', value: QuestionCount.five),
        const SizedBox(width: 8),
        radioButtonTile(label: '10', value: QuestionCount.ten),
      ],
    );
  }

  Widget radioButtonTile({
    required String label,
    required QuestionCount value,
  }) {
    return Row(children: [
      Transform.scale(
        scale: 1.3,
        child: Radio<QuestionCount>(
          value: value,
          visualDensity: VisualDensity(horizontal: -4, vertical: -4),

          groupValue: ctrl.selectedCount,
          onChanged: (QuestionCount? newValue) {
            ctrl.selectedCount = newValue!;
            ctrl.update();
          },
          activeColor: AppColors.primaryColor.withOpacity(0.8),
        ),
      ),
      addText500(label, fontSize: 16, height: 22),
    ]);
  }

  Widget toggleTile(String title,
      bool value,
      void Function()? onChanged, {
        bool showInfo = false,
        String? subTitle,
        void Function()? onInfoTap,
      }) {
    return ListTile(
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
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
                    addText500(title, fontSize: 16, height: 22),
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
    );
  }

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

  Widget buildCategoryStack(BuildContext context, bool randomMix) {
    final List<Color> bgColors = [
      hexToColor("C8E6C9"),
      hexToColor("FFE0B2"),
      hexToColor("F8BBD0"),
      hexToColor("B9C9FF"),
      hexToColor("FFCDD2"),
      hexToColor("E1BEE7"),
    ];

    final List<Color> borderColors = [
      hexToColor("66BB6A"),
      hexToColor("FF9800"),
      hexToColor("F06292"),
      hexToColor("4663D3"),
      hexToColor("E57373"),
      hexToColor("AB47BC"),
    ];
    return SizedBox(
      height: ctrl.categories.length * 95.0,
      child: Stack(
        children:
        ctrl.categories.asMap().entries.map((entry) {
          int index = entry.key;
          var category = entry.value;
          bool isSelected = ctrl.selectedCategories.contains(category.id);
          final bgColor = bgColors[index % bgColors.length];
          final borderColor = borderColors[index % borderColors.length];
          return Positioned(
            top: index * 94.0, // Controls the overlap
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // ctrl.effectSound(sound: AppAssets.actionButtonTapSound);

                  if(category.paidStatus==0 || category.adPass){

                    if (!randomMix && isSelected) {
                      ctrl.selectedCategories.remove(category.id);
                    }
                    else if (ctrl.selectedCategories.length < 5) {
                      ctrl.selectedCategories.add(category.id??0);
                    }
                    ctrl.update();
                  }
                  else{
                    showCategoryReadyMoreSheet(
                        context,
                        onTapUpgrade: (){
                      Get.back();
                      PremiumPlanCtrl controller = Get.isRegistered<PremiumPlanCtrl>()
                          ? Get.find<PremiumPlanCtrl>()
                          : Get.put(PremiumPlanCtrl());
                      WidgetsBinding.instance.addPostFrameCallback((_)async {
                        controller.setupPurchaseListener();
                        await controller.initStoreInfo();

                        controller.restoreSubscription();
                      });
                      Get.toNamed(AppRoutes.subscriptionScreen);
                    },
                        onTapDayPass: (){
                      Get.back();
                          showLoader(true);
                          categoryOneDayPassApi(categoryId: category.id).then((pass){
                            showLoader(false);
                            if(pass.status==true){
                              category.paidStatus=0;
                              ctrl.update();

                            } else if(pass.status==false){
                              CustomSnackBar().showSnack(Get.context!,message: '${pass.message}',isSuccess: false);
                            }
                          });



                    },
                      onTap10MinFree: (){Get.back();
                      Get.to(FreePassAdsScreen(game: 'soloPlay',catId: category.id))?.then((activePass){
                        if(activePass!=null){
                          int index = ctrl.categories.indexWhere((text)=> text.id==activePass);
                          ctrl.categories[index].adPass=true;
                          ctrl.update();
                        }
                      });
                      },

                    );

                    /*showReadyMoreSheet(context,onTapUpgrade: (){
                      // ctrl.effectSound(sound: AppAssets.actionButtonTapSound);
                      Get.back();
                      Get.toNamed(AppRoutes.subscriptionScreen);
                    });*/
                  }},
              child: categoryCard(category, isSelected, backgroundColor: bgColor,borderColor: borderColor),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget categoryCard(Category category, bool isSelected,{Color? backgroundColor,Color? borderColor}) {
    return Container(
      padding: EdgeInsets.only(left: 6, right: 6, top: 6), //


      // Main card
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(top: BorderSide(color: borderColor!, width: 6)),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 12, right: 24, top: 12, bottom: 40),
        // inside border
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          border: Border(
            top: BorderSide(color: borderColor),
            left: BorderSide(color: borderColor),
            right: BorderSide(color:borderColor),
          ),
        ),
        child: Row(
          children: [
            // Text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addText600(category.shortDescription??'', fontSize: 12,
                      color: AppColors.blackColor, height: 21.12),
                  // const SizedBox(height: 4),
                  addText400(category.title??'', fontSize: 20,
                      fontFamily: 'Caprasimo',
                      color: borderColor,
                      height: 22),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Checkbox icon

        category.paidStatus != 1 || category.adPass
            ? Container(
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
                        color: isSelected ? Colors.transparent : AppColors.textFieldHintColor)
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
            ).marginOnly(bottom: 16)
            : Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(AppAssets.lockIcon,height: 20,width: 20,color: borderColor),
            ).marginOnly(bottom: 16)
                ,



          ],
        ),
      ),
    );
  }
}
