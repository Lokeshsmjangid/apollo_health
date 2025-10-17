// To parse this JSON data, do
//
//     final commonModel = commonModelFromJson(jsonString);

import 'dart:convert';

CommonModel commonModelFromJson(String str) => CommonModel.fromJson(json.decode(str));

String commonModelToJson(CommonModel data) => json.encode(data.toJson());

class CommonModel {
  bool? status;
  int? statusCode;
  String? message;
  String? data;

  CommonModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory CommonModel.fromJson(Map<String, dynamic> json) => CommonModel(
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
