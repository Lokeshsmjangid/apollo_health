import 'dart:convert';
import 'package:apollo/resources/utils.dart';

import 'local_storage.dart';

class AuthData {

  AuthData._internal(); // Private constructor
  static final AuthData _instance = AuthData._internal();

  String? userToken;
  bool isLogin = false;
  // UserModel? userModel; // uncommen when api implemented


  // Factory constructor to return the same instance
  factory AuthData() {
    return _instance;
  }

  getLoginData() {

    if(LocalStorage().getValue(LocalStorage.USER_ACCESS_TOKEN).isNotEmpty){
      AuthData().userToken = LocalStorage().getValue(LocalStorage.USER_ACCESS_TOKEN);
      AuthData().isLogin = true;

      var userData = jsonDecode(LocalStorage().getValue(LocalStorage.USER_DATA));
      if(userData!=null){
        // AuthData().userModel = UserModel.fromJson(userData);
      }
    }
    apolloPrint(message: 'AuthData.IS_LOGIN-->${AuthData().isLogin}<--\n\n [\nLOGIN USER DETAILS--------********----------\nTOKEN: ${AuthData().userToken} \n\n '
        // 'Detail:${jsonEncode(AuthData().userModel)}\n-----********-----\n]'// uncommen when api implemented
    );
  }
}
