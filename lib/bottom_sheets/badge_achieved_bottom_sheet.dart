import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

void showBadgeAchievedSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,

    backgroundColor: Colors.transparent,
    builder: (context) => SafeArea(
      bottom: Platform.isIOS?false:true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bottomSheetBGColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),),
            // border: Border.all(color: Color(0xFFB58DF1), width: 2),
          ),
          padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColors.bottomSheetBorderColor,width: 2),
                    left: BorderSide(color: AppColors.bottomSheetBorderColor,width: 2),
                    right: BorderSide(color: AppColors.bottomSheetBorderColor,width: 2)),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))


            ),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /*Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.cancel_outlined, color: Colors.black87),
                  ),
                ),

                addHeight(4),*/

                addHeight(8),
                addText400('Hierarchical Achievement',fontSize: 28,color: AppColors.secondaryColor, textAlign: TextAlign.center, fontFamily: 'Caprasimo'),
                addText400('(HP = Health Points)',fontSize: 12,color: AppColors.blackColor, textAlign: TextAlign.center,),
                addHeight(16),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    build_text_view(txt: 'Health Apprentice — 5,000 HP'),
                    build_text_view(txt: 'Wellness Watcher — 10,000 HP'),
                    build_text_view(txt: 'Health Pro — 15,000 HP'),
                    build_text_view(txt: 'Health Whiz — 25,000 HP'),
                    build_text_view(txt: 'Grandmaster of Health — 50,000 HP'),

                  ],
                ),
                addHeight(28),

                AppButton(
                  onButtonTap: () async{

                    Get.back(); },
                  buttonText: 'Got It',buttonColor: AppColors.secondaryColor,),
                addHeight(16),

              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget build_text_view({required String txt}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(horizontal: -4,vertical: -4),
      leading: Image.asset(AppAssets.starIcon,height: 16,width: 16,),
    horizontalTitleGap: 2,
    title: addText500(txt,fontSize: 16),
  );
}
