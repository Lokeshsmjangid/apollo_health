// To parse this JSON data, do
//
//     final liveChallengeModel = liveChallengeModelFromJson(jsonString);

import 'dart:convert';

LiveChallengeModel liveChallengeModelFromJson(String str) => LiveChallengeModel.fromJson(json.decode(str));

String liveChallengeModelToJson(LiveChallengeModel data) => json.encode(data.toJson());

class LiveChallengeModel {
  bool? status;
  int? statusCode;
  String? message;
  LiveChallengeData? data;

  LiveChallengeModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory LiveChallengeModel.fromJson(Map<String, dynamic> json) => LiveChallengeModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : LiveChallengeData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class LiveChallengeData {
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
  String? userName;

  LiveChallengeData({
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
    this.userName,
  });

  factory LiveChallengeData.fromJson(Map<String, dynamic> json) => LiveChallengeData(
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
    userName: json["user_name"],
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
    "user_name": userName,
  };
}
