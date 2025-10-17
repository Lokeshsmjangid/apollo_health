// To parse this JSON data, do
//
//     final groupPlayResultModel = groupPlayResultModelFromJson(jsonString);

import 'dart:convert';

GroupPlayResultModel groupPlayResultModelFromJson(String str) => GroupPlayResultModel.fromJson(json.decode(str));

String groupPlayResultModelToJson(GroupPlayResultModel data) => json.encode(data.toJson());

class GroupPlayResultModel {
  bool? status;
  int? statusCode;
  String? message;
  List<GroupUser>? users;

  GroupPlayResultModel({
    this.status,
    this.statusCode,
    this.message,
    this.users,
  });

  factory GroupPlayResultModel.fromJson(Map<String, dynamic> json) => GroupPlayResultModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    users: json["users"] == null ? [] : List<GroupUser>.from(json["users"]!.map((x) => GroupUser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
  };
}

class GroupUser {
  int? userId;
  String? firstName;
  String? lastName;
  int? correctAnswers;
  int? totalTimeTaken;
  int? percentage;
  int? gameComplete;
  int? gameExit;
  int? totalXp;

  GroupUser({
    this.userId,
    this.firstName,
    this.lastName,
    this.correctAnswers,
    this.totalTimeTaken,
    this.percentage,
    this.gameComplete,
    this.gameExit,
    this.totalXp,
  });

  factory GroupUser.fromJson(Map<String, dynamic> json) => GroupUser(
    userId: json["user_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    correctAnswers: json["correct_answers"],
    totalTimeTaken: json["total_time_taken"],
    percentage: json["percentage"],
    gameComplete: json["game_complete"],
    gameExit: json["game_exit"],
    totalXp: json["totalxp"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "correct_answers": correctAnswers,
    "total_time_taken": totalTimeTaken,
    "percentage": percentage,
    "game_complete": gameComplete,
    "game_exit": gameExit,
    "totalxp": totalXp,

  };
}
