// To parse this JSON data, do
//
//     final wheelForWellnessModel = wheelForWellnessModelFromJson(jsonString);

import 'dart:convert';

WheelForWellnessModel wheelForWellnessModelFromJson(String str) => WheelForWellnessModel.fromJson(json.decode(str));

String wheelForWellnessModelToJson(WheelForWellnessModel data) => json.encode(data.toJson());

class WheelForWellnessModel {
  bool? status;
  int? statusCode;
  String? message;
  WellNessData? data;

  WheelForWellnessModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory WheelForWellnessModel.fromJson(Map<String, dynamic> json) => WheelForWellnessModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : WellNessData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class WellNessData {
  int? id;
  int? wellnessGameId;
  String? hiddenMedicalTerm;
  String? club;
  String? revealedMedicalTerm;
  String? description;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? lenth;
  int? live;

  WellNessData({
    this.id,
    this.wellnessGameId,
    this.hiddenMedicalTerm,
    this.club,
    this.revealedMedicalTerm,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.lenth,
    this.live,
  });

  factory WellNessData.fromJson(Map<String, dynamic> json) => WellNessData(
    id: json["id"],
    wellnessGameId: json["wellness_game_id"],
    hiddenMedicalTerm: json["hidden_medical_term"],
    club: json["club"],
    revealedMedicalTerm: json["revealed_medical_term"],
    description: json["description"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    lenth: json["lenth"],
    live: json["live"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "wellness_game_id": wellnessGameId,
    "hidden_medical_term": hiddenMedicalTerm,
    "club": club,
    "revealed_medical_term": revealedMedicalTerm,
    "description": description,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "lenth": lenth,
    "live": live,
  };
}
