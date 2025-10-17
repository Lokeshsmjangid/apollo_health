// To parse this JSON data, do
//
//     final userActiveModel = userActiveModelFromJson(jsonString);

import 'dart:convert';

import 'package:apollo/resources/Apis/api_models/user_model.dart';

UserActiveModel userActiveModelFromJson(String str) => UserActiveModel.fromJson(json.decode(str));

String userActiveModelToJson(UserActiveModel data) => json.encode(data.toJson());

class UserActiveModel {
  bool? status;
  int? statusCode;
  String? message;
  UserModel? data;

  UserActiveModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory UserActiveModel.fromJson(Map<String, dynamic> json) => UserActiveModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : UserModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

