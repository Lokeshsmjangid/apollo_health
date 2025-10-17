// To parse this JSON data, do
//
//     final liveChallengeRegisterModel = liveChallengeRegisterModelFromJson(jsonString);

import 'dart:convert';

LiveChallengeRegisterModel liveChallengeRegisterModelFromJson(String str) => LiveChallengeRegisterModel.fromJson(json.decode(str));

String liveChallengeRegisterModelToJson(LiveChallengeRegisterModel data) => json.encode(data.toJson());

class LiveChallengeRegisterModel {
  bool? status;
  int? statusCode;
  String? message;
  LiveChallengerRegisterData? data;
  int? startMilliseconds;
  int? remainingMilliseconds;
  String? readableRemainingTime;

  LiveChallengeRegisterModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
    this.startMilliseconds,
    this.remainingMilliseconds,
    this.readableRemainingTime,
  });

  factory LiveChallengeRegisterModel.fromJson(Map<String, dynamic> json) => LiveChallengeRegisterModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : LiveChallengerRegisterData.fromJson(json["data"]),
    startMilliseconds: json["start_milliseconds"],
    remainingMilliseconds: json["remaining_milliseconds"],
    readableRemainingTime: json["readable_remaining_time"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
    "start_milliseconds": startMilliseconds,
    "remaining_milliseconds": remainingMilliseconds,
    "readable_remaining_time": readableRemainingTime,
  };
}

class LiveChallengerRegisterData {
  int? id;
  int? userId;
  int? editedBy;
  dynamic selectedCategory;
  dynamic numberOfQuestion;
  String? title;
  String? startDate;
  String? startTime;
  String? useToken;
  int? questions;
  String? priceMoney;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? milliseconds;
  String? remainingTime;

  LiveChallengerRegisterData({
    this.id,
    this.userId,
    this.editedBy,
    this.selectedCategory,
    this.numberOfQuestion,
    this.title,
    this.startDate,
    this.startTime,
    this.useToken,
    this.questions,
    this.priceMoney,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.milliseconds,
    this.remainingTime,
  });

  factory LiveChallengerRegisterData.fromJson(Map<String, dynamic> json) => LiveChallengerRegisterData(
    id: json["id"],
    userId: json["user_id"],
    editedBy: json["edited_by"],
    selectedCategory: json["selected_category"],
    numberOfQuestion: json["number_of_question"],
    title: json["title"],
    startDate: json["start_date"],
    startTime: json["start_time"],
    useToken: json["use_token"],
    questions: json["questions"],
    priceMoney: json["price_money"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    milliseconds: json["milliseconds"],
    remainingTime: json["remaining_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "edited_by": editedBy,
    "selected_category": selectedCategory,
    "number_of_question": numberOfQuestion,
    "title": title,
    "start_date": startDate,
    "start_time": startTime,
    "use_token": useToken,
    "questions": questions,
    "price_money": priceMoney,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "milliseconds": milliseconds,
    "remaining_time": remainingTime,
  };
}
