// To parse this JSON data, do
//
//     final settingsCustomizationModel = settingsCustomizationModelFromJson(jsonString);

import 'dart:convert';

import 'package:apollo/resources/Apis/api_models/user_model.dart';

SettingsCustomizationModel settingsCustomizationModelFromJson(String str) => SettingsCustomizationModel.fromJson(json.decode(str));

String settingsCustomizationModelToJson(SettingsCustomizationModel data) => json.encode(data.toJson());

class SettingsCustomizationModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;
  UserModel? userData;

  SettingsCustomizationModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
    this.userData
  });

  factory SettingsCustomizationModel.fromJson(Map<String, dynamic> json) => SettingsCustomizationModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    userData: json["user_data"] == null ? null : UserModel.fromJson(json["user_data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
    "user_data": userData?.toJson(),
  };
}

class Data {
  int? dailyStreakEmail;
  int? musicEnabled;
  int? dailyDosePush;
  int? dailyDoseEmail;
  int? onlineStatusVisible;
  int? dailyStreakPush;
  int? liveEventPush;
  int? liveEventEmail;
  int? newProductsPush;
  int? newProductsEmail;
  int? allNotification;
  int? newFriendPush;
  int? systemNotificationPush;

  Data({
    this.dailyStreakEmail,
    this.musicEnabled,
    this.dailyDosePush,
    this.dailyDoseEmail,
    this.onlineStatusVisible,
    this.dailyStreakPush,
    this.liveEventPush,
    this.liveEventEmail,
    this.newProductsPush,
    this.newProductsEmail,
    this.allNotification,
    this.newFriendPush,
    this.systemNotificationPush,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    dailyStreakEmail: json["daily_streak_email"],
    musicEnabled: json["music_enabled"],
    dailyDosePush: json["daily_dose_push"],
    dailyDoseEmail: json["daily_dose_email"],
    onlineStatusVisible: json["online_status_visible"],
    dailyStreakPush: json["daily_streak_push"],
    liveEventPush: json["live_event_push"],
    liveEventEmail: json["live_event_email"],
    newProductsPush: json["new_products_push"],
    newProductsEmail: json["new_products_email"],
    allNotification: json["all_notification"],
    newFriendPush: json["new_friend_push"],
    systemNotificationPush: json["system_notification_push"],
  );

  Map<String, dynamic> toJson() => {
    "daily_streak_email": dailyStreakEmail,
    "music_enabled": musicEnabled,
    "daily_dose_push": dailyDosePush,
    "daily_dose_email": dailyDoseEmail,
    "online_status_visible": onlineStatusVisible,
    "daily_streak_push": dailyStreakPush,
    "live_event_push": liveEventPush,
    "live_event_email": liveEventEmail,
    "new_products_push": newProductsPush,
    "new_products_email": newProductsEmail,
    "all_notification": allNotification,
    "new_friend_push": newFriendPush,
    "system_notification_push": systemNotificationPush,
  };
}
