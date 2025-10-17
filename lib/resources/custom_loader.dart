
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'app_assets.dart';
import 'app_color.dart';

// filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
// Loader using getx
  showLoader(bool show) {
  if (show) {
    Get.dialog(
        barrierDismissible: false, // barrierColor: AppColors.primaryColor.withOpacity(0.2),
        WillPopScope(
          onWillPop: () async {
            // Return false to prevent the dialog from closing on back button press
            return false;
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                    shape: BoxShape.circle
                  ),
                  child: ClipRRect(child: SvgPicture.asset(AppAssets.logo).marginAll(6))),
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  // color: AppColors.primaryColor,
                  // borderRadius: BorderRadius.circular(4.0),
                  shape: BoxShape.circle,
                  // image: DecorationImage(image: AssetImage(AppAssets.commonLogo)),
                ),
                child: CircularProgressIndicator(color: AppColors.secondaryColor,strokeWidth: 4,).marginAll(1))
            ]
          )));}
  else {Get.back();}}