import 'package:apollo/resources/Apis/api_repository/daily_dose_repo.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

void showDailyDoseSheet(BuildContext context,{String? catName,String? desc}) {
  showModalBottomSheet(
    context: context,
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => PopScope(
      canPop: false,
      child: SafeArea(
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCD941),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(AppAssets.starIcon,height: 24,),
                        SizedBox(width: 6),
                        addText400(
                          'Daily Dose',
                            color: AppColors.primaryColor,
                            fontFamily: 'Caprasimo',
                            fontSize: 16,

                        ),
                        SizedBox(width: 6),
                        Image.asset(AppAssets.starIcon,height: 24,),
                      ],
                    ),
                  ),

                  addHeight(12),
                  addText400(
                    '$catName',fontSize: 28,color: AppColors.secondaryColor, textAlign: TextAlign.center, fontFamily: 'Caprasimo'),
                  addHeight(16),

                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      children: [

                        HTML.toTextSpan(
                            context,
                            desc??"",
                            defaultTextStyle: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Manrope',
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w500,),
                            overrideStyle: {
                              "a": TextStyle(
                                decoration: TextDecoration.none, // Remove underline from links
                                color: Colors.blue, // Or your preferred color
                              ),
                              "u": TextStyle(
                                decoration: TextDecoration.none, // Remove underline from <u>
                              ),}
                        ),
                        // TextSpan(
                        //   text: q.explanation??"",
                        //   style: TextStyle(
                        //     fontFamily: 'Manrope',
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  /*Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Myth: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Manrope',
                              ),
                            ),
                            TextSpan(
                              text: 'Brown eggs are healthier than white eggs.',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Fact: ',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Just different chickens! 🥚🐣',
                              style: TextStyle(color: Colors.black,),
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '(Source: Mayo Clinic)',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),*/
                  addHeight(28),

                  AppButton(
                    onButtonTap: () async{
                      Get.back();
                      dailyDoseApi(isRead: 1);
                      },
                    buttonText: 'Got It',buttonColor: AppColors.secondaryColor,),
                  addHeight(20),

                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
