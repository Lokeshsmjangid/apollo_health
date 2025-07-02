
import 'package:apollo/bottom_sheets/daily_dose_bottom_sheet.dart';
import 'package:apollo/notifications_screen.dart';
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
  Future<void> effectSound({required String sound}) async {

    await _audioPlayer.play(AssetSource(sound));

  }


  int selectedIndex = 0;
  List<Widget> widgetOptions = <Widget>[
    const HomeScreen(),
    CategoryScreen(),
    LeaderboardScreen(),
    DealsScreen(),
    MyProfileScreen(),
  ];


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(Duration(milliseconds: 5000),(){
      showDailyDoseSheet(Get.context!);
    });
  }
}