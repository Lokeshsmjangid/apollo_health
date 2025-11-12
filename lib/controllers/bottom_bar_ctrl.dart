import 'package:apollo/bottom_sheets/daily_dose_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/signup_gift_bottom_sheet.dart';
import 'package:apollo/resources/Apis/api_repository/daily_dose_repo.dart';
import 'package:apollo/resources/Apis/api_repository/signup_bonus_repo.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/dashboard/all_category_screen.dart';
import 'package:apollo/screens/dashboard/home_screen.dart';
import 'package:apollo/screens/dashboard/leaderboard_screen.dart';
import 'package:apollo/screens/deals/deals_screen.dart';
import 'package:apollo/screens/my_profile/my_profile_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController{

  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async { await _audioPlayer.play(AssetSource(sound));}

  int selectedIndex = 0;
  List<Widget> widgetOptions = <Widget>[
    const HomeScreen(),
    CategoryScreen(),
    LeaderboardScreen(),
    // DealsScreen(),
    MyProfileScreen(),
  ];

  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    apolloPrint(message: 'bottom called ctrl');
    if(AuthData().isLogin){
      // await AppLinksService.init();
      // getDailyDose();
      // getSignUpBonus();
      loadInitApis();
    }
  }

  Future<void> loadInitApis() async {
    try {
      final results = await Future.wait([

      getDailyDose(),
      getSignUpBonus()     // Replace with your second API

      ] as Iterable<Future>);

    } catch (e) {
      print('Init load error: $e');
    }
  }

  getDailyDose() async{
    await dailyDoseApi().then((value){
      if(value.status==true && value.data!=null){
        showDailyDoseSheet(Get.context!,catName: value.data?.categoryName??"", desc: value.data?.description??"",);
      }
    });
  }
  getSignUpBonus() async{
    await signUpBonusApi().then((value){
      if(value.status==true){
        Future.delayed(Duration(seconds: 3),(){
          if(Get.context!=null) {
            showSignUpGiftBottomSheet(Get.context!);
          }
        });
      }
    });
  }
}