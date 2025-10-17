import 'dart:convert';
import 'package:apollo/resources/Apis/api_models/user_model.dart';
import 'package:apollo/resources/utils.dart';

import 'local_storage.dart';

class AuthData {

  AuthData._internal(); // Private constructor
  static final AuthData _instance = AuthData._internal();

  String? userToken;
  bool isLogin = false;
  bool musicONOFF = false;
  bool isPremium = false;
  int isPremiumWellness = 0;
  int isPremiumMedpardy = 0;
  int isPremiumMedLingo = 0;
  UserModel? userModel; // uncommen when api implemented


  // Factory constructor to return the same instance
  factory AuthData() {
    return _instance;
  }
  getLoginData() {
    if(LocalStorage().getValue(LocalStorage.USER_TOKEN).isNotEmpty){
      AuthData().userToken = LocalStorage().getValue(LocalStorage.USER_TOKEN);
      AuthData().isLogin = true;
      AuthData().isPremium = LocalStorage().getBoolValue(LocalStorage.IS_PREMIUM);
      var userData = jsonDecode(LocalStorage().getValue(LocalStorage.USER_DATA));
      if(userData!=null){
         AuthData().userModel = UserModel.fromJson(userData);
         AuthData().musicONOFF = userModel!.musicEnabled==1?true:false;
         AuthData().isPremiumWellness = userModel!.wellnessPremium??0;
         AuthData().isPremiumMedpardy = userModel!.medpardyPremium??0;
         AuthData().isPremiumMedLingo = userModel!.medlingoPremium??0;
      }
    }
    apolloPrint(message: 'AuthData.IS_LOGIN-->${AuthData().isLogin}<--\nisPremiumUser-->$isPremium<--\n [\nLOGIN USER DETAILS--------********----------\nTOKEN: ${AuthData().userToken} \n\n '
        'Detail:${jsonEncode(AuthData().userModel)}\n-----********-----\n]'// uncommen when api implemented
    );
  }
}


