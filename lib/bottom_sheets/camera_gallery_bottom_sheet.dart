import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';

void showCameraGallerySheet(BuildContext context,{void Function()? onTapCamera,void Function()? onTapGallery}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,

    backgroundColor: Colors.transparent,
    builder: (context) => SafeArea(
      bottom: Platform.isAndroid?true:false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
          decoration: BoxDecoration(
            color: AppColors.bottomSheetBGColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),),
            // border: Border.all(color: Color(0xFFB58DF1), width: 2),
          ),
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
                // Align(
                //   alignment: Alignment.topRight,
                //   child: GestureDetector(
                //       onTap: () => Navigator.of(context).pop(),
                //     child: Icon(Icons.cancel_outlined, color: Colors.black87),
                //   ),
                // ),
                //
                // addHeight(8),

                addText400(
                  'Upload Photo',fontSize: 28,color: AppColors.secondaryColor,
                  textAlign: TextAlign.center, fontFamily: 'Caprasimo', // or another bold playful font

                ),
                addHeight(24),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildMediaButton(buttonText: 'Open Camera',onTap: onTapCamera),
                    addHeight(12),
                    buildMediaButton(buttonText:'Open Gallery', onTap: onTapGallery),
                  ],
                ),

                addHeight(20),

              ],
            ),
          ),
        ),
      ),
    ),
  );
}

buildMediaButton({String? buttonText,void Function()? onTap}) { return GestureDetector(
  onTap: onTap,
  child: Container(
      height: 60,
      decoration: BoxDecoration(
        color: buttonText=='Open Camera'?AppColors.primaryColor:AppColors.whiteColor,
        borderRadius: BorderRadius.circular(50)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 1,
              child: SvgPicture.asset(buttonText=='Open Camera'?AppAssets.cameraIcon:AppAssets.galleryIcon,height: 24,width: 24,)),

          Expanded(
              flex: 2,
              child: addText500(buttonText!,fontSize: 16,height: 22,color: buttonText=='Open Camera'?AppColors.whiteColor:AppColors.primaryColor))

        ],
      ),
    ),
);}
