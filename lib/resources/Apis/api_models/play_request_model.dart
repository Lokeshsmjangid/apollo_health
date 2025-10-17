// To parse this JSON data, do
//
//     final playRequestModel = playRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:apollo/resources/Apis/api_models/solo_play_models/solo_play_questions_model.dart';

PlayRequestModel playRequestModelFromJson(String str) => PlayRequestModel.fromJson(json.decode(str));

String playRequestModelToJson(PlayRequestModel data) => json.encode(data.toJson());

class PlayRequestModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  PlayRequestModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory PlayRequestModel.fromJson(Map<String, dynamic> json) => PlayRequestModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  int? groupGameId;
  int? senderId;
  int? receiverId;
  String? status;
  DateTime? requestedAt;
  dynamic respondedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? firstName;
  String? lastName;
  dynamic countryFlag;
  String? profileImage;
  dynamic country;
  int? xp;
  int? onlineStatusVisible;
  int? musicEnabled;
  int? remainingSeconds;
  List<SoloPlayQuestion>? questions;
  GameData? gameData;
  int? inviteCount;


  Data({
    this.id,
    this.groupGameId,
    this.senderId,
    this.receiverId,
    this.status,
    this.requestedAt,
    this.respondedAt,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.lastName,
    this.countryFlag,
    this.profileImage,
    this.country,
    this.xp,
    this.onlineStatusVisible,
    this.musicEnabled,
    this.remainingSeconds,
    this.questions,
    this.gameData,
    this.inviteCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    groupGameId: json["group_game_id"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    status: json["status"],
    requestedAt: json["requested_at"] == null ? null : DateTime.parse(json["requested_at"]),
    respondedAt: json["responded_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    firstName: json["first_name"],
    lastName: json["last_name"],
    countryFlag: json["country_flag"],
    profileImage: json["profile_image"],
    country: json["country"],
    xp: json["xp"],
    inviteCount: json["inviteCount"],
    onlineStatusVisible: json["online_status_visible"],
    musicEnabled: json["music_enabled"],
    remainingSeconds: json["remaining_seconds"],
    questions: json["questions"] == null ? [] : List<SoloPlayQuestion>.from(json["questions"]!.map((x) => SoloPlayQuestion.fromJson(x))),
    gameData: json["gameData"] == null ? null : GameData.fromJson(json["gameData"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "group_game_id": groupGameId,
    "sender_id": senderId,
    "receiver_id": receiverId,
    "status": status,
    "requested_at": requestedAt?.toIso8601String(),
    "responded_at": respondedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "first_name": firstName,
    "last_name": lastName,
    "country_flag": countryFlag,
    "profile_image": profileImage,
    "country": country,
    "xp": xp,
    "inviteCount": inviteCount,
    "online_status_visible": onlineStatusVisible,
    "music_enabled": musicEnabled,
    "remaining_seconds": remainingSeconds,
    "questions": questions == null ? [] : List<dynamic>.from(questions!.map((x) => x.toJson())),
    "gameData": gameData?.toJson(),
  };
}
