import 'package:apollo/models/my_profile_badge_model.dart' as pm; // pm for profile model
import 'package:apollo/resources/Apis/api_models/register_model.dart';
import 'package:apollo/resources/Apis/api_repository/friend_profile_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtherProfileCtrl extends GetxController{
  RegisterResponseModel profileModel = RegisterResponseModel();
  bool isDataLoading = false;
  bool updateProfile = false;
  bool? isMyFriend;

  int? friendId;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(Get.arguments!=null){
      friendId = Get.arguments['friend_id'];


      apolloPrint(message: 'message::::$isMyFriend');
      Future.microtask((){
     getProfile();
   });
    }}

  getProfile() async{
    isDataLoading = true;
    update();
    showLoader(true);
    friendProfileApi(friendId: friendId).then((value){
      profileModel = value;
      isDataLoading = false;
      if(value.data!=null){
        isMyFriend = value.data!.myFriendStatus==1?true: false;
      }
      update();
      showLoader(false);
    });
  }

  final List<pm.Badge> badges = [
    pm.Badge(
      title: "Health Apprentice",
      description: "You’ve reached 5,000 HP",
      date: "Sep. 20, 2025",
      color: Colors.blue,
      icon: AppAssets.healthApprenticeBadge,
    ),
  ];

}