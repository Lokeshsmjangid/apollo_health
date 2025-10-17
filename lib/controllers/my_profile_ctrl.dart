import 'dart:io';

import 'package:apollo/models/my_profile_badge_model.dart' as pm; // pm for profile model
import 'package:apollo/resources/Apis/api_models/register_model.dart';
import 'package:apollo/resources/Apis/api_repository/profile_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfileCtrl extends GetxController{
  RegisterResponseModel profileModel = RegisterResponseModel();
  bool isDataLoading = false;
  bool updateProfile = false;
  bool? showBlur;
  Rect? hpRect;
  final GlobalKey hpKey = GlobalKey();


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
   Future.microtask((){
     getProfile();
   });
  }

  getProfile() async{
    isDataLoading = true;
    update();
    showLoader(true);
    profileApi().then((value){
      profileModel = value;
      if(value.data!=null){
        showBlur = value.data!.blurStatus==1?true:false;
        hpRect = _getWidgetRect(hpKey);
      }
      isDataLoading = false;
      update();
      showLoader(false);
    });
  }

  Rect? _getWidgetRect(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    final offset = box.localToGlobal(Offset.zero);
    // Move hole 20 pixels up
    // final adjustedOffset = Offset(offset.dx, offset.dy - (Platform.isIOS?173:146.4)); //(Platform.isIOS?173:146.4) move hole to up and down
    final adjustedOffset = Offset(31,109); //(Platform.isIOS?173:146.4) move hole to up and down

    return adjustedOffset & box.size;
    // return offset & box.size;
  }

  // Rect? _getWidgetRect(GlobalKey key) {
  //   final box = key.currentContext?.findRenderObject() as RenderBox?;
  //   if (box == null || !box.hasSize) return null;
  //   final offset = box.localToGlobal(Offset.zero);
  //   // Adjust vertical position as needed
  //   final adjustedOffset = Offset(offset.dx, offset.dy - MediaQuery.sizeOf(Get.context!).height * 0.2);
  //
  //   return adjustedOffset & box.size;
  // }

  final List<pm.Badge> badges = [
    pm.Badge(
      title: "Grandmaster of Health",
      description: "You’ve reached 50,000 HP",
      date: "Dec. 29, 2025",
      color: Colors.red,
      icon: AppAssets.grandmasterOfHealthBadge,
    ),

    pm.Badge(
      title: "Health Whiz",
      description: "You’ve reached 25,000 HP",
      date: "Dec. 14, 2025",
      color: Colors.lightGreen,
      icon: AppAssets.healthBadge,
    ),

    pm.Badge(
      title: "Health Pro",
      description: "You’ve reached 15,000 HP",
      date: "Nov. 28, 2025",
      color: Colors.green,
      icon: AppAssets.healthProBadge,
    ),
    pm.Badge(
      title: "Wellness Watcher",
      description: "You’ve reached 10,000 HP",
      date: "Nov. 03, 2025",
      color: Colors.blueAccent,
      icon: AppAssets.wellnessWatcherBadge,
    ),
    pm.Badge(
      title: "Health Apprentice",
      description: "You’ve reached 5,000 HP",
      date: "Sep. 20, 2025",
      color: Colors.blue,
      icon: AppAssets.healthApprenticeBadge,
    ),
  ];
}