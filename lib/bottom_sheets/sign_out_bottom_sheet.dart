import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_repository/logout_repo.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSignOutRequestSheet(BuildContext context) {
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
                  'Are you sure you want to sign out?',
                  textAlign: TextAlign.center,
                  fontSize: 16,
                ),
                addHeight(28),
                AppButton(
                  onButtonTap: () async{

                    Get.back();
                    showLoader(true);
                    logoutApi().then((value){
                      showLoader(false);
                      if(value.status==true){
                        LocalStorage().clearLocalStorage();
                      }else if(value.status==false){
                        CustomSnackBar().showSnack(Get.context!,message: '${value.message}');
                      }
                    });
                    // Future.delayed(Duration(milliseconds: 1500),(){
                    //   LocalStorage().clearLocalStorage();
                    //   showLoader(false);
                    // });

                  },
                  buttonText: 'Sign out',buttonColor: AppColors.secondaryColor,),
                addHeight(10),

                AppButton(
                  onButtonTap: () async{
                    // final AudioPlayer _audioPlayer = AudioPlayer();
                    // await _audioPlayer.play(AssetSource(AppAssets.actionButtonTapSound));
                    Get.back();
                  },
                  buttonText: 'Cancel',buttonColor: AppColors.whiteColor,buttonTxtColor: AppColors.primaryColor),
                addHeight(20),

              ],
            ),
          ),
        ),
      ),
    ),
  );
}
