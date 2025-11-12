import 'dart:convert';
import 'dart:ui';

import 'package:apollo/resources/Apis/api_models/settings_customization_model.dart';
import 'package:apollo/resources/Apis/api_repository/settings_customization_repo.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/debouncer.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsCtrl extends GetxController{
  SettingsCustomizationModel model = SettingsCustomizationModel();
  final deBounce = Debouncer(milliseconds: 1000);

  bool music = false;
  bool onlineStatus = false;

  // Notification Settings
  bool allNotifications = false;

  // daily-Dose
  bool ddPush = false;
  bool ddEmail = false;

  // Live-update
  bool luPush = false;
  bool luEmail = false;

  // Group-request
  bool frPush = false;
  bool frEmail = false;

  // daily-streak
  bool dsPush = false;
  bool dsEmail = false;

  // friend-request
  bool friendRequestPush = false;

  // System Notification
  bool systemNotificationPush = false;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadVersion();
    Future.microtask((){
      fetchSettings();
    });

  }

  fetchSettings() async{
    showLoader(true);
    await getSettingsCustomizationApi().then((value){
      model = value;
      showLoader(false);
      if(model.data!=null){
        music = value.data!.musicEnabled==1?true:false;
        allNotifications = value.data!.allNotification==1?true:false;
        onlineStatus = value.data!.onlineStatusVisible==1?true:false;
        ddPush = value.data!.dailyDosePush==1?true:false;
        ddEmail = value.data!.dailyDoseEmail==1?true:false;
        luPush = value.data!.liveEventPush==1?true:false;
        luEmail = value.data!.liveEventEmail==1?true:false;

        frPush = value.data!.newProductsPush==1?true:false;
        frEmail = value.data!.newProductsEmail==1?true:false;
        dsPush = value.data!.dailyStreakPush==1?true:false;
        dsEmail = value.data!.dailyStreakEmail==1?true:false;
        friendRequestPush = value.data!.newFriendPush==1?true:false;
        systemNotificationPush = value.data!.systemNotificationPush==1?true:false;

      }
      if(model.userData!=null){
        LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.userData));
        LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.userData!.subscription==1?true:false);
        AuthData().getLoginData();
      }

      update();

    });
  }

  fetchSettings1() async{

    await getSettingsCustomizationApi().then((value){
      model = value;
      if(model.data!=null){
        music = value.data!.musicEnabled==1?true:false;
        allNotifications = value.data!.allNotification==1?true:false;
        onlineStatus = value.data!.onlineStatusVisible==1?true:false;
        ddPush = value.data!.dailyDosePush==1?true:false;
        ddEmail = value.data!.dailyDoseEmail==1?true:false;
        luPush = value.data!.liveEventPush==1?true:false;
        luEmail = value.data!.liveEventEmail==1?true:false;

        frPush = value.data!.newProductsPush==1?true:false;
        frEmail = value.data!.newProductsEmail==1?true:false;
        dsPush = value.data!.dailyStreakPush==1?true:false;
        dsEmail = value.data!.dailyStreakEmail==1?true:false;

      }
      if(model.userData!=null){
        LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.userData));
        LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.userData!.subscription==1?true:false);
        AuthData().getLoginData();
      }
      update();
    });
  }
  String appVersion = '';
  void loadVersion() async {
    appVersion = await getAppVersion();
    update();
  }
  Future<String> getAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      print('Version: ${info.version}');
      print('Build number: ${info.buildNumber}');
      return 'Version: ${info.version} (${info.buildNumber})';
    } catch (e) {
      print('Failed to get app version: $e');
      return 'Version info not available';
    }
  }

}

class SupportOption {
  final String title;
  final String? subtitle;
  final Color color;
  final Color colorBG;

  SupportOption({
    required this.title,
    this.subtitle,
    required this.color,
    required this.colorBG,
  });
}