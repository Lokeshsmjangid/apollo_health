// To parse this JSON data, do
//
//     final HealthPointHistoryModel = HealthPointHistoryModelFromJson(jsonString);

import 'dart:convert';

HealthPointHistoryModel HealthPointHistoryModelFromJson(String str) => HealthPointHistoryModel.fromJson(json.decode(str));

String HealthPointHistoryModelToJson(HealthPointHistoryModel data) => json.encode(data.toJson());

class HealthPointHistoryModel {
  bool? status;
  int? statusCode;
  String? message;
  List<HpHistory>? data;

  HealthPointHistoryModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory HealthPointHistoryModel.fromJson(Map<String, dynamic> json) => HealthPointHistoryModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? [] : List<HpHistory>.from(json["data"]!.map((x) => HpHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class HpHistory {
  int? id;
  String? game;
  int? userId;
  String? activity;
  String? type;
  String? xp;
  DateTime? createdAt;
  DateTime? updatedAt;

  HpHistory({
    this.id,
    this.game,
    this.userId,
    this.activity,
    this.type,
    this.xp,
    this.createdAt,
    this.updatedAt,
  });

  factory HpHistory.fromJson(Map<String, dynamic> json) => HpHistory(
    id: json["id"],
    game: json["game"],
    userId: json["user_id"],
    activity: json["activity"],
    type: json["type"],
    xp: json["xp"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "game": game,
    "user_id": userId,
    "activity": activity,
    "type": type,
    "xp": xp,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
