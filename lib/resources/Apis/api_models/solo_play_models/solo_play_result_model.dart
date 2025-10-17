// To parse this JSON data, do
//
//     final soloPlayResultModel = soloPlayResultModelFromJson(jsonString);

import 'dart:convert';

SoloPlayResultModel soloPlayResultModelFromJson(String str) => SoloPlayResultModel.fromJson(json.decode(str));

String soloPlayResultModelToJson(SoloPlayResultModel data) => json.encode(data.toJson());

class SoloPlayResultModel {
  bool? status;
  int? statusCode;
  String? message;
  SoloResult? data;

  SoloPlayResultModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory SoloPlayResultModel.fromJson(Map<String, dynamic> json) => SoloPlayResultModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : SoloResult.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class SoloResult {
  int? percentage;
  int? xp;
  int? totalXp;

  SoloResult({
    this.percentage,
    this.xp,
    this.totalXp,
  });

  factory SoloResult.fromJson(Map<String, dynamic> json) => SoloResult(
    percentage: json["percentage"],
    xp: json["xp"],
    totalXp: json["totalXp"],
  );

  Map<String, dynamic> toJson() => {
    "percentage": percentage,
    "xp": xp,
    "totalXp": totalXp,
  };
}
