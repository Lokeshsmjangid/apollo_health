import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';

void showUnlockPremiumHSMSheet(BuildContext context,{void Function()? onTapUpgrade,void Function()? onTapNotNow}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
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

                addText500(
                  'Unlock this Premium feature. Ready to upgrade?',
                  textAlign: TextAlign.center,
                  fontSize: 16,
                ),
                addHeight(28),


                AppButton(
                  onButtonTap: onTapUpgrade,
                  // onButtonTap: ()async{
                  //   Get.back();
                  //   Get.toNamed(AppRoutes.subscriptionScreen);
                  // },
                  buttonText: 'Upgrade Now!',buttonColor: AppColors.secondaryColor,),

                addHeight(10),

                AppButton(
                  onButtonTap: onTapNotNow,

                    // onButtonTap: () async{
                    //
                    // Get.back();
                  // },
                  buttonText: 'Not now.',buttonColor: AppColors.whiteColor,buttonTxtColor: AppColors.primaryColor),
                addHeight(16),

              ],
            ),
          ),
        ),
      ),
    ),
  );
}
