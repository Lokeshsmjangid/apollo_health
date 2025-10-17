// To parse this JSON data, do
//
//     final dailyDoseModel = dailyDoseModelFromJson(jsonString);

import 'dart:convert';

DailyDoseModel dailyDoseModelFromJson(String str) => DailyDoseModel.fromJson(json.decode(str));

String dailyDoseModelToJson(DailyDoseModel data) => json.encode(data.toJson());

class DailyDoseModel {
  bool? status;
  int? statusCode;
  DailyDose? data;

  DailyDoseModel({
    this.status,
    this.statusCode,
    this.data,
  });

  factory DailyDoseModel.fromJson(Map<String, dynamic> json) => DailyDoseModel(
    status: json["status"],
    statusCode: json["statusCode"],
    data: json["data"] == null ? null : DailyDose.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "data": data?.toJson(),
  };
}

class DailyDose {
  int? id;
  String? categoryName;
  String? description;

  DailyDose({
    this.id,
    this.categoryName,
    this.description,
  });

  factory DailyDose.fromJson(Map<String, dynamic> json) => DailyDose(
    id: json["id"],
    categoryName: json["category_name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_name": categoryName,
    "description": description,
  };
}
