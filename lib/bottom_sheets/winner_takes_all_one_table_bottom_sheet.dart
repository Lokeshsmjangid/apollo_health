import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/screens/game_mode/group_play/group_play_friends_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void WinnerTakesAllOnOneTableSheet(BuildContext context,{void Function()? onTapLetsGo,void Function()? onTapPass}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    backgroundColor: Colors.transparent,
    builder: (context) => SafeArea(
      bottom: Platform.isAndroid?true:false,
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
                /*addText400(
                  'Winner-Take-All Mode',fontSize: 28,color: AppColors.secondaryColor,
                  textAlign: TextAlign.center, fontFamily: 'Caprasimo', // or another bold playful font

                ),
                addHeight(16),*/
                addText500(
                  'Winner Takes All is on the table. It\'s optional. What’s your move?',
                  textAlign: TextAlign.center,
                  fontSize: 16,

                ),
                addHeight(28),
                AppButton(
                  onButtonTap: onTapLetsGo,
                  buttonText: 'Let’s go!',buttonColor: AppColors.secondaryColor,),
                addHeight(8),

                AppButton(
                  onButtonTap: onTapPass,
                  buttonText: 'I’ll pass',buttonColor: AppColors.whiteColor,buttonTxtColor: AppColors.primaryColor,),
                addHeight(20),

              ],
            ),
          ),
        ),
      ),
    ),
  );
}
