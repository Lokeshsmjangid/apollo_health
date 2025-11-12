
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void showCategoryReadyMoreSheet(BuildContext context,{bool isMadPardy = false,void Function()? onTapUpgrade,void Function()? onTapDayPass,
  void Function()? onTap10MinFree}) {
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
                // addText400(
                //   'Ready for more?',fontSize: 28,color: AppColors.secondaryColor,
                //   textAlign: TextAlign.center, fontFamily: 'Caprasimo', // or another bold playful font
                //
                // ),
                // addHeight(16),
                addText500(
                  // 'Go Premium and take your heath game to the next level!',
                  isMadPardy
                      ? 'Ready for more? Go Premium or try a temporary pass!' //Go Premium or get a 1-Day Pass for 3000 HP!
                      : 'Ready for more? Go Premium or try a temporary pass!', //Go Premium or get a 1-Day Pass for 1000 HP!
                  textAlign: TextAlign.center,
                  fontSize: 16,
                ),
                addHeight(28),
                if(!AuthData().isPremium)
                AppButton(
                  onButtonTap: onTapUpgrade,
                  buttonText: 'Upgrade Now',buttonColor: AppColors.secondaryColor,),
                if(!AuthData().isPremium)
                addHeight(10),
                AppButton(
                  onButtonTap: onTapDayPass,
                  buttonText: isMadPardy?'Day Pass for 3000 HP':'Day Pass for 1000 HP',
                  buttonColor: AppColors.bottomSheetBorderColor,buttonTxtColor: AppColors.primaryColor,),
                if(!AuthData().isPremium)
                  addHeight(10),
                AppButton(
                  onButtonTap: onTap10MinFree,
                  buttonText: 'No HP? Enjoy a Free Pass!',
                  buttonColor: AppColors.whiteColor,buttonTxtColor: AppColors.primaryColor,),
                addHeight(20),

              ],
            ),
          ),
        ),
      ),
    ),
  );
}
