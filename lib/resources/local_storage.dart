
import 'package:apollo/resources/app_routers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static const USER_TOKEN = "USER_TOKEN";
  static const USER_ID = "USER_ID";
  static const USER_DATA = "USER_DATA";
  static const MUSIC_ON = "MUSIC_ON";
  static const IS_PREMIUM = "IS_PREMIUM";
  static const IS_PREMIUM_WELLNESS = "IS_PREMIUM_WELLNESS";
  static const IS_PREMIUM_MEDPARDY = "IS_PREMIUM_MEDPARDY";
  static const IS_PREMIUM_MEDLINGO = "IS_PREMIUM_MEDLINGO";


  final box = GetStorage();


// Local Storage Getx methods
  setValue(String key, String value) {
    GetStorage localStorage = GetStorage();
    localStorage.write(key, value);
  }

  String getValue(String key) {
    GetStorage localStorage = GetStorage();
    var value = localStorage.read(key);
    return value ?? '';
  }

  setBoolValue(String key, value){
    GetStorage localStorage = GetStorage();
    localStorage.write(key, value);
  }

  bool getBoolValue(String key){
    GetStorage localStorage = GetStorage();
    var value = localStorage.read(key);
    return value ?? false;
  }

  clearLocalStorage({bool goToSignInScreen = true}){
    GetStorage localStorage = GetStorage();
    localStorage.erase();
    if(goToSignInScreen){
    Get.offAllNamed(AppRoutes.signInScreen);
    }
  }
}