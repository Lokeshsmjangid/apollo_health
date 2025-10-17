import 'dart:io';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showMedpardyPlayRulesSheet(BuildContext context) {
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
                addText400(
                  'Game Tips',fontSize: 32,color: AppColors.secondaryColor,height: 40,
                  textAlign: TextAlign.center, fontFamily: 'Caprasimo', // or another bold playful font

                ),
                addHeight(20),
                _buildBulletItem('Pick your category. Pick your risk.'),
                _buildBulletItem('Choose questions by value—tougher questions, higher points.'),
                _buildBulletItem('Faster answers break ties.'),
                _buildBulletItem('Final Round: Just one question. Wager wisely—win big or lose it all!'),
                _buildBulletItem('How to win: Play it smart in Final Round!'),
                /*addHeight(20),
                addText500(
                  'Need help? Tap the “Hand” to eliminate 2 wrong answers—costs 50% of the value.',
                  textAlign: TextAlign.center,
                  fontSize: 16,
                  height: 22
                ),*/
                addHeight(28),
                AppButton(buttonText: 'Got It',buttonColor: AppColors.secondaryColor,onButtonTap: () async{
                  Get.back();

                },),
                addHeight(16),

              ],
            ),
          ),
        ),
      ),
    ),
  );


}

Widget _buildBulletItem(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        addText600("• ",fontSize: 15), // Bullet
        Expanded(
          child: addText500(
            text,
            fontSize: 15,
          ),
        ),
      ],
    ),
  );
}