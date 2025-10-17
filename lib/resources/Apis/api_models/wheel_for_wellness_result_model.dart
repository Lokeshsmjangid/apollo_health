// To parse this JSON data, do
//
//     final wheelForWellnessResultModel = wheelForWellnessResultModelFromJson(jsonString);

import 'dart:convert';

WheelForWellnessResultModel wheelForWellnessResultModelFromJson(String str) => WheelForWellnessResultModel.fromJson(json.decode(str));

String wheelForWellnessResultModelToJson(WheelForWellnessResultModel data) => json.encode(data.toJson());

class WheelForWellnessResultModel {
  bool? status;
  int? statusCode;
  String? message;
  int? data;

  WheelForWellnessResultModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory WheelForWellnessResultModel.fromJson(Map<String, dynamic> json) => WheelForWellnessResultModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data,
  };
}
