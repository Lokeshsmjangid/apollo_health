import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'like_question_bottom_sheet.dart';

void showLeaveQuizSheet(BuildContext context,void Function() onButtonTap,{bool isWheelOfWellness = false}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,

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
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () async{
                      // final AudioPlayer _audioPlayer = AudioPlayer();
                      // await _audioPlayer.play(AssetSource(AppAssets.actionButtonTapSound));
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.cancel_outlined, color: Colors.black87),
                  ),
                ),

                addHeight(8),
                addText400(
                  isWheelOfWellness==true?'Leave Game?' :'Leave Quiz?',
                  fontSize: 32,color: AppColors.secondaryColor,height: 40,
                  textAlign: TextAlign.center, fontFamily: 'Caprasimo', // or another bold playful font

                ),
                addHeight(20),
                addText500(
                    isWheelOfWellness==true
                        ?'Are you sure you want to leave? Your progress will be lost and you will earn 0 points for this game.'
                        :'Are you sure you want to leave? Unanswered questions will earn 0 points and your progress will be lost.',
                  textAlign: TextAlign.center,
                  fontSize: 16,
                  height: 22
                ),
                addHeight(28),
                AppButton(
                  onButtonTap: onButtonTap,
                  buttonText: isWheelOfWellness==true
                      ? 'Leave Game'
                      : 'Quit Game',buttonColor: AppColors.secondaryColor,),
                addHeight(20),

              ],
            ),
          ),
        ),
      ),
    ),
  );
}
