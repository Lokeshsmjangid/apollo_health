
import 'dart:convert';
import 'dart:developer';

import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static const IS_LOGIN = "IS_LOGIN";
  static const USER_ACCESS_TOKEN = "USER_ACCESS_TOKEN";
  static const USER_DATA = "USER_DATA";
  static const ROLE = "ROLE";

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

  clearLocalStorage(){
    GetStorage localStorage = GetStorage();
    localStorage.erase();
  }
}